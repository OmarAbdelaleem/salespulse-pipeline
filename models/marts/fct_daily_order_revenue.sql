-- This file is part of the dbt project.
-- It is used to create a fact table for daily order revenue.
-- It aggregates the total revenue for each order on a daily basis.
select
o.order_date,
o.order_id,
sum(OI.total_price) as total_price
from
{{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_order_items') }} OI on o.order_id = OI.order_id
GROUP BY 1,2