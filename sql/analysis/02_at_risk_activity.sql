-- Customer 360 & CRM Campaign Analytics
-- Analytical Insight 02: At Risk customer activity
--
-- Business question:
-- Do customers currently classified as At Risk combine meaningful historical
-- value with lower recent activity?
--
-- Important limitation:
-- At Risk is assigned at the DAY 711 snapshot and uses Recency as an input.
-- Therefore, lower recent activity is partly structural to the segment
-- definition. The query is intended to quantify the magnitude and compare the
-- current cohort with overall customer activity, not to prove causal decline.
--
-- Data-edge caution:
-- WEEK 102 contains only 6 observed days and should not be used as a full-week
-- comparison. WEEK 101 is complete but shows an unusually sharp decline and
-- should be treated as a signal requiring coverage validation.

with at_risk_customers as (

    select
        household_id
    from {{ ref('mart_customer_segments') }}
    where customer_segment = 'At Risk'

),

weeks as (

    select
        week_number,
        count(distinct day_number) as observed_days
    from {{ ref('dim_relative_time') }}
    group by week_number

),

all_customer_activity as (

    select
        week_number,
        count(distinct household_id) as all_active_customers,
        count(distinct basket_id) as all_baskets,
        sum(sales_value) as all_revenue
    from {{ ref('fact_sales') }}
    group by week_number

),

at_risk_activity as (

    select
        f.week_number,
        count(distinct f.household_id) as at_risk_active_customers,
        count(distinct f.basket_id) as at_risk_baskets,
        sum(f.sales_value) as at_risk_revenue
    from {{ ref('fact_sales') }} as f

    inner join at_risk_customers as a
        on f.household_id = a.household_id

    group by f.week_number

)

select
    w.week_number,
    w.observed_days,

    round(
        100 * safe_divide(
            a.all_active_customers,
            2500
        ),
        2
    ) as all_active_rate_pct,

    round(
        100 * safe_divide(
            coalesce(r.at_risk_active_customers, 0),
            464
        ),
        2
    ) as at_risk_active_rate_pct,

    round(
        safe_divide(
            coalesce(r.at_risk_baskets, 0),
            464
        ),
        2
    ) as at_risk_baskets_per_customer,

    round(
        safe_divide(
            coalesce(r.at_risk_revenue, 0),
            464
        ),
        2
    ) as at_risk_revenue_per_customer

from weeks as w

left join all_customer_activity as a
    using (week_number)

left join at_risk_activity as r
    using (week_number)

where w.week_number >= 80
order by w.week_number;
