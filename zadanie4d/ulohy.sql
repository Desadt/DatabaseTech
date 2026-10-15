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