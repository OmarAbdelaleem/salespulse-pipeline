-- This file is part of the dbt project.
-- It is used to transform and stage the raw customer data.
SELECT
    id AS order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS item_total_amount
FROM {{ source('raw_data', 'order_items') }}