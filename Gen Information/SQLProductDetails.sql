SELECT
	SERVERPROPERTY('productversion') [Product Version],
	SERVERPROPERTY ('productlevel') [Product Level],
	SERVERPROPERTY ('edition') Edition,
	SERVERPROPERTY ('MachineName') [Machine Name],
	p.create_date [SQL Server Installation Date],
			@@Version [Full Version]
FROM sys.server_principals P
WHERE p.name='NT AUTHORITY\SYSTEM'


