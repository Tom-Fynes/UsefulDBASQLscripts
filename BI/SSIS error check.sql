SELECT TOP 100 
	OPR.object_name,
	MSG.message_time,
	MSG.message
FROM catalog.operation_messages AS MSG
INNER JOIN 
	catalog.operations AS OPR 
		ON OPR.operation_id = MSG.operation_id
WHERE MSG.message_type IN ('120','130')
    AND object_name = 'EMISHealthBusinessIntelligence'
    AND message LIKE '%EmisWebPatchingScheduled%'
ORDER BY message_time DESC



