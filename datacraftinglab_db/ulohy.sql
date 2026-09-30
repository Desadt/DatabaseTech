-- Active: 1790168926319@@127.0.0.1@5432@datacraftinglab

--uloha1
SELECT product_name, total_amount
FROM flourmills_sales
WHERE total_amount > (
    SELECT AVG(total_amount)
    FROM flourmills_sales
);

--uloha2
SELECT *
FROM flourmills_sales
WHERE product_category = (
    SELECT product_category
    FROM flourmills_sales
    GROUP BY product_category
    ORDER BY SUM(total_amount) DESC
    LIMIT 1
)
ORDER BY sales_id ASC;

--uloha3
SELECT 
    product_name, 
    total_amount, 
    (SELECT AVG(total_amount) FROM flourmills_sales) AS avg_amount
FROM flourmills_sales;

--ulohga4
SELECT 
    product_name, 
    total_amount, 
    total_amount / (SELECT SUM(total_amount) FROM flourmills_sales) AS amount_share
FROM flourmills_sales;

--uloha5
SELECT 
    month, 
    monthly_sales
FROM (
    SELECT 
        EXTRACT(MONTH FROM sale_date) AS month, 
        SUM(total_amount) AS monthly_sales
    FROM flourmills_sales
    GROUP BY EXTRACT(MONTH FROM sale_date)
) AS subquery
ORDER BY monthly_sales DESC;

--uloha6

SELECT 
    product_category, 
    total_sales
FROM (
    SELECT 
        product_category, 
        SUM(total_amount) AS total_sales
    FROM flourmills_sales
    GROUP BY product_category
) AS subquery
WHERE total_sales > 50000000
ORDER BY total_sales DESC;

--uloha7
SELECT 
    f1.product_name, 
    f1.product_category, 
    f1.total_amount
FROM flourmills_sales f1
WHERE f1.total_amount > (
    SELECT AVG(f2.total_amount)
    FROM flourmills_sales f2
    WHERE f2.product_category = f1.product_category
);