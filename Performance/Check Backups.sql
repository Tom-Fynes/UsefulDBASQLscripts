select
         database_name
       , backup_start_date
       , backup_finish_date
       , DATEDIFF(hour, backup_start_date, backup_finish_date) 'Duration (Hours)'
       , cast(compressed_backup_size/1024/1024 as int) as 'backupsize (mb)' 
   , cast(compressed_backup_size/1024/1024/1024 as int) as 'backupsize (gb)'
       , case type
              when 'I' then 'Diff'
              when 'D' then 'Full'
              when 'L' then 'Log'
              end as' Type'        
       , is_copy_only
       , name
       , user_name
       --, physical_device_name
from msdb.dbo.backupset b
--join msdb.dbo.backupmediafamily m on b.media_set_id = m.media_set_id
where database_name = 'EMISConnectDistributed'
order by backup_finish_date desc
