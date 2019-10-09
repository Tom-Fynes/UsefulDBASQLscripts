
--URL CHeck with extra infromation 
If EXISTS (SELECT SERVERPROPERTY ('IsHadrEnabled') Where SERVERPROPERTY ('IsHadrEnabled') = 1 )
Begin
	Select
		AR.endpoint_url,
		AG.name as 'Availability Group' ,
		AR.failover_mode,
		ARS.role_desc,
		AR.availability_mode_desc
	from sys.availability_replicas AR
	Inner Join 
		SYS.dm_hadr_availability_replica_states ARS
			on ARS.replica_id = AR.replica_id
	Inner Join 
		SYS.availability_groups AG 
			on AG.group_id = AR.group_id
	Inner Join 
		SYS.dm_hadr_availability_group_states AGS
			on AGS.group_id = AG.group_id
End
ELSE
	Print 'AG is not active for this server'