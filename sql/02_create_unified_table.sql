-- Before rerunning this CTAS statement, empty the S3 prefix:
-- s3://improvado-marketing-assignment-2026/curated/fct_paid_ads_daily/

DROP TABLE IF EXISTS marketing_assignment.fct_paid_ads_daily;

CREATE TABLE marketing_assignment.fct_paid_ads_daily
WITH (
  format = 'PARQUET',
  external_location = 's3://improvado-marketing-assignment-2026/curated/fct_paid_ads_daily/'
) AS

SELECT
  TRY_CAST(report_date AS DATE) AS date,
  'Facebook' AS platform,
  campaign_id,
  campaign_name,
  ad_set_id AS ad_group_id,
  ad_set_name AS ad_group_name,
  impressions,
  clicks,
  spend,
  conversions,
  CAST(NULL AS DOUBLE) AS conversion_value,
  video_views,
  CAST(NULL AS BIGINT) AS video_watch_25,
  CAST(NULL AS BIGINT) AS video_watch_50,
  CAST(NULL AS BIGINT) AS video_watch_75,
  CAST(NULL AS BIGINT) AS video_watch_100,
  reach,
  frequency,
  engagement_rate,
  CAST(NULL AS BIGINT) AS quality_score,
  CAST(NULL AS DOUBLE) AS search_impression_share,
  CAST(NULL AS BIGINT) AS likes,
  CAST(NULL AS BIGINT) AS shares,
  CAST(NULL AS BIGINT) AS comments,
  clicks * 1.0 / NULLIF(impressions, 0) AS ctr,
  spend * 1.0 / NULLIF(clicks, 0) AS cpc,
  spend * 1000.0 / NULLIF(impressions, 0) AS cpm,
  spend * 1.0 / NULLIF(conversions, 0) AS cpa,
  conversions * 1.0 / NULLIF(clicks, 0) AS conversion_rate,
  CAST(NULL AS DOUBLE) AS roas
FROM marketing_assignment.raw_facebook_ads

UNION ALL

SELECT
  TRY_CAST(report_date AS DATE) AS date,
  'Google Ads' AS platform,
  campaign_id,
  campaign_name,
  ad_group_id,
  ad_group_name,
  impressions,
  clicks,
  cost AS spend,
  conversions,
  conversion_value,
  CAST(NULL AS BIGINT) AS video_views,
  CAST(NULL AS BIGINT) AS video_watch_25,
  CAST(NULL AS BIGINT) AS video_watch_50,
  CAST(NULL AS BIGINT) AS video_watch_75,
  CAST(NULL AS BIGINT) AS video_watch_100,
  CAST(NULL AS BIGINT) AS reach,
  CAST(NULL AS DOUBLE) AS frequency,
  CAST(NULL AS DOUBLE) AS engagement_rate,
  quality_score,
  search_impression_share,
  CAST(NULL AS BIGINT) AS likes,
  CAST(NULL AS BIGINT) AS shares,
  CAST(NULL AS BIGINT) AS comments,
  clicks * 1.0 / NULLIF(impressions, 0) AS ctr,
  cost * 1.0 / NULLIF(clicks, 0) AS cpc,
  cost * 1000.0 / NULLIF(impressions, 0) AS cpm,
  cost * 1.0 / NULLIF(conversions, 0) AS cpa,
  conversions * 1.0 / NULLIF(clicks, 0) AS conversion_rate,
  conversion_value * 1.0 / NULLIF(cost, 0) AS roas
FROM marketing_assignment.raw_google_ads

UNION ALL

SELECT
  TRY_CAST(report_date AS DATE) AS date,
  'TikTok' AS platform,
  campaign_id,
  campaign_name,
  adgroup_id AS ad_group_id,
  adgroup_name AS ad_group_name,
  impressions,
  clicks,
  cost AS spend,
  conversions,
  CAST(NULL AS DOUBLE) AS conversion_value,
  video_views,
  video_watch_25,
  video_watch_50,
  video_watch_75,
  video_watch_100,
  CAST(NULL AS BIGINT) AS reach,
  CAST(NULL AS DOUBLE) AS frequency,
  CAST(NULL AS DOUBLE) AS engagement_rate,
  CAST(NULL AS BIGINT) AS quality_score,
  CAST(NULL AS DOUBLE) AS search_impression_share,
  likes,
  shares,
  comments,
  clicks * 1.0 / NULLIF(impressions, 0) AS ctr,
  cost * 1.0 / NULLIF(clicks, 0) AS cpc,
  cost * 1000.0 / NULLIF(impressions, 0) AS cpm,
  cost * 1.0 / NULLIF(conversions, 0) AS cpa,
  conversions * 1.0 / NULLIF(clicks, 0) AS conversion_rate,
  CAST(NULL AS DOUBLE) AS roas
FROM marketing_assignment.raw_tiktok_ads;
