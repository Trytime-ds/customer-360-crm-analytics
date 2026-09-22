select
    campaign_id,
    start_day_number,
    end_day_number

from {{ ref('stg_campaigns') }}

where end_day_number < start_day_number
   or start_day_number <= 0
   or end_day_number <= 0