with raw as (

    select count(*) as row_count
    from {{ source('customer360', 'campaign_table') }}

),

staging as (

    select count(*) as row_count
    from {{ ref('stg_campaign_assignments') }}

)

select
    raw.row_count as raw_rows,
    staging.row_count as staging_rows
from raw
cross join staging
where raw.row_count != staging.row_count