-- Active: 1790168926319@@127.0.0.1@5432@superstore
--uloha 1
CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.customer_name, SUM(o.sales) as total_sales FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(o.sales) > 2000;

SELECT * FROM high_value_customers;

DROP VIEW high_value_customers;

--uloha 2
CREATE VIEW regional_monthly_sales AS
SELECT c.region, DATE_TRUNC('month', o.order_date) AS month, SUM(o.sales) AS monthly_sales
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.region, DATE_TRUNC('month', o.order_date);

DROP VIEW  regional_monthly_sales;

SELECT * FROM regional_monthly_sales
WHERE region = 'West';

--uloha 3
CREATE VIEW analyst_orders AS
SELECT order_id, customer_id, product_id, sales, quantity, discount FROM orders;

SELECT * FROM analyst_orders;

DROP VIEW analyst_orders;