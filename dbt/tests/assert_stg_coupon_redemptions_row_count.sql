with raw as (

    select count(*) as row_count
    from {{ source('customer360', 'coupon_redempt') }}

),

staging as (

    select count(*) as row_count
    from {{ ref('stg_coupon_redemptions') }}

)

select
    raw.row_count as raw_rows,
    staging.row_count as staging_rows
from raw
cross join staging
where raw.row_count != staging.row_count