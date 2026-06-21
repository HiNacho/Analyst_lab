-- ==========================================
-- ANALYSTLAB AFRICA - WEEK 3: SQL & DATA QUERYING
-- DATASET: CHINOOK DATABASE (MUSIC STORE DATA)
-- DELIVERABLE: SQL SCRIPT
-- AUTHOR: Batch B Intern
-- ==========================================

USE `Chinook`;

-- ------------------------------------------
-- 1. CORE SQL QUERIES (Filtering & Sorting)
-- ------------------------------------------

-- Query 1: Customer list filtered by country and sorted.
-- Objective: Retrieve customers from USA, Canada, and Brazil, sorted by Country (ascending) and LastName (descending).
SELECT 
    CustomerId, 
    FirstName, 
    LastName, 
    Country, 
    Email
FROM Customer
WHERE Country IN ('USA', 'Canada', 'Brazil')
ORDER BY Country ASC, LastName DESC;


-- Query 2: Aggregation & Grouping with HAVING clause.
-- Objective: Retrieve the number of invoices, total revenue, and average invoice amount for each billing city that has 7 or more invoices, sorted by total revenue descending.
SELECT 
    BillingCity, 
    BillingCountry,
    COUNT(InvoiceId) AS InvoiceCount,
    SUM(Total) AS TotalRevenue,
    ROUND(AVG(Total), 2) AS AverageInvoiceAmount
FROM Invoice
GROUP BY BillingCity, BillingCountry
HAVING COUNT(InvoiceId) >= 7
ORDER BY TotalRevenue DESC;


-- ------------------------------------------
-- 2. ADVANCED SQL CONCEPTS (Joins, Subqueries & Window Functions)
-- ------------------------------------------

-- Query 3: Multi-Table Joins (INNER & LEFT JOIN)
-- Objective: Find the top 10 best-selling tracks. Include Track Name, Album Title, Artist Name, Genre Name, and the total quantity sold.
SELECT 
    t.TrackId, 
    t.Name AS TrackName, 
    al.Title AS AlbumTitle, 
    ar.Name AS ArtistName, 
    g.Name AS GenreName,
    COALESCE(SUM(il.Quantity), 0) AS TotalQuantitySold
FROM Track t
INNER JOIN Album al ON t.AlbumId = al.AlbumId
INNER JOIN Artist ar ON al.ArtistId = ar.ArtistId
INNER JOIN Genre g ON t.GenreId = g.GenreId
LEFT JOIN InvoiceLine il ON t.TrackId = il.TrackId
GROUP BY t.TrackId, t.Name, al.Title, ar.Name, g.Name
ORDER BY TotalQuantitySold DESC, TrackName ASC
LIMIT 10;


-- Query 4: Subquery in HAVING clause.
-- Objective: Identify high-value customers who spent more than the average customer lifetime spending.
SELECT 
    c.CustomerId, 
    c.FirstName, 
    c.LastName, 
    c.Email, 
    SUM(i.Total) AS TotalSpent
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Email
HAVING TotalSpent > (
    SELECT AVG(CustomerTotal.TotalSpent)
    FROM (
        SELECT SUM(Total) AS TotalSpent
        FROM Invoice
        GROUP BY CustomerId
    ) AS CustomerTotal
)
ORDER BY TotalSpent DESC;


-- Query 5: Window Functions (DENSE_RANK)
-- Objective: Rank tracks by length (milliseconds) within each genre and filter for the top 3 longest tracks per genre.
WITH TrackRanking AS (
    SELECT 
        t.Name AS TrackName, 
        g.Name AS GenreName, 
        t.Milliseconds,
        DENSE_RANK() OVER (PARTITION BY t.GenreId ORDER BY t.Milliseconds DESC) AS LengthRank
    FROM Track t
    INNER JOIN Genre g ON t.GenreId = g.GenreId
)
SELECT 
    GenreName, 
    TrackName, 
    Milliseconds, 
    LengthRank
FROM TrackRanking
WHERE LengthRank <= 3
ORDER BY GenreName ASC, LengthRank ASC;


-- ------------------------------------------
-- 3. BUSINESS PROBLEM SOLVING
-- ------------------------------------------

-- Query 6: Top Performing Customers
-- Objective: Retrieve top 5 customers with the highest cumulative spending.
SELECT 
    c.CustomerId, 
    c.FirstName, 
    c.LastName, 
    c.Country,
    SUM(i.Total) AS TotalSpent,
    COUNT(i.InvoiceId) AS NumberOfInvoices
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName, c.Country
ORDER BY TotalSpent DESC
LIMIT 5;


-- Query 7: Revenue Trends Over Time
-- Objective: Calculate monthly revenue to observe seasonal trends.
SELECT 
    DATE_FORMAT(InvoiceDate, '%Y-%m') AS SalesMonth,
    SUM(Total) AS MonthlyRevenue,
    COUNT(InvoiceId) AS InvoicesCount
FROM Invoice
GROUP BY DATE_FORMAT(InvoiceDate, '%Y-%m')
ORDER BY SalesMonth ASC;


-- Query 8: Customer Purchasing Behavior
-- Objective: Examine purchasing characteristics (total tracks, total spent, avg price, unique genres) for top 10 customers.
SELECT 
    c.CustomerId, 
    c.FirstName, 
    c.LastName,
    COUNT(il.InvoiceLineId) AS TotalTracksPurchased,
    SUM(il.UnitPrice * il.Quantity) AS TotalTrackSpent,
    ROUND(AVG(il.UnitPrice), 2) AS AveragePricePerTrack,
    COUNT(DISTINCT t.GenreId) AS UniqueGenresPurchased
FROM Customer c
INNER JOIN Invoice i ON c.CustomerId = i.CustomerId
INNER JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
INNER JOIN Track t ON il.TrackId = t.TrackId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY TotalTracksPurchased DESC
LIMIT 10;
