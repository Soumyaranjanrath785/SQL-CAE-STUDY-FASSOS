drop table if exists driver;
CREATE TABLE driver(driver_id integer,reg_date date); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,'01-01-2021'),
(2,'2021-01-03'),
(3,'2021-01-08'),
(4,'2021-01-15');


drop table if exists ingredients;
CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

drop table if exists rolls;
CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');

drop table if exists rolls_recipes;
CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

drop table if exists driver_order;
CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time timestamp,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation) 
 VALUES(1,1,'2021-01-01 18:15:34','20km','32 minutes',''),
(2,1,'2021-01-01 19:10:54','20km','27 minutes',''),
(3,1,'2021-01-03 00:12:37','13.4km','20 mins','NaN'),
(4,2,'2021-01-04 13:53:03','23.4','40','NaN'),
(5,3,'2021-01-08 21:10:57','10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,'2020-01-08 21:30:45','25km','25mins',null),
(8,2,'2020-01-10 00:15:02','23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,'2020-01-11 18:50:20','10km','10minutes',null);


drop table if exists customer_orders;
CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date timestamp);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','','2021-01-01  18:05:02'),
(2,101,1,'','','2021-01-01 19:00:52'),
(3,102,1,'','','2021-01-02 23:51:23'),
(3,102,2,'','NaN','2021-01-02 23:51:23'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,1,'4','','2021-01-04 13:23:46'),
(4,103,2,'4','','2021-01-04 13:23:46'),
(5,104,1,null,'1','2021-01-08 21:00:29'),
(6,101,2,null,null,'2021-01-08 21:03:13'),
(7,105,2,null,'1','2021-01-08 21:20:29'),
(8,102,1,null,null,'2021-01-09 23:54:33'),
(9,103,1,'4','1,5','2021-01-10 11:22:59'),
(10,104,1,null,null,'2021-01-11 18:34:49'),
(10,104,1,'2,6','1,4','2021-01-11 18:34:49');

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;

parts of portfolio 
A-Roll metrices
B-Driver and customer experience
C-Ingrient optimisation
P-Pricing and rating


A-Roll metrices

1.HOW MANY ROLLS WERE ORDERED?

select count(roll_id) as no_of_rolls_ordered from customer_orders

2.HOW MANY UNIQUE CUSTOMER ORDERS  WERE MADE?

select count(distinct customer_id) as no_of_unique_customers from customer_orders

3.HOW MANY SUCESSFULL ORDERS WERE DELEVERED BY EACH DRIVER?

SELECT COUNT(order_id) AS order_count, driver_id
FROM driver_order
WHERE cancellation NOT LIKE '%Cancellation%'
GROUP BY driver_id;

4.HOW MANY EACH TYPE OF ROLLS WERE DELEVERED

SELECT count(order_id) as no_of_orders,roll_id from(select c.*,d.cancellation,case when d.cancellation like '%Cancellation%'  then 'C' ELSE 'N' END AS status from customer_orders c
join driver_order d on c.order_id=d.order_id) as c where status='N' group by roll_id;

5.HOW MANY VEG AND NON VEG ROLLS WERE ORDERED BY EACH CUSTOMER

SELECT c.customer_id,r.roll_name,count(r.roll_id) from customer_orders c join rolls r on c.roll_id =r.roll_id
group by c.customer_id,r.roll_name
order by c.customer_id

6.what was the maximum no of rolls delivered in an single order

SELECT count(roll_id) as no_of_rolls,order_id from(select c.*,d.cancellation,case when d.cancellation like '%Cancellation%'  then 'C' ELSE 'N' END AS status from customer_orders c
join driver_order d on c.order_id=d.order_id) as c where status='N' group by order_id order by no_of_rolls desc limit 1;


7.for each customer how many have  at least one change and how many have no change

select *,case when not_include_items is null then 'excluded'
              when not_include_items = '' then 'excluded'
              else 'NA' end as exclude_items,
		 case when extra_items_included is null then 'included'
              when extra_items_included = '' then 'included'
              else 'NA' end as exclude_items 
from customer_orders


