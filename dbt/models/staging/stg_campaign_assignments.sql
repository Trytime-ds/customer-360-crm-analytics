select
    household_key as household_id,
    campaign as campaign_id,
    description as campaign_type
from {{ source('customer360', 'campaign_table') }}