select *
from {{ ref('int_customer_metrics') }}
where
    first_purchase_day > last_purchase_day
    or recency_days != 711 - last_purchase_day
    or recency_days < 0
    or basket_count < 1
    or average_order_value != safe_divide(monetary_value, basket_count)
    or is_repeat_customer != (basket_count >= 2)
