-- This file is part of the dbt project.
-- It is used to transform and stage the raw orders data.
SELECT id AS order_id,
customer_id,
order_date,
TOTAL_AMOUNT,
status AS order_status
FROM {{ source('raw_data', 'orders') }}