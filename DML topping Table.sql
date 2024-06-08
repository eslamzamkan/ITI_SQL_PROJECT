-----@@@@@@   first part there is stored procedure for each table using DML to insert, update,delete  @@@@@@---------

--#################  operation on topping table ##################
------------###   first stored procedure to (insert) data into (toppings) table     ###-----------------
create or alter proc insert_pizza_tooping (@id int,@name varchar(30))
as
begin
if not exists(select topping_name from pizza_toppings where topping_name like @name)
  insert into pizza_toppings values(@id,@name)
else
  select 'this toppings exist before'
end

exec dbo.insert_pizza_tooping 30,'egg' --we will use the same raw to insert and update to test other proc
select * from pizza_toppings

------------###   second stored procedure to (update) data into (toppings) table     ###-----------------
create or alter proc update_pizza_tooping (@id int,@topping_name varchar(30))
as
begin

if  exists(select topping_id from pizza_toppings where topping_id = @id)
   update pizza_toppings set topping_name = @topping_name where topping_id = @id                              
else
   select 'this topping name not exist'
end
 exec update_pizza_tooping 30,'liver'
select * from pizza_toppings
------------###   second stored procedure to (delete) data into (toppings) table     ###-----------------
create or alter proc delete_topping_pizza (@column nvarchar(30),@newValue sql_variant)
as
begin
declare @sql nvarchar(max)

   set @sql = N'delete from pizza_toppings where ' + quotename(@column) +N'= convert(varchar(30),@newvalue)'
   exec sp_executesql @sql,N'@newvalue sql_variant',@newvalue = @newvalue

end
exec dbo.delete_topping_pizza 'topping_name','egg'   --- use stored procedure that created to delete the same raw inserted before
select * from pizza_toppings                  ---show data to sure the new raw delete


