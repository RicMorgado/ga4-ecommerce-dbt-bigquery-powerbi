# GA4 E-commerce Analytics Pipeline

An end-to-end Modern Data Stack portfolio project using Google Analytics 4 ecommerce data, BigQuery, dbt Cloud, Power BI, and GitHub.

## Project Objective

The goal of this project is to transform raw GA4 ecommerce event data into clean analytics-ready models and build a Power BI dashboard for ecommerce performance analysis.

The final dashboard will focus on:

- E-commerce conversion funnel
- Average order value
- User drop-off by funnel stage
- Session-level behavior
- User acquisition and purchasing behavior

## Data Source

This project uses the public Google Analytics 4 ecommerce sample dataset available in BigQuery:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce`

## Tech Stack

| Layer | Tool |
|---|---|
| Data warehouse | Google BigQuery |
| Transformation | dbt Cloud |
| BI / Dashboard | Power BI |
| Version control / Portfolio | GitHub |

## Planned Data Model

The project will use a layered analytics engineering structure:

```text
Raw GA4 BigQuery export
        ↓
Staging models
        ↓
Intermediate models
        ↓
Mart models
        ↓
Power BI dashboard


