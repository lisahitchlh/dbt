SELECT 
    order_id,
    sum(amount) as total_amount

FROM {{ ref('stg_stripe__payment') }}
GROUP BY order_id
HAVING (total_amount >0)