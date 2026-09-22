select
    product_id,
    manufacturer_id,
    department,
    brand_type,
    commodity,
    sub_commodity,
    current_product_size
from {{ ref('stg_products') }}
