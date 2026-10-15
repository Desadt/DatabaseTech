-- Active: 1790168926319@@127.0.0.1@5432@superstore
--uloha 1
WITH ranked_orders AS (
    SELECT
        c.customer_name,
        o.order_id,
        o.order_date,
        ROW_NUMBER() OVER (
            PARTITION BY o.customer_id
            ORDER BY o.order_date DESC, o.order_id DESC
        ) AS rn
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
)
SELECT COUNT(*) AS pocet_zaznamov
FROM ranked_orders
WHERE rn <= 2;

--uloha 2
WITH customer_profit AS (
    SELECT
        c.region,
        c.customer_name,
        SUM(o.profit) AS total_profit
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY
        c.region,
        c.customer_id,
        c.customer_name
)
SELECT
    region,
    customer_name,
    total_profit,
    RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_rank,
    DENSE_RANK() OVER (
        PARTITION BY region
        ORDER BY total_profit DESC
    ) AS profit_dense_rank
FROM customer_profit
ORDER BY
    region ASC,
    total_profit DESC
LIMIT 5;

--uloha 3
WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_name,
    total_sales,
    NTILE(4) OVER (
        ORDER BY total_sales DESC
    ) AS quartile
FROM customer_sales
ORDER BY total_sales DESC;

WITH customer_sales AS (
    SELECT
        c.customer_name,
        SUM(o.sales) AS total_sales
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
),
customer_quartiles AS (
    SELECT
        customer_name,
        total_sales,
        NTILE(4) OVER (
            ORDER BY total_sales DESC
        ) AS quartile
    FROM customer_sales
)
SELECT *
FROM customer_quartiles
WHERE customer_name = 'Customer_26';

--uloha 4