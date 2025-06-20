with payments as
(
    SELECT * 
    FROM {{ ref('stg_stripe__payment') }}
), 

successful as
(
    SELECT * 
    FROM payments
    WHERE status = 'success'
)

SELECT * FROM successful
