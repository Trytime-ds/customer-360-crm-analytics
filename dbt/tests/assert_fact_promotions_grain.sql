select
    product_id,
    store_id,
    week_number,
    count(*) as row_count
from {{ ref('fact_promotions') }}
group by product_id, store_id, week_number
having count(*) > 1
