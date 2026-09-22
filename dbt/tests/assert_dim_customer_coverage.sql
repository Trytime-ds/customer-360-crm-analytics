with expected as (

    select count(*) as customer_count
    from {{ ref('int_customer_metrics') }}

),

actual as (

    select count(*) as customer_count
    from {{ ref('dim_customer') }}

)

select
    expected.customer_count as expected_customer_count,
    actual.customer_count as actual_customer_count
from expected
cross join actual
where expected.customer_count != actual.customer_count
