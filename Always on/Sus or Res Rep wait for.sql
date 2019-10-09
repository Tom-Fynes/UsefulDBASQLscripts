declare @AvailabilityGroup nvarchar(128) = '' -- AG name 

declare  @DatabaseName nvarchar(128)
       , @TSQL nvarchar(max)
declare CUR cursor for
       select dbcs.database_name as 'DatabaseName'
              from sys.availability_groups as ag
              Inner join 
				sys.availability_replicas as ar 
					on ar.group_id=ag.group_id
              Inner join 
				sys.dm_hadr_availability_replica_states as arstates 
					on ar.replica_id = arstates.replica_id and arstates.is_local = 1
              Inner join 
				sys.dm_hadr_database_replica_cluster_states as dbcs 
					on arstates.replica_id = dbcs.replica_id
              where ag.name = @AvailabilityGroup
              order by DatabaseName asc

       open CUR
              fetch next from CUR into @DatabaseName
              while @@Fetch_status = 0

       begin
              set @TSQL = 
                     
					'waitfor delay ''00:00:15''
                     alter database ' + @DatabaseName + ' set hadr resume
                     --alter database ' + @DatabaseName + ' set hadr suspend
                     '
              exec (@TSQL)
       
              fetch next from CUR into @DatabaseName
       end
close CUR deallocate CUR