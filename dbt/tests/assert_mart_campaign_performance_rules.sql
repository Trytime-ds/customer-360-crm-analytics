select *
from {{ ref('mart_campaign_performance') }}
where
    targeted_households < 1
    or customers_purchasing_during_campaign < 0
    or customers_purchasing_during_campaign > targeted_households
    or targeted_purchase_rate < 0 or targeted_purchase_rate > 1
    or unique_redeemers < 0
    or unique_redeemers > targeted_households
    or household_redemption_rate < 0 or household_redemption_rate > 1
    or campaign_reach < 0 or campaign_reach > 1
    or targeted_household_revenue_share_during_campaign < 0
    or targeted_household_revenue_share_during_campaign > 1
