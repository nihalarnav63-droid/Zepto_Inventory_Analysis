
-- 1. SCHEMA SETUP & TABLE CREATION
DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
    sku_id INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(120),
    name VARCHAR(150) NOT NULL,
    mrp DECIMAL(8,2),
    discountPercent DECIMAL(5,2),
    availableQuantity INTEGER,
    discountedSellingPrice DECIMAL(8,2),
    weightInGms INTEGER,
    outOfStock BOOLEAN,
    quantity INTEGER
);

SELECT COUNT(*) FROM zepto;

-- Preview sample data
SELECT * FROM zepto LIMIT 10;

-- Identify rows with critical NULL values
SELECT * FROM zepto
WHERE name IS NULL
   OR category IS NULL
   OR mrp IS NULL
   OR discountPercent IS NULL
   OR discountedSellingPrice IS NULL
   OR weightInGms IS NULL
   OR availableQuantity IS NULL
   OR outOfStock IS NULL
   OR quantity IS NULL;

-- List distinct product categories alphabetically
SELECT DISTINCT category
FROM zepto
ORDER BY category;

-- Stock availability distribution
SELECT outOfStock, COUNT(sku_id) AS total_skus
FROM zepto
GROUP BY outOfStock;

-- Identify duplicate product listings (SKUs with the same name)
SELECT name, COUNT(sku_id) AS `Number of SKUs`
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


-- 3. DATA CLEANING & RECTIFICATION
-- Identify and remove products with invalid pricing anomalies (price = 0)
SELECT * FROM zepto WHERE mrp = 0 OR discountedSellingPrice = 0;

DELETE FROM zepto WHERE mrp = 0;

-- Convert pricing units from paise to standard currency units (rupees)
UPDATE zepto
SET mrp = mrp / 100.0,
    discountedSellingPrice = discountedSellingPrice / 100.0;

-- Verify currency normalization success
SELECT mrp, discountedSellingPrice FROM zepto LIMIT 10;


-- 4. TARGET ANALYTICAL QUERIES
-- Q1. Find the top 10 best-value products based on the highest discount percentage.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;

-- Q2. Identify high-value products (MRP > 300) currently out of stock (Immediate Revenue Loss).
SELECT DISTINCT name, mrp
FROM zepto
WHERE outOfStock = TRUE AND mrp > 300
ORDER BY mrp DESC;

-- Q3. Calculate the estimated total revenue potential for each category based on active stock.
SELECT category,
       SUM(discountedSellingPrice * availableQuantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue DESC;

-- Q4. Find premium products where MRP > 500 and discount is low (< 10%).
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
       ROUND(AVG(discountPercent), 2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Calculate price-per-gram value for products weighing 100g or more.
SELECT DISTINCT name, weightInGms, discountedSellingPrice,
       ROUND(discountedSellingPrice / weightInGms, 2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram ASC;

-- Q7. Segment catalog dynamically into Low (<1kg), Medium (1kg-5kg), and Bulk (>=5kg) weight classes.
SELECT DISTINCT name, weightInGms,
       CASE WHEN weightInGms < 1000 THEN 'Low'
            WHEN weightInGms < 5000 THEN 'Medium'
            ELSE 'Bulk'
       END AS weight_category
FROM zepto;

-- Q8. Calculate total physical warehouse load weight per category for logistics capacity planning.
SELECT category,
       SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight DESC;
