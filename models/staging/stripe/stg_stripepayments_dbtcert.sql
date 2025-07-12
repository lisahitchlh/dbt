-- will add a configuration to change from default view to building a table in Snowflake
{{
config(
materialized='table'
)
}}

SELECT ORDERID
, STATUS
, AMOUNT
, CREATED
FROM STRIPE.PAYMENT