with expected as (
    select count(*) as campaign_count
    from {{ ref('dim_campaign') }}
),
actual as (
    select count(*) as campaign_count
    from {{ ref('mart_campaign_performance') }}
)
select expected.campaign_count, actual.campaign_count
from expected
cross join actual
where expected.campaign_count != actual.campaign_count
