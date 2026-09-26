-- Customer 360 & CRM Campaign Analytics
-- Analytical Insight 04: Campaign redemption behavior
--
-- Business question:
-- What observable campaign characteristics are associated with differences
-- in household redemption?
--
-- Important:
-- This is descriptive campaign analytics. The analysis does not estimate
-- incremental lift or causal campaign effectiveness.
--
-- The file contains three complementary views:
-- 1. Campaign-level ranking by household redemption rate.
-- 2. Assignment-weighted redemption by campaign type.
-- 3. Linear association between redemption rate and audience size/duration.
--
-- Campaign 24 is partially observed and is excluded from type-level and
-- correlation comparisons.

-- ---------------------------------------------------------------------------
-- 1. Campaign-level redemption ranking
-- ---------------------------------------------------------------------------

select
    campaign_id,
    campaign_type,
    targeted_households,
    unique_redeemers,

    round(
        100 * household_redemption_rate,
        2
    ) as redemption_rate_pct,

    observed_end_day_number
        - start_day_number
        + 1 as observed_duration_days,

    is_fully_observed

from {{ ref('mart_campaign_performance') }}

order by household_redemption_rate desc;


-- ---------------------------------------------------------------------------
-- 2. Assignment-weighted redemption by campaign type
-- ---------------------------------------------------------------------------

select
    campaign_type,
    count(*) as campaigns,
    sum(targeted_households) as targeted_assignments,
    sum(unique_redeemers) as redeemers,

    round(
        100 * safe_divide(
            sum(unique_redeemers),
            sum(targeted_households)
        ),
        2
    ) as weighted_redemption_rate_pct,

    round(
        100 * avg(household_redemption_rate),
        2
    ) as avg_campaign_redemption_rate_pct,

    round(
        avg(
            observed_end_day_number
            - start_day_number
            + 1
        ),
        1
    ) as avg_duration_days

from {{ ref('mart_campaign_performance') }}

where is_fully_observed = true

group by campaign_type
order by weighted_redemption_rate_pct desc;


-- ---------------------------------------------------------------------------
-- 3. Correlation checks
-- ---------------------------------------------------------------------------

with campaigns as (

    select
        targeted_households,

        observed_end_day_number
            - start_day_number
            + 1 as duration_days,

        household_redemption_rate

    from {{ ref('mart_campaign_performance') }}

    where is_fully_observed = true

)

select
    round(
        corr(
            targeted_households,
            household_redemption_rate
        ),
        3
    ) as corr_audience_redemption,

    round(
        corr(
            duration_days,
            household_redemption_rate
        ),
        3
    ) as corr_duration_redemption

from campaigns;
