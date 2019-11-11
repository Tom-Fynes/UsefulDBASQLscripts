SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET NOCOUNT ON

USE master


Declare @DataDrive nVarchar(100) = '', -- Enter Data file folder location
		@LogDrive nVarchar(100) = '',  -- Enter Log file folder location
		@TempDataDrive nVarchar(100) = '', -- Enter Data file folder location
		@TempLogDrive nVarchar(100) = '';  -- Enter Log file folder location


DECLARE @Code nVarchar(max);

DECLARE FileMoveCursor cursor for

	SELECT 
		'ALTER DATABASE '''+ D.name +''' MODIFY FILE (NAME = [' + f.name + '],'
		+ ' FILENAME = '''+ CASE WHEN f.type = 0 THEN  @DataDrive else @LogDrive END + '' + f.name
		+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
		+ ''');' as Code
	FROM sys.master_files f
	Inner Join 
		Sys.Databases D 
			on D.database_id = f.database_id
	WHERE D.Name in 
	(
		'model', 
		'msdb'
	);

OPEN FileMoveCursor

FETCH NEXT FROM FileMoveCursor INTO @Code

WHILE @@FETCH_STATUS = 0
BEGIN

	Exec (@Code)

	FETCH NEXT FROM FileMoveCursor INTO @Code
END

close FileMoveCursor;
deallocate FileMoveCursor;

/*****************************************************************************************************************************
															Move TempDB
*****************************************************************************************************************************/

DECLARE @TempCode nVarchar(max);

DECLARE TempFileMoveCursor cursor for

	SELECT 
		'ALTER DATABASE '''+ D.name +''' MODIFY FILE (NAME = [' + f.name + '],'
		+ ' FILENAME = '''+ CASE WHEN f.type = 0 THEN  @TempDataDrive else @TempLogDrive END + '' + f.name
		+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
		+ ''');' as Code
	FROM sys.master_files f
	Inner Join 
		Sys.Databases D 
			on D.database_id = f.database_id
	WHERE D.Name = 'tempdb'

OPEN TempFileMoveCursor

FETCH NEXT FROM TempFileMoveCursor INTO @TempCode

WHILE @@FETCH_STATUS = 0
BEGIN

	Exec (@TempCode)

	FETCH NEXT FROM TempFileMoveCursor INTO @TempCode
END

close TempFileMoveCursor;
deallocate TempFileMoveCursor;