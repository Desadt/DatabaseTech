--uloha 2
SELECT order_id, c.customer_name, sales FROM orders
INNER JOIN customers c ON orders.customer_id = c.customer_id
WHERE sales > 500 ORDER BY sales DESC;

--uloha 3
SELECT order_id, c.customer_name, p.category, sales FROM orders
INNER JOIN customers c ON orders.customer_id = c.customer_id
INNER JOIN products p ON orders.product_id = p.product_id;

--uloha 4
SELECT region, SUM(o.sales) AS total_sales from customers
LEFT JOIN orders o ON customers.customer_id = o.customer_id
GROUP BY region;

--uloha 5
SELECT product_name, COALESCE(SUM(o.sales), 0) AS total_sales FROM products
LEFT JOIN orders o ON products.product_id = o.product_id
GROUP BY product_name ORDER BY total_sales DESC;

--uloha 6
SELECT customer_name, o.order_id, o.sales FROM customers
FULL OUTER JOIN orders o ON customers.customer_id = o.customer_id;

--uloha 7
SELECT region, sum(o.sales) AS total_sales FROM customers
INNER JOIN orders o ON customers.customer_id = o.customer_id
GROUP BY region;