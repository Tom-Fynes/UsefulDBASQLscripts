EXEC msdb.dbo.sp_add_alert
@name=N'AlwaysOn - Role Change',
@message_id=1480,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=0,
@category_name=N'[Uncategorized]', 
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_alert
@name=N'AlwaysOn - Data Movement Suspended',
@message_id=35264,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=0, 
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO
EXEC msdb.dbo.sp_add_alert
@name=N'AlwaysOn - Data Movement Resumed',
@message_id=35265,
@severity=0,
@enabled=1,
@delay_between_responses=0,
@include_event_description_in=0,
@category_name=N'[Uncategorized]',
@job_id=N'00000000-0000-0000-0000-000000000000'
GO

EXEC msdb.dbo.sp_add_notification
@alert_name = N'AlwaysOn - Role Change',
@operator_name = N'DBAHub Alerts',
@notification_method =n1;
GO
EXEC msdb.dbo.sp_add_notification
@alert_name = N'AlwaysOn - Data Movement Suspended',
@operator_name = N'DBAHub Alerts',
@notification_method =n1;
GO
EXEC msdb.dbo.sp_add_notification
@alert_name = N'AlwaysOn - Data Movement Resumed',
@operator_name = N'DBAHub Alerts',
@notification_method =n1;
GO