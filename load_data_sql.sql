-- Load data into dim_date
COPY dim_date FROM '/path/to/dim_date.csv' DELIMITER ',' CSV HEADER;

-- Load data into dim_product
COPY dim_product FROM '/path/to/dim_product.csv' DELIMITER ',' CSV HEADER;

-- Load data into dim_store
COPY dim_store FROM '/path/to/dim_store.csv' DELIMITER ',' CSV HEADER;

-- Load data into fact_sales
COPY fact_sales FROM '/path/to/fact_sales.csv' DELIMITER ',' CSV HEADER;
