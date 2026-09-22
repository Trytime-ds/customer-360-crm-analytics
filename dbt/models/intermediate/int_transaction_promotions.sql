select
    sales.household_id,
    sales.basket_id,
    sales.day_number,
    sales.week_number,
    sales.product_id,
    sales.store_id,
    sales.sales_value,

    promotions.product_id is not null as has_promotion_record,
    coalesce(promotions.has_special_display, false) as has_special_display,
    coalesce(promotions.has_in_shelf_display, false) as has_in_shelf_display,
    coalesce(promotions.has_mailer, false) as has_mailer,
    coalesce(promotions.has_any_promotion, false) as is_promotional_line

from {{ ref('fact_sales') }} as sales
left join {{ ref('int_product_store_week_promotions') }} as promotions
    on sales.product_id = promotions.product_id
    and sales.store_id = promotions.store_id
    and sales.week_number = promotions.week_number

where sales.week_number between 9 and 101
