WITH orders as (
    SELECT * FROM {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    SELECT * FROM {{ ref('stg_stripe__payment') }}
)

SELECT
o.order_id
, o.customer_id
,SUM(p.AMOUNT) as total_amount

FROM orders as o
LEFT JOIN payments as p
ON p.order_id = o.order_id
GROUP BY 1,2