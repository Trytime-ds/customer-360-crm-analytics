select
    basket_id,
    any_value(household_id) as household_id,
    any_value(week_number) as week_number,

    sum(sales_value) as basket_revenue,

    logical_or(is_promotional_line) as has_promotional_condition,
    logical_or(has_special_display) as has_special_display,
    logical_or(has_in_shelf_display) as has_in_shelf_display,
    logical_or(has_mailer) as has_mailer,

    sum(if(is_promotional_line, sales_value, 0)) as promotional_revenue,
    sum(if(has_special_display, sales_value, 0)) as special_display_revenue,
    sum(if(has_in_shelf_display, sales_value, 0)) as in_shelf_revenue,
    sum(if(has_mailer, sales_value, 0)) as mailer_revenue

from {{ ref('int_transaction_promotions') }}
group by basket_id
