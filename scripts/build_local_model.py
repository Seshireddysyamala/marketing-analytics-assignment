from pathlib import Path

import pandas as pd


ROOT = Path(__file__).resolve().parents[1]
RAW_DIR = ROOT / "data" / "raw"
CURATED_DIR = ROOT / "data" / "curated"
OUTPUT_DIR = ROOT / "analysis" / "outputs"


def safe_divide(numerator, denominator):
    return numerator / denominator if denominator else pd.NA


def add_rate_columns(df):
    df = df.copy()
    df["ctr"] = df.apply(lambda row: safe_divide(row["clicks"], row["impressions"]), axis=1)
    df["cpc"] = df.apply(lambda row: safe_divide(row["spend"], row["clicks"]), axis=1)
    df["cpm"] = df.apply(lambda row: safe_divide(row["spend"] * 1000, row["impressions"]), axis=1)
    df["cpa"] = df.apply(lambda row: safe_divide(row["spend"], row["conversions"]), axis=1)
    df["conversion_rate"] = df.apply(lambda row: safe_divide(row["conversions"], row["clicks"]), axis=1)
    df["roas"] = df.apply(lambda row: safe_divide(row["conversion_value"], row["spend"]), axis=1)
    return df


def load_unified_data():
    facebook = pd.read_csv(RAW_DIR / "01_facebook_ads.csv", parse_dates=["date"])
    facebook = facebook.rename(
        columns={
            "ad_set_id": "ad_group_id",
            "ad_set_name": "ad_group_name",
        }
    )
    facebook["platform"] = "Facebook"
    facebook["conversion_value"] = pd.NA
    facebook["video_watch_25"] = pd.NA
    facebook["video_watch_50"] = pd.NA
    facebook["video_watch_75"] = pd.NA
    facebook["video_watch_100"] = pd.NA
    facebook["quality_score"] = pd.NA
    facebook["search_impression_share"] = pd.NA
    facebook["likes"] = pd.NA
    facebook["shares"] = pd.NA
    facebook["comments"] = pd.NA

    google = pd.read_csv(RAW_DIR / "02_google_ads.csv", parse_dates=["date"])
    google = google.rename(columns={"cost": "spend"})
    google["platform"] = "Google Ads"
    google["video_views"] = pd.NA
    google["video_watch_25"] = pd.NA
    google["video_watch_50"] = pd.NA
    google["video_watch_75"] = pd.NA
    google["video_watch_100"] = pd.NA
    google["reach"] = pd.NA
    google["frequency"] = pd.NA
    google["engagement_rate"] = pd.NA
    google["likes"] = pd.NA
    google["shares"] = pd.NA
    google["comments"] = pd.NA

    tiktok = pd.read_csv(RAW_DIR / "03_tiktok_ads.csv", parse_dates=["date"])
    tiktok = tiktok.rename(
        columns={
            "cost": "spend",
            "adgroup_id": "ad_group_id",
            "adgroup_name": "ad_group_name",
        }
    )
    tiktok["platform"] = "TikTok"
    tiktok["conversion_value"] = pd.NA
    tiktok["reach"] = pd.NA
    tiktok["frequency"] = pd.NA
    tiktok["engagement_rate"] = pd.NA
    tiktok["quality_score"] = pd.NA
    tiktok["search_impression_share"] = pd.NA

    columns = [
        "date",
        "platform",
        "campaign_id",
        "campaign_name",
        "ad_group_id",
        "ad_group_name",
        "impressions",
        "clicks",
        "spend",
        "conversions",
        "conversion_value",
        "video_views",
        "video_watch_25",
        "video_watch_50",
        "video_watch_75",
        "video_watch_100",
        "reach",
        "frequency",
        "engagement_rate",
        "quality_score",
        "search_impression_share",
        "likes",
        "shares",
        "comments",
    ]
    unified = pd.concat(
        [facebook[columns], google[columns], tiktok[columns]],
        ignore_index=True,
    )
    return add_rate_columns(unified)


def summarize(grouped):
    summary = grouped.agg(
        spend=("spend", "sum"),
        impressions=("impressions", "sum"),
        clicks=("clicks", "sum"),
        conversions=("conversions", "sum"),
        conversion_value=("conversion_value", "sum"),
        rows=("platform", "size"),
    ).reset_index()
    summary["ctr"] = summary.apply(lambda row: safe_divide(row["clicks"], row["impressions"]), axis=1)
    summary["cpc"] = summary.apply(lambda row: safe_divide(row["spend"], row["clicks"]), axis=1)
    summary["cpm"] = summary.apply(lambda row: safe_divide(row["spend"] * 1000, row["impressions"]), axis=1)
    summary["cpa"] = summary.apply(lambda row: safe_divide(row["spend"], row["conversions"]), axis=1)
    summary["conversion_rate"] = summary.apply(lambda row: safe_divide(row["conversions"], row["clicks"]), axis=1)
    summary["roas"] = summary.apply(
        lambda row: safe_divide(row["conversion_value"], row["spend"])
        if row["conversion_value"] > 0
        else pd.NA,
        axis=1,
    )
    return summary


def write_markdown_report(unified, platform_summary, campaign_summary):
    bad_metric_rows = unified[
        (unified["clicks"] > unified["impressions"])
        | (unified["conversions"] > unified["clicks"])
        | (unified["spend"] < 0)
        | (unified["impressions"] < 0)
        | (unified["clicks"] < 0)
        | (unified["conversions"] < 0)
    ]
    duplicate_keys = unified.duplicated(
        subset=["date", "platform", "campaign_id", "ad_group_id"],
        keep=False,
    ).sum()
    nulls = unified[
        ["date", "platform", "campaign_id", "impressions", "clicks", "spend", "conversions"]
    ].isna().sum()

    best_cpa = campaign_summary.sort_values("cpa", ascending=True).iloc[0]
    highest_spend = campaign_summary.sort_values("spend", ascending=False).iloc[0]
    best_roas_rows = campaign_summary[campaign_summary["conversion_value"] > 0].sort_values(
        "roas",
        ascending=False,
    )
    best_roas = best_roas_rows.iloc[0] if not best_roas_rows.empty else None

    lines = [
        "# Local Data Profile",
        "",
        "## Dataset Scope",
        f"- Unified rows: {len(unified):,}",
        f"- Date range: {unified['date'].min().date()} to {unified['date'].max().date()}",
        f"- Platforms: {', '.join(sorted(unified['platform'].unique()))}",
        "",
        "## QA Results",
        f"- Duplicate date/platform/campaign/ad group keys: {duplicate_keys}",
        f"- Rows with impossible metric logic: {len(bad_metric_rows)}",
        "- Nulls in required fields:",
    ]
    for column, count in nulls.items():
        lines.append(f"  - {column}: {int(count)}")

    display_platform_summary = platform_summary.copy()
    display_platform_summary["roas"] = display_platform_summary["roas"].apply(
        lambda value: "N/A" if pd.isna(value) else f"{value:.2f}x"
    )

    lines.extend(
        [
            "",
            "## Platform Summary",
            display_platform_summary.to_markdown(index=False, floatfmt=".4f"),
            "",
            "## Key Talking Points",
            f"- Highest-spend campaign: {highest_spend['platform']} / {highest_spend['campaign_name']} (${highest_spend['spend']:,.2f}).",
            f"- Most efficient CPA campaign: {best_cpa['platform']} / {best_cpa['campaign_name']} (${best_cpa['cpa']:,.2f}).",
        ]
    )
    if best_roas is not None:
        lines.append(
            f"- Best ROAS among campaigns with conversion value: {best_roas['campaign_name']} ({best_roas['roas']:.2f}x)."
        )

    lines.extend(
        [
            "- Google Ads is the only platform with conversion value, so ROAS should be labeled as Google-specific or limited-availability.",
            "- TikTok contributes the most volume and has richer upper-funnel engagement metrics.",
            "- Facebook has useful reach/frequency fields, which makes it better for audience saturation and retargeting diagnostics.",
            "",
        ]
    )
    (OUTPUT_DIR / "local_data_profile.md").write_text("\n".join(lines), encoding="utf-8")


def main():
    CURATED_DIR.mkdir(parents=True, exist_ok=True)
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    unified = load_unified_data()
    unified.to_csv(CURATED_DIR / "fct_paid_ads_daily.csv", index=False)

    platform_summary = summarize(unified.groupby("platform"))
    campaign_summary = summarize(unified.groupby(["platform", "campaign_name"]))
    daily_summary = summarize(unified.groupby(["date", "platform"]))

    platform_summary.to_csv(OUTPUT_DIR / "platform_summary.csv", index=False)
    campaign_summary.to_csv(OUTPUT_DIR / "campaign_summary.csv", index=False)
    daily_summary.to_csv(OUTPUT_DIR / "daily_platform_summary.csv", index=False)
    write_markdown_report(unified, platform_summary, campaign_summary)


if __name__ == "__main__":
    main()
