# Power BI Dashboard Build Guide

## Data Connection

Preferred path:

1. Open Power BI Desktop.
2. Get Data -> Amazon Athena or ODBC.
3. Connect to Athena.
4. Load `marketing_assignment.fct_paid_ads_daily`.
5. Use Import mode for the assignment; it is more stable for a small dataset.

Fallback path if the Athena connector takes too long:

1. Export the Athena unified table to CSV.
2. Import the CSV into Power BI.
3. Keep screenshots of Athena raw tables, unified table, and QA checks so the cloud database work is still evidenced.

## Measures

Create these DAX measures:

```DAX
Total Spend = SUM(fct_paid_ads_daily[spend])
Total Impressions = SUM(fct_paid_ads_daily[impressions])
Total Clicks = SUM(fct_paid_ads_daily[clicks])
Total Conversions = SUM(fct_paid_ads_daily[conversions])
CTR = DIVIDE([Total Clicks], [Total Impressions])
CPC = DIVIDE([Total Spend], [Total Clicks])
CPM = DIVIDE([Total Spend] * 1000, [Total Impressions])
CPA = DIVIDE([Total Spend], [Total Conversions])
Conversion Rate = DIVIDE([Total Conversions], [Total Clicks])
Conversion Value = SUM(fct_paid_ads_daily[conversion_value])
Spend With Conversion Value =
CALCULATE(
    [Total Spend],
    FILTER(
        fct_paid_ads_daily,
        NOT ISBLANK(fct_paid_ads_daily[conversion_value])
    )
)
ROAS = DIVIDE([Conversion Value], [Spend With Conversion Value])
```

Use this note near ROAS:

`ROAS is calculated only where conversion value is available. In this dataset, that is Google Ads.`

## One-Page Layout

Dashboard title:

`Cross-Channel Paid Marketing Performance - January 2024`

Top slicers:

- Date
- Platform
- Campaign Name

Top KPI cards:

- Total Spend
- Total Impressions
- Total Clicks
- Total Conversions
- CTR
- CPC
- CPA
- Conversion Rate

Main visuals:

- Line and clustered column chart: Date on X-axis, Total Spend as columns, Total Conversions as line, Platform as legend.
- Bar chart: Platform by Total Spend.
- Bar chart: Platform by CPA.
- Matrix: Platform, Campaign Name, Total Spend, Impressions, Clicks, Conversions, CTR, CPC, CPA, Conversion Rate.
- Scatter plot: Total Spend on X-axis, Total Conversions on Y-axis, Total Impressions as size, Platform as legend, Campaign Name as details.

Recommended insight labels:

- Google Ads: conversion-value and intent diagnostics.
- TikTok: upper-funnel video and engagement diagnostics.
- Facebook: reach, frequency, engagement, and retargeting diagnostics.
- MMM-readiness: This unified daily spend and performance table can be aggregated weekly by channel and joined with revenue, seasonality, pricing, promotion, and offline media variables for future marketing mix modeling.

## Formatting

- Spend, CPC, CPM, CPA: currency.
- CTR, Conversion Rate, ROAS: percentage.
- Impressions, Clicks, Conversions: whole numbers.
- Sort campaign matrix by Total Spend descending.
- Use conditional formatting on CPA, CTR, and Conversion Rate.
