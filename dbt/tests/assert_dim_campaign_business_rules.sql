select *
from {{ ref('dim_campaign') }}
where
    end_day_number < start_day_number
    or observed_end_day_number != least(end_day_number, 711)
    or scheduled_campaign_days != end_day_number - start_day_number + 1
    or observed_campaign_days != greatest(least(end_day_number, 711) - start_day_number + 1, 0)
    or is_fully_observed != (end_day_number <= 711)
    or observed_end_day_number > 711
