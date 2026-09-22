select
    household_id,
    count(*) as row_count
from {{ ref('int_customer_metrics') }}
group by household_id
having count(*) > 1
