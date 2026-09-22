with raw_demographics as (

    select count(*) as row_count
    from {{ source('customer360', 'hh_demographic') }}

),

staging_demographics as (

    select count(*) as row_count
    from {{ ref('stg_household_demographics') }}

)

select
    raw.row_count as raw_row_count,
    staging.row_count as staging_row_count

from raw_demographics raw
cross join staging_demographics staging

where raw.row_count != staging.row_count