with customer_metrics as (

    select
        household_id,
        recency_days,
        basket_count,
        monetary_value
    from {{ ref('int_customer_metrics') }}

),

percentiles as (

    select
        household_id,
        percent_rank() over (order by recency_days desc) as recency_percentile,
        percent_rank() over (order by basket_count asc) as frequency_percentile,
        percent_rank() over (order by monetary_value asc) as monetary_percentile
    from customer_metrics

),

scored as (

    select
        household_id,
        recency_percentile,
        frequency_percentile,
        monetary_percentile,

        case
            when recency_percentile < 0.20 then 1
            when recency_percentile < 0.40 then 2
            when recency_percentile < 0.60 then 3
            when recency_percentile < 0.80 then 4
            else 5
        end as recency_score,

        case
            when frequency_percentile < 0.20 then 1
            when frequency_percentile < 0.40 then 2
            when frequency_percentile < 0.60 then 3
            when frequency_percentile < 0.80 then 4
            else 5
        end as frequency_score,

        case
            when monetary_percentile < 0.20 then 1
            when monetary_percentile < 0.40 then 2
            when monetary_percentile < 0.60 then 3
            when monetary_percentile < 0.80 then 4
            else 5
        end as monetary_score
    from percentiles

)

select
    household_id,
    recency_percentile,
    frequency_percentile,
    monetary_percentile,
    recency_score,
    frequency_score,
    monetary_score,
    recency_score + frequency_score + monetary_score as rfm_total_score,
    concat(
        cast(recency_score as string),
        cast(frequency_score as string),
        cast(monetary_score as string)
    ) as rfm_code
from scored
