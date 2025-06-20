-- bring in data as it is from snowflake as initial staging model

-- create a CTE with source data
WITH source as 
(SELECT * 
FROM raw.stripe.payment),

-- CTE to rename columns
renamed as (
    SELECT id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    amount,
    created as created_at,
    _batched_at
    FROM source
)

SELECT * FROM renamed
