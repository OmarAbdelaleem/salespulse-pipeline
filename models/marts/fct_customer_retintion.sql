-- This file is part of the dbt project.
-- It is used to get the customer retention rate.
-- It calculates the number of customers who made a purchase in each month after their first purchase.
{{
config(
    materialized='table'
)
}}

WITH customer_cohorts AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', MIN(order_date)) AS cohort_month
    FROM {{ ref('stg_orders') }}
    GROUP BY 1
),

monthly_activity AS (
    SELECT
        cc.customer_id,
        cc.cohort_month,
        DATE_TRUNC('month', o.order_date) AS activity_month,
        COUNT(DISTINCT o.order_id) AS order_count,
        SUM(o.total_amount) AS total_spend
    FROM {{ ref('stg_orders') }} o
    JOIN customer_cohorts cc ON o.customer_id = cc.customer_id
    GROUP BY 1, 2, 3
)

SELECT
    cohort_month,
    activity_month,
    DATEDIFF(month, cohort_month, activity_month) AS months_since_first_purchase,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(order_count) AS total_orders,
    SUM(total_spend) AS total_revenue
FROM monthly_activity
GROUP BY 1, 2, 3
ORDER BY 1, 2