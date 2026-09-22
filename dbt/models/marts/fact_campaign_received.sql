select
    household_id,
    campaign_id
from {{ ref('stg_campaign_assignments') }}
