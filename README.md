# Cross-Channel Paid Media Performance Dashboard

## Live Dashboard

[View the Power BI dashboard](https://app.powerbi.com/reportEmbed?reportId=ce094775-3a66-4f3f-a793-1942cf7d4af3&autoAuth=true&ctid=30e25f77-b4cf-4d7b-877e-d3d303235b10)

## Objective

This project unifies Facebook Ads, Google Ads, and TikTok Ads data into a single reporting model and presents a one-page Power BI dashboard for cross-channel paid media performance analysis.

The goal is to create a trusted analytics workflow that supports campaign monitoring, platform comparison, QA/UAT, and business-facing marketing insights.

## Tools Used

- AWS S3 for raw file storage
- AWS Athena for cloud SQL modeling
- SQL for table creation, transformation, and QA checks
- Power BI for dashboarding and visualization
- GitHub for version control and documentation

## Data Sources

The assignment includes three raw advertising exports:

- `01_facebook_ads.csv`
- `02_google_ads.csv`
- `03_tiktok_ads.csv`

Each file was uploaded to S3 and modeled in Athena.

## Data Architecture

```text
Raw CSV files
    -> AWS S3 raw folders
    -> Athena raw external tables
    -> Athena unified reporting table
    -> Power BI dashboard
```

Raw Athena tables:

- `marketing_assignment.raw_facebook_ads`
- `marketing_assignment.raw_google_ads`
- `marketing_assignment.raw_tiktok_ads`

Final reporting table:

- `marketing_assignment.fct_paid_ads_daily`

## Data Model

The unified table standardizes common paid media fields across platforms:

- Date
- Platform
- Campaign
- Ad group / ad set
- Spend
- Impressions
- Clicks
- Conversions
- CTR
- CPC
- CPM
- CPA
- Conversion rate

Platform-specific fields were also preserved:

- Google Ads: conversion value, quality score, search impression share
- TikTok: video views, video watch progression, likes, shares, comments
- Facebook: reach, frequency, engagement rate

## QA/UAT Checks

QA checks were run in Athena before building the dashboard:

- Row counts by platform
- Date range validation
- Null checks for required fields
- Duplicate business key checks
- Negative metric checks
- Logic checks such as clicks greater than impressions and conversions greater than clicks

The final unified table contains 330 rows, with 110 rows per platform.

## Dashboard Overview

The Power BI dashboard includes:

- KPI cards for spend, impressions, clicks, conversions, CTR, CPC, CPA, and conversion rate
- Daily spend vs conversions trend
- Spend distribution by platform
- CPA comparison by platform
- Campaign-level performance table
- Campaign efficiency scatter plot
- Client-facing insight summary

## Key Insights

- TikTok led upper-funnel scale with the highest spend and impression volume.
- Google Ads showed strong conversion intent across search and shopping campaigns.
- Facebook delivered the lowest CPA, supporting cost-efficient retargeting analysis.
- Budget should be evaluated by campaign objective, not only by platform.
- ROAS is limited to Google Ads because conversion value is only available for Google Ads in this dataset.

## MMM Readiness

This dashboard is not a full Marketing Mix Model. However, the unified daily spend and performance table can support future MMM work by aggregating spend weekly by platform and joining it with revenue, seasonality, pricing, promotion, and offline media variables.

## Repository Structure

```text
README.md
analysis/
  outputs/
dashboard/
  Power BI dashboard file
  Power BI theme
data/
  raw/
  curated/
docs/
  AWS Athena setup
  Power BI build guide
scripts/
  local profiling script
sql/
  Athena raw table creation
  unified table creation
  QA checks
  analysis queries
```

## Reproducibility

1. Upload the three raw CSV files to S3.
2. Run `sql/01_create_raw_tables.sql` in Athena.
3. Run `sql/02_create_unified_table.sql` in Athena.
4. Run `sql/03_qa_checks.sql` to validate the model.
5. Connect Power BI to the unified table or an Athena export.
6. Build the dashboard using the measures and layout described in the documentation.
