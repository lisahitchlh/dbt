with int_model as
(
    SELECT * FROM {{ ref('int_successful_payments') }}
), 

aggregated as (
    SELECT created_at as date,
    sum(amount) as daily_sales

    FROM int_model
    GROUP BY 1
    ORDER BY date
)

SELECT * 
FROM aggregated