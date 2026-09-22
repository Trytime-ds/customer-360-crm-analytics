# Changelog

All notable project milestones and structural changes will be documented in this file.

---

## [Unreleased]

### Added

- Initial repository structure and base project documentation.
- Initial `.gitignore` and Python dependency placeholder.
- Google BigQuery + dbt Core project configuration.
- Eight BigQuery raw tables registered as dbt Sources.
- Source-to-BigQuery smoke test and layer routing validation.
- Complete source-to-staging layer across all eight raw tables.
- `int_customer_metrics` for reusable customer behavioral metrics.
- `int_customer_rfm` for percentile-based RFM scoring.
- `int_product_store_week_promotions` for safe promotion-grain resolution.
- `int_campaign_household_activity` for campaign-window customer behavior.
- `int_transaction_promotions` and `int_basket_promotion_summary` for promotional sales analysis.
- Core dimensions: `dim_customer`, `dim_product`, `dim_campaign`, `dim_store`, `dim_relative_time`.
- Core facts: `fact_sales`, `fact_campaign_received`, `fact_coupon_redemption`, `fact_promotions`.
- `mart_customer_360`.
- `mart_customer_segments`.
- `mart_campaign_performance`.
- `mart_promotion_performance`.
- Schema documentation, generic dbt tests and singular business/data-quality tests across staging, intermediate and marts.

### Changed

- Configured dbt layer routing so RAW `customer360` remains immutable while downstream models materialize in `customer360_staging`, `customer360_intermediate` and `customer360_marts`.
- Standardized source field names into analytics-friendly staging conventions.
- Converted monetary transaction fields from `FLOAT64` to BigQuery `NUMERIC`.
- Preserved source HHMM transaction time and added a derived BigQuery `TIME` field.
- Preserved optional household demographics as enrichment rather than treating demographic coverage as the full customer universe.
- Refined the MVP execution path to prioritize dimensional modeling, analytical marts, Customer 360/RFM, campaign and promotion analytics, and Power BI before advanced Python or Machine Learning work.
- Campaign analysis now uses observable terminology such as `Targeted Purchase Rate` and `Revenue During Campaign` rather than causal conversion language.
- Promotion logic resolves source data to `product_id + store_id + week_number` before joining to transactions.
- Corrected promotion semantics so source `display='A'` is treated as In-Shelf and does not qualify as special display by itself.
- RFM accepted-value tests explicitly compare integer values in BigQuery.
- Renamed the misleading `New Customers` RFM segment to `Recent Low-Frequency` after analytical QA showed those customers were recent but not necessarily new.

### Data Quality & Validation

- `stg_transactions` preserves the raw transaction row count: `2,595,732` rows.
- Campaign assignments are protected at `household_id + campaign_id` grain.
- Coupon staging applies controlled exact-row deduplication while preserving valid relationships.
- Campaign windows are capped at `DAY 711` while preserving scheduled end dates and observability flags.
- Customer metrics use one row per transactional household and distinct basket counts for frequency.
- Promotion joins use the validated `product_id + store_id + week_number` grain.
- Customer, campaign and promotion marts include grain, coverage and business-rule tests.
- Phase 05 closed with **8/8 staging models implemented** and **73/73 staging tests passing**.
- Full project validation completed with `dbt build`: **PASS=243, WARN=0, ERROR=0, SKIP=0**.
- Analytical QA validated customer, RFM, campaign and promotion outputs before BI consumption.
- RFM segment model revalidated after semantic relabeling: **PASS=6, WARN=0, ERROR=0, SKIP=0**.

### Project Status

- Phase 00 — Project Definition: complete.
- Phase 01 — Repository & Environment: complete.
- Phase 02 — Source Inspection & Profiling: complete.
- Phase 03 — Raw Ingestion: complete.
- Phase 04 — Data Quality: complete.
- Phase 05 — Staging & dbt: complete.
- Phase 06 — Dimensional Modeling: core model implementation complete; ERD/documentation pending.
- Phase 07 — Analytical Marts: core mart implementation and analytical output QA complete.
- Phase 09 — Power BI: current implementation focus.
- Known blockers: none.

### Milestones

- `18788f4` — `feat: add transaction staging model and data quality tests`.
- `48e898f` — `feat: add product staging model and data quality tests`.
- `1a19064` — `feat: add household demographics staging model and tests`.
- `8541fdc` — `feat: add campaign staging model and temporal tests`.
- `b62474d` — `feat: add campaign assignments staging model and tests`.
- `5d0d302` — `feat: add coupons staging model with exact deduplication`.
- `5ae4c28` — `feat: add coupon redemptions staging model and tests`.
- `0b90fd0` — `feat: add promotions staging model and tests`.
- `8aee134` — `feat: add customer metrics intermediate model`.
- `1d8197a` — `feat: add core customer product and campaign dimensions`.
- `0e009e5` — `feat: add core facts rfm and customer 360 mart`.
- `3a9c53f` — `fix: compare RFM accepted values as integers`.
- `5c79353` — `feat: add campaign and promotion performance marts`.
- `c3729c5` — `fix: source campaign observability flag from dimension`.
- `764dd36` — `feat: add customer RFM segmentation mart`.
