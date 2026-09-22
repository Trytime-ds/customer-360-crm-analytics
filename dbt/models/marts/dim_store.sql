select distinct store_id
from (
    select store_id from {{ ref('stg_transactions') }}
    union distinct
    select store_id from {{ ref('stg_promotions') }}
)
