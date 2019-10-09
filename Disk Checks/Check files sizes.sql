
;With FileSize as 
(
Select 
	d.name,
	Sum(mf.size) * 8.0 / 1024 /1024 'Size In GB'
from sys.databases D
Inner Join 
	sys.master_files mf 
		on mf.database_id = D.database_id
Group by d.name
)
Select
	Name,
	Sum([Size In GB]) 'Size In GB'
From FileSize
Group by Name 

