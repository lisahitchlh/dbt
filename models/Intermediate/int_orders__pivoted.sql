WITH payments1 as (
    select * FROM {{ ref('stg_stripe__payment') }} ),


pivoted as
(
    SELECT
        ORDER_ID,

        {% set status_method = ['success', 'fail'] %}
        {% for i in status_method %}
        sum(case when i = '{{STATUS}}' THEN AMOUNT ELSE 0 END ) as {{i}}_amount
        {% endfor %}

     FROM payments1
     GROUP BY 1
)

SELECT * FROM pivoted