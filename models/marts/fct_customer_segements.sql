-- This file is part of the dbt project.
-- It is used to get customer segments based on their order history.
-- It aggregates the total number of orders and total spend for each customer.
{{
config(
    materialized='table'
)
}}

SELECT
    customer_id,
    customer_name,
    country,
    total_orders,
    total_spend,
    CASE
        WHEN total_orders >= 10 THEN 'VIP'
        WHEN total_orders >= 5 THEN 'Loyal'
        WHEN total_orders >= 1 THEN 'Occasional'
        ELSE 'New'
    END AS customer_segment,
    CASE
        WHEN total_spend >= 1000 THEN 'High Value'
        WHEN total_spend >= 500 THEN 'Medium Value'
        WHEN total_spend >= 100 THEN 'Low Value'
        ELSE 'Minimal Value'
    END AS value_segment
FROM {{ ref('fct_customer_orders') }}