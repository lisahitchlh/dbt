SELECT 
    ORDERID as order_id
    , AMOUNT as amount
    , created as created_at
    , status
FROM stripe.payment

