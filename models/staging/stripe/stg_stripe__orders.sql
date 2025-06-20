-- bring in data as it is from snowflake as initial staging model

-- create a CTE with source data
WITH source as 
(SELECT * 
FROM {{ source('jaffle_shop', 'orders')}}
),

-- CTE to rename columns
renamed as (
    SELECT 
    id as order_id,
    customer as user_id,
    ordered_at as order_date,
    FROM source
)

SELECT * FROM renamed
