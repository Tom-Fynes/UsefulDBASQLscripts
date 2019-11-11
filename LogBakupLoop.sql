SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET NOCOUNT ON

DECLARE @DBName nVarchar(150),
		@Date Date = Cast(Current_TimeStamp as Date),
		@Time Time = Cast(Current_TimeStamp as Time);

DECLARE BackUPCursor cursor for

Select	
	QUOTENAME(D.name)
From Sys.databases D 
Inner Join 
	sys.dm_hadr_database_replica_states RS
		on RS.database_id = D.database_id
Group By D.name

OPEN BackUPCursor

FETCH NEXT FROM BackUPCursor INTO @DBName

WHILE @@FETCH_STATUS = 0
BEGIN

Declare @SQL nVarchar(max)
Set @SQL = N'
	BACKUP LOG '+ @DBName +' TO  
	DISK = N''\\NetworkLocation\'+ @DBName +'_'+ Replace(Cast(@Date as nVarchar(25)), '-','') +'_'+ Replace(Left(Cast(@Time as nVarchar(25)), charindex('.', Cast(@Time as nVarchar(25))) - 1),':','') +'.trn'' 
	WITH NOFORMAT, NOINIT, checksum,  NAME = N''Dominus-Log Database Backup'',
	SKIP,
	NOREWIND, 
	NOUNLOAD, 
	COMPRESSION,
	ENCRYPTION (
	ALGORITHM = AES_256,
	--SERVER CERTIFICATE = [CertName]
	),STATS = 1
	GO
'

Exec (@SQL)

	FETCH NEXT FROM BackUPCursor INTO @DBName
END

close BackUPCursor;
deallocate BackUPCursor;
