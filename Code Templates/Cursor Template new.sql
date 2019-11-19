SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
SET NOCOUNT ON
SET DATEFORMAT dmy


DECLARE @QueryID int; -- Declare variable to be passed into cursor.
DECLARE CursorName cursor for -- Declare cursor

/**************************************************
Below this is the start or the cursor
**************************************************/

-- Add your select statment.

OPEN CursorName

FETCH NEXT FROM CursorName INTO @QueryId

WHILE @@FETCH_STATUS = 0
BEGIN

--Add what you want the cursor to do. 

	FETCH NEXT FROM CursorName INTO @QueryId
END

close CursorName; -- Clean up after yourself and close cursor
deallocate CursorName; -- remove curosr
