select
    product_id,
    store_id,
    week_number,
    logical_or(display_code in ('1', '2', '3', '4', '5', '6', '7', '9')) as has_special_display,
    logical_or(display_code = 'A') as has_in_shelf_display,
    logical_or(mailer_code != '0') as has_mailer,
    logical_or(
        display_code in ('1', '2', '3', '4', '5', '6', '7', '9')
        or mailer_code != '0'
    ) as has_any_promotion,
    count(*) as promotion_record_count,
    count(distinct display_code) as distinct_display_code_count,
    count(distinct mailer_code) as distinct_mailer_code_count
from {{ ref('stg_promotions') }}
group by
    product_id,
    store_id,
    week_number
