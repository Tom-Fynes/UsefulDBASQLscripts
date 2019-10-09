Use Master;
GO
Declare @TotalMemory int,
        @MaxMemory   int;

Set @TotalMemory = 	(Select
						total_physical_memory_kb / 1024   as [Memory in MB,]
					from sys.dm_os_sys_memory);

Set @MaxMemory = (Select 
					@TotalMemory * 85 / 100);

EXEC sp_configure 'max server memory (MB)', @MaxMemory; 
GO
RECONFIGURE;
GO
Exec sp_configure 'Min Server Memory (MB)' , 0; -- Makking sure memory is dynamic
GO
Reconfigure;
Go

-- Checking the values have updated
Select 
	Name,
	value
from sys.configurations
Where Name in ('Min Server Memory (MB)', 'max server memory (MB)')

