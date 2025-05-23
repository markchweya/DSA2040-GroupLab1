# DSA 2040A - Retail Data Warehouse Quiz Answers

## Database Implementation Details

**Database System Used**: Supabase (PostgreSQL)

Supabase was chosen for this project because it provides a fully managed PostgreSQL database with an intuitive interface for running SQL queries and viewing results. As PostgreSQL is one of the recommended systems in the lab assignment, Supabase offers all the capabilities needed for implementing the star schema and running analytical queries.

**Data Loading Method**:

For this project, data was loaded using two complementary approaches:

1. **SQL COPY Commands**: The standard PostgreSQL approach using commands like:
   ```sql
   COPY dim_date FROM '/path/to/dim_date.csv' DELIMITER ',' CSV HEADER;
   ```
   This is the approach recommended in the lab manual, though in Supabase (cloud-hosted PostgreSQL), client-side `\COPY` commands would be needed.

2. **Programmatic Loading**: For practical implementation in the cloud environment, we used a Python script with the Supabase client to insert the data from CSV files into the respective tables. This method offers better compatibility with cloud-hosted databases where server-side file access is restricted.

The database schema follows the star schema design specified in the lab manual, with proper foreign key relationships between the fact and dimension tables.
![image](https://github.com/user-attachments/assets/ebcf8e15-f30e-4bb0-ac77-56673f923b78)



## 1. Total Revenue by Product Category

| Category | Total Revenue |
|----------|--------------|
| Electronics | $7,500.00 |
| Footwear | $400.00 |
| Apparel | $560.00 |

## 2. Monthly Sales Trends

| Month | Year | Monthly Revenue |
|-------|------|----------------|
| 1 | 2023 | $5,500.00 |
| 2 | 2023 | $560.00 |
| 3 | 2023 | $400.00 |
| 4 | 2023 | $2,000.00 |

## 3. Revenue by Region

| Region | Region Revenue |
|--------|---------------|
| Midwest | $4,500.00 |
| East | $3,400.00 |
| West | $560.00 |

## 4. Top Products by Quantity Sold

| Product Name | Total Quantity Sold |
|--------------|---------------------|
| Jeans | 7 |
| Phone | 5 |
| Laptop | 5 |
| Shoes | 4 |

## Analysis Summary

- **Product Categories**: Electronics is the highest revenue-generating category at $7,500.00, which is significantly higher than the other categories.
  
- **Monthly Trends**: January 2023 shows the highest sales with $5,500.00, followed by April with $2,000.00. February and March show considerably lower sales.
  
- **Regional Performance**: The Midwest region leads in sales with $4,500.00, followed closely by the East region with $3,400.00. The West region shows much lower sales at $560.00.
  
- **Product Performance**: Jeans are the best-selling product by quantity (7 units), followed by Phone and Laptop (5 units each), and Shoes (4 units).

## Part 5: Reflection & Discussion

### 1. Why use a star schema instead of a normalized schema?

A star schema is preferred over a normalized schema for data warehousing for several key reasons:

- **Query Performance**: Star schemas optimize analytical query performance by reducing the number of joins needed. With fewer tables, simpler relationships, and denormalized dimensions, queries run faster and are more efficient.

- **Simplicity and Intuitiveness**: The star structure is intuitive and easier to understand for business users. Fact tables represent what is being measured, while dimension tables provide context for those measurements.

- **Aggregation Efficiency**: Star schemas facilitate quick aggregation and summarization of data (e.g., total sales by region, by product category, etc.) which is essential for business intelligence reports.

- **Predictable Query Response Times**: The simplified structure leads to more consistent and predictable query performance, which is critical for operational reporting.

- **ETL Process Simplicity**: Loading data into a star schema is typically more straightforward than into a fully normalized database, reducing ETL complexity.

### 2. What are the benefits of separating facts from dimensions?

Separating facts from dimensions provides numerous benefits:

- **Data Volume Management**: Fact tables can grow to billions of rows but remain manageable because dimension attributes are stored separately. This reduces redundancy and storage requirements.

- **Consistency in Reporting**: Dimensions provide consistent descriptive attributes for categorization and filtering, ensuring that all reports using the same dimension maintain consistent definitions.

- **Flexibility in Analysis**: Users can easily analyze facts from different dimensional perspectives (slicing and dicing) without complex query rewriting.

- **Evolutionary Development**: The separation allows for independent evolution of facts and dimensions. New facts can be added without affecting dimensions, and dimension attributes can be enriched without modifying fact tables.

- **Support for Slowly Changing Dimensions**: The separation facilitates tracking of historical changes in dimension attributes (e.g., when a product changes category or a store changes region).

### 3. What types of business decisions could this warehouse support?

This retail data warehouse could support various business decisions:

- **Inventory Management**: Identifying top-selling products to optimize stock levels and ensure popular items don't go out of stock.

- **Marketing Strategy**: Allocating marketing budget to high-performing product categories or regions that drive the most revenue.

- **Seasonal Planning**: Analyzing monthly sales trends to prepare for peak seasons and adjust staffing and inventory accordingly.

- **Store Performance Analysis**: Evaluating the performance of different store locations to identify underperforming stores or regions that need attention.

- **Product Mix Optimization**: Understanding which product categories drive the most revenue to optimize shelf space and product assortment.

- **Pricing Strategies**: Analyzing revenue patterns to develop effective pricing strategies across different product categories.

- **Regional Expansion**: Identifying successful regions for potential new store locations or expanded operations.

- **Sales Forecasting**: Using historical sales trends to predict future demand and plan accordingly.
