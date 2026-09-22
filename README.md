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
marts
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
| Phase 06 — Dimensional Modeling | 🚧 Current focus |
| Phase 07 — Analytical Marts | ⏳ Pending |
| Phase 08 — Python Analytics | ⏳ Complementary / deferred |
| Phase 09 — Power BI | ⏳ Pending |
| Phase 10 — Insights & Recommendations | ⏳ Pending |
| Phase 11 — Portfolio Packaging | ⏳ Pending |

### Staging milestone

The source-to-staging layer is complete:

- `stg_transactions`
- `stg_products`
- `stg_household_demographics`
- `stg_campaigns`
- `stg_campaign_assignments`
- `stg_coupons`
- `stg_coupon_redemptions`
- `stg_promotions`

All eight source tables now have production staging models with explicit grain, standardized naming, documented data-quality rules and dbt tests. The Phase 05 closeout completed with **73 dbt tests passing** and no known blockers.

### Current focus

The MVP is following a **BI-first path**:

```text
Dimensional Modeling
        ↓
Intermediate Models & Analytical Marts
        ↓
Customer 360 / RFM
        ↓
Campaign, Coupon & Promotion Analytics
        ↓
Power BI / DAX
        ↓
Business Insights
        ↓
Portfolio Packaging
```

Advanced Python analysis, Machine Learning, CLV, churn modeling and causal campaign measurement are intentionally deferred until after the core BI MVP is complete.

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

**Work in progress — Phase 06: Dimensional Modeling.**
