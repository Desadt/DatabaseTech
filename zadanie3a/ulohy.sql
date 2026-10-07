-- Active: 1790168926319@@127.0.0.1@5432@superstore
CREATE VIEW high_value_customers AS
SELECT c.customer_id, c.customer_name, SUM(o.sales) as total_sales FROM customers c
INNER JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.customer_name
HAVING SUM(o.sales) > 2000;

SELECT * FROM high_value_customers;