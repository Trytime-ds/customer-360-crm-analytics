with expected as (

    select count(*) as product_count
    from {{ ref('stg_products') }}

),

actual as (

    select count(*) as product_count
    from {{ ref('dim_product') }}

)

select
    expected.product_count as expected_product_count,
    actual.product_count as actual_product_count
from expected
cross join actual
where expected.product_count != actual.product_count
