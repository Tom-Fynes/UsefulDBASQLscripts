Use DatabaseName -- Change to correct database.


If Object_iD ('Databases.schema.table') is null 
Begin

Create table Database.schema.table
(


)
End

Begin Try
Begin Transaction;

; with Temp as
(
--Do Something
)

Delete co
output deleted.TableID
into Databases.schema.table
from Some.Table co 
Inner join 
temp T on T.TableID = CO.TableID

commit tran;
end try

begin catch

declare @ErrorMessage nvarchar(4000);
declare @ErrorSeverity int;
declare @ErrorState int;
declare @ErrorLine int;
declare @ErrorNumber int;
declare @ErrorProcedure nvarchar(126);

select 
@ErrorMessage = error_message(),
@ErrorSeverity = error_severity(),
@ErrorState = error_state(),
@ErrorLine = error_line(),
@ErrorNumber = error_number(),
@ErrorProcedure = error_procedure();

if @@trancount > 0
begin 
rollback transaction;
end

raiserror(@ErrorMessage, @ErrorSeverity, @ErrorState)

end catch;