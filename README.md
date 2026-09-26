# Customer 360 & CRM Campaign Analytics

End-to-end Data Analytics and Business Intelligence portfolio project focused on customer behavior, CRM segmentation, campaign response and promotional activity.

The project uses the dunnhumby **The Complete Journey** dataset to build a reproducible workflow from raw retail transactions to validated analytical marts, documented business insights and a Power BI decision-support dashboard.

> **Current stage:** analytical insights documented; dashboard blueprint and final Power BI visual design in progress.

---

## Business Problem

How can a retailer use transactional and CRM data to:

- identify where customer value is concentrated;
- understand what differentiates high-value customer segments;
- detect customer groups worth monitoring for retention / reactivation;
- evaluate observable campaign-response behavior;
- understand how promotions participate in customer baskets;
- communicate those findings through a business-ready BI product?

The MVP is intentionally **descriptive and observable**. It does not present campaign lift, incremental revenue or promotion-driven basket expansion without a defensible causal design.

---

## Key Findings

### 1. Customer value is highly concentrated

**Champions + Loyal Customers represent 31.48% of customers but generate 61.01% of historical revenue.**

Champions alone represent:

- **20.08% of customers**
- **44.97% of revenue**
- value concentration index: **2.24**

### 2. Purchase frequency is the strongest observed value differentiator

Champions generate **7,217.66 revenue/customer** with **246.87 baskets/customer**, despite an AOV of **29.24**.

Other segments have equal or higher basket values:

- At Risk AOV: **30.81**
- Potential Loyalists AOV: **33.79**

The largest economic gap is therefore associated more strongly with **shopping frequency / intensity** than with basket size.

### 3. At Risk customers retain meaningful historical value

The current At Risk segment contains:

- **464 customers**
- **18.56% of the customer base**
- **18.15% of historical revenue**
- **3,151.79 revenue/customer**

Their recent activity is lower than the overall customer universe, making the group relevant for retention / reactivation analysis. End-of-dataset behavior is treated cautiously because the final period requires coverage validation.

### 4. Campaign redemption is more discriminating than purchase-during-campaign

Targeted purchase rates are almost saturated across campaigns, while household redemption varies materially.

Among fully observed campaigns:

| Campaign Type | Weighted Household Redemption |
|---|---:|
| TypeA | **15.96%** |
| TypeB | **7.95%** |
| TypeC | **7.67%** |

However, audience size is also positively associated with redemption (`r = 0.604`), so campaign type cannot be isolated as the causal explanation.

### 5. Promotional baskets are much larger, but most of their value is not promotional

- **55.66%** of baskets contain at least one promotional line.
- Those baskets account for **77.61%** of revenue in the promotion-analysis window.
- Average promotional basket value: **40.62**
- Average non-promotional basket value: **14.72**
- Basket value ratio: **2.76x**
- Only **25.28%** of revenue inside promotional baskets comes from promotional lines.

This is an association, not evidence that promotions caused larger baskets.

**[Read the full analytical case study →](docs/analytical_insights.md)**

---

## Analytical Workflow

The dashboard is designed **after** the analytical exploration, not before it.

```text
CSV source files
        ↓
Google Cloud Storage
        ↓
BigQuery RAW dataset
        ↓
dbt staging
        ↓
intermediate business logic
        ↓
dimensions / facts / analytical marts
        ↓
analytical QA
        ↓
SQL analytical exploration
        ↓
validated findings + limitations
        ↓
Power BI semantic model + DAX
        ↓
3-page decision-support dashboard
```

This workflow separates:

- data engineering / transformation;
- analytical modeling;
- exploratory business analysis;
- insight validation;
- BI communication.

---

## Technology Stack

- **SQL**
- **Google BigQuery**
- **dbt Core**
- **Power BI**
- **DAX**
- **Git**
- **GitHub**

Python remains a post-MVP / complementary option rather than a dependency of the current BI-first workflow.

---

## Data Model & Analytical Layer

The transformation pipeline includes:

### Staging

- `stg_transactions`
- `stg_products`
- `stg_household_demographics`
- `stg_campaigns`
- `stg_campaign_assignments`
- `stg_coupons`
- `stg_coupon_redemptions`
- `stg_promotions`

### Intermediate

- `int_customer_metrics`
- `int_customer_rfm`
- `int_product_store_week_promotions`
- `int_campaign_household_activity`
- `int_transaction_promotions`
- `int_basket_promotion_summary`

### Dimensions

- `dim_customer`
- `dim_product`
- `dim_campaign`
- `dim_store`
- `dim_relative_time`

### Facts

- `fact_sales`
- `fact_campaign_received`
- `fact_coupon_redemption`
- `fact_promotions`

### Analytical Marts

- `mart_customer_360`
- `mart_customer_segments`
- `mart_campaign_performance`
- `mart_promotion_performance`

A full dbt project build completed with:

```text
PASS=243
WARN=0
ERROR=0
SKIP=0
```

---

## Reproducible Analytical Evidence

Portfolio-facing analytical SQL is versioned separately from profiling and QA:

```text
sql/
├── qa/
│   └── analytical_qa.sql
└── analysis/
    ├── 01_customer_value_concentration.sql
    ├── 02_at_risk_activity.sql
    ├── 03_customer_department_affinity.sql
    ├── 04_campaign_redemption_analysis.sql
    └── 05_promotional_basket_behavior.sql
```

Each analysis is tied to a business question and includes methodological caveats.

**[Open the analytical insights case study →](docs/analytical_insights.md)**

---

## Power BI Product

The semantic model is already connected to validated BigQuery marts and versioned as a Power BI Project (PBIP/TMDL/PBIR).

The final dashboard is designed around the validated findings rather than around isolated visuals.

### Planned 3-page structure

**1. Executive Overview**

- business scale;
- customer value concentration;
- Champions / Loyal contribution;
- At Risk exposure;
- high-level CRM signals.

**2. Customer 360**

- RFM segmentation;
- customer share vs revenue share;
- purchase frequency, AOV and revenue/customer;
- At Risk activity context;
- product/category as a secondary explanatory dimension.

**3. Campaign & Promotions**

- household redemption;
- campaign comparison;
- campaign observation status;
- promotional basket rate;
- promotional revenue share;
- promotional vs non-promotional basket value.

---

## Analytical Design Principles

- Customer 360 / RFM uses the full transactional horizon **DAY 1–711**, with snapshot **DAY 711**.
- Time is relative; calendar dates are not fabricated.
- Campaign windows are capped at observed transactional coverage.
- Campaign 24 is explicitly flagged as partially observed.
- Purchase during a campaign is not presented as campaign-caused conversion.
- Campaign revenue is descriptive and non-additive when windows overlap.
- Promotion analysis preserves safe product-store-week grain before joining to sales.
- `display='A'` is treated as **In-Shelf**, not as special display.
- `QUANTITY` is not used as a universal unit-sales measure because fuel / special transactions contain incompatible scales.
- Demographic coverage is partial and is not generalized to the entire customer universe.

---

## Analytical QA Snapshot

Validated benchmarks include:

- transactional customer universe: **2,500 households**
- customers with demographic profile: **801**
- repeat customers: **99.88%**
- Customer 360 revenue: **8,057,463.08**
- promotion-analysis coverage: **WEEK 9–101**
- promotional basket rate: **55.66%**
- promotional line revenue share: **19.62%**

The RFM segmentation was also semantically reviewed: an initially misleading "New Customers" label was corrected to **Recent Low-Frequency** after the underlying behavior was inspected.

---

## Repository Structure

```text
dbt/          transformation pipeline, tests and analytical marts
sql/          profiling, QA and portfolio analytical SQL
powerbi/      Power BI Project, semantic model and report assets
docs/         public analytical documentation / case study
images/       architecture, ERD and dashboard assets
```

---

## Current Status

| Area | Status |
|---|---|
| Project definition & ingestion | ✅ Complete |
| Data quality & profiling | ✅ Complete |
| dbt staging | ✅ Complete |
| Dimensional modeling | 🟢 Core complete; public ERD/docs pending |
| Analytical marts | ✅ Complete |
| Analytical QA | ✅ Complete |
| Analytical exploration | ✅ Core findings documented |
| Power BI semantic model & DAX | ✅ Initial version complete |
| Dashboard visual design | 🚧 Next |
| Portfolio packaging | 🚧 In progress |

---

## Dataset

**dunnhumby — The Complete Journey**

Raw/source data is stored in Google BigQuery under:

```text
customer360
```

The raw layer is treated as immutable. Cleaning, semantic normalization and analytical logic are implemented downstream with dbt.

---

## Scope Boundaries

The current BI-first MVP intentionally excludes:

- causal campaign lift;
- incremental revenue attribution;
- Customer Lifetime Value;
- churn / inactivity prediction;
- machine learning;
- advanced cohorts;
- market basket association rules;
- real-time orchestration.

These are potential post-MVP extensions only when the methodology and data support them.
