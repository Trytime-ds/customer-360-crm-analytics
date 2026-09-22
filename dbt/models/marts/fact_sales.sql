select
    household_id,
    basket_id,
    day_number,
    product_id,
    quantity,
    sales_value,
    store_id,
    retail_discount,
    transaction_time_hhmm,
    transaction_time,
    week_number,
    coupon_discount,
    coupon_match_discount
from {{ ref('stg_transactions') }}
where day_number between 1 and 711
