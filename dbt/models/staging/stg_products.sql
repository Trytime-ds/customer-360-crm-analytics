with source as (

    select *
    from {{ source('customer360', 'product') }}

),

renamed as (

    select
        PRODUCT_ID as product_id,
        MANUFACTURER as manufacturer_id,
        NULLIF(TRIM(DEPARTMENT), '') as department,
        BRAND as brand_type,
        NULLIF(TRIM(COMMODITY_DESC), '') as commodity,
        NULLIF(TRIM(SUB_COMMODITY_DESC), '') as sub_commodity,
        NULLIF(TRIM(CURR_SIZE_OF_PRODUCT), '') as current_product_size

    from source

)

select *
from renamed