-- Retail Data Warehouse Full Database Schema
-- DSA 2040A US 2025 LAB 1

-- Create a schema for the retail data warehouse
-- Comment this out if you don't want a separate schema
-- CREATE SCHEMA retail_dw;
-- SET search_path TO retail_dw;

-- Drop tables if they exist (for re-running the script)
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_store;

-- Dimension: Date
-- This table stores all date attributes to enable time-based analysis
CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT
);

-- Dimension: Product
-- This table stores product details and classification information
CREATE TABLE dim_product (
    product_id INT PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50)
);

-- Dimension: Store
-- This table stores store location and regional classification
CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50)
);

-- Fact: Sales
-- This is the central fact table that connects all dimensions
-- and stores the quantitative metrics (quantity sold and revenue)
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

-- Create indexes to improve query performance
CREATE INDEX idx_fact_sales_date ON fact_sales(date_id);
CREATE INDEX idx_fact_sales_product ON fact_sales(product_id);
CREATE INDEX idx_fact_sales_store ON fact_sales(store_id);

-- Sample comment explaining the schema
/*
This star schema consists of one fact table (fact_sales) and three dimension tables:
- dim_date: Contains time attributes for time-based analysis
- dim_product: Contains product details for product-based analysis
- dim_store: Contains store information for regional analysis

The fact table contains foreign keys to each dimension table and the measures:
- quantity_sold: Number of units sold
- revenue: Total sales amount

This design enables efficient querying for business analytics by:
1. Minimizing joins (star topology)
2. Supporting slice-and-dice analysis across multiple dimensions
3. Optimizing for read-heavy analytical workloads
*/
