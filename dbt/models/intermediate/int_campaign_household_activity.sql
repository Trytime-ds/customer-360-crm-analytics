with assignments as (

    select
        received.household_id,
        received.campaign_id,
        campaign.campaign_type,
        campaign.start_day_number,
        campaign.observed_end_day_number
    from {{ ref('fact_campaign_received') }} as received
    inner join {{ ref('dim_campaign') }} as campaign
        using (campaign_id)

),

purchase_activity as (

    select
        assignments.household_id,
        assignments.campaign_id,
        count(distinct sales.basket_id) as baskets_during_campaign,
        sum(sales.sales_value) as revenue_during_campaign
    from assignments
    inner join {{ ref('fact_sales') }} as sales
        on assignments.household_id = sales.household_id
        and sales.day_number between assignments.start_day_number
        and assignments.observed_end_day_number
    group by
        assignments.household_id,
        assignments.campaign_id

),

redemption_activity as (

    select
        assignments.household_id,
        assignments.campaign_id,
        count(*) as redemption_events,
        count(distinct redemption.coupon_upc) as distinct_coupons_redeemed
    from assignments
    inner join {{ ref('fact_coupon_redemption') }} as redemption
        on assignments.household_id = redemption.household_id
        and assignments.campaign_id = redemption.campaign_id
        and redemption.day_number between assignments.start_day_number
        and assignments.observed_end_day_number
    group by
        assignments.household_id,
        assignments.campaign_id

)

select
    assignments.household_id,
    assignments.campaign_id,
    assignments.campaign_type,
    assignments.start_day_number,
    assignments.observed_end_day_number,

    coalesce(purchase.baskets_during_campaign, 0) as baskets_during_campaign,
    coalesce(purchase.revenue_during_campaign, 0) as revenue_during_campaign,
    coalesce(purchase.baskets_during_campaign, 0) > 0 as has_purchase_during_campaign,

    coalesce(redemption.redemption_events, 0) as redemption_events,
    coalesce(redemption.distinct_coupons_redeemed, 0) as distinct_coupons_redeemed,
    coalesce(redemption.redemption_events, 0) > 0 as has_redemption

from assignments
left join purchase_activity as purchase
    using (household_id, campaign_id)
left join redemption_activity as redemption
    using (household_id, campaign_id)
