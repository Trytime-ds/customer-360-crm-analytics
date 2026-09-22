select
    product_id,
    store_id,
    week_number,
    count(*) as row_count
from {{ ref('int_product_store_week_promotions') }}
group by product_id, store_id, week_number
having count(*) > 1
