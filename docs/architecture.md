# Architecture

## Project Name

GA4 E-commerce Analytics Pipeline

## Objective

This project transforms raw Google Analytics 4 ecommerce event data from BigQuery into clean, business-ready analytics models and a Power BI dashboard.

The architecture follows a modern ELT pattern:

```text
Extract / Load → Transform → Serve / Visualize
```

In this project, the extraction and loading step is already handled by Google's public BigQuery dataset. The main engineering work happens in the transformation and semantic modeling layers.

## High-Level Architecture

```mermaid
flowchart LR
    A[GA4 Public BigQuery Dataset] --> B[dbt Cloud]
    B --> C[Staging Layer]
    C --> D[Intermediate Layer]
    D --> E[Marts Layer]
    E --> F[Power BI Dataset]
    F --> G[Power BI Dashboard]
    G --> H[GitHub Portfolio Assets]
```

## Source Layer

The source data comes from the public GA4 ecommerce sample dataset in BigQuery:

```text
bigquery-public-data.ga4_obfuscated_sample_ecommerce
```

This dataset contains raw GA4 event export tables with nested and repeated fields, including:

- Event parameters
- User properties
- Ecommerce data
- Item arrays
- Device data
- Geography data
- Traffic source data

The raw data is not directly business-friendly because many important attributes are stored inside nested arrays.

## Transformation Layer

The transformation layer will be built in dbt Cloud.

dbt will be responsible for:

- Defining source tables
- Creating staging models
- Flattening nested GA4 fields
- Building intermediate business logic
- Creating final mart models
- Adding data tests
- Adding documentation

## dbt Project Structure

The dbt project will live inside:

```text
dbt_ga4_ecommerce/
```

Planned internal structure:

```text
dbt_ga4_ecommerce/
│
├── models/
│   ├── staging/
│   │   └── ga4/
│   ├── intermediate/
│   │   └── ga4/
│   └── marts/
│       └── ecommerce/
│
├── macros/
├── seeds/
├── tests/
├── analyses/
│
├── dbt_project.yml
└── packages.yml
```

## Staging Layer

The staging layer prepares raw GA4 data for downstream modeling.

Planned models:

| Model | Grain | Purpose |
|---|---|---|
| `stg_ga4__events_base` | One row per event | Clean base event model |
| `stg_ga4__event_params` | One row per event parameter | Exploded event parameters |
| `stg_ga4__user_properties` | One row per user property | Exploded user properties |
| `stg_ga4__items` | One row per event item | Exploded ecommerce item data |

The staging layer should stay close to the raw source but make field names, timestamps, and nested structures easier to use.

## Intermediate Layer

The intermediate layer contains reusable business logic that should not live directly in final marts.

Planned models:

| Model | Grain | Purpose |
|---|---|---|
| `int_ga4__sessions` | One row per session | Session-level calculations |
| `int_ga4__user_journey_events` | One row per sequenced event | User journey analysis |
| `int_ga4__funnel_events` | One row per funnel-relevant event | Funnel stage preparation |

This layer will help keep final marts cleaner and easier to understand.

## Marts Layer

The marts layer contains final business-facing models designed for Power BI.

Planned models:

| Model | Grain | Purpose |
|---|---|---|
| `fct_events` | One row per event | Event-level fact table |
| `fct_sessions` | One row per session | Session-level fact table |
| `dim_users` | One row per user | User dimension |
| `fct_funnel_daily` | One row per date and funnel stage | Funnel reporting table |

These models will support the dashboard and business KPIs.

## BI Layer

Power BI will connect to the final BigQuery mart models.

The dashboard will focus on:

- Ecommerce conversion funnel
- Drop-off rate by stage
- Average order value
- Purchase conversion rate
- Revenue
- Sessions
- Users
- Acquisition behavior

## Portfolio Layer

GitHub will store:

- dbt project files
- SQL models
- Documentation
- Architecture notes
- Power BI screenshots
- Power BI backup files
- Final README
- LinkedIn-ready project assets

## Design Principles

This project follows these principles:

1. Preserve the correct data grain in each model.
2. Keep staging models close to the raw source.
3. Move reusable business logic into intermediate models.
4. Expose clean facts and dimensions in the marts layer.
5. Make the repository readable for both technical and non-technical reviewers.
6. Document decisions as the project evolves.

## Current Status

Current phase:

```text
Sprint 0 — Repository setup and project documentation
```

Completed:

- GitHub repository created
- Repository cloned locally
- Initial folder structure created
- Portfolio README improved
- Architecture documentation started

Next phase:

```text
Sprint 1 — dbt Cloud and BigQuery setup
```