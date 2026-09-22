select
    household_key as household_id,
    coupon_upc,
    campaign as campaign_id,
    day as day_number
from {{ source('customer360', 'coupon_redempt') }}