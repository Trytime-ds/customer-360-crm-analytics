select *
from {{ ref('mart_customer_360') }}
where
    recency_days < 0
    or basket_count < 1
    or monetary_value < 0
    or average_order_value != safe_divide(monetary_value, basket_count)
    or customer_revenue_share < 0
    or customer_revenue_share > 1
    or campaigns_received < 0
    or coupon_redemption_events < 0
    or distinct_coupons_redeemed < 0
    or campaigns_with_redemption < 0
    or has_campaign_history != (campaigns_received > 0)
    or has_coupon_redemption != (coupon_redemption_events > 0)
