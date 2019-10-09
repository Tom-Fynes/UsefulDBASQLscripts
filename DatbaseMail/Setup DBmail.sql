Declare @Email nVarchar(128) = N'SQLSERVER01@yourdomain.com', -- Domain Email
		@ReplyEmail nVarchar(128) ='', -- Reply Email
		@SMTP sysname = N'127.0.0.0', -- SMTP IP Address
		@Port int = 25, -- SMTP Port
		@OpEmail nVarchar(128) = N'ListofPeople@yourdomain.com', -- Who gets the emails
		@ProfileName nVarchar(128) = '', -- Database mail profile name
		@AccName nVarchar(128) = '', -- Account name
		@DisplayName nVarchar(128) = '' -- Display Name


/************** Nothing after this line needs changing   ***********************/

if (Select value_in_use From sys.configurations Where Name = 'Database Mail XPs') = 1 begin

	if not exists (select * from msdb.dbo.sysmail_profile where name = @ProfileName) begin
		exec msdb.dbo.sysmail_add_profile_sp
			@profile_name = @ProfileName,
			@description = 'Notification Service';
	end

	if not exists (select * from msdb.dbo.sysmail_account where name = 'Database Mail') begin
		exec msdb.dbo.sysmail_add_account_sp
			@account_name = @AccName,
			@description = 'Notification Service',
			@email_address = @Email,
			@replyto_address = @ReplyEmail,
			@display_name = @DisplayName,
			@mailserver_name = @SMTP,
			@port = @Port;
			
	end

	if not exists (select * from msdb.dbo.sysmail_profileaccount as spa inner join msdb.dbo.sysmail_profile as sp on spa.profile_id = sp.profile_id where sp.name = 'DBAHub Notifications') begin
		exec msdb.dbo.sysmail_add_profileaccount_sp
			@profile_name = @ProfileName,
			@account_name = @AccName,
			@sequence_number = 1;
	end

	if not exists (select * from msdb.dbo.sysmail_principalprofile as spp inner join msdb.dbo.sysmail_profile as sp on spp.profile_id = sp.profile_id where sp.name = 'DBAHub Notifications') begin
		exec msdb.dbo.sysmail_add_principalprofile_sp
			@profile_name = @ProfileName,
			@principal_id = 0,
			@is_default = 1;
	end

	if @@version like 'Microsoft SQL Server 2012%' or @@version like 'Microsoft SQL Server 2014%' or @@version like 'Microsoft SQL Server 2016%' begin
		exec msdb.dbo.sp_set_sqlagent_properties
			@email_save_in_sent_folder = 1,
			@alert_replace_runtime_tokens = 1,
			@databasemail_profile = @ProfileName,
			@use_databasemail = 1;
	end

	if not exists (select name from msdb.dbo.sysoperators where name = @DisplayName) begin
		exec msdb.dbo.sp_add_operator
			@name = @DisplayName, 
			@enabled = 1,
			@pager_days = 0,
			@email_address = @OpEmail;
	end

end
go
