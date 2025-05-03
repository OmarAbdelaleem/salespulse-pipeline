-- This file is part of the dbt project.
-- It is used to transform and stage the raw customer data.
SELECT id as product_id,
name as product_name,
category as product_category,
price as product_price,
FROM {{ source('raw_data', 'products') }}