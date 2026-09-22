with campaign_activity as (

    select
        household_id,
        count(distinct campaign_id) as campaigns_received
    from {{ ref('fact_campaign_received') }}
    group by household_id

),

redemption_activity as (

    select
        household_id,
        count(*) as coupon_redemption_events,
        count(distinct coupon_upc) as distinct_coupons_redeemed,
        count(distinct campaign_id) as campaigns_with_redemption
    from {{ ref('fact_coupon_redemption') }}
    group by household_id

)

select
    customer.household_id,
    customer.age_range,
    customer.marital_status_code,
    customer.income_range,
    customer.homeowner_status,
    customer.household_composition,
    customer.household_size,
    customer.kid_category,
    customer.has_demographic_profile,

    metrics.first_purchase_day,
    metrics.last_purchase_day,
    metrics.recency_days,
    metrics.basket_count,
    metrics.monetary_value,
    metrics.average_order_value,
    metrics.is_repeat_customer,

    safe_divide(
        metrics.monetary_value,
        sum(metrics.monetary_value) over ()
    ) as customer_revenue_share,

    rfm.recency_percentile,
    rfm.frequency_percentile,
    rfm.monetary_percentile,
    rfm.recency_score,
    rfm.frequency_score,
    rfm.monetary_score,
    rfm.rfm_total_score,
    rfm.rfm_code,

    coalesce(campaign.campaigns_received, 0) as campaigns_received,
    coalesce(redemption.coupon_redemption_events, 0) as coupon_redemption_events,
    coalesce(redemption.distinct_coupons_redeemed, 0) as distinct_coupons_redeemed,
    coalesce(redemption.campaigns_with_redemption, 0) as campaigns_with_redemption,

    coalesce(campaign.campaigns_received, 0) > 0 as has_campaign_history,
    coalesce(redemption.coupon_redemption_events, 0) > 0 as has_coupon_redemption

from {{ ref('dim_customer') }} as customer
inner join {{ ref('int_customer_metrics') }} as metrics
    using (household_id)
inner join {{ ref('int_customer_rfm') }} as rfm
    using (household_id)
left join campaign_activity as campaign
    using (household_id)
left join redemption_activity as redemption
    using (household_id)
