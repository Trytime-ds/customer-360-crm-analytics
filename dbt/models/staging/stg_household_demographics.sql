with source as (

    select *
    from {{ source('customer360', 'hh_demographic') }}

),

renamed as (

    select
        HOUSEHOLD_KEY as household_id,
        AGE_DESC as age_range,
        MARITAL_STATUS_CODE as marital_status_code,
        INCOME_DESC as income_range,
        HOMEOWNER_DESC as homeowner_status,
        HH_COMP_DESC as household_composition,
        HOUSEHOLD_SIZE_DESC as household_size,
        KID_CATEGORY_DESC as kid_category

    from source

)

select *
from renamed