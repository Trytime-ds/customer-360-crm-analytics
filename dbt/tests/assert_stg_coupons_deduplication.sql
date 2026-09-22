with expected as (

    select distinct
        coupon_upc,
        product_id,
        campaign
    from {{ source('customer360', 'coupon') }}

),

expected_count as (

    select count(*) as row_count
    from expected

),

staging_count as (

    select count(*) as row_count
    from {{ ref('stg_coupons') }}

)

select
    expected_count.row_count as expected_rows,
    staging_count.row_count as staging_rows
from expected_count
cross join staging_count
where expected_count.row_count != staging_count.row_count