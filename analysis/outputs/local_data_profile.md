# Local Data Profile

## Dataset Scope
- Unified rows: 330
- Date range: 2024-01-01 to 2024-01-30
- Platforms: Facebook, Google Ads, TikTok

## QA Results
- Duplicate date/platform/campaign/ad group keys: 0
- Rows with impossible metric logic: 0
- Nulls in required fields:
  - date: 0
  - platform: 0
  - campaign_id: 0
  - impressions: 0
  - clicks: 0
  - spend: 0
  - conversions: 0

## Platform Summary
| platform   |      spend |   impressions |   clicks |   conversions |   conversion_value |   rows |    ctr |    cpc |    cpm |     cpa |   conversion_rate | roas   |
|:-----------|-----------:|--------------:|---------:|--------------:|-------------------:|-------:|-------:|-------:|-------:|--------:|------------------:|:-------|
| Facebook   | 18292.0000 |       4541474 |    88899 |          2395 |             0.0000 |    110 | 0.0196 | 0.2058 | 4.0278 |  7.6376 |            0.0269 | N/A    |
| Google Ads | 37686.2000 |       7223544 |   137590 |          4218 |        210900.0000 |    110 | 0.0190 | 0.2739 | 5.2171 |  8.9346 |            0.0307 | 5.60x  |
| TikTok     | 74266.7000 |      28708167 |   461844 |          6750 |             0.0000 |    110 | 0.0161 | 0.1608 | 2.5870 | 11.0025 |            0.0146 | N/A    |

## Key Talking Points
- Highest-spend campaign: TikTok / Influencer_Collab ($26,312.30).
- Most efficient CPA campaign: Google Ads / Search_Brand_Terms ($5.10).
- Best ROAS among campaigns with conversion value: Search_Brand_Terms (9.81x).
- Google Ads is the only platform with conversion value, so ROAS should be labeled as Google-specific or limited-availability.
- TikTok contributes the most volume and has richer upper-funnel engagement metrics.
- Facebook has useful reach/frequency fields, which makes it better for audience saturation and retargeting diagnostics.
