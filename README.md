# Advanced-Public-Transport-Demand-Analysis-Using-Microsoft-SQL-Server

## Project Overview

An end-to-end advanced SQL Server analytics project designed to analyze public transportation demand, passenger behavior, route performance, operational efficiency, revenue generation, and vehicle capacity utilization.

The project simulates a public transportation company's operational database and uses advanced T-SQL techniques to transform raw operational data into actionable business insights.

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

SQL Server nonclustered indexes are implemented on frequently queried columns.

Query performance is evaluated through:

- Logical reads
- CPU time
- Elapsed time
- Actual execution plans

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

Execute the SQL scripts in the documented dependency order provided in this repository.

## Author

SQL Data Analyst Portfolio Project

**Domain:** Transportation Analytics

**Database:** Microsoft SQL Server

**Project Level:** Advanced SQL Analytics

**Primary Skill:** T-SQL
