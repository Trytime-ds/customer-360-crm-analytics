select
    product_id,
    store_id,
    week_no as week_number,
    display as display_code,
    mailer as mailer_code
from {{ source('customer360', 'causal_data') }}