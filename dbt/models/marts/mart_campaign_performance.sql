with campaign_households as (

    select *
    from {{ ref('int_campaign_household_activity') }}

),

campaign_rollup as (

    select
        campaign_id,
        any_value(campaign_type) as campaign_type,
        any_value(start_day_number) as start_day_number,
        any_value(observed_end_day_number) as observed_end_day_number,

        count(*) as targeted_households,
        countif(has_purchase_during_campaign) as customers_purchasing_during_campaign,
        safe_divide(
            countif(has_purchase_during_campaign),
            count(*)
        ) as targeted_purchase_rate,

        sum(revenue_during_campaign) as revenue_during_campaign,
        safe_divide(
            sum(revenue_during_campaign),
            count(*)
        ) as average_spend_during_campaign,
        safe_divide(
            sum(revenue_during_campaign),
            countif(has_purchase_during_campaign)
        ) as average_spend_per_targeted_purchaser,

        countif(has_redemption) as unique_redeemers,
        sum(redemption_events) as coupon_redemption_events,
        safe_divide(
            countif(has_redemption),
            count(*)
        ) as household_redemption_rate,
        safe_divide(
            sum(if(has_redemption, revenue_during_campaign, 0)),
            countif(has_redemption)
        ) as average_spend_per_redeemer

    from campaign_households
    group by campaign_id

),

all_customer_window_revenue as (

    select
        campaign.campaign_id,
        sum(sales.sales_value) as all_customer_revenue_during_campaign
    from {{ ref('dim_campaign') }} as campaign
    inner join {{ ref('fact_sales') }} as sales
        on sales.day_number between campaign.start_day_number
        and campaign.observed_end_day_number
    group by campaign.campaign_id

),

customer_universe as (

    select count(*) as customer_count
    from {{ ref('dim_customer') }}

)

select
    campaign.campaign_id,
    campaign.campaign_type,
    campaign.start_day_number,
    campaign.observed_end_day_number,
    campaign.is_fully_observed,

    campaign.targeted_households,
    safe_divide(
        campaign.targeted_households,
        customer_universe.customer_count
    ) as campaign_reach,

    campaign.customers_purchasing_during_campaign,
    campaign.targeted_purchase_rate,

    campaign.revenue_during_campaign,
    campaign.average_spend_during_campaign,
    campaign.average_spend_per_targeted_purchaser,

    campaign.unique_redeemers,
    campaign.coupon_redemption_events,
    campaign.household_redemption_rate,
    campaign.average_spend_per_redeemer,

    window_revenue.all_customer_revenue_during_campaign,
    safe_divide(
        campaign.revenue_during_campaign,
        window_revenue.all_customer_revenue_during_campaign
    ) as targeted_household_revenue_share_during_campaign

from campaign_rollup as campaign
left join all_customer_window_revenue as window_revenue
    using (campaign_id)
cross join customer_universe
