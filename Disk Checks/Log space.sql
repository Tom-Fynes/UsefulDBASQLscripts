 create table #logSpaceStats
(
  databaseName varchar(100),
  logSize dec(15,2),
  percentUsed dec(15,2),
  status int
)

insert into #logSpaceStats
exec ('dbcc sqlperf (logspace)')

select
	databaseName,
	logSize,
	percentUsed
from #logSpaceStats 
order by percentUsed 
 
Drop Table #logSpaceStats