with source_customers as (

    select count(distinct household_id) as customer_count
    from {{ ref('stg_transactions') }}
    where day_number between 1 and 711

),

intermediate_customers as (

    select count(*) as customer_count
    from {{ ref('int_customer_metrics') }}

)

select
    source_customers.customer_count as source_customer_count,
    intermediate_customers.customer_count as intermediate_customer_count
from source_customers
cross join intermediate_customers
where source_customers.customer_count != intermediate_customers.customer_count
