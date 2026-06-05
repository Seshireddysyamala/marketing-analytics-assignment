-- Check 1: row count by platform.
SELECT
  platform,
  COUNT(*) AS row_count,
  MIN(date) AS min_date,
  MAX(date) AS max_date
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY platform
ORDER BY platform;

-- Check 2: duplicate business keys.
SELECT
  date,
  platform,
  campaign_id,
  ad_group_id,
  COUNT(*) AS row_count
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY 1, 2, 3, 4
HAVING COUNT(*) > 1
ORDER BY row_count DESC;

-- Check 3: nulls in required fields.
SELECT
  COUNT(*) AS total_rows,
  COUNT_IF(date IS NULL) AS null_dates,
  COUNT_IF(platform IS NULL) AS null_platforms,
  COUNT_IF(campaign_id IS NULL) AS null_campaign_ids,
  COUNT_IF(campaign_name IS NULL) AS null_campaign_names,
  COUNT_IF(impressions IS NULL) AS null_impressions,
  COUNT_IF(clicks IS NULL) AS null_clicks,
  COUNT_IF(spend IS NULL) AS null_spend,
  COUNT_IF(conversions IS NULL) AS null_conversions
FROM marketing_assignment.fct_paid_ads_daily;

-- Check 4: impossible or suspicious metric logic.
SELECT *
FROM marketing_assignment.fct_paid_ads_daily
WHERE clicks > impressions
   OR conversions > clicks
   OR spend < 0
   OR impressions < 0
   OR clicks < 0
   OR conversions < 0;

-- Check 5: platform totals and calculated efficiency metrics.
SELECT
  platform,
  SUM(spend) AS total_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,
  SUM(conversion_value) AS total_conversion_value,
  SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0) AS ctr,
  SUM(spend) * 1.0 / NULLIF(SUM(clicks), 0) AS cpc,
  SUM(spend) * 1000.0 / NULLIF(SUM(impressions), 0) AS cpm,
  SUM(spend) * 1.0 / NULLIF(SUM(conversions), 0) AS cpa,
  SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0) AS conversion_rate,
  SUM(conversion_value) * 1.0 / NULLIF(SUM(spend), 0) AS roas
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY platform
ORDER BY total_spend DESC;

