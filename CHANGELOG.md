# Changelog

All notable project milestones and structural changes will be documented in this file.

---

## [Unreleased]

### Added

- Initial repository structure.
- Base project documentation.
- Initial `.gitignore`.
- Python dependency file placeholder.
- Configured dbt Core with BigQuery.
- Registered the eight BigQuery raw tables as dbt Sources.
- Validated dbt-to-BigQuery connectivity with a source smoke test.
- Preserved the project directory structure for dbt, SQL, Python, Power BI and documentation.
- Published the initial project structure to GitHub.
- Added `stg_transactions` as the first production staging model.
- Added staging model documentation and eight `not_null` data tests.
- Added a singular test protecting the `basket_id + product_id` transaction grain.
- Added a relationship test from staging transactions to the raw product master.
- Added a singular test validating `day_number` / `week_number` consistency.

### Changed

- Configured dbt layer routing so RAW `customer360` remains immutable while downstream models materialize in `customer360_staging`, `customer360_intermediate` and `customer360_marts`.
- Standardized transaction field names to staging conventions.
- Converted monetary transaction fields from `FLOAT64` to BigQuery `NUMERIC`.
- Preserved source HHMM transaction time and added a derived BigQuery `TIME` field.

### Validation

- `stg_transactions` preserves the raw transaction row count: `2,595,732` rows.
- HHMM-to-`TIME` conversion validated with real source values.
- `dbt test --select stg_transactions` completed with `PASS=11`, `WARN=0`, `ERROR=0`.

### Project Status

- Phase 00 — Discovery & Planning: complete.
- Phase 01 — Repository & Environment: complete.
- Staging & dbt: in progress.
- `stg_transactions` v1: complete and tested.
- Next model: `stg_products` (raw schema inspected; implementation pending).

### Milestones

- `18788f4` — `feat: add transaction staging model and data quality tests`.
