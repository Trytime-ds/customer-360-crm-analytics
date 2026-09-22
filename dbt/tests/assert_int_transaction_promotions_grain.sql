select
    basket_id,
    product_id,
    count(*) as row_count
from {{ ref('int_transaction_promotions') }}
group by basket_id, product_id
having count(*) > 1
