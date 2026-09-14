# Dublin Bikes: Rebalancing Insights

Analysis of Dublin Bikes historical station data to identify where and when the bike-share network runs out of balance — stations going empty during the morning commute, and stations filling up during the evening commute — with a concrete rebalancing recommendation.

## Problem

Dublin Bikes stations aren't rebalanced perfectly: some stations run out of bikes during the morning rush, leaving commuters stranded, while others fill up completely in the evening, leaving no space to dock. This project quantifies exactly which stations are affected, how often, and proposes where bikes should be moved and when.

## Data Sources

- **Dublin Bikes historical station data** — [Smart Dublin Open Data Portal](https://data.smartdublin.ie/dataset/dublinbikes-api). Two months analyzed: August 2023 (summer) and February 2023 (winter), ~322,000 station-level readings across 114 stations.
- **Weather data** — [Open-Meteo Historical Weather API](https://open-meteo.com/en/docs/historical-weather-api). Daily max/min temperature and precipitation for Dublin, matched to the same date range.

## Tools Used

- **Python (pandas)** — data cleaning, merging, feature engineering, exploratory analysis
- **SQL (SQLite)** — core aggregation queries re-implemented and cross-checked against pandas results (see `scripts/analysis_queries.sql`)
- **Power BI Desktop** — interactive dashboard
- **Open-Meteo REST API** — weather data retrieval

## Methodology

1. Pulled two months of station-level data (169,404 + 152,903 rows) via CSV download from Smart Dublin
2. Cleaned timestamps, derived `hour`, `day_of_week`, and `is_weekend` features
3. Identified and removed a test/dummy station (`ORIEL STREET TEST TERMINAL`) that would have distorted the "always full" ranking
4. Pulled and merged daily weather data (temperature, precipitation) via the Open-Meteo API
5. Answered three core questions using both pandas and SQL, cross-checking results matched between the two approaches
6. Built an interactive Power BI dashboard summarizing the findings

## Key Findings

**1. Certain stations are chronically empty during the morning commute.**
Broadstone had zero bikes available in 55% of 8–9am readings; Custom House Quay in 49%. These stations need bikes moved in *before* the morning peak.

**2. A different set of stations is chronically full during the evening commute.**
Heuston Bridge (South) was completely full in 62% of 5–6pm readings; Custom House Quay again appears here at 47% — meaning it runs empty in the morning and full in the evening, a strong round-trip commuter signal worth flagging to operations specifically.

**3. Weekday usage is clearly commuter-driven; weekends are flat.**
Weekday availability drops sharply at 8–9am and again at 5–6pm. Weekend usage stays flat throughout the day with no comparable dips — consistent with leisure rather than commute-driven demand.

**4. Weather showed no meaningful effect at the daily level.**
Correlation between daily temperature/rainfall and bike availability was effectively zero (|r| < 0.01). This is a genuine null result, not a bug — daily-level weather is too coarse to capture effects that likely only matter during specific commute windows. Hourly weather data would be needed to test this properly; noted here as a limitation rather than omitted.

## Recommendation

- Prioritize moving bikes **into** Broadstone and Custom House Quay before 7:30am on weekdays.
- Prioritize moving bikes **out of** Heuston Bridge (South) and Custom House Quay before 5pm on weekdays.
- Custom House Quay should be treated as a single round-trip rebalancing priority, not two separate problems.
- Weekend rebalancing can follow a lighter, flatter schedule given the absence of sharp peaks.

## Dashboard

Interactive Power BI dashboard: `dashboard/dublinbikes_dashboard.pbix` (static PDF export also included: `dashboard/dublinbikes_dashboard.pdf`)

*(Add a screenshot or GIF of the dashboard here once exported)*

## Repository Structure

```
dublinbikes-analysis/
├── data/
│   ├── raw/                  # Original monthly CSVs (not committed — see .gitignore)
│   └── processed/            # Cleaned data, summary tables, SQLite DB
├── notebooks/
│   ├── 01_explore_data.ipynb # Loading, cleaning, weather merge, pandas analysis
│   └── 02_sql_analysis.ipynb # SQL version of core queries (SQLite)
├── scripts/
│   └── analysis_queries.sql  # Standalone SQL queries
├── dashboard/
│   └── dublinbikes_dashboard.pbix
├── requirements.txt
└── README.md
```

## Reproducing This Project

```bash
git clone <your-repo-url>
cd dublinbikes-analysis
python -m venv venv
venv\Scripts\Activate.ps1        # Windows
pip install -r requirements.txt
jupyter notebook
```

Download the August 2023 and February 2023 CSVs from [Smart Dublin](https://data.smartdublin.ie/dataset/dublinbikes-api) into `data/raw/`, then run `01_explore_data.ipynb` followed by `02_sql_analysis.ipynb`.

## Skills Demonstrated

Data acquisition (API + open data portal) · Python/pandas data cleaning and feature engineering · SQL aggregation and querying · Data quality checks (nulls, duplicates, anomaly detection) · Time-series and comparative analysis · Correlation analysis and honest null-result reporting · Power BI dashboard design · Git/GitHub version control · Technical documentation
