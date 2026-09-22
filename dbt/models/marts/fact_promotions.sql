select
    product_id,
    store_id,
    week_number,
    has_special_display,
    has_in_shelf_display,
    has_mailer,
    has_any_promotion,
    promotion_record_count,
    distinct_display_code_count,
    distinct_mailer_code_count
from {{ ref('int_product_store_week_promotions') }}
