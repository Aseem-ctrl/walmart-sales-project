-- Walmart Sales Database Queries
-- This file contains SQL queries for analyzing Walmart sales data

-- Create Database
CREATE DATABASE IF NOT EXISTS walmart_db;
USE walmart_db;

-- Create table structure for walmartsales_db
CREATE TABLE IF NOT EXISTS walmartsales_db (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Invoice_ID VARCHAR(255),
    Branch VARCHAR(50),
    City VARCHAR(100),
    Customer_type VARCHAR(50),
    Gender VARCHAR(10),
    Product_line VARCHAR(100),
    Unit_price DECIMAL(10, 2),
    Quantity INT,
    Date DATE,
    Time TIME,
    Total DECIMAL(10, 2),
    Payment VARCHAR(50),
    COGS DECIMAL(10, 2),
    gross_margin_percentage DECIMAL(5, 2),
    gross_income DECIMAL(10, 2),
    Rating DECIMAL(3, 1)
);

-- Query 1: Total Sales by Branch
SELECT 
    Branch,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Total) AS Average_Sale,
    SUM(Quantity) AS Total_Items_Sold
FROM walmartsales_db
GROUP BY Branch
ORDER BY Total_Sales DESC;

-- Query 2: Sales by Product Line
SELECT 
    Product_line,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Rating) AS Average_Rating,
    SUM(Quantity) AS Total_Items_Sold
FROM walmartsales_db
GROUP BY Product_line
ORDER BY Total_Sales DESC;

-- Query 3: Sales by Gender and Customer Type
SELECT 
    Gender,
    Customer_type,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Total) AS Average_Sale
FROM walmartsales_db
GROUP BY Gender, Customer_type
ORDER BY Total_Sales DESC;

-- Query 4: Sales by Payment Method
SELECT 
    Payment,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Total) AS Average_Sale
FROM walmartsales_db
GROUP BY Payment
ORDER BY Total_Sales DESC;

-- Query 5: Monthly Sales Trend
SELECT 
    MONTH(Date) AS Month,
    YEAR(Date) AS Year,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Rating) AS Average_Rating
FROM walmartsales_db
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY YEAR(Date), MONTH(Date);

-- Query 6: Top 10 Cities by Sales
SELECT 
    City,
    COUNT(*) AS Number_of_Transactions,
    SUM(Total) AS Total_Sales,
    AVG(Total) AS Average_Sale
FROM walmartsales_db
GROUP BY City
ORDER BY Total_Sales DESC
LIMIT 10;

-- Query 7: Customer Rating Analysis
SELECT 
    Product_line,
    AVG(Rating) AS Average_Rating,
    MIN(Rating) AS Min_Rating,
    MAX(Rating) AS Max_Rating,
    COUNT(*) AS Total_Reviews
FROM walmartsales_db
GROUP BY Product_line
ORDER BY Average_Rating DESC;

-- Query 8: Best Selling Product Lines by Branch
SELECT 
    Branch,
    Product_line,
    SUM(Quantity) AS Total_Quantity_Sold,
    SUM(Total) AS Total_Sales
FROM walmartsales_db
GROUP BY Branch, Product_line
ORDER BY Branch, Total_Sales DESC;

-- Query 9: Customer Segmentation
SELECT 
    Customer_type,
    COUNT(DISTINCT Invoice_ID) AS Total_Customers,
    COUNT(*) AS Total_Transactions,
    SUM(Total) AS Total_Spent,
    AVG(Total) AS Average_Spend,
    AVG(Rating) AS Average_Rating
FROM walmartsales_db
GROUP BY Customer_type;

-- Query 10: Inventory Analysis (COGS)
SELECT 
    Product_line,
    Branch,
    SUM(COGS) AS Total_COGS,
    SUM(Total) AS Total_Revenue,
    SUM(Total) - SUM(COGS) AS Total_Profit,
    ROUND((SUM(Total) - SUM(COGS)) / SUM(Total) * 100, 2) AS Profit_Margin_Percentage
FROM walmartsales_db
GROUP BY Product_line, Branch
ORDER BY Total_Profit DESC;
