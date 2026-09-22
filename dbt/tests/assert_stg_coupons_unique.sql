select
    coupon_upc,
    product_id,
    campaign_id,
    count(*) as n
from {{ ref('stg_coupons') }}
group by
    coupon_upc,
    product_id,
    campaign_id
having count(*) > 1