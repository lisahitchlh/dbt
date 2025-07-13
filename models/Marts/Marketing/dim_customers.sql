with customers as (
    SELECT * FROM {{ ref('stg_jaffle_shop__customers') }}
),

orders as (
    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}
),

customer_orders1 as (
    SELECT customer_id
    , min(order_date) as first_order_date
    ,max(order_date) as most_recent_order_date
    , count(order_id) as number_of_orders

    FROM orders
    GROUP BY customer_id
),

payments as (
    SELECT * FROM {{ ref('fct_orders') }}
),

customer_dim as (
    SELECT c.customer_id
    ,c.first_name
    ,c.last_name
    ,co.first_order_date
    ,co.most_recent_order_date
    ,coalesce (co.number_of_orders, 0) as number_of_orders

    FROM customers as c
    LEFT JOIN customer_orders1 as co
    ON c.customer_id = co.customer_id
),

customer_orders as(

SELECT cd.customer_id, total_amount
FROM customer_dim as cd
JOIN payments as p
ON cd.customer_id = p.customer_id

)

SELECT SUM(total_amount)/100 as life_time_value FROM customer_orders