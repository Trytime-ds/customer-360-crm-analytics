with raw_campaigns as (

    select count(*) as row_count
    from {{ source('customer360', 'campaign_desc') }}

),

staging_campaigns as (

    select count(*) as row_count
    from {{ ref('stg_campaigns') }}

)

select
    raw.row_count as raw_row_count,
    staging.row_count as staging_row_count

from raw_campaigns raw
cross join staging_campaigns staging

where raw.row_count != staging.row_count