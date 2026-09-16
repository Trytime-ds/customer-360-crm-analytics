select
    household_id,
    campaign_id,
    count(*) as n
from {{ ref('stg_campaign_assignments') }}
group by
    household_id,
    campaign_id
having count(*) > 1