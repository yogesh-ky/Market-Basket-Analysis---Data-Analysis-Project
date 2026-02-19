-- Check total records
SELECT COUNT(*) as total_records FROM transactions_clean;

-- Check date range
SELECT 
    MIN(InvoiceDate) as start_date,
    MAX(InvoiceDate) as end_date
FROM transactions_clean;

-- Check unique values
SELECT 
    COUNT(*) as total_records,
    COUNT(DISTINCT InvoiceNo) as unique_invoices,
    COUNT(DISTINCT StockCode) as unique_products,
    COUNT(DISTINCT CustomerID) as unique_customers,
    COUNT(DISTINCT Country) as unique_countries
FROM transactions_clean; 

-- Check for nulls
SELECT 
    MIN(UnitPrice) as min_price,
    MAX(UnitPrice) as max_price,
    AVG(UnitPrice) as avg_price
FROM transactions_clean; 

--linetotal created by me (quantity * price)
-- Total revenue
SELECT SUM(LineTotal) as total_revenue
FROM transactions_clean;

-- Top 10 products by revenue
SELECT Top 10
    StockCode,
    Description,
    SUM(Quantity) as total_quantity,
    ROUND(SUM(LineTotal), 2) as total_revenue
FROM transactions_clean
GROUP BY StockCode, Description
ORDER BY total_revenue DESC 

-- Top 10 products by frequency (how often purchased)
SELECT Top 10
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) as order_count
FROM transactions_clean
GROUP BY StockCode, Description
ORDER BY order_count DESC

-- Average basket size (items per order) (number of products per order) stockcode column is productid
-- **62% of orders** contain 10+ items (11,526 out of 18,402 orders)
-- Customers already seeking product combinations
- --Average basket size: 20 items
WITH basket_size AS (
    SELECT 
        InvoiceNo,
        COUNT(DISTINCT StockCode) as items_per_order
    FROM transactions_clean
    GROUP BY InvoiceNo
),
order_totals AS (
    SELECT 
        InvoiceNo,
        SUM(LineTotal) as total_order_value
    FROM transactions_clean
    GROUP BY InvoiceNo
)
SELECT 
    CASE 
        WHEN b.items_per_order = 1 THEN '1 item' 
        WHEN b.items_per_order BETWEEN 2 AND 3 THEN '2-3 items'
        WHEN b.items_per_order BETWEEN 4 AND 5 THEN '4-5 items'
        WHEN b.items_per_order BETWEEN 6 AND 10 THEN '6-10 items'
        WHEN b.items_per_order > 10 THEN '10+ items'
    END as basket_category,
    COUNT(b.InvoiceNo) as order_count,
    ROUND(AVG(o.total_order_value), 2) as avg_order_value
FROM basket_size b
INNER JOIN order_totals o ON b.InvoiceNo = o.InvoiceNo
GROUP BY 
    CASE 
        WHEN b.items_per_order = 1 THEN '1 item' 
        WHEN b.items_per_order BETWEEN 2 AND 3 THEN '2-3 items'
        WHEN b.items_per_order BETWEEN 4 AND 5 THEN '4-5 items'
        WHEN b.items_per_order BETWEEN 6 AND 10 THEN '6-10 items'
        WHEN b.items_per_order > 10 THEN '10+ items'
    END
ORDER BY 
   1 

--Product Pairs 
--You need to identify all unique product pairs that appear in the same invoice.
--The Logic:

--Take all products in Invoice #12345
--If it has products A, B, C → pairs are: (A,B), (A,C), (B,C)
--Do this for ALL invoices

select Top 10 tc1.StockCode as Product1,tc2.StockCode as product2, COUNT(distinct tc1.InvoiceNo) Total_orders from transactions_clean tc1 
join transactions_clean tc2 
on tc1.InvoiceNo = tc2.InvoiceNo 
and tc1.StockCode < tc2.StockCode 
group by tc1.StockCode ,tc2.StockCode 
having COUNT(distinct tc1.InvoiceNo) > 10

--Metrics - SUpport, Confidence, Lift
--The Three Metrics You Need:

--Support(A,B) = Orders with both A and B / Total orders
--Confidence(A→B) = Orders with both A and B / Orders with A
--Lift(A,B) = Support(A,B) / (Support(A) × Support(B)) 


select Top 10 *,ROUND(Total_orders * 1.0 / (SELECT COUNT(DISTINCT InvoiceNo) FROM transactions_clean), 4) as Support  from (
select StockCode,count(distinct InvoiceNo) as Total_orders
from transactions_clean
group by StockCode
) subq
order by Support desc 

--Metrics - SUpport, Confidence, Lift
--The Three Metrics You Need:

--Support(A,B) = Orders with both A and B / Total orders
--Confidence(A→B) = Orders with both A and B / Orders with A
--Lift(A,B) = Support(A,B) / (Support(A) × Support(B)) 

SELECT StockCode
INTO popular_products
FROM transactions_clean
GROUP BY StockCode
HAVING COUNT(DISTINCT InvoiceNo) >= 50;

SELECT tc.*
INTO filtered_transactions
FROM transactions_clean tc
WHERE tc.StockCode IN (SELECT StockCode FROM popular_products);

SELECT 
    tc1.StockCode as Product_A,
    tc2.StockCode as Product_B, 
    COUNT(DISTINCT tc1.InvoiceNo) as pair_count
INTO product_pairs_table
FROM filtered_transactions tc1 
INNER JOIN filtered_transactions tc2 
    ON tc1.InvoiceNo = tc2.InvoiceNo 
    AND tc1.StockCode < tc2.StockCode 
GROUP BY tc1.StockCode, tc2.StockCode 
HAVING COUNT(DISTINCT tc1.InvoiceNo) >= 10; 

SELECT 
    StockCode,
    COUNT(DISTINCT InvoiceNo) as product_orders
INTO product_support_table
FROM filtered_transactions
GROUP BY StockCode; 

DECLARE @total_orders INT = (select count(distinct InvoiceNo) from transactions_clean);

SELECT TOP 100
    pp.Product_A,
    pp.Product_B,
    pp.pair_count,
    ROUND(pp.pair_count * 1.0 / @total_orders, 4) as Support_AB,
    ROUND(pp.pair_count * 1.0 / spa.product_orders, 4) as Confidence,
    ROUND((pp.pair_count * 1.0 / @total_orders) / 
          ((spa.product_orders * 1.0 / @total_orders) * (spb.product_orders * 1.0 / @total_orders)), 2) as Lift
FROM product_pairs_table pp
INNER JOIN product_support_table spa ON pp.Product_A = spa.StockCode
INNER JOIN product_support_table spb ON pp.Product_B = spb.StockCode
ORDER BY Lift DESC;

----------------------------------------------- 
SELECT Top 100
    pp.Product_A,
    tc1.Description as Description_A,
    pp.Product_B,
    tc2.Description as Description_B,
    pp.pair_count as Total_Orders_together,
    ROUND(pp.pair_count * 1.0 / 18402, 4) as Support_AB,
    ROUND(pp.pair_count * 1.0 / spa.product_orders, 4) as Confidence,
    ROUND((pp.pair_count * 1.0 / 18402) / 
          ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)), 2) as Lift
FROM product_pairs_table pp
INNER JOIN product_support_table spa ON pp.Product_A = spa.StockCode
INNER JOIN product_support_table spb ON pp.Product_B = spb.StockCode
INNER JOIN (SELECT DISTINCT StockCode, Description FROM transactions_clean) tc1 
    ON pp.Product_A = tc1.StockCode
INNER JOIN (SELECT DISTINCT StockCode, Description FROM transactions_clean) tc2 
    ON pp.Product_B = tc2.StockCode
WHERE (pp.pair_count * 1.0 / 18402) / 
      ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)) > 1.5
ORDER BY Lift DESC;

---------------------------------------------------------------------- 
--Top 10 Bundle Recommendations 
with cte as(	
	SELECT  Top 100 
		pp.Product_A,
		tc1.Description as Description_A,
		tc1.avg_UnitPrice as Avg_Unit_price_ProductA,
		pp.Product_B,
		tc2.Description as Description_B,
		tc2.avg_UnitPrice as Avg_Unit_price_ProductB,
		pp.pair_count as Total_Orders_together,
		ROUND(pp.pair_count * 1.0 / 18402, 4) as Support_AB,
		ROUND(pp.pair_count * 1.0 / spa.product_orders, 4) as Confidence,
		ROUND((pp.pair_count * 1.0 / 18402) / 
			  ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)), 2) as Lift
	FROM product_pairs_table pp 
	INNER JOIN product_support_table spa ON pp.Product_A = spa.StockCode
	INNER JOIN product_support_table spb ON pp.Product_B = spb.StockCode
	INNER JOIN (SELECT DISTINCT StockCode, Description,avg(UnitPrice) avg_UnitPrice FROM transactions_clean where Quantity <= 10 group by StockCode, Description ) tc1 
	ON pp.Product_A = tc1.StockCode
	INNER JOIN (SELECT DISTINCT StockCode,avg(UnitPrice) avg_UnitPrice,Description FROM transactions_clean where Quantity <= 10 group by StockCode, Description) tc2 
		ON pp.Product_B = tc2.StockCode 
	WHERE (pp.pair_count * 1.0 / 18402) / 
		  ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)) > 5
		  and pp.pair_count > 30
	)

select *,(Avg_Unit_price_ProductA+ Avg_Unit_price_ProductB) as Bundle_Price, (Lift * Total_Orders_together) /1000 as Bundle_score from cte 
order by Total_Orders_together 


----------------------------------------------------
CREATE VIEW vw_product_pairs_analysis AS
WITH pair_metrics AS (
    SELECT  
        pp.Product_A,
        pp.Product_B,
        pp.pair_count as times_together,
        ROUND(pp.pair_count * 1.0 / 18402, 4) as Support_AB,
        ROUND(pp.pair_count * 1.0 / spa.product_orders, 4) as Confidence,
        ROUND((pp.pair_count * 1.0 / 18402) / 
              ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)), 2) as Lift
    FROM product_pairs_table pp 
    INNER JOIN product_support_table spa ON pp.Product_A = spa.StockCode
    INNER JOIN product_support_table spb ON pp.Product_B = spb.StockCode
    WHERE (pp.pair_count * 1.0 / 18402) / 
          ((spa.product_orders * 1.0 / 18402) * (spb.product_orders * 1.0 / 18402)) > 1.5
)
SELECT 
    pm.*,
    tc1.Description as Description_A,
    tc1.avg_UnitPrice as Avg_Price_A,
    tc2.Description as Description_B,
    tc2.avg_UnitPrice as Avg_Price_B,
    (tc1.avg_UnitPrice + tc2.avg_UnitPrice) as Bundle_Price,
    (pm.Lift * pm.times_together) / 1000 as Bundle_Score
FROM pair_metrics pm
INNER JOIN (
    SELECT StockCode, Description, AVG(UnitPrice) as avg_UnitPrice 
    FROM transactions_clean 
    WHERE Quantity <= 10
    GROUP BY StockCode, Description
) tc1 ON pm.Product_A = tc1.StockCode
INNER JOIN (
    SELECT StockCode, Description, AVG(UnitPrice) as avg_UnitPrice 
    FROM transactions_clean 
    WHERE Quantity <= 10
    GROUP BY StockCode, Description
) tc2 ON pm.Product_B = tc2.StockCode;
GO
--Basket Analysis
CREATE VIEW vw_basket_analysis AS
WITH basket_size AS (
    SELECT 
        InvoiceNo,
        COUNT(DISTINCT StockCode) as items_per_order
    FROM transactions_clean
    GROUP BY InvoiceNo
),
order_totals AS (
    SELECT 
        InvoiceNo,
        SUM(LineTotal) as total_order_value
    FROM transactions_clean
    GROUP BY InvoiceNo
)
SELECT 
    CASE 
        WHEN b.items_per_order = 1 THEN '1 item' 
        WHEN b.items_per_order BETWEEN 2 AND 3 THEN '2-3 items'
        WHEN b.items_per_order BETWEEN 4 AND 5 THEN '4-5 items'
        WHEN b.items_per_order BETWEEN 6 AND 10 THEN '6-10 items'
        WHEN b.items_per_order > 10 THEN '10+ items'
    END as basket_category,
    COUNT(b.InvoiceNo) as order_count,
    ROUND(AVG(o.total_order_value), 2) as avg_order_value
FROM basket_size b
INNER JOIN order_totals o ON b.InvoiceNo = o.InvoiceNo
GROUP BY 
    CASE 
        WHEN b.items_per_order = 1 THEN '1 item' 
        WHEN b.items_per_order BETWEEN 2 AND 3 THEN '2-3 items'
        WHEN b.items_per_order BETWEEN 4 AND 5 THEN '4-5 items'
        WHEN b.items_per_order BETWEEN 6 AND 10 THEN '6-10 items'
        WHEN b.items_per_order > 10 THEN '10+ items'
    END;
GO 

CREATE VIEW vw_top_products AS
SELECT 
    StockCode,
    Description,
    COUNT(DISTINCT InvoiceNo) as order_frequency,
    SUM(Quantity) as total_quantity_sold,
    ROUND(SUM(LineTotal), 2) as total_revenue,
    ROUND(AVG(CASE WHEN Quantity <= 10 THEN UnitPrice END), 2) as avg_retail_price
FROM transactions_clean
GROUP BY StockCode, Description;
GO

CREATE VIEW vw_transactions_summary AS
SELECT 
    InvoiceNo,
    InvoiceDate,
    CustomerID,
    Country,
    COUNT(DISTINCT StockCode) as basket_size,
    SUM(LineTotal) as order_value
FROM transactions_clean
GROUP BY InvoiceNo, InvoiceDate, CustomerID, Country;
GO 

-- Test each view
SELECT TOP 10 * FROM vw_product_pairs_analysis ORDER BY Lift DESC;
SELECT * FROM vw_basket_analysis;
SELECT TOP 10 * FROM vw_top_products ORDER BY total_revenue DESC;
SELECT TOP 10 * FROM vw_transactions_summary ORDER BY InvoiceDate DESC;

select * from vw_product_pairs_analysis where Lift > 100 