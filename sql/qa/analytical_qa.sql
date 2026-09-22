-- Analytical QA checkpoint
-- Run after a successful full dbt build.

-- QA 1 — Customer 360 / RFM segment distribution
select
    customer_segment,
    count(*) as customers,
    round(100 * safe_divide(count(*), sum(count(*)) over ()), 2) as customer_pct,
    round(avg(recency_days), 2) as avg_recency_days,
    round(avg(basket_count), 2) as avg_baskets,
    round(avg(monetary_value), 2) as avg_customer_revenue,
    round(sum(monetary_value), 2) as segment_revenue,
    round(100 * safe_divide(sum(monetary_value), sum(sum(monetary_value)) over ()), 2) as revenue_pct
from `customer360_marts.mart_customer_segments`
group by customer_segment
order by segment_revenue desc;

-- QA 2 — Customer universe / global metrics
select
    count(*) as customers,
    countif(has_demographic_profile) as customers_with_demographics,
    countif(is_repeat_customer) as repeat_customers,
    round(100 * safe_divide(countif(is_repeat_customer), count(*)), 2) as repeat_customer_pct,
    min(recency_days) as min_recency,
    max(recency_days) as max_recency,
    min(basket_count) as min_baskets,
    max(basket_count) as max_baskets,
    round(sum(monetary_value), 2) as total_revenue,
    round(avg(monetary_value), 2) as avg_revenue_per_customer,
    round(avg(average_order_value), 2) as avg_customer_aov
from `customer360_marts.mart_customer_360`;

-- QA 3 — Campaign performance
select
    campaign_id,
    campaign_type,
    is_fully_observed,
    targeted_households,
    round(100 * campaign_reach, 2) as campaign_reach_pct,
    customers_purchasing_during_campaign,
    round(100 * targeted_purchase_rate, 2) as targeted_purchase_rate_pct,
    unique_redeemers,
    coupon_redemption_events,
    round(100 * household_redemption_rate, 2) as household_redemption_rate_pct,
    round(revenue_during_campaign, 2) as revenue_during_campaign,
    round(average_spend_per_targeted_purchaser, 2) as avg_spend_per_targeted_purchaser,
    round(100 * targeted_household_revenue_share_during_campaign, 2)
        as targeted_household_revenue_share_pct
from `customer360_marts.mart_campaign_performance`
order by campaign_id;

-- QA 4 — Promotion performance
select
    min(week_number) as min_week,
    max(week_number) as max_week,
    count(*) as observed_weeks,
    sum(total_baskets) as total_baskets,
    sum(promotional_baskets) as promotional_baskets,
    round(100 * safe_divide(sum(promotional_baskets), sum(total_baskets)), 2)
        as promotional_basket_rate_pct,
    round(sum(total_revenue), 2) as total_revenue,
    round(sum(promotional_revenue), 2) as promotional_revenue,
    round(100 * safe_divide(sum(promotional_revenue), sum(total_revenue)), 2)
        as promotional_revenue_share_pct,
    round(sum(revenue_under_special_display), 2) as revenue_under_special_display,
    round(sum(revenue_under_mailer), 2) as revenue_under_mailer,
    round(sum(revenue_under_in_shelf_display), 2) as revenue_under_in_shelf_display
from `customer360_marts.mart_promotion_performance`;
