with expected as (
    select count(*) as customer_count
    from {{ ref('dim_customer') }}
),
actual as (
    select count(*) as customer_count
    from {{ ref('mart_customer_360') }}
)
select
    expected.customer_count as expected_customer_count,
    actual.customer_count as actual_customer_count
from expected
cross join actual
where expected.customer_count != actual.customer_count
