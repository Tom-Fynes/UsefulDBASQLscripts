/*****************************************************************************************************************************************
If using an AG verify AG health
*****************************************************************************************************************************************/
select 
	G.name as [AG],
	AGS.primary_replica, 
	AGS.primary_recovery_health_desc, 
	AGS.synchronization_health_desc 
from sys.availability_groups G
Inner join 
	sys.dm_hadr_availability_group_states AGS
		on g.group_id = AGS.group_id


/*****************************************************************************************************************************************
If using an AG Replica find synch health
*****************************************************************************************************************************************/ 
select 
	AR.replica_server_name, 
	AR.availability_mode_desc, 
	AR.failover_mode_desc,
	ARS.role_desc, 
	ARS.connected_state_desc, 
	ARS.synchronization_health_desc
from sys.availability_replicas AR
Inner join 
	sys.dm_hadr_availability_replica_states ARS 
		on AR.replica_id = ARS.replica_id
and AR.group_id = ARS.group_id
order by replica_server_name


/*****************************************************************************************************************************************
If using an AG , Replica and number of databases not healthy (synchronizing or synchronized)
*****************************************************************************************************************************************/ 

select 
	G.name, 
	R.replica_server_name, 
	count(G.name) 'CountOfNotHealthlyDBs'
from sys.dm_hadr_database_replica_states RS
Inner join 
	sys.availability_groups G on RS.group_id = G.group_id
Inner join 
	sys.availability_replicas R on RS.replica_id = R.replica_id
where synchronization_health_desc <> 'HEALTHY'
group by 
	G.name, 
	R.replica_server_name