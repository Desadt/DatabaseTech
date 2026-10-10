-- Active: 1790168926319@@127.0.0.1@5432@retail_sales
--uloha 8
CREATE TABLE orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    ship_mode VARCHAR(30) NOT NULL,
    sales NUMERIC(10,2) NOT NULL,
    profit NUMERIC(10,2) NOT NULL
);

SELECT *
FROM orders;

--uloha 9
CREATE OR REPLACE PROCEDURE get_customer_sales(
    p_customer_id VARCHAR(20)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(10,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE customer_id = p_customer_id;

    RAISE NOTICE 'Customer ID: %, Total Sales: %',
        p_customer_id, v_total_sales;
END;
$$;

CALL get_customer_sales('C001');

--uloha 10
CREATE OR REPLACE PROCEDURE apply_regional_discount(
    region_name VARCHAR(20),
    discount_rate NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE orders
    SET sales = sales * (1 - discount_rate)
    WHERE region = region_name;

    RAISE NOTICE 'Discount of % applied to region %',
        discount_rate, region_name;
END;
$$;

CALL apply_regional_discount('West', 0.10);

--uloha 11
CREATE OR REPLACE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_sales NUMERIC(12,2);
BEGIN
    SELECT COALESCE(SUM(sales), 0)
    INTO v_total_sales
    FROM orders
    WHERE order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Start date: %, End date: %, Total sales: %',
        start_date, end_date, v_total_sales;
END;
$$;

CALL get_sales_between('2024-01-01', '2024-03-31');