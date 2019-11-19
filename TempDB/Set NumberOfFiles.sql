/**************************************************************************************************************************************
Description: Set correct number of TempDB files
***************************************************************************************************************************************/
Use Master
Go

declare
	@SQL nvarchar (max),
	@TempDBFileName nvarchar (max),
	@TempDBFileLocation nvarchar (max),
	@NumberOfTempDBFiles int = (		select
											case when sum (online_scheduler_count) > 8 then 8 else sum (online_scheduler_count) end
										from sys.dm_os_nodes
										where node_state_desc = 'ONLINE'),
	@TempDBLocation nvarchar (max) = (	select
											reverse(substring(reverse(physical_name), charindex('\', reverse(physical_name)), len(physical_name)))
										from sys.master_files
										where database_id = 2
										and file_id = 1)

declare TempDBFileCursor cursor for
	with TempDBFiles as (
		select
			T = 1
		union all
		select
			T + 1
		from TempDBFiles
		where T < @NumberOfTempDBFiles
	)
	select
		N'TempDev' + case when T = 1 then '' else cast (T as nvarchar (max)) end,
		@TempDBLocation + N'TempDev' + case when T = 1 then '.mdf' else cast (T as nvarchar (max)) + N'.ndf' end
	from TempDBFiles;

open TempDBFileCursor;
fetch next from TempDBFileCursor into @TempDBFileName, @TempDBFileLocation;


while @@fetch_status = 0 begin
	
	if not exists (select * from master.sys.master_files where name = @TempDBFileName) begin

		set @SQL = N'alter database TempDB
	add file ( name = N''' + @TempDBFileName + N''',
		filename = N''' + @TempDBFileLocation + N''',
		size = 2024, -- 2Gb
		filegrowth = 250 -- 250MB
	);';
		exec (@SQL);

	end

	fetch next from TempDBFileCursor into @TempDBFileName, @TempDBFileLocation;

end

close TempDBFileCursor;
deallocate TempDBFileCursor;
