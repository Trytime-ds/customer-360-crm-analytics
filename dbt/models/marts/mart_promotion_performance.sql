select
    week_number,

    count(*) as total_baskets,
    countif(has_promotional_condition) as promotional_baskets,
    safe_divide(
        countif(has_promotional_condition),
        count(*)
    ) as promotional_basket_rate,

    sum(basket_revenue) as total_revenue,
    sum(promotional_revenue) as promotional_revenue,
    safe_divide(
        sum(promotional_revenue),
        sum(basket_revenue)
    ) as promotional_revenue_share,

    sum(special_display_revenue) as revenue_under_special_display,
    sum(mailer_revenue) as revenue_under_mailer,
    sum(in_shelf_revenue) as revenue_under_in_shelf_display,

    countif(has_special_display) as baskets_with_special_display,
    countif(has_mailer) as baskets_with_mailer,
    countif(has_in_shelf_display) as baskets_with_in_shelf_display

from {{ ref('int_basket_promotion_summary') }}
group by week_number
