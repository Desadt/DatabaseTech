\set ON_ERROR_STOP on

\encoding UTF8

CREATE SCHEMA IF NOT EXISTS silver;

CREATE OR REPLACE VIEW silver.stg_categories AS
SELECT categoryid AS category_id, NULLIF(TRIM(categoryname), '') AS category_name,
       NULLIF(TRIM(description), '') AS description
FROM bronze.categories;

CREATE OR REPLACE VIEW silver.stg_customers AS
SELECT customerid AS customer_id, NULLIF(TRIM(customername), '') AS customer_name,
       NULLIF(TRIM(contactname), '') AS contact_name,
       NULLIF(TRIM(address), '') AS address,
       NULLIF(TRIM(city), '') AS city,
       NULLIF(TRIM(postalcode), '') AS postal_code,
       NULLIF(TRIM(country), '') AS country
FROM bronze.customers;

CREATE OR REPLACE VIEW silver.stg_employees AS
SELECT employeeid AS employee_id, NULLIF(TRIM(lastname), '') AS last_name,
       NULLIF(TRIM(firstname), '') AS first_name,
       birthdate AS birth_date, NULLIF(TRIM(photo), '') AS photo,
       NULLIF(TRIM(notes), '') AS notes
FROM bronze.employees;

CREATE OR REPLACE VIEW silver.stg_orderdetails AS
SELECT orderdetailid AS order_detail_id, orderid AS order_id,
       productid AS product_id, quantity
FROM bronze.orderdetails;

CREATE OR REPLACE VIEW silver.stg_orders AS
SELECT orderid AS order_id, customerid AS customer_id,
       employeeid AS employee_id, orderdate AS order_date,
       shipperid AS shipper_id
FROM bronze.orders;

CREATE OR REPLACE VIEW silver.stg_products AS
SELECT productid AS product_id, NULLIF(TRIM(productname), '') AS product_name,
       supplierid AS supplier_id, categoryid AS category_id,
       NULLIF(TRIM(unit), '') AS product_unit, price
FROM bronze.products;

CREATE OR REPLACE VIEW silver.stg_shippers AS
SELECT shipperid AS shipper_id, NULLIF(TRIM(shippername), '') AS shipper_name,
       NULLIF(TRIM(phone), '') AS phone
FROM bronze.shippers;

CREATE OR REPLACE VIEW silver.stg_suppliers AS
SELECT supplierid AS supplier_id, NULLIF(TRIM(suppliername), '') AS supplier_name,
       NULLIF(TRIM(contactname), '') AS contact_name,
       NULLIF(TRIM(address), '') AS address,
       NULLIF(TRIM(city), '') AS city,
       NULLIF(TRIM(postalcode), '') AS postal_code,
       NULLIF(TRIM(country), '') AS country,
       NULLIF(TRIM(phone), '') AS phone
FROM bronze.suppliers;
