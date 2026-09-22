with customer_universe as (

    select household_id
    from {{ ref('int_customer_metrics') }}

),

demographics as (

    select
        household_id,
        age_range,
        marital_status_code,
        income_range,
        homeowner_status,
        household_composition,
        household_size,
        kid_category
    from {{ ref('stg_household_demographics') }}

)

select
    customers.household_id,
    demographics.age_range,
    demographics.marital_status_code,
    demographics.income_range,
    demographics.homeowner_status,
    demographics.household_composition,
    demographics.household_size,
    demographics.kid_category,
    demographics.household_id is not null as has_demographic_profile
from customer_universe as customers
left join demographics
    using (household_id)
