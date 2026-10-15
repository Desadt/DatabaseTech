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
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    monthly_sales,
    LAG(monthly_sales, 1) OVER (
        ORDER BY month
    ) AS prev_month_sales,
    LEAD(monthly_sales, 1) OVER (
        ORDER BY month
    ) AS next_month_sales
FROM monthly_sales
ORDER BY month ASC;

--uloha 5
WITH product_sales AS (
    SELECT
        p.category,
        p.product_name,
        SUM(o.sales) AS product_sales
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.category,
        p.product_name
),
category_sales AS (
    SELECT
        category,
        product_name,
        product_sales,
        SUM(product_sales) OVER (
            PARTITION BY category
        ) AS category_total
    FROM product_sales
)
SELECT
    category,
    product_name,
    product_sales,
    category_total,
    ROUND(
        product_sales * 100.0 / NULLIF(category_total, 0),
        2
    ) AS pct_of_category
FROM category_sales
ORDER BY
    category ASC,
    pct_of_category DESC;