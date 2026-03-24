-- Retrieve the total number of orders placed.
select count(order_id) as total_orders from orders;

-- Calculate the total revenue generated from pizza sales.
select sum(order_details.quantity * pizzas.price)
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id; 

-- Identify the highest-priced pizza.
select *
from pizzas
order by price desc
limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size as sizes, count(order_details_id) as orders
from order_details join pizzas
on pizzas.pizza_id=order_details.pizza_id
group by pizzas.size
order by orders desc; 

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.namee as typess, sum(order_details.quantity) as order_count
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on pizzas.pizza_id=order_details.pizza_id
group by pizza_types.namee
order by order_count desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category as typess, sum(order_details.quantity) as total_quantity
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on pizzas.pizza_id=order_details.pizza_id
group by typess;

-- Determine the distribution of orders by hour of the day.
select EXTRACT(HOUR FROM timee) as hours, count(order_id)
from orders
group by hours;

-- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(pizza_type_id) as total_pizzas
from pizza_types
group by category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(total_pizzas), 0)
from (select orders.datee as order_date, SUM(order_details.quantity) as total_pizzas
from order_details join orders on orders.order_id=order_details.order_id
group by order_date) t ;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.namee as typee, sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id
group by typee order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.namee, 100.0*( sum(order_details.quantity*pizzas.price)/total.total_revenue) as percentage
from pizza_types join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details on order_details.pizza_id=pizzas.pizza_id,
(
select sum(order_details.quantity * pizzas.price) as total_revenue
from pizzas
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
)total
group by pizza_types.namee, total.total_revenue;

-- Analyze the cumulative revenue generated over time.
SELECT o.datee,
sum(od.quantity * p.price) AS daily_revenue,
sum(sum(od.quantity * p.price)) OVER (ORDER BY o.datee) AS cumulative_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY o.datee
ORDER BY o.datee;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, namee, revenue
FROM (
SELECT pizza_types.category,
pizza_types.namee, SUM(order_details.quantity * pizzas.price) AS revenue,
RANK() OVER ( PARTITION BY pizza_types.category ORDER BY SUM(order_details.quantity * pizzas.price) DESC) AS rnk
    FROM pizza_types
    JOIN pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
    JOIN order_details on order_details.pizza_id = pizzas.pizza_id
    GROUP BY pizza_types.category, pizza_types.namee
) sub
WHERE rnk <= 3;



