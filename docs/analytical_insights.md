# Analytical Insights — Customer 360 & CRM Campaign Analytics

This document summarizes the main analytical findings produced after the data pipeline, dimensional model and analytical marts were validated.

The goal of this phase was deliberately different from dashboard building: first determine what the data actually supports, then design visuals around a defensible business story.

## Executive Summary

The analysis produced four primary findings:

1. **Customer value is highly concentrated and primarily differentiated by purchase frequency.** Champions and Loyal Customers represent **31.48% of customers but 61.01% of historical revenue**; Champions combine very high purchase frequency with an AOV that is not the highest among segments.
2. **The current At Risk segment contains meaningful historical value with lower recent activity.** These customers represent **18.56% of the customer base and 18.15% of historical revenue**, making them relevant for retention / reactivation analysis while end-of-dataset behavior remains a coverage caveat.
3. **Household redemption is more discriminating than purchase-during-campaign.** TypeA shows higher observed redemption, but audience size is also associated with redemption, so campaign type cannot be isolated as the explanation.
4. **Promotions are frequently present in high-value baskets but account for a minority of their revenue.** Promotional baskets average **2.76x** the value of non-promotional baskets, while promotional lines represent only **25.28%** of revenue inside those baskets.

The analysis is descriptive. It does **not** estimate causal campaign lift, incremental revenue or promotion-driven basket expansion.

---

## Insight 01 — Customer Value Concentration

### Business Question

How concentrated is customer value across RFM segments, and what appears to differentiate the highest-value segments?

### Initial Hypothesis

The large revenue difference between Champions and other segments may be driven more by purchase frequency than by a materially higher average order value.

### Analytical Approach

Customer-level metrics from `mart_customer_segments` were aggregated by segment.

Segment AOV was calculated as:

```text
segment revenue / segment baskets
```

rather than averaging customer-level AOVs. This preserves the relationship:

```text
Revenue per Customer
=
Baskets per Customer
x
Revenue per Basket
```

### Evidence

| Segment | Customer Share | Revenue Share | Baskets / Customer | Segment AOV | Revenue / Customer |
|---|---:|---:|---:|---:|---:|
| Champions | 20.08% | 44.97% | 246.87 | 29.24 | 7,217.66 |
| Loyal Customers | 11.40% | 16.04% | 166.93 | 27.16 | 4,533.63 |
| At Risk | 18.56% | 18.15% | 102.31 | 30.81 | 3,151.79 |
| Potential Loyalists | 11.96% | 8.31% | 66.29 | 33.79 | 2,240.28 |
| Needs Attention | 14.28% | 7.89% | 61.91 | 28.77 | 1,781.02 |
| Hibernating | 22.72% | 4.48% | 26.60 | 23.87 | 634.89 |
| Recent Low-Frequency | 1.00% | 0.17% | 19.12 | 28.02 | 535.78 |

Champions alone account for **44.97% of revenue from 20.08% of customers**, producing a value concentration index of **2.24**.

Champions + Loyal Customers represent:

- **31.48% of customers**
- **61.01% of historical revenue**

### Validation / Challenge

The AOV comparison does not support the idea that Champions are valuable because they make unusually expensive baskets:

- Champions AOV: **29.24**
- At Risk AOV: **30.81**
- Potential Loyalists AOV: **33.79**

Champions instead show a much larger purchase frequency: **246.87 baskets/customer**.

A separate department-affinity analysis also showed that the major high-value segments have broadly similar product mixes, which further weakens product mix as the main explanation of the value gap.

### Finding

Customer value is strongly concentrated, and the observed economic difference between the highest-value segments appears to be associated primarily with **purchase frequency / shopping intensity**, rather than unusually high basket value or a radically different department mix.

### Business Implication

CRM strategies focused on preserving purchase frequency and detecting deteriorating activity among historically valuable customers may be more relevant than focusing only on increasing basket size.

### Limitations

Frequency and Monetary are inputs to the RFM segmentation itself. The relationship between RFM segments and those metrics is therefore partly structural and should not be presented as independent causal evidence.

### SQL

[View analysis query](../sql/analysis/01_customer_value_concentration.sql)

---

## Insight 02 — Historically Valuable Customers with Lower Recent Activity

### Business Question

Do customers currently classified as At Risk combine meaningful historical value with lower recent activity?

### Initial Hypothesis

The At Risk group may represent a reactivation opportunity if it contains customers with meaningful historical value whose current activity is materially lower.

### Analytical Approach

The current At Risk cohort was identified at the final RFM snapshot and linked back to its full transaction history.

Weekly activity was compared with the overall customer universe using:

- active customer rate;
- baskets per cohort customer;
- revenue per cohort customer.

The cohort denominator was held constant at **464 At Risk customers** so that falling participation would remain visible.

### Evidence

At Risk customers currently represent:

- **464 customers**
- **18.56% of the customer base**
- **18.15% of historical revenue**
- **102.31 baskets/customer**
- **30.81 AOV**
- **3,151.79 revenue/customer**
- **32.25 average recency days**

In recent full weeks, their activity weakened more than the overall customer universe.

Approximate comparison:

| Period | Overall Active Rate | At Risk Active Rate | At Risk Baskets / Customer | At Risk Revenue / Customer |
|---|---:|---:|---:|---:|
| WEEK 88–92 | 54.61% | 50.86% | 0.90 | 31.49 |
| WEEK 93–100 | 53.03% | 43.94% | 0.71 | 25.54 |

WEEK 101 remains a particularly sharp drop:

- overall active rate: **50.76%**
- At Risk active rate: **23.71%**
- At Risk baskets/customer: **0.33**
- At Risk revenue/customer: **13.64**

### Validation / Challenge

Two important caveats prevent overstating the result.

First, At Risk is defined at the final snapshot using **Recency**, so lower recent activity is partly embedded in the segment definition.

Second, the end of the dataset requires caution:

- WEEK 101 is complete but unusually weak for this cohort.
- WEEK 102 contains only **6 observed days** and **0 At Risk activity**.
- The abrupt end-period behavior should be treated as a coverage / edge-of-data signal requiring validation rather than definitive evidence of abandonment.

### Finding

The current At Risk segment contains a material amount of historical economic value and shows lower recent activity than the customer universe. This makes the group analytically relevant for retention / reactivation prioritization, while the final-week behavior should not be overinterpreted.

### Business Implication

At Risk customers are a reasonable group for targeted retention or reactivation analysis because the segment combines historical value with lower current activity.

A production CRM strategy should additionally validate data completeness and define operational reactivation rules before deployment.

### Limitations

- The segment is selected partly through Recency, creating a selection effect.
- WEEK 101/102 behavior needs additional coverage validation.
- The analysis does not estimate the probability that reactivation efforts would succeed.

### SQL

[View analysis query](../sql/analysis/02_at_risk_activity.sql)

---

## Insight 03 — Campaign Redemption Is More Discriminating Than Purchase-During-Campaign

### Business Question

Which observable campaign characteristics are associated with differences in household redemption?

### Initial Hypothesis

Campaign type, audience size or campaign duration may help explain variation in household redemption.

### Analytical Approach

Campaign-level household redemption rates were compared across the 30 campaigns.

Type-level results were calculated only on fully observed campaigns and used assignment-weighted rates:

```text
total redeemers / total targeted assignments
```

This avoids giving a 12-household campaign the same weight as a campaign targeting more than 1,000 households.

Linear correlations were also calculated between redemption rate and:

- targeted audience size;
- observed duration.

### Evidence

Among fully observed campaigns:

| Campaign Type | Campaigns | Targeted Assignments | Redeemers | Weighted Redemption Rate |
|---|---:|---:|---:|---:|
| TypeA | 5 | 3,979 | 635 | **15.96%** |
| TypeB | 18 | 2,555 | 203 | **7.95%** |
| TypeC | 6 | 574 | 44 | **7.67%** |

The largest high-redemption campaigns include:

- Campaign 18 — TypeA — 1,133 targeted — **18.89% redemption**
- Campaign 13 — TypeA — 1,077 targeted — **18.20%**
- Campaign 8 — TypeA — 1,076 targeted — **14.68%**

However:

- correlation between audience size and redemption = **0.604**
- correlation between duration and redemption = **0.231**

### Validation / Challenge

The initial result could have been interpreted as "TypeA performs better."

The audience-size correlation challenged that interpretation. TypeA campaigns are also among the largest campaigns, so campaign type and audience size are confounded in this observational dataset.

Duration shows a much weaker linear relationship.

A second important signal is that targeted purchase rates are almost saturated across campaigns (approximately **92%–100%**) while household redemption rates vary much more widely (approximately **1.54%–18.89%**).

### Finding

Household redemption is a substantially more discriminating CRM signal than purchase-during-campaign rate.

TypeA campaigns show higher observed redemption, but the available data does not isolate campaign type from audience size, targeting decisions or other campaign-design characteristics.

### Business Implication

Campaign evaluation should give greater prominence to redemption behavior and should investigate the targeting / offer mechanics behind high-redemption campaigns before standardizing a campaign type.

### Limitations

- Observational analysis only.
- Audience size, targeting, campaign type, offer design and timing may be confounded.
- Campaign revenue is descriptive and not incremental revenue.
- Campaign 24 is partially observed and excluded from type-level comparisons.

### SQL

[View analysis query](../sql/analysis/04_campaign_redemption_analysis.sql)

---

## Insight 04 — Promotions Are Present in High-Value Baskets but Represent a Minority of Basket Revenue

### Business Question

When a promotion is present in a basket, how much of the basket value comes from promotional lines, and how does basket value compare with baskets without promotional conditions?

### Initial Hypothesis

Promotional conditions may often appear as one component of a broader shopping trip rather than accounting for most of the basket value.

### Analytical Approach

Basket-level promotion data was used to distinguish:

- baskets containing at least one promotional line;
- revenue of the full promotional basket;
- revenue attributable specifically to promotional lines;
- baskets without promotional conditions.

### Evidence

Across the promotion-analysis window:

- total baskets: **268,905**
- promotional baskets: **149,685**
- promotional basket rate: **55.66%**
- promotional baskets account for **77.61% of total revenue**
- promotional-line revenue share of total revenue: **19.62%**
- promotional lines represent **25.28% of revenue inside promotional baskets**

Average basket values:

| Basket Type | Average Basket Value |
|---|---:|
| Promotional basket | **40.62** |
| Non-promotional basket | **14.72** |

Promotional baskets are therefore associated with an average basket value **2.76x** that of non-promotional baskets.

Inside promotional baskets, approximately:

```text
25.28%  promotional-line revenue
74.72%  non-promotional-line revenue
```

### Validation / Challenge

A promotional basket is defined as a basket containing **at least one** promotional line.

Therefore, the 55.66% promotional basket rate and the 19.62% promotional revenue share measure different things and are not contradictory.

The 2.76x basket-value ratio is an association. Customers with larger baskets may simply have more opportunities to include a promotional product.

### Finding

Promotions are widely present in high-value baskets, but the majority of revenue within those baskets comes from non-promotional products.

This suggests that promotional products frequently coexist with broader purchases rather than dominating basket value.

### Business Implication

Promotion reporting should distinguish **promotion presence at basket level** from **revenue directly under promotional conditions**.

The pattern is worth monitoring for CRM / merchandising use, but should not be described as incremental revenue, halo effect or promotion-driven basket expansion without a causal design.

### Limitations

- Association is not causation.
- No untreated counterfactual is available.
- Promotion mechanisms can overlap.
- In-Shelf display is tracked separately from special display conditions.

### SQL

[View analysis query](../sql/analysis/05_promotional_basket_behavior.sql)

---

## Supporting Finding — Department Mix Is Broadly Similar Across Major Value Segments

The product-mix analysis did not reveal a radically different department composition for Champions, Loyal Customers and At Risk.

Grocery + Drug GM account for:

- Champions: **62.81%**
- Loyal Customers: **64.16%**
- At Risk: **64.49%**

Most major department affinity indexes remain close to **1.00**.

Notable but secondary deviations include:

- Champions over-index in `KIOSK-GAS` (**1.27**) and `MISC SALES TRAN` (**1.42**).
- At Risk moderately over-index in `MEAT` (**1.12**) and `MEAT-PCKGD` (**1.13**).
- Loyal Customers moderately over-index in `NUTRITION` (**1.18**).

These differences are not large enough to explain the much larger gap in revenue/customer across value segments.

This supporting result strengthens the interpretation that customer-value differences are predominantly behavioral rather than driven by a radically different high-level department mix.

[View analysis query](../sql/analysis/03_customer_department_affinity.sql)

---

## What These Findings Do Not Claim

This project deliberately separates observable analytics from causal claims.

The analysis does **not** claim that:

- campaigns caused purchases made during their active windows;
- TypeA campaigns causally generate higher redemption;
- promotions caused baskets to become 2.76x larger;
- the At Risk segment will respond successfully to reactivation;
- promotional revenue represents incremental revenue.

Those questions require stronger experimental or quasi-experimental designs and are outside the current BI-first MVP.

---

## Dashboard Implications

The analytical exploration determines the information hierarchy of the final Power BI product.

### Executive Overview

Focus on:

- customer and revenue scale;
- value concentration;
- Champions / Loyal contribution;
- At Risk exposure;
- concise CRM signals.

### Customer 360

Focus on:

- RFM segment distribution;
- revenue share vs customer share;
- frequency, AOV and revenue/customer;
- At Risk activity context;
- category mix as a secondary explanatory dimension.

### Campaign & Promotions

Focus on:

- household redemption rather than purchase-during-campaign as the primary differentiating campaign KPI;
- campaign comparison with observation-status context;
- promotional basket rate;
- promotional revenue share;
- promotional vs non-promotional basket value;
- explicit non-causal interpretation.

---

## Reproducible Analysis

All primary analytical queries are versioned under:

```text
sql/analysis/
├── 01_customer_value_concentration.sql
├── 02_at_risk_activity.sql
├── 03_customer_department_affinity.sql
├── 04_campaign_redemption_analysis.sql
└── 05_promotional_basket_behavior.sql
```

These queries operate on validated dbt marts and intermediate models rather than reconstructing business logic from raw source tables.
