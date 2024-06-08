----------------first part there is stored procedure for each table using DML to insert, update,delete----------------

------------###   first stored procedure to (insert) data into (customer order) table     ###-----------------
create or alter proc insert_customer_order (@id_order int,@id_customer int,@address_delivery varchar(40),@method_payment varchar(40),@order_date date,@duration int,@cancell int,@distance decimal(7,2),@id_runner int,@pizza_name varchar(30))
as
begin

 declare @id_pizz int = (select pizza_id from pizza_names where pizza_name = @pizza_name) ---get pizza_id from pizza name that regist in order 

if not exists(select order_id from customer_orders where order_id  = @id_order)
  begin --@ start first if
    if exists(select runner_id from Runners where runner_id = @id_runner)
	   begin   --# start second if
		 if (@id_pizz is not null)
		   begin  --$ start third if 
             INSERT INTO customer_orders VALUES (@id_order,@id_customer,@address_delivery,@method_payment,@order_date,@duration,@cancell,@distance,@id_runner)
	         insert into Order_Pizza values (@id_order,@id_pizz) ---if exist insert date in m<------>N table relation
		   end   --$ end third if
		else
		   select ('ensure the name of pizza is correct')
	   end  --# end second if 
	 else
	   select 'this runners Not Exist'
   end --@ end first if
else
    select 'this order info exist before'

end ---end of stored procedure
exec dbo.insert_customer_order 11,30,'Sharm El Sheikh','cash','2024-06-07 15:50:58.343',36,0,7.5,3,'Vegetarian' --we will use the same raw to insert and update to test other proc
select * from customer_orders


------------###   second stored procedure to (update) data into (customer_orders) table     ###-----------------
create or alter proc update_customer_order (@id_order int,@column nvarchar(30),@newvalue sql_variant)
as
begin
declare @sql nvarchar(max) 
set @sql = N'update customer_orders set ' + quotename(@column) +N'= convert(varchar(30),@newvalue) where order_id = @id_order'
if exists(select order_id from customer_orders where order_id = @id_order)
   exec sp_executesql @sql,N'@newvalue sql_variant , @id_order int',@newvalue = @newvalue,@id_order = @id_order  
else
   select 'this customer order not exist'
end
exec dbo.update_customer_order 11,'payment_methods','cash on delivery'
exec dbo.update_customer_order 11,'distance',6.5   --we can update any column
select * from customer_orders
------------###   second stored procedure to (delete) data into (customer_orders) table     ###-----------------
create or alter proc delete_customer_order (@id_order int)
as
begin
if exists(select order_id from customer_orders where order_id = @id_order)
   delete from customer_orders where order_id = @id_order 
else
    select 'this order not exist'
end

--when we test this give error becuase there is foreign key from this table we handle this on Delete cascade or on Delete Null
exec dbo.delete_customer_order 11  --- use stored procedure that created to delete the same raw inserted before
select * from customer_orders            ---show data to sure the new raw delete
