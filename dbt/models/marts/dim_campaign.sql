select
    campaign_id,
    campaign_type,
    start_day_number,
    end_day_number,
    least(end_day_number, 711) as observed_end_day_number,
    end_day_number - start_day_number + 1 as scheduled_campaign_days,
    greatest(least(end_day_number, 711) - start_day_number + 1, 0) as observed_campaign_days,
    end_day_number <= 711 as is_fully_observed
from {{ ref('stg_campaigns') }}
