select distinct
    day_number,
    week_number
from {{ ref('stg_transactions') }}
where day_number between 1 and 711
