with customer_universe as (

    select distinct
        household_id
    from {{ ref('stg_transactions') }}

)

select
    r.household_id,
    r.coupon_upc,
    r.campaign_id,
    r.day_number
from {{ ref('stg_coupon_redemptions') }} r

left join customer_universe c
    on r.household_id = c.household_id

where c.household_id is null