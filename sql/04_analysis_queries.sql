-- Use these after QA to extract business insights for the dashboard and walkthrough.

-- Campaign leaderboard by spend and efficiency.
SELECT
  platform,
  campaign_name,
  SUM(spend) AS total_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,
  SUM(conversion_value) AS total_conversion_value,
  SUM(clicks) * 1.0 / NULLIF(SUM(impressions), 0) AS ctr,
  SUM(spend) * 1.0 / NULLIF(SUM(clicks), 0) AS cpc,
  SUM(spend) * 1.0 / NULLIF(SUM(conversions), 0) AS cpa,
  SUM(conversions) * 1.0 / NULLIF(SUM(clicks), 0) AS conversion_rate,
  SUM(conversion_value) * 1.0 / NULLIF(SUM(spend), 0) AS roas
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY 1, 2
ORDER BY total_spend DESC;

-- Daily spend and conversions by platform.
SELECT
  date,
  platform,
  SUM(spend) AS total_spend,
  SUM(conversions) AS total_conversions,
  SUM(clicks) AS total_clicks,
  SUM(impressions) AS total_impressions,
  SUM(spend) * 1.0 / NULLIF(SUM(conversions), 0) AS cpa
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY 1, 2
ORDER BY date, platform;

-- Platform-specific diagnostics.
SELECT
  platform,
  SUM(video_views) AS video_views,
  SUM(video_watch_25) AS video_watch_25,
  SUM(video_watch_50) AS video_watch_50,
  SUM(video_watch_75) AS video_watch_75,
  SUM(video_watch_100) AS video_watch_100,
  SUM(likes) AS likes,
  SUM(shares) AS shares,
  SUM(comments) AS comments,
  AVG(quality_score) AS avg_quality_score,
  AVG(search_impression_share) AS avg_search_impression_share,
  AVG(frequency) AS avg_frequency,
  AVG(engagement_rate) AS avg_engagement_rate
FROM marketing_assignment.fct_paid_ads_daily
GROUP BY platform
ORDER BY platform;

