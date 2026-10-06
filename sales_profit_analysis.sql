
CREATE TABLE sales_data (
    "Order ID" INTEGER,
    "Order Date" DATE,
    "Customer ID" VARCHAR(20),
    "Salesperson ID" VARCHAR(20),
    "Customer Segment" VARCHAR(50),
    "Category" VARCHAR(50),
    "Product" VARCHAR(100),
    "State" VARCHAR(50),
    "Region" VARCHAR(30),
    "Sales Channel" VARCHAR(30),
    "Quantity" INTEGER,
    "Unit Price" NUMERIC(12,2),
    "Discount %" NUMERIC(6,4),
    "Sales" NUMERIC(14,2),
    "COGS" NUMERIC(14,2),
    "Profit" NUMERIC(14,2),
    "Payment Method" VARCHAR(50)
);

-- 3. Total number of rows
SELECT COUNT(*) AS total_rows
FROM sales_data;

-- 4. View sample records
SELECT *
FROM sales_data
LIMIT 10;

-- 5. Check date range
SELECT
    MIN("Order Date") AS first_order_date,
    MAX("Order Date") AS last_order_date
FROM sales_data;

-- 6. Count distinct customers
SELECT COUNT(DISTINCT "Customer ID") AS total_customers
FROM sales_data;

-- 7. Count distinct products
SELECT COUNT(DISTINCT "Product") AS total_products
FROM sales_data;

-- 8. Count distinct states
SELECT COUNT(DISTINCT "State") AS total_states
FROM sales_data;

-- 9. Check for duplicate Order IDs
SELECT
    "Order ID",
    COUNT(*) AS duplicate_count
FROM sales_data
GROUP BY "Order ID"
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

-- 10. Total sales
SELECT ROUND(SUM("Sales"), 2) AS total_sales
FROM sales_data;

-- 11. Total profit
SELECT ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data;

-- 12. Total quantity sold
SELECT SUM("Quantity") AS total_quantity
FROM sales_data;

-- 13. Average order sales
SELECT ROUND(AVG("Sales"), 2) AS average_order_sales
FROM sales_data;

-- 14. Profit margin %
SELECT
    ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM sales_data;

-- 15. Combined KPI report
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    SUM("Quantity") AS total_quantity,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("COGS"), 2) AS total_cogs,
    ROUND(SUM("Profit"), 2) AS total_profit,
    ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM sales_data;

-- 16. Sales and profit by category
SELECT
    "Category",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    SUM("Quantity") AS total_quantity
FROM sales_data
GROUP BY "Category"
ORDER BY total_sales DESC;

-- 17. Category profit margin
SELECT
    "Category",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    ROUND(SUM("Profit") / NULLIF(SUM("Sales"), 0) * 100, 2) AS profit_margin_pct
FROM sales_data
GROUP BY "Category"
ORDER BY profit_margin_pct DESC;


-- 18. Sales and profit by region
SELECT
    "Region",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    COUNT(*) AS total_orders
FROM sales_data
GROUP BY "Region"
ORDER BY total_sales DESC;

-- 19. Sales by state
SELECT
    "State",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "State"
ORDER BY total_sales DESC;

-- 20. Top 10 states by profit
SELECT
    "State",
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "State"
ORDER BY total_profit DESC
LIMIT 10;

-- 21. Sales and profit by product
SELECT
    "Product",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit,
    SUM("Quantity") AS total_quantity
FROM sales_data
GROUP BY "Product"
ORDER BY total_sales DESC;

-- 22. Top 10 products by sales
SELECT
    "Product",
    ROUND(SUM("Sales"), 2) AS total_sales
FROM sales_data
GROUP BY "Product"
ORDER BY total_sales DESC
LIMIT 10;

-- 23. Top 10 products by profit
SELECT
    "Product",
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "Product"
ORDER BY total_profit DESC
LIMIT 10;

-- 24. Products with negative profit
SELECT
    "Product",
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "Product"
HAVING SUM("Profit") < 0
ORDER BY total_profit;


-- 25. Sales and profit by customer segment
SELECT
    "Customer Segment",
    COUNT(*) AS total_orders,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "Customer Segment"
ORDER BY total_sales DESC;

-- 26. Average sales by customer segment
SELECT
    "Customer Segment",
    ROUND(AVG("Sales"), 2) AS average_order_sales
FROM sales_data
GROUP BY "Customer Segment"
ORDER BY average_order_sales DESC;

-- 27. Sales by sales channel
SELECT
    "Sales Channel",
    COUNT(*) AS total_orders,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "Sales Channel"
ORDER BY total_sales DESC;


SELECT
    "Payment Method",
    COUNT(*) AS total_orders,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY "Payment Method"
ORDER BY total_sales DESC;

SELECT
    DATE_TRUNC('month', "Order Date")::DATE AS month,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY month
ORDER BY month;

-- 30. Yearly sales and profit
SELECT
    EXTRACT(YEAR FROM "Order Date") AS year,
    ROUND(SUM("Sales"), 2) AS total_sales,
    ROUND(SUM("Profit"), 2) AS total_profit
FROM sales_data
GROUP BY year
ORDER BY year;

-- 31. Monthly sales growth using LAG
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', "Order Date")::DATE AS month,
        SUM("Sales") AS total_sales
    FROM sales_data
    GROUP BY month
)
SELECT
    month,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(LAG(total_sales) OVER (ORDER BY month), 2) AS previous_month_sales,
    ROUND(
        (total_sales - LAG(total_sales) OVER (ORDER BY month))
        / NULLIF(LAG(total_sales) OVER (ORDER BY month), 0) * 100,
        2
    ) AS growth_pct
FROM monthly_sales
ORDER BY month;

-- ============================================================
-- CASE WHEN PRACTICE
-- ============================================================

-- 32. Classify orders by profit
SELECT
    "Order ID",
    "Sales",
    "Profit",
    CASE
        WHEN "Profit" < 0 THEN 'Loss'
        WHEN "Profit" = 0 THEN 'No Profit'
        WHEN "Profit" < 1000 THEN 'Low Profit'
        WHEN "Profit" < 5000 THEN 'Medium Profit'
        ELSE 'High Profit'
    END AS profit_category
FROM sales_data
ORDER BY "Profit" DESC;

-- 33. Count orders by profit category
WITH profit_categories AS (
    SELECT
        CASE
            WHEN "Profit" < 0 THEN 'Loss'
            WHEN "Profit" = 0 THEN 'No Profit'
            WHEN "Profit" < 1000 THEN 'Low Profit'
            WHEN "Profit" < 5000 THEN 'Medium Profit'
            ELSE 'High Profit'
        END AS profit_category
    FROM sales_data
)
SELECT
    profit_category,
    COUNT(*) AS order_count
FROM profit_categories
GROUP BY profit_category
ORDER BY order_count DESC;

-- ============================================================
-- SUBQUERY PRACTICE
-- ============================================================

-- 34. Orders with sales above the average order sales
SELECT
    "Order ID",
    "Customer ID",
    "Sales",
    "Profit"
FROM sales_data
WHERE "Sales" > (
    SELECT AVG("Sales")
    FROM sales_data
)
ORDER BY "Sales" DESC;

-- 35. Products with profit above average product profit
WITH product_profit AS (
    SELECT
        "Product",
        SUM("Profit") AS total_profit
    FROM sales_data
    GROUP BY "Product"
)
SELECT
    "Product",
    ROUND(total_profit, 2) AS total_profit
FROM product_profit
WHERE total_profit > (
    SELECT AVG(total_profit)
    FROM product_profit
)
ORDER BY total_profit DESC;

-- ============================================================
-- WINDOW FUNCTION PRACTICE
-- ============================================================

-- 36. Rank products by total sales
WITH product_sales AS (
    SELECT
        "Product",
        SUM("Sales") AS total_sales
    FROM sales_data
    GROUP BY "Product"
)
SELECT
    "Product",
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM product_sales
ORDER BY sales_rank;

-- 37. Rank products within each category
WITH product_category_sales AS (
    SELECT
        "Category",
        "Product",
        SUM("Sales") AS total_sales
    FROM sales_data
    GROUP BY "Category", "Product"
)
SELECT
    "Category",
    "Product",
    ROUND(total_sales, 2) AS total_sales,
    RANK() OVER (
        PARTITION BY "Category"
        ORDER BY total_sales DESC
    ) AS category_rank
FROM product_category_sales
ORDER BY "Category", category_rank;

-- 38. Running monthly sales total
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', "Order Date")::DATE AS month,
        SUM("Sales") AS total_sales
    FROM sales_data
    GROUP BY month
)
SELECT
    month,
    ROUND(total_sales, 2) AS monthly_sales,
    ROUND(
        SUM(total_sales) OVER (ORDER BY month),
        2
    ) AS running_sales
FROM monthly_sales
ORDER BY month;
 ============================================================

-- 39. Find the best-performing region by profit
WITH region_profit AS (
    SELECT
        "Region",
        SUM("Profit") AS total_profit
    FROM sales_data
    GROUP BY "Region"
)
SELECT
    "Region",
    ROUND(total_profit, 2) AS total_profit
FROM region_profit
ORDER BY total_profit DESC
LIMIT 1;

-- 40. Find the best-performing category by profit margin
WITH category_metrics AS (
    SELECT
        "Category",
        SUM("Sales") AS total_sales,
        SUM("Profit") AS total_profit
    FROM sales_data
    GROUP BY "Category"
)
SELECT
    "Category",
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,
    ROUND(total_profit / NULLIF(total_sales, 0) * 100, 2) AS profit_margin_pct
FROM category_metrics
ORDER BY profit_margin_pct DESC
LIMIT 1;