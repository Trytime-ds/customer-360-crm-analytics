select
    basket_id,
    product_id,
    count(*) as row_count
from {{ ref('fact_sales') }}
group by basket_id, product_id
having count(*) > 1
