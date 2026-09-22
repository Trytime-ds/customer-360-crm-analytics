select
    basket_id
from {{ ref('int_transaction_promotions') }}
group by basket_id
having count(distinct week_number) > 1
