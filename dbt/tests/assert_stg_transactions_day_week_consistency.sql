select
    day_number,
    week_number

from {{ ref('stg_transactions') }}

where week_number != div(day_number + 1, 7) + 1