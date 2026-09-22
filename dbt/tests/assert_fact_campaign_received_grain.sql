select
    household_id,
    campaign_id,
    count(*) as row_count
from {{ ref('fact_campaign_received') }}
group by household_id, campaign_id
having count(*) > 1
