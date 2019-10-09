;with maxworker
as
(
select
case
when (select cpu_count from sys.dm_os_sys_info) <= 4 then
case
    when @@version like '%X86%' then 256
    when @@version like '%X64%' then 512
end
when (select cpu_count from sys.dm_os_sys_info) > 4 then
case
    when @@version like '%X86%' then 256
    when @@version like '%X64%' then 512
end +(((select cpu_count from sys.dm_os_sys_info) -4) *
case
    when @@version like '%X86%' then 8
    when @@version like '%X64%' then 16
end)
else 0
end as maxworkerthreads
)
select
maxworkerthreads +ceiling(maxworkerthreads *23.0 /100)
from maxworker