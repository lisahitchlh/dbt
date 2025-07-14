
-- import CTEs
WITH orders as
(
    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}
),

payments as
(
    SELECT * FROM {{ ref('stg_stripe__payment') }}
),

customers as
(
SELECT * FROM {{ ref('stg_jaffle_shop__customers') }}
),

--logical model CTEs
total_amount as
(SELECT
    order_id, 
    max(created_at) as payment_finalized_date,
    sum(amount) / 100.0 as total_amount_paid
    from payments as p
    where status <> 'fail'
    group by 1),

customer_orders as
(
select c.customer_id  
    , min(o.order_date) as first_order_date
    , max(o.order_date) as most_recent_order_date
    , count(o.order_id) AS number_of_orders
from customers as c
JOIN orders as o
    on o.customer_id=c.customer_id 
group by 1),

-- final CTEs
paid_orders as 
(SELECT
    o.customer_id,
    o.order_id,
    o.order_date as order_placed_at,
    o.status as order_status,
    ta.total_amount_paid,
    ta.payment_finalized_date,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
FROM orders as o
JOIN total_amount as ta 
    ON o.order_id = ta.order_id
join customers as c
    on o.customer_id = c.customer_id
JOIN payments as p
    on o.order_id = p.order_id),

bad_clv as(
select p.order_id,
        sum(t2.total_amount_paid) as clv_bad
    from paid_orders p
    left join paid_orders t2 on p.customer_id = t2.customer_id and p.order_id >= t2.order_id
    group by p.order_id),

final as(
select
p.*,
ROW_NUMBER() OVER (ORDER BY p.order_id) as transaction_seq,
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY p.order_id) as customer_sales_seq,
CASE WHEN c.first_order_date = p.order_placed_at THEN 'new' ELSE 'return' END as nvsr,
b.clv_bad as customer_lifetime_value,
c.first_order_date
FROM paid_orders as p
    join customer_orders as c USING (customer_id)
    LEFT OUTER JOIN bad_clv as b
    on b.order_id = p.order_id
    ORDER BY order_id)

    SELECT * FROM final