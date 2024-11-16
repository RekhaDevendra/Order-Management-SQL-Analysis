# Order Management and Supplier Data Analysis using SQL

## Project Overview
This project focuses on analyzing manufacturing data to optimize order management, pricing strategies, and supplier relationships using SQL. By consolidating data from various sources, this project provides key insights that help streamline processes, improve decision-making, and enhance business strategies.

## Key Features
- **Data Aggregation**: Analyzed product order data to uncover sales trends, material usage, and order distribution.
- **Order Categorization**: Categorized product orders into pricing tiers, identifying potential areas for profitability.
- **Customer Insights**: Identified top customers and provided insights for retention and acquisition strategies.
- **Production Tracking**: Built a funnel to track product order progress through various stages, highlighting bottlenecks.
- **Data Cleaning**: Ensured data consistency and accuracy through SQL-based cleaning and transformation.

## Tools & Technologies
- **SQL** (PostgreSQL)
- Data Analysis & Reporting
- Data Cleaning & Transformation
- (**Tableau**) Data Visualization 

## Installation

### Set up PostgreSQL

1. **Install PostgreSQL**: Download and install PostgreSQL from [PostgreSQL's official website](https://www.postgresql.org/download/).

2. **Create a Database**:
   - Open PostgreSQL's SQL interface (pgAdmin or command line).
   - Run the following command to create a new database:

   ```sql
   CREATE DATABASE order_management_db;

3. **Import SQL Scripts**: After creating the database, import the provided .sql scripts to set up the required tables.
Use the following command:
\i path_to_your_script.sql;
Ensure that the database is correctly set up with all the necessary tables for this project.

5. **Running SQL Queriess**"
- Once the database and tables are set up, you can execute the provided SQL queries to aggregate and analyze product orders, categorize pricing, track production stages, and clean the data.
- To run a query, simply execute the SQL command in your PostgreSQL interface.

**Contributing**
Feel free to fork the repository and submit a pull request for bug fixes, features, or improvements.

**License**
This project is licensed under the Apache License 2.0.
