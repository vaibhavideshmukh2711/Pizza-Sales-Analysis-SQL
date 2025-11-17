select *from pizzas;

#Basic:
-- 1.Retrieve the total number of orders placed.

SELECT 
    COUNT(order_id) AS total_orders
FROM
    orders;

-- 2. Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(order_details.quantity * pizzas.price),2) AS total_sales
FROM order_details
JOIN pizzas 
ON pizzas.pizza_id = order_details.pizza_id;

-- 3. Identify the highest-priced pizza.

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc
limit 1;

-- 4.Identify the most common pizza size ordered.

select * from order_details;
select * from pizzas;

select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by order_count desc;

-- 5.List the top 5 most ordered pizza types along with their quantities.

select * from pizzas;
select *from order_details;
select * from pizza_types;

select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details 
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name
order by quantity desc
limit 5;

#Intermediate:

-- 6. Join the necessary tables to find the total quantity of each pizza category


select * from pizza_types;
select * from order_details;
select * from pizzas;

SELECT 
    pizza_types.category,
    SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY quantity DESC;

-- 7.Determine the distribution of orders by hour of the day.

SELECT 
    HOUR(order_time) AS hour, COUNT(order_id) AS order_count
FROM
    orders
GROUP BY HOUR(order_time);

-- 8. Join relevant tables to find the category-wise distribution of pizzas.

SELECT 
    category, COUNT(name) AS pizza_count
FROM
    pizza_types
GROUP BY category;

--  9 .Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    ROUND(AVG(quantity), 0) AS avg_pizza_order_per_day
FROM
    (SELECT 
        orders.order_date, SUM(order_details.quantity) AS quantity
    FROM
        orders
    JOIN order_details ON orders.order_id = order_details.order_id
    GROUP BY orders.order_date) AS order_quantity;


-- 10. Determine the top 3 most ordered pizza types based on revenue.

SELECT 
    pizza_types.name,
    SUM(order_details.quantity * pizzas.price) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizzas.pizza_type_id = pizza_types.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY revenue DESC
LIMIT 3;

use pizzahut;

select * from pizzas;

-- 11. Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;


-- 12 Analyze the cumulative revenue generated over time.

select order_date, 
sum(revenue) over (order by order_date)  as cum_revenue
from
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as revenue
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date )  as sales;


--  13 Determine the top 3 most ordered pizza types 
-- based on revenue for each pizza category.


select name,revenue from 
(select  category,name,revenue,
rank() over(partition by category order by revenue desc ) as rnk 
from
(select pizza_types.category, pizza_types.name,
sum((order_details.quantity) * pizzas.price) as revenue
from pizza_types
join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) as a ) as b 
where rnk <=3;


-- Monthly Sales Trend:



SELECT EXTRACT(MONTH FROM o.order_date) AS month, 
      round( SUM(p.price * od.quantity), 0)AS total_sales
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY EXTRACT(MONTH FROM o.order_date)
ORDER BY month;


 -- By ordetr id Ordering Frequency

select * from order_details;
select *from pizzas;

SELECT order_id, 
       COUNT(od.order_id) AS order_count, 
       SUM(p.price) AS total_spent
FROM Order_details od  join pizzas p on od.pizza_id=p.pizza_id
GROUP BY order_id
HAVING COUNT(order_id) > 5  -- filter customers with more than 5 orders
ORDER BY order_count DESC;










