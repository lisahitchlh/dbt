SELECT 
    ORDERID as order_id
    , id as payment_id
    , paymentmethod as payment_method
    , AMOUNT/100 as amount
    , created as created_at
    , status
FROM stripe.payment

