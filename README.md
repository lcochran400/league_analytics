# League of Legends Analytics dbt Project

A comprehensive data transformation pipeline built with dbt Core for analyzing League of Legends match data, player performance, and team insights using the Riot Games API.

## 📊 Project Overview

This dbt project transforms raw League of Legends match data into clean, analytics-ready datasets for performance analysis. It processes match results, player statistics, objective control, and team compositions to generate insights for competitive gameplay improvement and trend analysis.

**Data Sources:**
- Riot Games API (Match-v5, Summoner-v4)
- Raw match data stored in DuckDB
- Team roster configurations



## 🚀 Getting Started

### Prerequisites

- dbt Core >= 1.0.0
- Python >= 3.7
- DuckDB (local development)
- **Data extraction setup**: [League Data Extractor](https://github.com/lcochran400/team_data_extraction) - Required Python repository for Riot API data collection

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd lol-analytics-dbt
```

2. Set up your `profiles.yml` for DuckDB connection

3. Test your connection:
```bash
dbt debug
```

### Running the Project

```bash
# Install dependencies
dbt deps

# Run all models
dbt run

# Run tests to validate match data integrity
dbt test

# Generate documentation
dbt docs generate
dbt docs serve
```



## 📈 Key Metrics & KPIs

This project generates League of Legends insights on:

**Team Performance:**
- Win rate overall and by various game impacts (game duration, objective control, etc)
- Objective control efficiency (Dragons, Barons, Towers per team)
- Team composition effectiveness

**Player Analytics:**
- Individual KDA trends and improvement over time
- Champion mastery and performance by role
- CS per minute and damage contribution
- Performance in wins vs. losses

**Match Analysis:**
- Game duration patterns and win conditions
- Patch-over-patch performance changes
- Power spike timing and objective prioritization

## 🔄 Data Refresh

Data refresh is managed through the [League Data Extractor](https://github.com/lcochran400/team_data_extraction) repository. This dbt project transforms data based on manual refreshes from the extraction pipeline. Run `dbt run` after new match data has been extracted to update analytics models.

## Related Repositories

This project is part of a two-repository data pipeline:

**[League Data Extractor](link-to-extraction-repo)** - Python scripts that:
- Call Riot Games API for match data
- Handle rate limiting and error handling  
- Store raw data in DuckDB

**League Analytics dbt** (this repo) - dbt transformations that:
- Clean and standardize raw API data
- Calculate League-specific metrics
- Generate analytics-ready datasets

**Data Flow:**
```
Riot API → Python Extractor → DuckDB → dbt Models → Analytics Tables
```

## 📚 Documentation

Generate and view documentation with data lineage:
```bash
dbt docs generate
dbt docs serve
```

## 🤝 Contributing

1. Create a feature branch
2. Add new champions/items to seed files as needed
3. Run tests: `dbt test`
4. Submit a pull request