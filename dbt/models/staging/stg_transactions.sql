with source as (

    select *
    from {{ source('customer360', 'transaction_data') }}

),

renamed_and_typed as (

    select
        household_key as household_id,
        basket_id,
        day as day_number,
        product_id,
        quantity,

        cast(sales_value as numeric) as sales_value,

        store_id,

        cast(retail_disc as numeric) as retail_discount,

        trans_time as transaction_time_hhmm,
        time(
            div(trans_time, 100),
            mod(trans_time, 100),
            0
        ) as transaction_time,

        week_no as week_number,

        cast(coupon_disc as numeric) as coupon_discount,
        cast(coupon_match_disc as numeric) as coupon_match_discount

    from source

)

select *
from renamed_and_typed
