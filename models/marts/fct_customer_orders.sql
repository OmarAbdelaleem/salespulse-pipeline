-- This file is part of the dbt project.
-- It is used to generate a fact table that aggregates customer order data.
-- The fact table includes customer details and their order statistics.
{{ 
config(
    materialized='table'
)
}}

WITH order_totals AS (
    SELECT
        customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(total_amount) AS total_spend,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS most_recent_order_date
    FROM {{ ref('stg_orders') }} o
    GROUP BY 1
)

SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.country,
    COALESCE(ot.total_orders, 0) AS total_orders,
    COALESCE(ot.total_spend, 0) AS total_spend,
    ot.first_order_date,
    ot.most_recent_order_date,
    DATEDIFF(DAY, ot.first_order_date, CURRENT_DATE) AS days_as_customer,
    ot.total_spend / NULLIF(ot.total_orders, 0) AS avg_order_value
FROM {{ ref('stg_customers') }} c
LEFT JOIN order_totals ot ON c.customer_id = ot.customer_id