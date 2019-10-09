-- verify Object Store LBSS Size
select 
	[type], 
	sum(pages_kb)/ 1024 as PagesMB,
	convert(decimal(5,2), (sum(nullif(pages_kb,0)) / (select sum(pages_kb)*1.0 from sys.dm_os_memory_clerks))*100) as 'Percentage Of Total Clerks'
from sys.dm_os_memory_clerks
group by [type]
order by PagesMB desc


