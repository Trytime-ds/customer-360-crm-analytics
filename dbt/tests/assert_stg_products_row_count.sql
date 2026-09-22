select
    product_id,
    department,
    commodity,
    sub_commodity,
    current_product_size

from {{ ref('stg_products') }}

where
    trim(department) = ''
    or trim(commodity) = ''
    or trim(sub_commodity) = ''
    or trim(current_product_size) = ''