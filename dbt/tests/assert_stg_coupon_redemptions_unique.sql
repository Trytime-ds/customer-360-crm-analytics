select
    household_id,
    coupon_upc,
    campaign_id,
    day_number,
    count(*) as n
from {{ ref('stg_coupon_redemptions') }}
group by
    household_id,
    coupon_upc,
    campaign_id,
    day_number
having count(*) > 1