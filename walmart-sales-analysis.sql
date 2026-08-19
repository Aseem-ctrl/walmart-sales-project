CREATE DATABASE walmart_db;
USE walmart_db;

SHOW TABLES;

#DROP TABLE walmartsales_db;

SELECT * FROM walmartsales_db;

SELECT COUNT(*) FROM walmartsales_db;

SELECT DISTINCT payment_method FROM walmartsales_db;

SELECT payment_method, 
COUNT(*)
FROM walmartsales_db
GROUP BY payment_method;

SELECT COUNT(DISTINCT branch) FROM walmartsales_db;

SELECT MAX(quantity) FROM walmartsales_db;


#finding different payment methods and number of transactions , no.of quantity sold and total sales for each payment method
SELECT payment_method,
COUNT(*) AS no_of_transactions,
SUM(quantity) AS no_of_quantity_sold,
SUM(total) AS total_sales
FROM walmartsales_db
GROUP BY payment_method
ORDER BY total_sales DESC;  



#identifying the highest-rated category in each branch, displaying the branch, category
#AVG rating
SELECT * FROM
(   SELECT branch, category, AVG(rating) AS avg_rating,
    RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_number
    FROM walmartsales_db
    GROUP BY branch, category
) AS ranked_categories
WHERE rank_number = 1;
#ORDER BY branch, avg_rating DESC;



#Identifying the busiest day for each branch based on the number of transactions.
SELECT * FROM
(
    SELECT branch, DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name, 
    COUNT(*) AS transaction_count,
    RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_number
    FROM walmartsales_db
    GROUP BY branch, DAYNAME(STR_TO_DATE(date, '%d/%m/%y'))
    #ORDER BY branch, transaction_count DESC
) AS ranked_categories
WHERE rank_number = 1;



#Total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT payment_method,
SUM(quantity) AS no_of_quantity_sold
FROM walmartsales_db
GROUP BY payment_method



#determining the average,minimum and maximum rating of category for each city.
#list city, average rating, minimum rating and maximum rating.
SELECT city, category,
AVG(rating) AS average_rating,
MIN(rating) AS minimum_rating,
MAX(rating) AS maximum_rating
FROM walmartsales_db
GROUP BY city, category



#calculating the total profit for each category by considering total_profit as (unit_price * quantity * profit_margin).
#List category and total_profit, ordered from highest to lowest profit
SELECT category, 
SUM(total) AS total_profit,
SUM(total * profit_margin) AS total_profit
FROM walmartsales_db
GROUP BY category
ORDER BY total_profit DESC;



#Determining the most common payment method for each branch. Display branch and the preferred payment method.
with cte as (
    SELECT branch, payment_method,
COUNT(*) AS total_transactions,
RANK() OVER (PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_number
FROM walmartsales_db
GROUP BY branch, payment_method
)
SELECT *
FROM cte    
WHERE rank_number = 1




#categorize sales into 3 group MORNING ,AFTERNOON and EVENING 
#Find out each of the shift and number of invoices or transactions.
SELECT
branch,
    CASE 
        WHEN EXTRACT(HOUR FROM CAST(time AS TIME)) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM CAST(time AS TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END day_time,
    COUNT(*)  
FROM walmartsales_db
GROUP BY branch, day_time
ORDER BY branch, COUNT(*) DESC;



#Identifying 5 branch with highest decrease ratio in revenue compare to last year(current year 2023 and last year 2022)
select * from walmartsales_db


WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmartsales_db
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue
    FROM walmartsales_db
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;
