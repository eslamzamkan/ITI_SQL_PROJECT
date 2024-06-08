-----@@@@@@   first part there is stored procedure for each table using DML to insert, update,delete  @@@@@@---------

--#################  operation on pizza recipes table ##################
------------###   first stored procedure to (insert) data into (pizza recipes) table     ###-----------------
create or alter proc insert_pizza_reipes (@topping_name varchar(30),@pizza_name varchar(30))
as
begin
declare @pi_id int = (select pizza_id from pizza_names where pizza_name like @pizza_name) 
declare @to_id int = (select topping_id from pizza_toppings where topping_name like @topping_name)

if (@to_id is not null)
   if(@pi_id is not null)
     insert into pizza_recipes values(@to_id,@pi_id)
   else
     select 'this pizza  is not correct'
else
  select 'this topping is not correct'
end

exec dbo.insert_pizza_reipes 'BBQ Sauce','Pepperoni' --we will use the same raw to insert and update to test other proc
select * from pizza_recipes   --  topinng id  = 2 and pizza id  = 4 in the new raw
select * from pizza_names      -- id 4  Pepperoni
select * from pizza_toppings  --- id 2 BBQ Sauce

------------###   first stored procedure to (update) data into (pizza recipes) table     ###-----------------
create or alter proc delete_pizza_reipes (@topping_name varchar(30),@pizza_name varchar(30))
as
begin
declare @pi_id int = (select pizza_id from pizza_names where pizza_name like @pizza_name) 
declare @to_id int = (select topping_id from pizza_toppings where topping_name like @topping_name)

if (@to_id is not null)
   if(@pi_id is not null)
       delete from pizza_recipes where pizza_id = @pi_id and tooping_id = @to_id
   else
     select 'this pizza  is not correct'
else
  select 'this topping is not correct'
end
                                                                                            --tooping_id   pizza_id
exec dbo.delete_pizza_reipes 'Bacon','Pepperoni' --we will use the same raw to remove and          1          4
select * from pizza_recipes   --  topinng id  = 1 and pizza id  = 4 in the new raw
select * from pizza_names      -- id 4  Pepperoni
select * from pizza_toppings  --- id 1 Bacon





