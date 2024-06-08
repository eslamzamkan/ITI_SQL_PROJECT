-----@@@@@@   first part there is stored procedure for each table using DML to insert, update,delete  @@@@@@---------

--#################  operation on pizza names  table ##################
------------###   first stored procedure to (insert) data into (pizaa_names) table     ###-----------------
create or alter proc insert_pizza_names (@id int,@name varchar(30),@price decimal(6,2))
as
begin
if not exists(select pizza_name from pizza_names where pizza_name like @name)
  insert into pizza_names  values(@id,@name,@price)
else
  select 'this pizza names exist before'
end

exec dbo.insert_pizza_names 11,'Marinara',60 --we will use the same raw to insert and update to test other proc
select * from pizza_names

------------###   second stored procedure to (update) data into (pizza_names) table     ###-----------------
create or alter proc update_pizza_names (@id int,@price decimal(6,2))
as
begin

if  exists(select pizza_id from pizza_names where pizza_id = @id)
   update pizza_names set price = @price where pizza_id = @id                              
else
   select 'this pizza name not exist'
end
 exec update_pizza_names 11,85 ---if we try use the same id will print error mesage in else statement
select * from pizza_names        ------to test if data update so that we select data from table
------------###   second stored procedure to (delete) data into (pizza_names) table     ###-----------------
create or alter proc delete_pizza_names (@column nvarchar(30),@newValue sql_variant)
as
begin
declare @sql nvarchar(max)

   set @sql = N'delete from pizza_names where ' + quotename(@column) +N'= convert(varchar(30),@newvalue)'
   exec sp_executesql @sql,N'@newvalue sql_variant',@newvalue = @newvalue

end

exec dbo.delete_pizza_names 'pizza_name','marinara'   --- use stored procedure that created to delete the same raw inserted before

exec dbo.delete_pizza_names 'pizza_id',11         -- another way to delete raw using id
select * from pizza_names                  ---show data to sure the new raw delete


