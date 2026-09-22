with valid_coupon_campaigns as (

    select distinct
        coupon_upc,
        campaign_id
    from {{ ref('stg_coupons') }}

)

select
    r.household_id,
    r.coupon_upc,
    r.campaign_id,
    r.day_number
from {{ ref('stg_coupon_redemptions') }} r

left join valid_coupon_campaigns c
    on r.coupon_upc = c.coupon_upc
    and r.campaign_id = c.campaign_id

where c.coupon_upc is null