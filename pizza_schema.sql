create table pizzas(
pizza_id TEXT,
pizza_type_id TEXT, 
size TEXT,
price NUMERIC
);

create table pizza_types(
pizza_type_id TEXT,
namee TEXT,
category TEXT,
ingredients TEXT
);

create table orders(
order_id INT,
datee DATE,
timee TIME
);

create table order_details(
order_details_id INT,
order_id INT,
pizza_id TEXT,
quantity INT
);

alter table pizzas
add primary key (pizza_id);

alter table pizza_types
add primary key (pizza_type_id);

alter table orders
add primary key (order_id);

alter table order_details
add primary key(order_details_id);
