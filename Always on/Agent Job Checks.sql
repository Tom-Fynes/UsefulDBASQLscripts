/*****************************************************************************************************************************************
Check jobs exists and counts
*****************************************************************************************************************************************/ 
select sj.name
, sum(isnull(case when run_status = 0 then 1 end,0)) as FailedJobSteps
, sum(isnull(case when run_status = 1 then 1 end,0)) as SuccessfulJobSteps
, sum(isnull(case when run_status = 2 then 1 end,0)) as RetriedJobSteps
, sum(isnull(case when run_status = 3 then 1 end,0)) as CanceledJobSteps
from msdb.dbo.sysjobs sj
left join msdb.dbo.sysjobhistory sjh on sjh.job_id = sj.job_id
where sj.name like '%%'
group by sj.name
	select sj.name
		, sum(isnull(case when run_status = 0 then 1 end,0)) as FailedJobSteps
		, sum(isnull(case when run_status = 1 then 1 end,0)) as SuccessfulJobSteps
		, sum(isnull(case when run_status = 2 then 1 end,0)) as RetriedJobSteps
		, sum(isnull(case when run_status = 3 then 1 end,0)) as CanceledJobSteps
	from msdb.dbo.sysjobs sj
		left join msdb.dbo.sysjobhistory sjh on sjh.job_id = sj.job_id
	where sj.name like '%%'
	group by sj.name

/*****************************************************************************************************************************************
Check jobs exists and failed job history for last 24 hours.
*****************************************************************************************************************************************/ 

declare @ServerName varchar(50) = '%%'

select name from sys.databases
where name like @ServerName

select name from msdb.dbo.sysjobs
where name like @ServerName

select 
j.name as 'JobName',
s.step_name as 'StepName',
h.step_id,
cast(msdb.dbo.agent_datetime(run_date, run_time) as datetime) as 'RunDateTime',
((run_duration/10000*3600 + (run_duration/100)%100*60 + run_duration%100 + 31 ) / 60) 
as 'RunDurationMinutes'
, h.run_status
,h.message
From msdb.dbo.sysjobs j 
INNER JOIN msdb.dbo.sysjobsteps s ON j.job_id = s.job_id
INNER JOIN msdb.dbo.sysjobhistory h ON s.job_id = h.job_id 
AND s.step_id = h.step_id 
where j.enabled = 1 --Only Enabled Jobs
and j.name like @ServerName
and cast(msdb.dbo.agent_datetime(run_date, run_time) as date) > dateadd(dd,-1,getdate())
and h.run_status <> 1 -- Filter on failed steps
order by RunDateTime ,RunDurationMinutes desc

select d.name,f.name,f.physical_name,f.growth,f.size from sys.databases d
inner join sys.master_files f
on d.database_id = f.database_id
where d.name in ('tempdb')

exec sp_readerrorlog

