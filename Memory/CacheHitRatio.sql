
WITH hit AS 
(
SELECT 
	[instance_name],  
	[cntr_value] 
FROM sys.dm_os_performance_counters 
WHERE [counter_name] = 'Cache Hit Ratio' 
AND [object_name] LIKE '%:Plan Cache%'
), 
Plans AS 
(
SELECT 
	[instance_name],  
	[cntr_value] 
FROM sys.dm_os_performance_counters 
WHERE [counter_name] = 'Cache Hit Ratio Base' 
AND [object_name] LIKE '%:Plan Cache%'
), 
CachedPages AS 
(
SELECT 
	[instance_name], 
	[cntr_value] 
FROM sys.dm_os_performance_counters 
WHERE [object_name] LIKE '%:Plan Cache%' 
AND [counter_name] = 'Cache Pages'
)
SELECT 
	RTRIM(H.[instance_name]) AS 'Name',
    CAST((H.[cntr_value] * 1.0 / (1+ P.[cntr_value])) * 100.0 AS DECIMAL(5, 2)) AS 'HitRatio%',
    (CP.[cntr_value] * 8 / 1024 ) AS 'CacheMB' 
FROM hit H
INNER JOIN Plans P
        ON H.[instance_name] = P.[instance_name] 
INNER JOIN CachedPages CP
        ON H.[instance_name] = CP.[instance_name] 
ORDER  BY 'HitRatio%';  