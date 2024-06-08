----------------first part there is stored procedure for each table using DML to insert, update,delete----------------

------------###   first stored procedure to (insert) data into (Runners) table     ###-----------------
create or alter proc insert_runner
(@id_runner int,@name varchar(40),@contact_num varchar(40),@e_mail varchar(40),@address varchar(40),@vehicle varchar(40),@experience int,@status varchar(10),@start_shift time(7),@end_shift time(7),@regist_date date)
as
begin
   begin try 
      insert into Runners values(@id_runner,@name,@contact_num,@e_mail,@address,@vehicle,@experience,@status,@start_shift,@end_shift,@regist_date)
      PRINT 'Runner record inserted successfully.';
   end try
   begin catch
      DECLARE @errorMessage NVARCHAR(MAX);
     SET @errorMessage = ERROR_MESSAGE();
     PRINT 'Error inserting runner record: ' + @errorMessage;
  end catch
end ---end of stored procedure
exec dbo.insert_runner 12,'John Smith','+20123456789','jhon@example.com','Sharm El Sheikh, Egypt','car',2,'active','08:00:00','17:00:00','2021-05-26' --we will use the same raw to insert and update to test other proc
select * from Runners


------------###   second stored procedure to (update) data into (Runners) table     ###-----------------
create or alter proc update_runner (@id_runner int,@column nvarchar(30),@newvalue sql_variant)
as
begin

   begin try 
	 declare @sql nvarchar(max) 
	 set @sql = N'update runners set ' + quotename(@column) +N'= convert(varchar(30),@newvalue) where runner_id = @id_runner'
	 if exists(select runner_id from runners where runner_id = @id_runner)
	    begin
          exec sp_executesql @sql,N'@newvalue sql_variant , @id_runner int',@newvalue = @newvalue,@id_runner = @id_runner 
          PRINT 'Runner record updated successfully.';
		end
	 else
	      PRINT 'this runner not exist.'; 
   end try
   begin catch
      DECLARE @errorMessage NVARCHAR(MAX);
     SET @errorMessage = ERROR_MESSAGE();
     PRINT 'Error inserting runner record: ' + @errorMessage;
  end catch
end

exec dbo.update_runner 12,'email','jhon123@example.com'
exec dbo.update_runner 12,'name','khalid hosny'  --use different column
select * from Runners

------------###   second stored procedure to (delete) data into (Runners) table     ###-----------------
create or alter proc delete_runner (@id_runner int)
as
begin
if exists(select runner_id from Runners where runner_id = @id_runner)
   delete from Runners where runner_id = @id_runner 
else
    select 'this runner not exist'
end

exec dbo.delete_runner 12  --- use stored procedure that created to delete the same raw inserted before
select * from Runners            ---show data to sure the new raw delete
