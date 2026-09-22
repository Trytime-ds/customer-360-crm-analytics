select
    customer.*,

    case
        when recency_score >= 4
            and frequency_score >= 4
            and monetary_score >= 4
            then 'Champions'

        when recency_score >= 3
            and frequency_score >= 4
            and monetary_score >= 3
            then 'Loyal Customers'

        when recency_score = 5
            and frequency_score = 1
            then 'New Customers'

        when recency_score >= 4
            and frequency_score between 2 and 3
            then 'Potential Loyalists'

        when recency_score <= 2
            and (frequency_score >= 3 or monetary_score >= 3)
            then 'At Risk'

        when recency_score <= 2
            and frequency_score <= 2
            and monetary_score <= 2
            then 'Hibernating'

        else 'Needs Attention'
    end as customer_segment

from {{ ref('mart_customer_360') }} as customer
