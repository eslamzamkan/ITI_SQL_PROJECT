/*group a*/
--1-How many pizzas were ordered?
create function sd()
returns @e  table (
counta int
)
begin
insert into @e
select count(pizza_id) from Order_Pizza as count_ordered_pizza
return
end
select * from sd()
------
--2-How many unique customer orders were made?
create function sd3()
returns @y  table (
counta int
)
begin
insert into @y
select count( distinct order_id) from customer_orders as unique_customer_order
return
end
select * from sd3()

--3-How many successful orders were delivered by each runner?

create or alter view suc_orders as
select
  runner_id, count(order_id) as orders
from
	customer_orders
where
	cancellations = 0
group by
	runner_id;

select * from suc_orders


-- 4-How many of each type of pizza was delivered?

create or alter view pizza_num as
    select
        pn.pizza_name, count(op.order_id) as delivered
    from
        Order_Pizza op
    join
        pizza_names pn on op.pizza_id = pn.pizza_id
	group by        
		pn.pizza_name;

select * from pizza_num
-- 5-How many Vegetarian and Meatlovers were ordered by each customer?
create or alter procedure PizzaOrderCounts as

begin
    select
        co.customer_id,
        SUM(pn.name = 'Vegetarian') as Vegetarian_Count,
        SUM(pn.name = 'Meatlovers') as Meatlovers_Count
    from
        Customer_Orders co
    join
        order_pizza po on co.Order_id = po.order_id
    join
        Pizza_names pn on po.pizza_id = pn.pizza_id
    GROUP BY
        co.customer_id
end

--6-What was the maximum number of pizzas delivered in a single order?

create or alter procedure MaxPizzasPerOrder
as
begin
    select MAX(pizza_count) as Max_Pizzas
    from (
        select
            order_id, COUNT(*) over (PARTITION BY order_id) as pizza_count
        from
            Order_Pizza
    ) as OrderCounts
end

--7-What was the total volume of pizzas ordered for each hour of the day?    using cursor

DECLARE order_cursor CURSOR FOR
SELECT
    DATEPART(HOUR, pinching_time) AS hour_of_day,
    COUNT(order_id) AS total_order
FROM customer_orders GROUP BY DATEPART(HOUR, pinching_time)

OPEN order_cursor
DECLARE @hour_of_day INT,@total_order INT

FETCH NEXT FROM order_cursor INTO @hour_of_day, @total_order

WHILE @@FETCH_STATUS = 0
BEGIN
    SELECT @hour_of_day AS hour_of_day, @total_order AS total_order,
        CONCAT(CAST(CAST(@total_order AS DECIMAL(10,2)) / (SELECT SUM(total_order) FROM (
            SELECT COUNT(order_id) AS total_order
            FROM customer_orders
            GROUP BY DATEPART(HOUR, pinching_time)
        ) AS total_orders) * 100 AS DECIMAL(6,2)), '%') AS total_volume

    FETCH NEXT FROM order_cursor INTO @hour_of_day, @total_order
END

CLOSE order_cursor
DEALLOCATE order_cursor

--8-What was the volume of orders for each day of the week?     using view

create or alter view A10_get_voulme_eachDay 
as

SELECT top 100 percent
  datename(weekday,pinching_time) as day_of_week,
  COUNT(order_id) as total_orders,
  CONCAT(cast(COUNT(order_id)*1.0 / SUM(COUNT(order_id)) OVER() * 100 AS DECIMAL(6,2)), '%') as volume_ordered
FROM customer_orders
GROUP BY datename(weekday,pinching_time) ORDER BY COUNT(order_id) ;

select * from dbo.A10_get_voulme_eachDay

/*group B*/
--------
------1-How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)  using multistatment function
create function B1_runnerSigned()
returns @t table(total_runers int,week_category varchar(20))
as
begin
with res as (
SELECT runner_id,
  CASE WHEN registration_date BETWEEN '2021-01-01' AND '2021-01-07' THEN 'first_week'
    WHEN registration_date BETWEEN '2021-01-08' AND '2021-01-15' THEN 'second_week'
    WHEN registration_date BETWEEN '2021-01-16' AND '2021-01-23' THEN 'third_week'
    WHEN registration_date BETWEEN '2021-01-24' AND '2021-01-31' THEN 'fourth_week'
  ELSE NULL END AS week_category
FROM runners WHERE registration_date >= '2021-01-01' )

insert into @t
 select count(runner_id),week_category from res where week_category is not null 
 GROUP BY week_category order by count(runner_id);
	return
end

select * from B1_runnerSigned()


--2-
/*What was the average time in minutes it took for each runner
to arrive at the Pizza Runner HQ to pickup the order?*/

/*solution in cursor*/
declare c1 cursor 
for
SELECT  runner_id,sum(duration)/count(order_id)[avg minutes] FROM  customer_orders
where cancellations=0
group by runner_id
for read only
declare @runner_id int,@average int
open c1
fetch c1 into @runner_id,@average
while @@FETCH_STATUS =0
   begin
   select  @runner_id as 'runner_id',@average as 'average minutes'
   fetch c1 into @runner_id,@average
   end
close c1
deallocate c1


--3-Is there any relationship between the number of pizzas and how long the order takes to prepare?

create or alter procedure PizzaOrderPreparationTime
as
begin
    select
        o.order_id, COUNT(po.pizza_id) as Pizza_Count, o.duration
    from
        Customer_Orders o
    JOIN
        Order_Pizza po ON o.Order_id = po.order_id
    group by
        o.order_id, o.duration
end
--4- What was the average distance travelled for each customer?

create or alter procedure AverageDistance
as
begin
	select 
		avg(distance) as average, customer_id 
	from 
		customer_orders
	where
		cancellations = 0
	group by 
		customer_id
end

execute AverageDistance
--5-What was the difference between the longest and shortest delivery times for all orders?
select max(duration)-min(duration) from customer_orders
select min(duration) from customer_orders
select max(duration) from customer_orders
----6-What was the average speed for each runner for each delivery and do you notice any trend for these values? 
/* Using a function and TOP to handle all selected rows because there is a problem 
if we use ORDER BY in a function without TOP. */

create function B6_Average_speedRunner()
returns table
as
return(
select top 100 percent runner_id,order_id,distance,duration,cast(distance / duration as decimal(6,2))as average_speed 
from customer_orders where cancellations = 0 order by runner_id,average_speed 
)
select * from B6_Average_speedRunner()
--7-
/*What is the successful delivery percentage for each runner?*/
create function deliver()
returns  @del table(
runner_id int ,
successful_delivery int
)
begin 
insert into @del
select runner_id,count(case when cancellations=0 then 1 end)
*100.0/ count(*) [successful delivery percentage] 
from customer_orders
group by runner_id
return
end
select * from deliver()

/*group c*/

--1-What are the standard ingredients for each pizza?

select T.topping_name ,P.pizza_name 
from pizza_toppings T , pizza_names P , pizza_recipes R
where P.pizza_id=R.pizza_id and R.tooping_id=T.topping_id
--2- What was the most commonly added extra?
create function Common()
returns table
as
return
(
	select 
		top 1 pt.topping_name,  count(*) as topping_count
	from 
		pizza_recipes pr
	JOIN 
		pizza_toppings pt on pr.tooping_id = pt.topping_id
	group by
		pt.topping_name
	order by 
		topping_count desc
)

select * from Common()

--3-
/*
Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table 
and add a 2x in front of any relevant ingredients
For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"    */

create or alter  procedure C5_get_Pizza_component @pizza_name varchar(30)
as
begin
	declare @id int,@name varchar(30),@res varchar(max)
declare @id_pizza int = (select pizza_id from pizza_names where pizza_name like @pizza_name) 
if (@id_pizza is not null)
begin
  if exists(select pizza_id from pizza_recipes where pizza_id = @id_pizza)
   begin
	declare cur cursor for
	select pizza_id,pizza_name from pizza_names where pizza_id = @id_pizza

	open cur

	fetch cur into @id,@name

	while @@FETCH_STATUS = 0
	begin

	select @res = concat(@res,pt.topping_name,' , ')  from pizza_toppings as pt  
	inner join pizza_recipes as pr on pr.tooping_id = pt.topping_id 
	where pr.pizza_id = @id and @id is not null
	print @name + ' : ' + substring(@res,1,len(@res)-1) 
	set @res = ' '
	fetch cur into @id,@name
	end  ---end cursor
	close cur
	deallocate cur
      end --end nest if
	  else
	  select 'this pizza has no toppings'
    end ---end first if
	else
	select 'the name of this pizza not exist or may be in correct'
end   ---end function

exec C5_get_Pizza_component 'Pepperoni'

--4-
/*What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?*/
create function quantity()
returns @result table 
(
topping_name varchar(70),
avg_quantity int
)
as
begin
insert into @result
select topping_name,count(*)[Total Quantity] from Order_Pizza o
inner join customer_orders c
on c.order_id=o.order_id
inner join pizza_recipes pr
on pr.pizza_id=o.pizza_id
inner join pizza_toppings t
on pr.tooping_id=t.topping_id 
where  cancellations=0 
group by topping_name
order by [Total Quantity] desc
return
end
GO
SELECT * FROM quantity();
--5-

/*Generate an order item for each record in the customers_orders table in the format of one of the following:
Meat Lovers
Meat Lovers - Exclude Beef
Meat Lovers - Extra Bacon
Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers*/
create function ss()
returns @t table(
order_id int,
pizza_name varchar(70)
)
begin
insert into @t
SELECT
    co.order_id,
    pn.pizza_name AS order_item
FROM
    customer_orders co
JOIN
    Order_Pizza op ON co.order_id = op.order_id
JOIN
    pizza_names pn ON op.pizza_id = pn.pizza_id;
	return 
end
select * from ss()

/*group d*/
---calculate the total money gained from pizza orders and each runner is paid $0.30 
--per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?

declare @s1 decimal(6,2) = (
select  sum(pizza_price) as total_profit
from (select o.pizza_id , count(o.pizza_id) as count_pizza , n.price ,count(o.pizza_id)  * n.price as pizza_price
from Order_Pizza o inner join pizza_names n
on o.pizza_id=n.pizza_id 
group by o.pizza_id ,n.price) as t)

declare @s2 decimal(6,2) = (select sum(distance) * 0.30 from customer_orders)

select @s1 - @s2

/*E. Bonus Questions
If Danny wants to expand his range of pizzas - how would this impact the existing data design? 
Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all 
the toppings was added to the Pizza Runner menu?*/
insert into pizza_names(pizza_id,pizza_name,price)values(17,'Supreme',25)
INSERT INTO pizza_recipes (tooping_id, pizza_id)
SELECT topping_id, 17
FROM pizza_toppings;
select * from pizza_toppings
