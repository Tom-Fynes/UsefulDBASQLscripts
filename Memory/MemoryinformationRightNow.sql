-- Memory Right now
select 
	* 
from sys.dm_os_process_memory

go

SELECT distinct 
	mc.page_allocator_address,
	memory_clerk_address,
	mc.[type] as Memory_clerk_type,
	mo.[type] as Memory_Object_type,
	mc.[name],
	mc.memory_node_id,
	mc.pages_kb,
	virtual_memory_reserved_kb,
	virtual_memory_committed_kb,
	virtual_address_space_reserved_kb,
	virtual_address_space_committed_kb,
	locked_page_allocations_kb
	awe_allocated_kb,
	mc.shared_memory_reserved_kb,
	mc.shared_memory_committed_kb,
	mc.page_size_in_bytes,
	target_kb,
	cpu_affinity_mask
FROM sys.dm_os_memory_objects mo
inner join sys.dm_os_memory_clerks mc on mo.page_allocator_address = mc.page_allocator_address
inner join sys.dm_os_memory_nodes mn on mc.memory_node_id = mn.memory_node_id
ORDER BY mc.pages_kb DESC

GO

Dbcc memorystatus

GO

Select 
	* 
from sys.dm_os_loaded_modules

Go

SELECT 
	t.name, 
	lock_escalation_desc 
FROM sys.tables t 
where type_desc = 'USER_TABLE'

