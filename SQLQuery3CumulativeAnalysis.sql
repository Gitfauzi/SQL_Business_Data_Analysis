--SELECT * from gold.fact_sales;

-- find the running total of sales over time (after calculating total sales per month) --

--SELECT 
--order_date,
--total_sales,
--SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales --using partition by here means for each order_date reset the cumulative sum
--FROM
--(
--SELECT 
--DATETRUNC(month, order_date) AS order_date,
--SUM(sales_amount) AS total_sales
--FROM gold.fact_sales
--WHERE order_date IS NOT NULL
--GROUP BY DATETRUNC(month, order_date)
--) t

-- similarly we can find the Average price overtime --

--SELECT 
--order_date,
--AVG(avg_price) OVER(PARTITION BY order_date ORDER BY order_date) AS Moving_avg_price
--FROM 
--(
--SELECT 
--DATETRUNC(month, order_date) AS order_date,
--AVG(price) AS avg_price
--FROM gold.fact_sales
--WHERE order_date IS NOT NULL
--GROUP BY DATETRUNC(month, order_date)
--ORDER BY DATETRUNC(month, order_date)
--) t

-- Finding both running total sales and moving average over time --

SELECT
order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date) AS Running_total_sales,
AVG(avg_price) OVER(PARTITION BY order_date ORDER BY order_date) AS Running_Average_price -- used partition by
FROM (
SELECT 
DATETRUNC(month, order_date) AS order_date,
SUM(sales_amount) AS total_sales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
-- ORDER BY DATETRUNC(month, order_date) -- comment this out coz it is already done by ORDER BY in OVER()
) t