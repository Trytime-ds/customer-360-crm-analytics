with transactions as (

    select
        household_id,
        basket_id,
        day_number,
        sales_value
    from {{ ref('stg_transactions') }}
    where day_number between 1 and 711

),

customer_metrics as (

    select
        household_id,
        min(day_number) as first_purchase_day,
        max(day_number) as last_purchase_day,
        711 - max(day_number) as recency_days,
        count(distinct basket_id) as basket_count,
        sum(sales_value) as monetary_value,
        safe_divide(
            sum(sales_value),
            count(distinct basket_id)
        ) as average_order_value,
        count(distinct basket_id) >= 2 as is_repeat_customer
    from transactions
    group by household_id

)

select *
from customer_metrics
