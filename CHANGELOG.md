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
- Production staging model `stg_transactions`.
- Production staging model `stg_products`.
- Production staging model `stg_household_demographics`.
- Production staging model `stg_campaigns`.
- Production staging model `stg_campaign_assignments`.
- Production staging model `stg_coupons` with exact-row deduplication.
- Production staging model `stg_coupon_redemptions`.
- Production staging model `stg_promotions`.
- Schema documentation, generic dbt tests and singular business/data-quality tests across the staging layer.
- Tests protecting transaction grain, campaign assignment grain, coupon relationships, redemption relationships, promotion grain and temporal consistency.

### Changed

- Configured dbt layer routing so RAW `customer360` remains immutable while downstream models materialize in `customer360_staging`, `customer360_intermediate` and `customer360_marts`.
- Standardized source field names into analytics-friendly staging conventions.
- Converted monetary transaction fields from `FLOAT64` to BigQuery `NUMERIC`.
- Preserved source HHMM transaction time and added a derived BigQuery `TIME` field.
- Preserved optional household demographics as enrichment rather than treating demographic coverage as the full customer universe.
- Preserved raw promotion codes in staging so business semantics can be resolved downstream at the appropriate analytical grain.
- Refined the MVP execution path to prioritize dimensional modeling, analytical marts, Customer 360/RFM, campaign and promotion analytics, and Power BI before advanced Python or Machine Learning work.

### Data Quality & Validation

- `stg_transactions` preserves the raw transaction row count: `2,595,732` rows.
- HHMM-to-`TIME` conversion validated with real source values.
- Product, household demographic and campaign staging models validated against their source grains and domains.
- Campaign assignments validated at `household_id + campaign_id` grain.
- Coupon staging applies controlled exact-row deduplication while preserving valid coupon/product/campaign relationships.
- Coupon redemptions validated as observed redemption events with campaign and household relationship checks.
- Promotions staging preserves source promotional conditions and validates the full staging grain.
- Phase 05 closed with **8/8 staging models implemented** and **73/73 dbt tests passing**.

### Project Status

- Phase 00 — Project Definition: complete.
- Phase 01 — Repository & Environment: complete.
- Phase 02 — Source Inspection & Profiling: complete.
- Phase 03 — Raw Ingestion: complete.
- Phase 04 — Data Quality: complete.
- Phase 05 — Staging & dbt: complete.
- Phase 06 — Dimensional Modeling: current focus.
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
