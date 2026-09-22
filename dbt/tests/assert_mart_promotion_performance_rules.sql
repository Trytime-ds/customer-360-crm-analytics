select *
from {{ ref('mart_promotion_performance') }}
where
    week_number < 9
    or week_number > 101
    or promotional_baskets < 0
    or promotional_baskets > total_baskets
    or promotional_basket_rate < 0
    or promotional_basket_rate > 1
    or promotional_revenue < 0
    or promotional_revenue > total_revenue
    or promotional_revenue_share < 0
    or promotional_revenue_share > 1
