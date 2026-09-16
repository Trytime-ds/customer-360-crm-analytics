with source as (

    select
        coupon_upc,
        product_id,
        campaign
    from {{ source('customer360', 'coupon') }}

),

deduplicated as (

    select distinct
        coupon_upc,
        product_id,
        campaign
    from source

)

select
    coupon_upc,
    product_id,
    campaign as campaign_id
from deduplicated