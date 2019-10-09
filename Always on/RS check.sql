declare @AvailabilityGroup nvarchar(128) = '' -- AG name 
--Check RS Connections
If EXISTS 
	(
	SELECT 
		SERVERPROPERTY ('IsHadrEnabled')
	Where SERVERPROPERTY ('IsHadrEnabled') = 1 
	)
And Exists
	(
	Select 
		AG.name as 'Availability Group'
	from sys.availability_replicas AR 
		Inner Join 
		SYS.availability_groups AG 
			on AG.group_id = AR.group_id 
	Where AR.endpoint_url like '%%' -- Add part of readable secondary name.
	And AG.Name = @AvailabilityGroup
	)
Begin
	Select
		endpoint_url,
		secondary_role_allow_connections_desc
	from sys.availability_replicas
	Where endpoint_url like '%%'
End
ELSE
	Print 'AG is not active for this server'


