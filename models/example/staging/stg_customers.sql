-- This file is part of the dbt project.
-- It is used to transform and stage the raw customer data.
SELECT id AS customer_id,
name AS customer_name,
email,
country
FROM {{ source('raw_data', 'customers') }}