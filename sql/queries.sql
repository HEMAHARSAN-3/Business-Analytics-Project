-- STEP 1: Create Orders Table
CREATE TABLE orders AS
SELECT 
    "Row ID",
    "Order ID",
    "Order Date",
    "Ship Date",
    "Ship Mode",
    "Customer ID",
    "Product ID",
    Sales,
    Quantity,
    Discount,
    Profit
FROM superstore;


SELECT * FROM orders LIMIT 5;


-- STEP 2: Create Customers Table
CREATE TABLE customers AS
SELECT DISTINCT
    "Customer ID",
    "Customer Name",
    Segment
FROM superstore;

SELECT * FROM customers LIMIT 5;


-- STEP 3: Create Products Table
CREATE TABLE products AS
SELECT DISTINCT
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category"
FROM superstore;

SELECT * FROM products LIMIT 5;


-- STEP 4: Create Regions Table
CREATE TABLE regions AS
SELECT DISTINCT
    Country,
    City,
    State,
    "Postal Code",
    Region
FROM superstore;

SELECT * FROM regions LIMIT 5;


-- JOIN QUERY
SELECT 
    o."Order ID",
    c."Customer Name",
    p."Product Name",
    o.Sales
FROM orders o
JOIN customers c ON o."Customer ID" = c."Customer ID"
JOIN products p ON o."Product ID" = p."Product ID"
LIMIT 5;



-- JOIN QUERY
SELECT 
    o."Order ID",
    c."Customer Name",
    p."Product Name",
    o.Sales
FROM orders o
JOIN customers c ON o."Customer ID" = c."Customer ID"
JOIN products p ON o."Product ID" = p."Product ID"
LIMIT 5;


-- 1. KPI 1 — Total Revenue
SELECT 
    ROUND(SUM(Sales), 2) AS Total_Revenue
FROM orders;


-- 2. KPI — Total Orders
SELECT 
    COUNT(DISTINCT "Order ID") AS Total_Orders
FROM orders;


-- 3. KPI — Total Profit
SELECT 
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM orders;



-- 4. Sales by Category
SELECT 
    p.Category,
    ROUND(SUM(o.Sales), 2) AS Total_Sales
FROM orders o
JOIN products p 
ON o."Product ID" = p."Product ID"
GROUP BY p.Category
ORDER BY Total_Sales DESC;



-- 5. Sales by Region
SELECT 
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;


-- 6. Monthly Sales Trend
SELECT 
    strftime('%Y-%m', "Order Date") AS Month,
    ROUND(SUM(Sales), 2) AS Monthly_Sales
FROM orders
GROUP BY Month
ORDER BY Month;


-- 7. Top 10 Products
SELECT 
    p."Product Name",
    ROUND(SUM(o.Sales), 2) AS Total_Sales
FROM orders o
JOIN products p 
ON o."Product ID" = p."Product ID"
GROUP BY p."Product Name"
ORDER BY Total_Sales DESC
LIMIT 10;



-- 8. Low-Performing Products
SELECT 
    p."Product Name",
    ROUND(SUM(o.Sales), 2) AS Total_Sales
FROM orders o
JOIN products p 
ON o."Product ID" = p."Product ID"
GROUP BY p."Product Name"
ORDER BY Total_Sales ASC
LIMIT 10;


-- 9. Advanced KPI — Growth %
WITH monthly_sales AS (
    SELECT 
        strftime('%Y-%m', "Order Date") AS Month,
        SUM(Sales) AS Sales
    FROM orders
    GROUP BY Month
)
SELECT 
    Month,
    Sales,
    LAG(Sales) OVER (ORDER BY Month) AS Previous_Month,
    ROUND(
        ((Sales - LAG(Sales) OVER (ORDER BY Month)) * 100.0) 
        / LAG(Sales) OVER (ORDER BY Month), 2
    ) AS Growth_Percentage
FROM monthly_sales;


