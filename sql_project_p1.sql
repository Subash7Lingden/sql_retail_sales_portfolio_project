-- SQL retail sales analysis project- p1
CREATE DATABASE sql_project_p1;


-- Create table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales 
			(
				transactions_id INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id INT,
				gender VARCHAR(15),
				age INT,
				category VARCHAR(15),
				quantiy INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			);


SELECT * FROM dbo.retail_sales;

-- DATA CLEANING

-- Checking for NULL Values
SELECT * FROM dbo.retail_sales 
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

DELETE FROM dbo.retail_sales
WHERE 
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
category IS NULL
OR 
quantiy IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

-- DATA EXPLORATION
-- How many sales we have
SELECT COUNT(*) AS total_sales FROM dbo.retail_sales;



-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) as total_sales FROM dbo.retail_sales;

-- Unique category 
SELECT DISTINCT category FROM dbo.retail_sales;


-- Data analysis and business key problems and answers
-- My analysis and findings
--Q1. Write a SQL query to retrive the all columns for sales made in '2022s-11-05'
/*Q2. Write a SQL query to retrive the all transactions, where category is 'Clothings'and quantity sold is more than 4
in the month of Nov-2022*/
--Q3. Write a SQL query to calculate the total sales for each category
--Q4. Write a SQL query to find the average of customers who purchased the items from category 'Beauty'
--Q5. Write a SQL query to find all transaction where total sales is > 1000
--Q6. Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category
--Q7. Write a SQL query to find out the average sales for each month. And find out the best selling for each year.
--Q8. Write a SQL query to find top 5 customers based on highest total sales.
--Q9. Write a SQL query to number of unique customers who purchased items from each category
/*--Q10. Write a SQL query to create each shift and number of orders (morning shift <= 12am, aftrnoon shift between 12
and 17 and evening >17*/

----Q1. Write a SQL query to retrive the all columns for sales made in '2022s-11-05'
SELECT * 
FROM dbo.retail_sales
WHERE sale_date = '2022-11-05'


/*Q2. Write a SQL query to retrive the all transactions, where category is 'Clothings'and quantity sold is more than 4
in the month of Nov-2022*/
SELECT 
    *
FROM 
    dbo.retail_sales
WHERE 
    category = 'Clothing'
    AND 
    FORMAT(sale_date, 'yyyy-MM') = '2022-11'
	AND
	quantiy >= 4;


--Q3. Write a SQL query to calculate the total sales for each category
SELECT 
	category,
	SUM(total_sale) AS  Total_sales,
	COUNT(*) AS total_orders
FROM dbo.retail_sales
GROUP BY category;

--Q4. Write a SQL query to find the average age of customers who purchased the items from category 'Beauty'
SELECT
	AVG(age) AS average_age
FROM dbo.retail_sales
WHERE category = 'Beauty'


--Q5. Write a SQL query to find all transaction where total sales is > 1000
SELECT *
FROM dbo.retail_sales
WHERE total_sale > 1000

-- Q6. Write a SQL query to find the total number of transactions(transactions_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(*) AS total_transactions
FROM dbo.retail_sales
GROUP BY category, gender
ORDER BY category

--Q7. Write a SQL query to find out the average sales for each month. And find out the best selling in each year.
SELECT 
	year,
	month,
	avg_sales
FROM
(
	SELECT 
		YEAR(sale_date) AS year,
		MONTH(sale_date) AS month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale )DESC) AS rank
	FROM dbo.retail_sales
	GROUP BY 
		YEAR(sale_date),
		MONTH(sale_date)
)AS t1
WHERE RANK = 1
	--ORDER BY YEAR(sale_date),AVG(total_sale) DESC;

	
--Q8. Write a SQL query to find top 5 customers based on highest total sales.
SELECT TOP 5
	customer_id,
	SUM(total_sale) AS total_sales
FROM dbo.retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC;

--Q9. Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customers
FROM dbo.retail_sales
GROUP BY category;

/*--Q10. Write a SQL query to create each shift and number of orders (morning shift <= 12am, aftrnoon shift between 12
and 17 and evening shift>17*/
WITH hourly_sales AS
(
	SELECT *,
		CASE 
			WHEN CAST(sale_time AS TIME) <= '12:00:00' THEN 'morning shift'
			WHEN CAST(sale_time AS TIME) BETWEEN '12:00:01' AND '17:00:00' THEN 'afternoon shift'
			ELSE 'evening shift'
		END AS shifts
	FROM dbo.retail_sales
)
SELECT 
	shifts,
	COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shifts;

-- END OF PROJECT
