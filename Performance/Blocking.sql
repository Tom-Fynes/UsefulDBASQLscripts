--Returning only blocked processes for all processes running on SQL server
USE Master
GO
SELECT 
	* 
FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0;
GO

--DMV Returns info aboout tasks that are waiting on resources
USE Master
GO
SELECT 
	session_id, 
	wait_duration_ms, wait_type, 
	blocking_session_id 
FROM sys.dm_os_waiting_tasks 
WHERE blocking_session_id <> 0
GO

--Sessions that are currently active
USE master;
GO
EXEC sp_who 'active';
GO
EXEC sp_who2 'active';
GO

