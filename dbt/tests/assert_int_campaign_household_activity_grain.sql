select
    household_id,
    campaign_id,
    count(*) as row_count
from {{ ref('int_campaign_household_activity') }}
group by household_id, campaign_id
having count(*) > 1
