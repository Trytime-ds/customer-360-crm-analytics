select *
from {{ ref('int_customer_rfm') }}
where
    recency_percentile < 0 or recency_percentile > 1
    or frequency_percentile < 0 or frequency_percentile > 1
    or monetary_percentile < 0 or monetary_percentile > 1
    or recency_score not between 1 and 5
    or frequency_score not between 1 and 5
    or monetary_score not between 1 and 5
    or rfm_total_score != recency_score + frequency_score + monetary_score
    or length(rfm_code) != 3
