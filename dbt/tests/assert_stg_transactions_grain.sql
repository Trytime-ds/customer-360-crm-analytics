select
    basket_id,
    product_id,
    count(*) as row_count

from {{ ref('stg_transactions') }}

group by
    basket_id,
    product_id

having count(*) > 1