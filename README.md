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

- Python

- Power BI

- DAX

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
   ┌────┴────┐
   ↓         ↓
Python    Power BI
             ↓
      Insights & Recommendations
```


## Repository Structure



dbt/          dbt transformation pipeline

sql/          exploratory, validation and analytical SQL

notebooks/    complementary Python analysis

powerbi/      Power BI assets

docs/         project documentation

images/       architecture, model and dashboard images



## Current Project Status



Phase 00 — Discovery & Planning        COMPLETE

Phase 01 — Repository & Environment    IN PROGRESS



Current focus:



Repository structure

Environment configuration

dbt + BigQuery connectivity



## Analytical Scope



MVP



Data quality



dbt staging / intermediate / marts



dimensional modeling



Customer 360



RFM segmentation



sales analytics



descriptive campaign analytics



promotions and coupon redemptions



Python validation and complementary analysis



Power BI dashboard



business insights and recommendations



## Post-MVP / Backlog



Customer Lifetime Value



Machine Learning



causal campaign lift



incremental revenue



cohort analysis



market basket analysis



association rules



## Dataset



Source:



dunnhumby — The Complete Journey



Raw/source data is stored in Google BigQuery under the dataset:



customer360



The raw/source layer is treated as immutable. Cleaning and transformation logic will be implemented downstream with dbt.



## Project Status



Work in progress.

