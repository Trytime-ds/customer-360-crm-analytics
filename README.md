# Customer 360 & CRM Campaign Analytics

End-to-end Data Analytics and Business Intelligence portfolio project focused on customer behavior, CRM campaigns, segmentation, promotions and commercial performance.

The project uses the dunnhumby **The Complete Journey** dataset to build a reproducible analytical workflow from raw transactional data to business-ready analytical marts and Power BI dashboards.

---

## Project Objectives

The project aims to build a Customer 360 analytical layer capable of supporting:

- customer behavior analysis;
- customer segmentation;
- RFM analysis;
- sales performance analysis;
- descriptive CRM campaign analytics;
- coupon redemption analysis;
- promotion performance analysis;
- business intelligence reporting.

The project focuses on **descriptive and observable analytics**. Causal or incremental campaign impact is outside the MVP unless the available data supports a defensible methodology.

---

## Technology Stack

- SQL
- Google BigQuery
- dbt Core
- Power BI
- DAX
- Python (complementary analysis / validation)
- Git
- GitHub

---

## High-Level Architecture

```text
Kaggle / dunnhumby CSV
        ↓
Google Cloud Storage
        ↓
BigQuery
customer360 [RAW / SOURCE]
        ↓
dbt
        ↓
staging
        ↓
intermediate
        ↓
dimensions / facts / analytical marts
        ↓
Power BI / DAX
        ↓
Insights & Recommendations

Python is used selectively for complementary validation or analysis.
```

## Repository Structure

```text
dbt/          dbt transformation pipeline
sql/          exploratory, validation and analytical SQL
notebooks/    complementary Python analysis
powerbi/      Power BI assets
docs/         public project documentation
images/       architecture, model and dashboard images
```

## Current Project Status

| Phase | Status |
|---|---|
| Phase 00 — Project Definition | ✅ Complete |
| Phase 01 — Repository & Environment | ✅ Complete |
| Phase 02 — Source Inspection & Profiling | ✅ Complete |
| Phase 03 — Raw Ingestion | ✅ Complete |
| Phase 04 — Data Quality | ✅ Complete |
| Phase 05 — Staging & dbt | ✅ Complete |
| Phase 06 — Dimensional Modeling | 🟢 Core models complete; ERD/docs pending |
| Phase 07 — Analytical Marts | ✅ Core marts + analytical QA complete |
| Phase 08 — Python Analytics | ⏳ Complementary / deferred |
| Phase 09 — Power BI | 🚧 Current focus |
| Phase 10 — Insights & Recommendations | ⏳ Pending |
| Phase 11 — Portfolio Packaging | ⏳ Pending |

### dbt milestone

The transformation pipeline now includes:

**Staging**
- `stg_transactions`
- `stg_products`
- `stg_household_demographics`
- `stg_campaigns`
- `stg_campaign_assignments`
- `stg_coupons`
- `stg_coupon_redemptions`
- `stg_promotions`

**Intermediate**
- `int_customer_metrics`
- `int_customer_rfm`
- `int_product_store_week_promotions`
- `int_campaign_household_activity`
- `int_transaction_promotions`
- `int_basket_promotion_summary`

**Dimensions**
- `dim_customer`
- `dim_product`
- `dim_campaign`
- `dim_store`
- `dim_relative_time`

**Facts**
- `fact_sales`
- `fact_campaign_received`
- `fact_coupon_redemption`
- `fact_promotions`

**Analytical marts**
- `mart_customer_360`
- `mart_customer_segments`
- `mart_campaign_performance`
- `mart_promotion_performance`

A full project `dbt build` completed successfully with:

```text
PASS=243
WARN=0
ERROR=0
SKIP=0
```

### Analytical design principles

- Customer 360 / RFM uses the full transactional horizon `DAY 1–711`, with snapshot `DAY 711`.
- Campaign analysis uses effective campaign windows capped at `DAY 711`.
- Campaign KPIs are descriptive and observable; purchase during a campaign is not presented as campaign-caused conversion.
- Promotion analytics uses the safe `product_id + store_id + week_number` grain.
- `display='A'` is preserved as **In-Shelf** and is not treated as special display.
- Advanced causal lift, incrementality, CLV and Machine Learning remain outside the BI-first MVP.

### Current focus

```text
Power BI semantic model
        ↓
DAX measures
        ↓
3-page dashboard
        ↓
Insights & Recommendations
        ↓
Portfolio Packaging
```

## Analytical Scope

### MVP

- data quality and reproducible dbt transformations;
- staging, intermediate models and analytical marts;
- dimensional modeling;
- Customer 360;
- RFM segmentation;
- sales analytics;
- descriptive campaign analytics;
- promotions and coupon redemption analytics;
- Power BI dashboard and DAX measures;
- business insights and recommendations;
- selective Python validation when it adds analytical value.

## Post-MVP / Backlog

- Customer Lifetime Value;
- churn / inactivity modeling;
- Machine Learning;
- causal campaign lift;
- incremental revenue;
- advanced customer clustering;
- cohort analysis;
- market basket analysis;
- association rules.

## Dataset

Source:

**dunnhumby — The Complete Journey**

Raw/source data is stored in Google BigQuery under the dataset:

```text
customer360
```

The raw/source layer is treated as immutable. Cleaning and transformation logic is implemented downstream with dbt.

## Project Status

**Work in progress — Phase 09: Power BI.**


### Analytical QA checkpoint

Analytical QA confirmed:
- customer universe = **2,500 households**;
- demographic coverage = **801 households**;
- repeat customers = **99.88%**;
- total Customer 360 revenue = **8,057,463.08**;
- promotion coverage = **WEEK 9–101 (93 weeks)**;
- promotional basket rate = **55.66%**;
- promotional revenue share = **19.62%**;
- campaign metrics remained within valid descriptive ranges;
- the low-frequency recent RFM segment was renamed to `Recent Low-Frequency` after semantic review.

The RFM segment model was revalidated after the semantic correction with:

```text
PASS=6
WARN=0
ERROR=0
SKIP=0
```
