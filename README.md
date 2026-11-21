# Advanced-Public-Transport-Demand-Analysis-Using-Microsoft-SQL-Server

## Project Overview

An end-to-end advanced SQL Server analytics project designed to analyze public transportation demand, passenger behavior, route performance, operational efficiency, revenue generation, and vehicle capacity utilization.

The project simulates a public transportation company's operational database and uses advanced T-SQL techniques to transform raw operational data into actionable business insights.

The synthetic dataset contains 3,840 trip records across 8 routes.

## Business Objective

The primary objective is to help transportation management understand passenger demand, optimize vehicle allocation, monitor operational performance, and improve service efficiency through SQL-based analysis.

## Key findings

Analysis of the synthetic dataset (3,840 trip records across 8 routes):

- **Top revenue route:** Nigdi-Hadapsar generated 4,391,730 in fare revenue, 17.8% of total revenue.

## Technology Stack

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Transact-SQL (T-SQL)
- Git and GitHub

**Development restriction:** All data generation, cleaning, transformation, analysis, and reporting are performed using Microsoft SQL Server.

## Database Architecture

The project uses a relational database design with separate master, transaction, staging, analytics, and audit objects.

### Main Tables

| Table | Purpose |
|---|---|
| Routes | Route and fare information |
| Vehicles | Vehicle details and capacity |
| DimDate | Calendar dimension |
| TimePeriods | Travel time categories |
| TripOperations | Validated operational records |
| RawTripData | Incoming staging records |
| DataQualityLog | Data quality issue tracking |
| RouteChangeLog | Route fare audit history |

## Advanced SQL Concepts

- Database design and normalization
- Primary and foreign key constraints
- Data validation and cleansing
- Duplicate detection using ROW_NUMBER()
- Common Table Expressions
- Recursive CTEs
- Advanced joins and subqueries
- Window functions: LAG, LEAD, RANK, DENSE_RANK, NTILE
- Running totals and rolling averages
- Month-over-month and year-over-year analysis
- Dynamic SQL using sp_executesql
- Stored procedures
- User-defined functions
- Views
- DML triggers
- Transactions and error handling
- TRY/CATCH
- Nonclustered indexes
- Execution plan analysis
- SQL Server performance optimization

## Key Business KPIs

1. Total Passenger Demand
2. Total Fare Revenue
3. Vehicle Occupancy Percentage
4. Trip Completion Percentage
5. Average Operational Delay
6. Revenue Per Passenger
7. Passenger Demand Growth
8. Monthly Revenue Growth
9. Route-wise Demand Ranking
10. Vehicle Capacity Utilization

## Data Quality Framework

A staging-to-production workflow is implemented to:

- Identify duplicate source records.
- Detect missing critical information.
- Validate passenger and trip counts.
- Identify invalid revenue and delay values.
- Validate route and vehicle references.
- Record data quality issues.
- Load only valid records into the operational table.
- Maintain audit information.

## Business Analysis

The project investigates:

- Highest and lowest demand routes.
- Peak and off-peak passenger traffic.
- Route-wise revenue generation.
- Daily and monthly demand trends.
- Passenger growth comparisons.
- Vehicle capacity utilization.
- Trip completion performance.
- Operational delay analysis.
- Route efficiency and resource allocation.

## Performance Optimization

SQL Server nonclustered indexes are implemented on frequently queried columns. To measure the effect, a route-level demand query (daily passengers and fare revenue for one route) was run before and after adding a covering index on `TripOperations (RouteID, DateKey)` that includes `PassengerCount` and `FareRevenue`. The BEFORE run was forced to scan the full table.

| Metric | Before index | After index |
|---|---|---|
| Logical reads (`TripOperations`) | 37 | 5 |
| Elapsed time | 3 ms | 1 ms |
| CPU time | 0 ms | 0 ms |

The covering index reduced logical reads by about 86%. With only 3,840 trip records the absolute times are tiny, so logical reads are the more reliable measure, and the benefit would grow with a larger dataset.

## Business Recommendations

Analytical findings can help management:

- Increase service frequency on consistently high-demand routes.
- Evaluate additional vehicle allocation.
- Optimize low-demand route schedules.
- Improve peak-hour operations.
- Investigate delays and missed trips.
- Monitor route-level revenue and service efficiency.

## Dataset Disclaimer

This project uses synthetic data generated through SQL Server.

It is an educational and portfolio demonstration, not an analysis of actual public transportation company records.

Year-over-year analysis requires an extended dataset covering multiple years.


## Project Execution

Run the scripts in this order in SQL Server Management Studio (SSMS):

1. `01_database_setup.sql`: creates the database.
2. `02_table_creation.sql`: creates tables, keys and constraints.
3. `03_data_generation.sql`: generates the synthetic data.
4. `04_data_quality_cleaning.sql`: runs data cleaning and validation.
5. `05_views_and_functions.sqll`: creates indexes, views, functions and stored procedures.
6. `06_final_business_insights.sql`: runs the business analysis queries.

Requires Microsoft SQL Server 2019 or later and permission to create databases.

## Author
**name** juhi Singh

**Domain:** Transportation Analytics

**Database:** Microsoft SQL Server

**Project Level:** Advanced SQL Analytics

**Primary Skill:** T-SQL
