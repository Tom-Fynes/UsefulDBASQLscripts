
Select 
	D.database_id,
	D.name as 'Database Name',
	MF.physical_name,
	LEFT(MF.Physical_Name,1) as 'Drive',
	MF.type_desc 
from sys.databases D 
Inner Join 
	SYS.master_files MF
		on MF.database_id = D.database_id
Where D.name in 
(
	'Master',
	'Model',
	'MSDB',
	'TempDB'
)
Order by database_id asc