-- Active: 1790168926319@@127.0.0.1@5432@northwind_elt
CREATE DATABASE northwind_elt;

SELECT 'categories' AS zdroj, (SELECT COUNT(*) FROM bronze.categories) AS bronze, (SELECT COUNT(*) FROM silver.stg_categories) AS silver
UNION ALL SELECT 'customers',(SELECT COUNT(*) FROM bronze.customers),(SELECT COUNT(*) FROM silver.stg_customers)
UNION ALL SELECT 'employees',(SELECT COUNT(*) FROM bronze.employees),(SELECT COUNT(*) FROM silver.stg_employees)
UNION ALL SELECT 'orderdetails',(SELECT COUNT(*) FROM bronze.orderdetails),(SELECT COUNT(*) FROM silver.stg_orderdetails)
UNION ALL SELECT 'orders',(SELECT COUNT(*) FROM bronze.orders),(SELECT COUNT(*) FROM silver.stg_orders)
UNION ALL SELECT 'products',(SELECT COUNT(*) FROM bronze.products),(SELECT COUNT(*) FROM silver.stg_products)
UNION ALL SELECT 'shippers',(SELECT COUNT(*) FROM bronze.shippers),(SELECT COUNT(*) FROM silver.stg_shippers)
UNION ALL SELECT 'suppliers',(SELECT COUNT(*) FROM bronze.suppliers),(SELECT COUNT(*) FROM silver.stg_suppliers);

SELECT 'fact_order' AS tabulka, COUNT(*) AS pocet FROM gold.fact_order
UNION ALL SELECT 'dim_customer',COUNT(*) FROM gold.dim_customer
UNION ALL SELECT 'dim_product',COUNT(*) FROM gold.dim_product
UNION ALL SELECT 'dim_date',COUNT(*) FROM gold.dim_date
UNION ALL SELECT 'dim_employee',COUNT(*) FROM gold.dim_employee
UNION ALL SELECT 'dim_shipper',COUNT(*) FROM gold.dim_shipper;

SELECT
    (SELECT COUNT(*) FROM silver.stg_orderdetails) AS zdrojove_polozky,
    (SELECT COUNT(*) FROM gold.fact_order) AS faktove_riadky;

SELECT cat.category_name, SUM(f.quantity) AS predane_kusy,
       SUM(f.price) AS odhad_trzieb
FROM gold.fact_order f
JOIN gold.dim_product p ON p.product_id = f.product_id
JOIN gold.sdim_category cat ON cat.category_id = p.sdim_category_category_id
GROUP BY cat.category_name
ORDER BY odhad_trzieb DESC;