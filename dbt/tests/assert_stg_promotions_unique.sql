select
    product_id,
    store_id,
    week_number,
    display_code,
    mailer_code,
    count(*) as n
from {{ ref('stg_promotions') }}
group by
    product_id,
    store_id,
    week_number,
    display_code,
    mailer_code
having count(*) > 1