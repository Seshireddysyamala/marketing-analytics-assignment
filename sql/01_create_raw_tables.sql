-- S3 bucket: improvado-marketing-assignment-2026

CREATE DATABASE IF NOT EXISTS marketing_assignment;

DROP TABLE IF EXISTS marketing_assignment.raw_facebook_ads;

CREATE EXTERNAL TABLE marketing_assignment.raw_facebook_ads (
  report_date STRING,
  campaign_id STRING,
  campaign_name STRING,
  ad_set_id STRING,
  ad_set_name STRING,
  impressions BIGINT,
  clicks BIGINT,
  spend DOUBLE,
  conversions BIGINT,
  video_views BIGINT,
  engagement_rate DOUBLE,
  reach BIGINT,
  frequency DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
LOCATION 's3://improvado-marketing-assignment-2026/raw/facebook/'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS marketing_assignment.raw_google_ads;

CREATE EXTERNAL TABLE marketing_assignment.raw_google_ads (
  report_date STRING,
  campaign_id STRING,
  campaign_name STRING,
  ad_group_id STRING,
  ad_group_name STRING,
  impressions BIGINT,
  clicks BIGINT,
  cost DOUBLE,
  conversions BIGINT,
  conversion_value DOUBLE,
  ctr DOUBLE,
  avg_cpc DOUBLE,
  quality_score BIGINT,
  search_impression_share DOUBLE
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
LOCATION 's3://improvado-marketing-assignment-2026/raw/google_ads/'
TBLPROPERTIES ("skip.header.line.count"="1");

DROP TABLE IF EXISTS marketing_assignment.raw_tiktok_ads;

CREATE EXTERNAL TABLE marketing_assignment.raw_tiktok_ads (
  report_date STRING,
  campaign_id STRING,
  campaign_name STRING,
  adgroup_id STRING,
  adgroup_name STRING,
  impressions BIGINT,
  clicks BIGINT,
  cost DOUBLE,
  conversions BIGINT,
  video_views BIGINT,
  video_watch_25 BIGINT,
  video_watch_50 BIGINT,
  video_watch_75 BIGINT,
  video_watch_100 BIGINT,
  likes BIGINT,
  shares BIGINT,
  comments BIGINT
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  "separatorChar" = ",",
  "quoteChar" = "\""
)
LOCATION 's3://improvado-marketing-assignment-2026/raw/tiktok_ads/'
TBLPROPERTIES ("skip.header.line.count"="1");
