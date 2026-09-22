select *
from {{ ref('mart_customer_segments') }}
where
    customer_segment = 'Champions'
    and not (
        recency_score >= 4
        and frequency_score >= 4
        and monetary_score >= 4
    )
