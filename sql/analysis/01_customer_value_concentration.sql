-- Customer 360 & CRM Campaign Analytics
-- Analytical Insight 01: Customer value concentration
--
-- Business question:
-- How concentrated is customer value across RFM segments, and is the
-- difference primarily associated with purchase frequency or basket value?
--
-- Analytical notes:
-- * Segment AOV is calculated as SUM(revenue) / SUM(baskets), not as the
--   average of customer-level AOVs. This preserves the identity:
--   revenue/customer = baskets/customer * revenue/basket.
-- * RFM uses Frequency and Monetary in the segmentation itself, so the
--   relationship between segment and those metrics is descriptive rather
--   than independent evidence.

with segment_base as (

    select
        customer_segment,
        count(*) as customers,
        sum(basket_count) as baskets,
        sum(monetary_value) as revenue,
        avg(recency_days) as avg_recency_days
    from {{ ref('mart_customer_segments') }}
    group by customer_segment

),

segment_metrics as (

    select
        customer_segment,
        customers,
        baskets,
        revenue,
        avg_recency_days,

        safe_divide(
            customers,
            sum(customers) over ()
        ) as customer_share,

        safe_divide(
            revenue,
            sum(revenue) over ()
        ) as revenue_share,

        safe_divide(
            baskets,
            customers
        ) as purchase_frequency,

        safe_divide(
            revenue,
            baskets
        ) as segment_aov,

        safe_divide(
            revenue,
            customers
        ) as revenue_per_customer

    from segment_base

)

select
    customer_segment,
    customers,
    round(100 * customer_share, 2) as customer_share_pct,
    round(revenue, 2) as segment_revenue,
    round(100 * revenue_share, 2) as revenue_share_pct,

    round(
        safe_divide(
            revenue_share,
            customer_share
        ),
        2
    ) as value_concentration_index,

    round(purchase_frequency, 2) as purchase_frequency,
    round(segment_aov, 2) as segment_aov,
    round(revenue_per_customer, 2) as revenue_per_customer,
    round(avg_recency_days, 2) as avg_recency_days

from segment_metrics
order by segment_revenue desc;
