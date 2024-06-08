CREATE TABLE Runners (
    runner_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT,
    vehicle_type VARCHAR(50),
    experience INT, 
    status VARCHAR(20), -- e.g., active, on leave
    shift_start_time TIME,
    shift_end_time TIME,
    registration_date DATE NOT NULL,
    CHECK (shift_start_time < shift_end_time)
);
INSERT INTO Runners 
VALUES
  (1, 'Ahmed ali', '+1234567890', 'Ahmed@example.com', '123 Main Street', 'Car', 5, 'active', '08:00:00', '17:00:00', '2024-06-06'),
  (2, 'mohamed Nasser', '+5476548210', 'mohamed@example.com', '15 Ali fahmy St.Giza', 'Bike', 3, 'active', '06:00:00', '12:14:00', '2022-06-05'),
  (3, 'omar mahmoud', '+7654324510', 'omar@example.com', '120 elsalam Street', 'motor cicyle', 2, 'active', '03:00:00', '10:22:00', '2023-04-04'),
  (4, 'Raoof Adel', '+0124578214', 'Raoof@example.com', '18 Kholosi st.Shobra.Cairo', 'motor cicyle', 4, 'active', '02:00:00', '8:40:00', '2024-04-18'),
  (5, 'omran sobhy', '+471214715', 'omran@example.com', '55 Orabi St. El Mohandiseen .Cairo', 'Bike', 1, 'active', '03:00:00', '12:20:00', '2023-11-10');

 create TABLE customer_orders (
  order_id int primary key,
  customer_id int,
  delivery_address varchar(60),
  payment_methods varchar(20),
  pinching_time DATETIME,
  duration INT,
  cancellations INT,
  distance FLOAT,
  runner_id int foreign key REFERENCES Runners(runner_id)
);

INSERT INTO customer_orders
VALUES
  (1, 101, '120 El-Zohor Village street', 'Credit Card', '2022-02-18 10:00:00', 60, 0, 5.2,1),
  (2, 102, 'El-Mehata Street', 'Debit Card', '2024-04-04 11:30:00', 45, 0, 3.8,5),
  (3, 98, '789 Oak Street, Anytown', 'Cash on Delivery', '2024-01-07 14:00:00', 75, 1, 7.1,3),
  (4, 147, 'New Valley, Qena', 'Credit Card', '2024-05-22 16:15:00', 30, 0, 2.5,2),
  (5, 15, '44 Hilopolis.Cairo', 'Debit Card', '2024-06-08 09:00:00', 50, 1, 4.7,4),
  (6, 10, 'Apt. 30, El-Nasr Building', 'E-Wallet', '2023-05-08 06:00:00', 22, 0, 2.2,3), 
  (7, 125, '18 Abaas El 3akaad St. Nasr City.Cairo', 'Cash on Delivery', '2023-02-08 04:22:12', 32, 1, 3.5,1),
  (8, 54, '38 Abdel Khalik Tharwat St. Downtown.Cairo', 'Debit Card', '2023-07-15 8:40:00', 28, 0, 4.5,2),
  (9, 108, '269 El-Haram st. Giza', 'E-Wallet', '2023-08-08 10:25:00', 44, 0, 4,4),
  (10, 102, 'El-Mehata Street', 'Cash on Delivery', '2024-05-14 9:15:00', 17, 1, 4,5);

create table pizza_names (
	pizza_id INT primary key,
	pizza_name VARCHAR(50),
	price DECIMAL(8,2)
);


insert into pizza_names (pizza_id, pizza_name, price) values (1, 'Meatlovers', 70.12),
(2, 'Vegetarian',28.0),
(3, 'Cheese',60.88),
(4, 'Pepperoni',100.35),
(5, 'Meat',90.33),
(6, 'BBQ Chicken',110.0),
(7, 'Honorable',45.21),
(8, 'Buffalo',55.8),
(9,'Margherita',35),
(10, 'Supreme',70.26);

CREATE TABLE Order_Pizza (
    order_id INT,
    pizza_id INT,
    PRIMARY KEY (order_id, pizza_id),
    FOREIGN KEY (order_id) REFERENCES customer_orders(order_id),
    FOREIGN KEY (pizza_id) REFERENCES pizza_names(pizza_id)
);

insert into Order_Pizza values (3,1),
(1,5),
(2,7),
(4,5),
(5,3),
(6,8),
(5,6),
(4,3),
(7,6),
(9,2),
(6,10),
(4,9),
(10,7),
(8,4);

CREATE TABLE pizza_toppings (
  topping_id int primary key,
  topping_name varchar(70)
);


insert into pizza_toppings values
(1,'Bacon'),
(2,'BBQ Sauce'),
(3,'Beef'),
(4,'cheese'),
(5,'Chicken'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Pepperoni'),
(9,'Peppers'),
(10,'Salami'),
(11,'Tomatoes'),
(12,'Tomato Sauce'),
(13,'olives'),
(14,'mushrooms'),
(15,'eggplant'),
(16,'mozzarella'),
(17,'crispy'),
(18,'basil'),
(19,'sausage'),
(20,' buttery');

CREATE TABLE pizza_recipes (
    tooping_id INT,
    pizza_id INT,
    PRIMARY KEY (tooping_id, pizza_id),
    FOREIGN KEY (tooping_id) REFERENCES pizza_toppings(topping_id),
    FOREIGN KEY (pizza_id) REFERENCES pizza_names(pizza_id)
);

insert into pizza_recipes values (3,4),
(14,10),
(7,10),
(15,10),
(17,4),
(8,4),
(3,5),
(19,5),
(16,9),
(11,9),
(5,6),
(20,8),
(12,8);
 


