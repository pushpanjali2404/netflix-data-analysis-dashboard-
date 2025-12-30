
-- =========================================
-- SQL DATA CLEANING & EXTRACTION TEMPLATE
-- =========================================

-- 1. Remove duplicate records
WITH dedup AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY order_id
               ORDER BY last_updated DESC
           ) AS rn
    FROM raw_sales_table
)
SELECT *
INTO cleaned_sales_table
FROM dedup
WHERE rn = 1;

-- 2. Handle NULL values
UPDATE cleaned_sales_table
SET
    sales_amount = COALESCE(sales_amount, 0),
    cost_amount  = COALESCE(cost_amount, 0),
    region       = COALESCE(region, 'Unknown');

-- 3. Standardize date formats
UPDATE cleaned_sales_table
SET order_date = CAST(order_date AS DATE);

-- 4. Remove invalid records
DELETE FROM cleaned_sales_table
WHERE sales_amount < 0 OR cost_amount < 0;

-- 5. Create extraction view for Power BI
CREATE OR REPLACE VIEW vw_powerbi_sales AS
SELECT
    order_id,
    order_date,
    product_name,
    region,
    sales_amount,
    cost_amount,
    (sales_amount - cost_amount) AS profit
FROM cleaned_sales_table;
