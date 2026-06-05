# AWS Athena Setup

## 1. Create S3 Bucket

Create a globally unique bucket, for example:

`improvado-marketing-assignment-2026`

Create these folders:

- `raw/facebook/`
- `raw/google_ads/`
- `raw/tiktok_ads/`
- `curated/fct_paid_ads_daily/`
- `athena-results/`

Upload files:

- `01_facebook_ads.csv` to `raw/facebook/`
- `02_google_ads.csv` to `raw/google_ads/`
- `03_tiktok_ads.csv` to `raw/tiktok_ads/`

## 2. Configure Athena

In Athena Query Editor, set the query result location:

`s3://improvado-marketing-assignment-2026/athena-results/`

The SQL files in this repo already use `improvado-marketing-assignment-2026`.

## 3. Run SQL In This Order

1. `sql/01_create_raw_tables.sql`
2. `sql/02_create_unified_table.sql`
3. `sql/03_qa_checks.sql`
4. `sql/04_analysis_queries.sql`

## 4. Important CTAS Note

Athena `CREATE TABLE AS SELECT` fails if the target S3 folder already has files. Before rerunning `sql/02_create_unified_table.sql`, delete the files inside:

`s3://improvado-marketing-assignment-2026/curated/fct_paid_ads_daily/`
