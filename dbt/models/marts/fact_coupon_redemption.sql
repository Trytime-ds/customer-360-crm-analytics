select
    household_id,
    coupon_upc,
    campaign_id,
    day_number
from {{ ref('stg_coupon_redemptions') }}
where day_number between 1 and 711
