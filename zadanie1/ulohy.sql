--uloha 2
SELECT order_id, c.customer_name, sales FROM orders
INNER JOIN customers c ON orders.customer_id = c.customer_id
WHERE sales > 500 ORDER BY sales DESC;

--uloha 3
SELECT order_id, c.customer_name, p.category, sales FROM orders
INNER JOIN customers c ON orders.customer_id = c.customer_id
INNER JOIN products p ON orders.product_id = p.product_id;

SELECT region, SUM(o.sales) AS total_sales from customers
LEFT JOIN orders o ON customers.customer_id = o.customer_id
GROUP BY region;