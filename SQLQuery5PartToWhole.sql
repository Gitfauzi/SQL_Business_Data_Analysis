--Part to whole Analysis

use DataWarehouseAnalytics;

--SELECT * FROM gold.fact_sales;
--SELECT * FROM gold.dim_products;

WITH category_sales AS(
  SELECT 
    p.category, 
    SUM(s.sales_amount) AS sales_per_category 
  FROM 
    gold.fact_sales s 
    LEFT JOIN gold.dim_products p ON s.product_key = p.product_key 
  GROUP BY 
    p.category
) 
SELECT 
  category, 
  sales_per_category, 
  SUM(sales_per_category) OVER() total_sales, 
  CONCAT(
    ROUND(
      (CAST(sales_per_category AS FLOAT) * 100 / SUM(sales_per_category) OVER())
    ,2 ), 
  '%') AS percentage_sales 
FROM 
  category_sales 
ORDER BY 
  percentage_sales DESC;
