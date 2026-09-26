-- Customer 360 & CRM Campaign Analytics
-- Analytical Insight 03: Department mix and affinity
--
-- Business question:
-- Are value differences across Champions, Loyal Customers and At Risk
-- associated with materially different department mixes?
--
-- Affinity index:
-- segment department revenue share / overall department revenue share
--
-- Interpretation:
-- 1.00 = proportional to the overall business mix
-- >1.00 = over-indexing
-- <1.00 = under-indexing
--
-- Noise controls:
-- Only departments representing >=1% of segment revenue and reaching >=10%
-- of customers in the segment are retained in the final result.

with base as (

    select
        s.customer_segment,
        f.household_id,
        f.sales_value,
        p.department
    from {{ ref('fact_sales') }} as f

    inner join {{ ref('mart_customer_segments') }} as s
        on f.household_id = s.household_id

    inner join {{ ref('dim_product') }} as p
        on f.product_id = p.product_id

    where p.department is not null

),

segment_department as (

    select
        customer_segment,
        department,
        sum(sales_value) as department_revenue,
        count(distinct household_id) as customers_buying_department
    from base
    group by
        customer_segment,
        department

),

segment_totals as (

    select
        customer_segment,
        sum(sales_value) as segment_revenue,
        count(distinct household_id) as segment_customers
    from base
    group by customer_segment

),

overall_department as (

    select
        department,
        sum(sales_value) as overall_department_revenue
    from base
    group by department

),

overall_total as (

    select
        sum(sales_value) as overall_revenue
    from base

),

metrics as (

    select
        sd.customer_segment,
        sd.department,

        safe_divide(
            sd.department_revenue,
            st.segment_revenue
        ) as segment_revenue_share,

        safe_divide(
            od.overall_department_revenue,
            ot.overall_revenue
        ) as overall_revenue_share,

        safe_divide(
            safe_divide(
                sd.department_revenue,
                st.segment_revenue
            ),
            safe_divide(
                od.overall_department_revenue,
                ot.overall_revenue
            )
        ) as affinity_index,

        safe_divide(
            sd.customers_buying_department,
            st.segment_customers
        ) as customer_penetration

    from segment_department as sd

    inner join segment_totals as st
        using (customer_segment)

    inner join overall_department as od
        using (department)

    cross join overall_total as ot

    where sd.customer_segment in (
        'Champions',
        'Loyal Customers',
        'At Risk'
    )

)

select
    customer_segment,
    department,
    round(100 * segment_revenue_share, 2) as segment_revenue_share_pct,
    round(100 * overall_revenue_share, 2) as overall_revenue_share_pct,
    round(affinity_index, 2) as affinity_index,
    round(100 * customer_penetration, 2) as customer_penetration_pct

from metrics

where segment_revenue_share >= 0.01
  and customer_penetration >= 0.10

order by
    customer_segment,
    affinity_index desc;
