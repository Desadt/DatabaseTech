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

--uloha 8
SELECT customer_name, COUNT(o.order_id) as number_of_orders FROM customers
LEFT JOIN orders o ON customers.customer_id = o.customer_id
GROUP BY customers.customer_id;

--uloha 9
SELECT category, AVG(o.discount) as average_discount FROM products
INNER JOIN orders o ON products.product_id = o.product_id
GROUP BY category;

--uloha 10
SELECT customer_name, SUM(o.sales) as total_value FROM customers
INNER JOIN orders o ON customers.customer_id = o.customer_id
GROUP BY customers.customer_id, customer_name HAVING SUM(o.sales) > 2000;

--uloha 11
SELECT region, SUM(o.sales) as total_sales, ROUND(AVG(o.discount), 4) as avarege_discount, COUNT(o.order_id) as number_of_orders FROM customers c
INNER JOIN orders o on c.customer_id = o.customer_id
GROUP BY region;

--uloha 12
SELECT region,
COUNT(CASE 
    WHEN o.sales > 1000 THEN 1 
END) as high_value,
COUNT(CASE 
    WHEN o.sales <= 1000 THEN 1 
END) as low_value
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY region;

--uloha 13
SELECT customer_name, SUM(o.sales) as total_sales, AVG(o.discount) as avarage_discount, COUNT(o.order_id),
CASE 
    WHEN SUM(o.sales) > 2500 THEN 'VIP'  
    ELSE  'REGULAR'
END as customer_type
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_sales DESC;