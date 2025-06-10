-- Performance Analysis --> Analyze the yearly performance of products by comparing each product's sales to both its average sales performance of the product and the previous year sales.
--SELECT * FROM gold.dim_products;
--SELECT * FROM gold.fact_sales;
WITH year_product_sales AS (
  SELECT 
    YEAR(s.order_date) AS order_year, 
    p.product_name, 
    SUM(s.sales_amount) AS current_sales 
  FROM 
    gold.fact_sales s 
    LEFT JOIN gold.dim_products p ON s.product_key = p.product_key 
  where 
    order_date IS NOT NULL 
  GROUP BY 
    YEAR(s.order_date), 
    p.product_name
) 
SELECT 
  order_year, 
  product_name, 
  current_sales, 
  AVG(current_sales) OVER(PARTITION BY product_name) avg_sales, 
  current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg, 
  CASE WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above avg' WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below avg' ELSE 'avg' END 'avg_change', 
  -- Now for comparing to the previous year sales
  LAG(current_sales) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) AS prev_year_sales, 
  current_sales - LAG(current_sales) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) AS diff_prev_year, 
  CASE WHEN current_sales - LAG(current_sales) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) > 0 THEN 'Increase' WHEN current_sales - LAG(current_sales) OVER(
    PARTITION BY product_name 
    ORDER BY 
      order_year
  ) < 0 THEN 'Decrease' ELSE 'same as py' END 'previous_year_change' 
FROM 
  year_product_sales 
ORDER BY 
  product_name, 
  order_year;
