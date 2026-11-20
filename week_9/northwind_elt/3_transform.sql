\set ON_ERROR_STOP on

\encoding UTF8

BEGIN;
CREATE SCHEMA IF NOT EXISTS gold;

DROP TABLE IF EXISTS gold.fact_order, gold.dim_customer, gold.dim_product,
    gold.dim_date, gold.dim_employee, gold.dim_shipper,
    gold.dim_address, gold.dim_city, gold.dim_country,
    gold.sdim_address, gold.sdim_city, gold.sdim_country,
    gold.sdim_category, gold.sdim_day, gold.sdim_month,
    gold.sdim_quarter CASCADE;

CREATE TABLE gold.sdim_day (
    day_id INT PRIMARY KEY,
    day INT NOT NULL,
    day_of_week VARCHAR(15) NOT NULL
);

CREATE TABLE gold.sdim_month (
    month_id INT PRIMARY KEY,
    month INT NOT NULL,
    month_name VARCHAR(15) NOT NULL
);

CREATE TABLE gold.sdim_quarter (
    quarter_id INT PRIMARY KEY,
    quarter INT NOT NULL,
    quarter_label VARCHAR(20) NOT NULL
);

CREATE TABLE gold.dim_date (
    iddim_date INT PRIMARY KEY,
    order_date DATE NOT NULL UNIQUE,
    day INT NOT NULL,
    week INT NOT NULL,
    day_id INT NOT NULL REFERENCES gold.sdim_day(day_id),
    month_id INT NOT NULL REFERENCES gold.sdim_month(month_id),
    year INT NOT NULL,
    quarter_id INT NOT NULL REFERENCES gold.sdim_quarter(quarter_id)
);

CREATE TABLE gold.dim_employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL
);

CREATE TABLE gold.dim_shipper (
    shipper_id INT PRIMARY KEY,
    shipper_name VARCHAR(50) NOT NULL
);

CREATE TABLE gold.sdim_category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL
);

CREATE TABLE gold.sdim_country (
    supplier_id INT PRIMARY KEY,
    country VARCHAR(50)
);

CREATE TABLE gold.sdim_city (
    supplier_id INT PRIMARY KEY REFERENCES gold.sdim_country(supplier_id),
    city VARCHAR(80)
);

CREATE TABLE gold.sdim_address (
    supplier_id INT PRIMARY KEY REFERENCES gold.sdim_city(supplier_id),
    address VARCHAR(120)
);

CREATE TABLE gold.dim_product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    product_unit VARCHAR(60),
    supplier_name VARCHAR(100),
    sdim_category_category_id INT NOT NULL REFERENCES gold.sdim_category(category_id),
    address INT REFERENCES gold.sdim_address(supplier_id),
    city INT REFERENCES gold.sdim_city(supplier_id),
    country INT REFERENCES gold.sdim_country(supplier_id)
);

CREATE TABLE gold.dim_country (
    country_id INT PRIMARY KEY,
    country VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE gold.dim_city (
    city_id INT PRIMARY KEY,
    city VARCHAR(80) NOT NULL,
    country_id INT NOT NULL REFERENCES gold.dim_country(country_id),
    UNIQUE (city, country_id)
);

CREATE TABLE gold.dim_address (
    address_id INT PRIMARY KEY,
    address VARCHAR(120)
);

CREATE TABLE gold.dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    sdim_address_address_id INT NOT NULL REFERENCES gold.dim_address(address_id),
    sdim_city_city_id INT NOT NULL REFERENCES gold.dim_city(city_id),
    sdim_country_country_id INT NOT NULL REFERENCES gold.dim_country(country_id)
);

CREATE TABLE gold.fact_order (
    order_detail_id INT PRIMARY KEY,
    order_id INT NOT NULL,
    quantity INT NOT NULL,
    price NUMERIC(12,2) NOT NULL,
    date_id INT NOT NULL REFERENCES gold.dim_date(iddim_date),
    employee_id INT NOT NULL REFERENCES gold.dim_employee(employee_id),
    shipper_id INT NOT NULL REFERENCES gold.dim_shipper(shipper_id),
    product_id INT NOT NULL REFERENCES gold.dim_product(product_id),
    customer_id INT NOT NULL REFERENCES gold.dim_customer(customer_id)
);

INSERT INTO gold.sdim_day (day_id, day, day_of_week)
SELECT d, d, TRIM(TO_CHAR(DATE '2024-01-01' + (d - 1), 'FMDay'))
FROM GENERATE_SERIES(1, 7) AS gs(d);

INSERT INTO gold.sdim_month (month_id, month, month_name)
SELECT m, m, TRIM(TO_CHAR(MAKE_DATE(2024, m, 1), 'FMMonth'))
FROM GENERATE_SERIES(1, 12) AS gs(m);

INSERT INTO gold.sdim_quarter (quarter_id, quarter, quarter_label)
SELECT q, q, 'Q' || q::TEXT
FROM GENERATE_SERIES(1, 4) AS gs(q);

INSERT INTO gold.dim_date (
    iddim_date, order_date, day, week, day_id, month_id, year, quarter_id
)
SELECT TO_CHAR(d, 'YYYYMMDD')::INT, d::DATE,
       EXTRACT(DAY FROM d)::INT, EXTRACT(WEEK FROM d)::INT,
       EXTRACT(ISODOW FROM d)::INT, EXTRACT(MONTH FROM d)::INT,
       EXTRACT(YEAR FROM d)::INT, EXTRACT(QUARTER FROM d)::INT
FROM GENERATE_SERIES(
    (SELECT MIN(order_date)::DATE FROM silver.stg_orders),
    (SELECT MAX(order_date)::DATE FROM silver.stg_orders),
    INTERVAL '1 day'
) AS gs(d);

INSERT INTO gold.dim_employee (employee_id, last_name, first_name)
SELECT employee_id, last_name, first_name
FROM silver.stg_employees;

INSERT INTO gold.dim_shipper (shipper_id, shipper_name)
SELECT shipper_id, shipper_name
FROM silver.stg_shippers;

INSERT INTO gold.sdim_category (category_id, category_name)
SELECT category_id, category_name FROM silver.stg_categories;

INSERT INTO gold.sdim_country (supplier_id, country)
SELECT supplier_id, country FROM silver.stg_suppliers;

INSERT INTO gold.sdim_city (supplier_id, city)
SELECT supplier_id, city FROM silver.stg_suppliers;

INSERT INTO gold.sdim_address (supplier_id, address)
SELECT supplier_id, address FROM silver.stg_suppliers;

INSERT INTO gold.dim_product (
    product_id, product_name, product_unit, supplier_name,
    sdim_category_category_id, address, city, country
)
SELECT p.product_id, p.product_name, p.product_unit, s.supplier_name,
       p.category_id, p.supplier_id, p.supplier_id, p.supplier_id
FROM silver.stg_products p
JOIN silver.stg_suppliers s ON s.supplier_id = p.supplier_id;

INSERT INTO gold.dim_country (country_id, country)
SELECT ROW_NUMBER() OVER (ORDER BY country)::INT, country
FROM (SELECT DISTINCT country FROM silver.stg_customers) AS x;

INSERT INTO gold.dim_city (city_id, city, country_id)
SELECT ROW_NUMBER() OVER (ORDER BY c.country, c.city)::INT,
       c.city, co.country_id
FROM (SELECT DISTINCT country, city FROM silver.stg_customers) AS c
JOIN gold.dim_country co ON co.country = c.country;

INSERT INTO gold.dim_address (address_id, address)
SELECT customer_id, address FROM silver.stg_customers;

INSERT INTO gold.dim_customer (
    customer_id, customer_name, sdim_address_address_id,
    sdim_city_city_id, sdim_country_country_id
)
SELECT c.customer_id, c.customer_name, c.customer_id,
       ci.city_id, co.country_id
FROM silver.stg_customers c
JOIN gold.dim_country co ON co.country = c.country
JOIN gold.dim_city ci ON ci.city = c.city AND ci.country_id = co.country_id;

INSERT INTO gold.fact_order (
    order_detail_id, order_id, quantity, price,
    date_id, employee_id, shipper_id, product_id, customer_id
)
SELECT od.order_detail_id, o.order_id, od.quantity,
       (od.quantity * p.price)::NUMERIC(12,2),
       TO_CHAR(o.order_date, 'YYYYMMDD')::INT,
       o.employee_id, o.shipper_id, od.product_id, o.customer_id
FROM silver.stg_orderdetails od
JOIN silver.stg_orders o ON o.order_id = od.order_id
JOIN silver.stg_products p ON p.product_id = od.product_id;

CREATE INDEX idx_fact_order_date ON gold.fact_order(date_id);
CREATE INDEX idx_fact_order_employee ON gold.fact_order(employee_id);
CREATE INDEX idx_fact_order_shipper ON gold.fact_order(shipper_id);
CREATE INDEX idx_fact_order_product ON gold.fact_order(product_id);
CREATE INDEX idx_fact_order_customer ON gold.fact_order(customer_id);
CREATE INDEX idx_fact_order_order ON gold.fact_order(order_id);

COMMIT;
