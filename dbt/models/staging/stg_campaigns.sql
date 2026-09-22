with source as (

    select *
    from {{ source('customer360', 'campaign_desc') }}

),

renamed as (

    select
        CAMPAIGN as campaign_id,
        DESCRIPTION as campaign_type,
        START_DAY as start_day_number,
        END_DAY as end_day_number

    from source

)

select *
from renamed