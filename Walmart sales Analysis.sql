CREATE DATABASE IF NOT EXISTS walmart;
USE walmart;
DROP TABLE IF EXISTS w_sales;

CREATE TABLE W_sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT(20) NOT NULL,
vat FLOAT(6,4) NOT NULL,
total DECIMAL(12, 4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
gross_margin_pct FLOAT(11,9),
gross_income DECIMAL(12, 4),
rating FLOAT(2, 1)
);

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 
'/Users/koresdominic/Downloads/Walmart Sales Data.csv.csv'
INTO TABLE W_sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT*
FROM W_sales;

-- 1. Time of the day
SELECT time,
	(CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
END) AS time_of_day
FROM W_sales;

ALTER table W_sales ADD COLUMN time_of_day varchar(20);

UPDATE W_sales
SET time_of_day =(
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);

-- 2.Day_name

SELECT date,
DAYNAME(date) AS day_name
FROM W_sales;

ALTER TABLE W_sales ADD COLUMN day_name VARCHAR(10);

UPDATE W_sales
SET day_name = DAYNAME(date);

-- 3.Month_name

SELECT date,
MONTHNAME(date) AS month_name
FROM W_sales;

ALTER TABLE W_sales ADD COLUMN month_name VARCHAR(10);

UPDATE W_sales
SET month_name = MONTHNAME(date);



--------- Exploratory Data Analysis (EDA) ---------
SELECT*
FROM W_sales;


--- Product Analysis ---

-- 1.How many distinct product lines are there in the dataset?
SELECT COUNT(DISTINCT product_line) 
FROM W_sales;



-- 2.What is the most common payment method?
SELECT payment,count(payment) as common_payment_method
FROM W_sales
GROUP BY payment
ORDER BY common_payment_method DESC
LIMIT 1;


-- 3.What is the most selling product line?
SELECT product_line,count(product_line) as Most_selling_product
FROM W_sales
GROUP BY product_line
ORDER BY Most_selling_product DESC
LIMIT 1;


-- 4.What is the total revenue by month?
SELECT Month_name,sum(total) as Total_revenue
FROM W_sales
GROUP BY Month_name
ORDER BY Total_revenue DESC;




-- 5.Which month recorded the highest Cost of Goods Sold (COGS)?
SELECT Month_name, sum(cogs) as Highest_cogs
FROM W_sales
GROUP BY Month_name
ORDER BY Highest_cogs desc
LIMIT 1;

-- 6.Which product line generated the highest revenue?
SELECT product_line,sum(total) as highest_total_revenue
FROM W_sales
GROUP BY product_line
ORDER BY highest_total_revenue desc
LIMIT 1;


-- 7.Which city has the highest revenue?
SELECT city, sum(total) as Highest_revenue
FROM W_sales
GROUP BY city
ORDER BY Highest_revenue desc
LIMIT 1;


-- 8.What is the most common product line by gender?

SELECT gender,product_line,COUNT(gender) as total_count
FROM W_sales
GROUP BY gender,product_line
ORDER BY total_count DESC
LIMIT 1;


--- Sales Analysis
-- 1.Number of sales made in each time of the day per weekday
-- a)
SELECT day_name,time_of_day,COUNT(invoice_id) AS total_sales
FROM W_sales
GROUP BY day_name,time_of_day
HAVING day_name NOT IN ('Sunday','Saturday')
ORDER BY total_sales DESC;
-- b)
SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM W_sales
WHERE day_name NOT IN ('Saturday','Sunday') 
GROUP BY day_name, time_of_day
ORDER BY total_sales DESC;

-- 2.Identify the customer type that generates the highest revenue.
SELECT *
FROM W_sales;

SELECT customer_type, SUM(total) as Total_revenue
FROM W_sales
GROUP BY customer_type
ORDER BY Total_revenue DESC;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city,SUM(VAT) AS Value_added_tax
FROM W_sales
GROUP BY city
ORDER BY Value_added_tax DESC
LIMIT 1;



-- 4.Which customer type pays the most in VAT?
SELECT customer_type,SUM(VAT) AS most_vat
FROM W_sales
GROUP BY customer_type
ORDER BY most_vat desc
LIMIT 1;


--- Customer Analysis ---

-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) as unique_customer
FROM W_sales;




-- 2.Which is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS common_customer
FROM W_sales
GROUP BY customer_type 
ORDER BY common_customer DESC 
LIMIT 1;


-- 4.Which customer type buys the most?
SELECT customer_type, sum(total) as total_sales
FROM W_sales
GROUP BY customer_type
ORDER BY total_sales DESC;

-- 5.What gender has the most customers?

SELECT gender,count(*) as all_genders
FROM W_sales
GROUP BY gender
ORDER BY all_genders DESC;

-- 6.What is the gender distribution per branch?
SELECT *
FROM W_sales;

SELECT branch,gender,count(gender) as distribution
FROM W_sales
GROUP BY branch,gender
ORDER BY branch desc;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day,count(rating) as most_ratings
FROM W_sales
GROUP BY time_of_day
ORDER BY most_ratings desc;

-- 8.Which day of the week has the best avg ratings?

SELECT day_name,ROUND(AVG(rating),2) as best_avg_rating
FROM W_sales
GROUP BY day_name
ORDER BY best_avg_rating DESC
LIMIT 1;

-- 9.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, ROUND(AVG(rating),2) AS average_rating
FROM W_sales 
GROUP BY branch, time_of_day
 ORDER BY average_rating DESC
 LIMIT 1;


























