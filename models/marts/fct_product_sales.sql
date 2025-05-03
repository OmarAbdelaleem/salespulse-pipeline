-- This file is part of the dbt project.
-- It is used to generate a fact table that aggregates products' data.
-- It includes the product ID, name, category, order count, total quantity sold, total revenue, and average sale price.
{{
config(
    materialized='table'
)
}}

SELECT
    p.product_id,
    p.product_name,
    p.product_category,
    COUNT(DISTINCT o.order_id) AS order_count,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.item_total_amount) AS total_revenue,
    AVG(oi.unit_price) AS avg_sale_price
FROM {{ ref('stg_order_items') }} oi
JOIN {{ ref('stg_orders') }} o ON oi.order_id = o.order_id
JOIN {{ ref('stg_products') }} p ON oi.product_id = p.product_id
GROUP BY 1, 2, 3