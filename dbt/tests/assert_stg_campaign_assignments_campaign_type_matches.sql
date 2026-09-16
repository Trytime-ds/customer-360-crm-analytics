select
    ca.household_id,
    ca.campaign_id,
    ca.campaign_type as assignment_campaign_type,
    c.campaign_type as campaign_campaign_type

from {{ ref('stg_campaign_assignments') }} ca

inner join {{ ref('stg_campaigns') }} c
    on ca.campaign_id = c.campaign_id

where ca.campaign_type != c.campaign_type