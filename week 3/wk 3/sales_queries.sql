-- ==========================================
-- ANALYSTLAB AFRICA - WEEK 3: SQL & DATA QUERYING
-- DATASET: SALES DATASET (ADVENTUREWORKS LITE / EQUIVALENT)
-- DELIVERABLE: SQL SCRIPT
-- AUTHOR: Batch B Intern
-- ==========================================

USE `sales_db`;

-- ------------------------------------------
-- 1. CORE SQL QUERIES (Filtering & Sorting)
-- ------------------------------------------

-- Query 1: Filter high-value orders and sort.
-- Objective: Find classic cars orders in 2003 or 2004 where the sales amount is greater than $5,000, sorted by Sales in descending order.
SELECT 
    ORDERNUMBER, 
    PRODUCTCODE, 
    PRODUCTLINE, 
    QUANTITYORDERED, 
    PRICEEACH, 
    SALES, 
    ORDERDATE
FROM sales_data
WHERE PRODUCTLINE = 'Classic Cars' 
  AND YEAR_ID IN (2003, 2004) 
  AND SALES > 5000
ORDER BY SALES DESC;


-- Query 2: Aggregation & Grouping with aggregate functions.
-- Objective: Calculate total revenue, total quantity sold, average price each, and total number of transactions for each product line.
SELECT 
    PRODUCTLINE,
    COUNT(DISTINCT ORDERNUMBER) AS UniqueOrdersCount,
    COUNT(*) AS TotalTransactions,
    SUM(QUANTITYORDERED) AS TotalQuantitySold,
    ROUND(AVG(PRICEEACH), 2) AS AverageUnitPrice,
    ROUND(SUM(SALES), 2) AS TotalRevenue
FROM sales_data
GROUP BY PRODUCTLINE
ORDER BY TotalRevenue DESC;


-- ------------------------------------------
-- 2. ADVANCED SQL CONCEPTS (Joins, Subqueries & Window Functions)
-- ------------------------------------------

-- Query 3: Window Functions (DENSE_RANK)
-- Objective: Rank the top-selling products (by total revenue) within each Product Line and show the top 3 products per product line.
WITH ProductSalesRanking AS (
    SELECT 
        PRODUCTLINE, 
        PRODUCTCODE,
        SUM(SALES) AS TotalSales,
        DENSE_RANK() OVER (PARTITION BY PRODUCTLINE ORDER BY SUM(SALES) DESC) AS SalesRank
    FROM sales_data
    GROUP BY PRODUCTLINE, PRODUCTCODE
)
SELECT 
    PRODUCTLINE, 
    PRODUCTCODE, 
    ROUND(TotalSales, 2) AS TotalSales, 
    SalesRank
FROM ProductSalesRanking
WHERE SalesRank <= 3
ORDER BY PRODUCTLINE ASC, SalesRank ASC;


-- Query 4: Subqueries in HAVING clause.
-- Objective: Find all customers whose average order sales amount exceeds the overall average order sales amount of all orders.
SELECT 
    CUSTOMERNAME, 
    COUNTRY,
    ROUND(AVG(OrderSales.TotalOrderSales), 2) AS CustomerAvgOrderValue,
    COUNT(DISTINCT OrderSales.ORDERNUMBER) AS TotalOrdersPlaced
FROM (
    SELECT 
        ORDERNUMBER, 
        CUSTOMERNAME, 
        COUNTRY, 
        SUM(SALES) AS TotalOrderSales
    FROM sales_data
    GROUP BY ORDERNUMBER, CUSTOMERNAME, COUNTRY
) AS OrderSales
GROUP BY CUSTOMERNAME, COUNTRY
HAVING CustomerAvgOrderValue > (
    SELECT AVG(AllOrders.TotalOrderSales)
    FROM (
        SELECT 
            ORDERNUMBER, 
            SUM(SALES) AS TotalOrderSales
        FROM sales_data
        GROUP BY ORDERNUMBER
    ) AS AllOrders
)
ORDER BY CustomerAvgOrderValue DESC;


-- ------------------------------------------
-- 3. BUSINESS PROBLEM SOLVING
-- ------------------------------------------

-- Query 5: Top Performing Customers
-- Objective: Identify the top 10 customers by total revenue contribution.
SELECT 
    CUSTOMERNAME, 
    COUNTRY,
    CONCAT(CONTACTFIRSTNAME, ' ', CONTACTLASTNAME) AS ContactName,
    ROUND(SUM(SALES), 2) AS TotalSpent
FROM sales_data
GROUP BY CUSTOMERNAME, COUNTRY, CONTACTFIRSTNAME, CONTACTLASTNAME
ORDER BY TotalSpent DESC
LIMIT 10;


-- Query 6: Revenue Trends Over Time (Quarterly Cumulative Sales)
-- Objective: Retrieve quarterly and yearly revenue trends, showing Year, Quarter, Total Sales, Cumulative Revenue, and total orders.
SELECT 
    YEAR_ID, 
    QTR_ID,
    ROUND(SUM(SALES), 2) AS QuarterlyRevenue,
    ROUND(SUM(SUM(SALES)) OVER (ORDER BY YEAR_ID, QTR_ID), 2) AS CumulativeRevenue,
    COUNT(DISTINCT ORDERNUMBER) AS TotalOrders
FROM sales_data
GROUP BY YEAR_ID, QTR_ID
ORDER BY YEAR_ID, QTR_ID;


-- Query 7: Deal Size Analysis
-- Objective: Analyze how transaction count, quantity, and total sales are distributed across small, medium, and large deal sizes.
SELECT 
    DEALSIZE,
    COUNT(*) AS TransactionCount,
    SUM(QUANTITYORDERED) AS TotalQuantitySold,
    ROUND(SUM(SALES), 2) AS TotalSales,
    ROUND(AVG(SALES), 2) AS AverageSalesPerTransaction,
    ROUND(AVG(QUANTITYORDERED), 1) AS AverageQuantityPerTransaction
FROM sales_data
GROUP BY DEALSIZE
ORDER BY TotalSales DESC;
