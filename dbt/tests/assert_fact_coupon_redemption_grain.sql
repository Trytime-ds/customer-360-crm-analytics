select
    household_id,
    coupon_upc,
    campaign_id,
    day_number,
    count(*) as row_count
from {{ ref('fact_coupon_redemption') }}
group by household_id, coupon_upc, campaign_id, day_number
having count(*) > 1
