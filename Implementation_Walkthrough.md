# Retail Data Warehouse Implementation Walkthrough

This document provides a detailed step-by-step explanation of how the retail data warehouse was implemented, from database creation to final analysis.

## Table of Contents
1. [Database Setup](#database-setup)
2. [Schema Creation](#schema-creation)
3. [Data Loading Process](#data-loading-process)
4. [Query Execution and Analysis](#query-execution-and-analysis)
5. [Challenges and Solutions](#challenges-and-solutions)

## Database Setup

### Choice of Database System
For this project, we selected **Supabase** as our database platform. Supabase runs on PostgreSQL, which was one of the recommended database systems in the lab requirements. The selection was based on:

- PostgreSQL's robust support for analytical workloads
- Supabase's easy-to-use SQL editor for running queries
- Cloud-hosted environment for accessibility
- No need for local database installation

### Database Connection Setup
We created a project in the Supabase dashboard and established a connection using:

```
Database URL: https://cpcwvlrlbomqhfenword.supabase.co
API Key: [secure anon key]
```

## Schema Creation

### Star Schema Implementation
The database schema was implemented as a classic star schema with one fact table (fact_sales) and three dimension tables (dim_date, dim_product, dim_store). 

The following SQL was used to create the schema:

```sql
-- Dimension: Date
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT
);

-- Dimension: Product
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);

-- Dimension: Store
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50)
);

-- Fact: Sales
CREATE TABLE fact_sales (
    sale_id INT PRIMARY KEY,
    date_id INT,
    product_id INT,
    store_id INT,
    quantity_sold INT,
    revenue DECIMAL(10, 2),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (store_id) REFERENCES dim_store(store_id)
);
```

### Performance Optimization
To improve query performance, we added indexes on the foreign key columns in the fact table:

```sql
CREATE INDEX idx_fact_sales_date ON fact_sales(date_id);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX idx_fact_sales_store ON fact_sales(store_id);
```

## Data Loading Process

### Data Source Overview
The data was provided in four CSV files:
- `dim_date.csv`: Date dimension with time attributes
- `dim_product.csv`: Product information including categories
- `dim_store.csv`: Store locations and regions
- `fact_sales.csv`: Sales transactions with quantities and revenue

### Loading Method
For a cloud-hosted Supabase database, we implemented two approaches:

#### 1. SQL COPY Commands (PostgreSQL Standard Approach)
In a standard PostgreSQL installation, we would use:

```sql
COPY dim_date FROM '/path/to/dim_date.csv' DELIMITER ',' CSV HEADER;
COPY dim_product FROM '/path/to/dim_product.csv' DELIMITER ',' CSV HEADER;
COPY dim_store FROM '/path/to/dim_store.csv' DELIMITER ',' CSV HEADER;
COPY fact_sales FROM '/path/to/fact_sales.csv' DELIMITER ',' CSV HEADER;
```

#### 2. Programmatic Loading with Supabase Client
Since Supabase is cloud-hosted and doesn't have direct access to local files, we created a Python script to load the data:

```python
# Connect to Supabase
supabase = create_client(supabase_url, supabase_key)

# Load data from CSV
with open(csv_path, 'r', newline='') as csvfile:
    reader = csv.DictReader(csvfile)
    data = []
    for row in reader:
        # Convert types as needed
        data.append(row)
    
    # Insert data
    result = supabase.table(table_name).insert(data).execute()
```

### Data Loading Order
We carefully loaded the data in the correct order to maintain referential integrity:
1. First, all dimension tables (dim_date, dim_product, dim_store)
2. Then, the fact table (fact_sales) which references the dimension tables

## Query Execution and Analysis

### Analytical Queries
We ran the following analytical queries to gain business insights:

#### 1. Total Revenue by Product Category
```sql
SELECT p.category, SUM(f.revenue) AS total_revenue
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.category;
```

**Results:**
| Category | Total Revenue |
|----------|--------------|
| Electronics | $7,500.00 |
| Footwear | $400.00 |
| Apparel | $560.00 |

**Analysis:** Electronics is by far the highest revenue-generating category, accounting for approximately 89% of total revenue.

#### 2. Monthly Sales Trends
```sql
SELECT d.month, d.year, SUM(f.revenue) AS monthly_revenue
FROM fact_sales f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month
ORDER BY d.year, d.month;
```

**Results:**
| Month | Year | Monthly Revenue |
|-------|------|----------------|
| 1 | 2023 | $5,500.00 |
| 2 | 2023 | $560.00 |
| 3 | 2023 | $400.00 |
| 4 | 2023 | $2,000.00 |

**Analysis:** January shows the strongest sales with a significant drop in February and March. April shows signs of recovery. This could indicate seasonal purchasing patterns or the effects of marketing campaigns.

#### 3. Revenue by Region
```sql
SELECT s.region, SUM(f.revenue) AS region_revenue
FROM fact_sales f
JOIN dim_store s ON f.store_id = s.store_id
GROUP BY s.region;
```

**Results:**
| Region | Region Revenue |
|--------|---------------|
| Midwest | $4,500.00 |
| East | $3,400.00 |
| West | $560.00 |

**Analysis:** The Midwest region is the top performer, followed by the East. The West region significantly underperforms and may need targeted marketing or inventory adjustments.

#### 4. Top Products by Quantity Sold
```sql
SELECT p.name, SUM(f.quantity_sold) AS total_quantity
FROM fact_sales f
JOIN dim_product p ON f.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity DESC;
```

**Results:**
| Product Name | Total Quantity Sold |
|--------------|---------------------|
| Jeans | 7 |
| Phone | 5 |
| Laptop | 5 |
| Shoes | 4 |

**Analysis:** Jeans are the best-selling product by quantity. However, when comparing to revenue data, it's clear that higher-volume items like Jeans don't necessarily generate the most revenue.

## Challenges and Solutions

### Challenge 1: Cloud Database Access
**Challenge:** Traditional COPY commands don't work with cloud databases that don't have access to local files.

**Solution:** We implemented a Python script using the Supabase client library to programmatically load the data from CSV files.

### Challenge 2: Data Type Conversions
**Challenge:** CSV files contain all data as strings, but the database needs proper data types.

**Solution:** We implemented type conversion in our loading script to ensure proper numeric values for quantities and revenue.

### Challenge 3: Performance Optimization
**Challenge:** Analytical queries could potentially be slow on larger datasets.

**Solution:** We added indexes on foreign key columns in the fact table to improve join performance.

## Conclusion

This implementation successfully demonstrates the power of a star schema for analytical processing. The separation of facts and dimensions allows for flexible analysis across multiple dimensions while maintaining good query performance.

The insights gained from the analytical queries provide valuable information for business decision-making, particularly in areas of inventory management, regional performance evaluation, and marketing strategy.

This small-scale implementation could be easily extended to handle much larger datasets while maintaining the same logical structure and analytical capabilities.
