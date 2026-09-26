-- Customer 360 & CRM Campaign Analytics
-- Analytical Insight 05: Promotional basket behavior
--
-- Business question:
-- When a promotion is present in a basket, how much of that basket's value is
-- actually attributable to promotional lines, and how does basket value
-- compare with baskets without promotional conditions?
--
-- Important:
-- A promotional basket is any basket containing at least one promotional line.
-- Therefore, promotional basket rate and promotional revenue share operate at
-- different analytical levels.
--
-- The relationship is associative, not causal. A higher average basket value
-- for promotional baskets does not prove that the promotion increased basket
-- value.

with basket_summary as (

    select
        count(*) as total_baskets,

        countif(has_promotional_condition)
            as promotional_baskets,

        sum(basket_revenue)
            as total_revenue,

        sum(
            if(
                has_promotional_condition,
                basket_revenue,
                0
            )
        ) as revenue_from_promotional_baskets,

        sum(promotional_revenue)
            as promotional_line_revenue,

        sum(
            if(
                not has_promotional_condition,
                basket_revenue,
                0
            )
        ) as revenue_from_non_promotional_baskets

    from {{ ref('int_basket_promotion_summary') }}

)

select
    total_baskets,
    promotional_baskets,

    round(
        100 * safe_divide(
            promotional_baskets,
            total_baskets
        ),
        2
    ) as promotional_basket_rate_pct,

    round(
        100 * safe_divide(
            revenue_from_promotional_baskets,
            total_revenue
        ),
        2
    ) as promotional_basket_revenue_share_pct,

    round(
        100 * safe_divide(
            promotional_line_revenue,
            total_revenue
        ),
        2
    ) as promotional_line_revenue_share_pct,

    round(
        100 * safe_divide(
            promotional_line_revenue,
            revenue_from_promotional_baskets
        ),
        2
    ) as promotional_intensity_inside_baskets_pct,

    round(
        safe_divide(
            revenue_from_promotional_baskets,
            promotional_baskets
        ),
        2
    ) as avg_promotional_basket_value,

    round(
        safe_divide(
            revenue_from_non_promotional_baskets,
            total_baskets - promotional_baskets
        ),
        2
    ) as avg_non_promotional_basket_value,

    round(
        safe_divide(
            safe_divide(
                revenue_from_promotional_baskets,
                promotional_baskets
            ),
            safe_divide(
                revenue_from_non_promotional_baskets,
                total_baskets - promotional_baskets
            )
        ),
        2
    ) as basket_value_ratio

from basket_summary;
