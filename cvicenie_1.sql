-- Active: 1790168926319@@127.0.0.1@5432@superstore
CREATE Table customers(
    customer_id VARCHAR(20) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    region VARCHAR(50)
);

CREATE Table products(
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_name VARCHAR(100)
);

CREATE Table orders(
    order_id VARCHAR(20) PRIMARY KEY,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    order_date DATE,
    ship_date DATE,
    sales DECIMAL(2),
    quantity INT,
    discount DECIMAL(2),
    profint DECIMAL(2)
);