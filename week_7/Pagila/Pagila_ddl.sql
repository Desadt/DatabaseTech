CREATE DATABASE Pagila

CREATE TABLE sdim_country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(50)
);

CREATE TABLE sdim_city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(50)
);

CREATE TABLE sdim_address (
    address_id INT PRIMARY KEY,
    address VARCHAR(50),
    address2 VARCHAR(50),
    district VARCHAR(50)
);

CREATE TABLE sdim_day (
    day_id INT PRIMARY KEY,
    day INT,
    day_name VARCHAR(15)
);

CREATE TABLE sdim_month (
    month_id INT PRIMARY KEY,
    month INT,
    month_name VARCHAR(15)
);

CREATE TABLE sdim_quarter (
    quarter_id INT PRIMARY KEY,
    quarter INT,
    quarter_label VARCHAR(2)
);

CREATE TABLE sdim_hour (
    hour_id INT PRIMARY KEY,
    hour INT,
    hour_12_label INT
);

CREATE TABLE sdim_part_name (
    part_id INT PRIMARY KEY,
    part_name VARCHAR(15)
);

CREATE TABLE sdim_actor (
    actor_id INT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45)
);

CREATE TABLE sdim_category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(25)
);

CREATE TABLE sdim_language (
    language_id INT PRIMARY KEY,
    language_name VARCHAR(25)
);

CREATE TABLE dim_date (
    date_id INT PRIMARY KEY,
    week INT,
    week_name VARCHAR(15),
    year INT,
    day_id INT,
    month_id INT,
    quarter_id INT,

    FOREIGN KEY (day_id)
        REFERENCES sdim_day(day_id),

    FOREIGN KEY (month_id)
        REFERENCES sdim_month(month_id),

    FOREIGN KEY (quarter_id)
        REFERENCES sdim_quarter(quarter_id)
);


CREATE TABLE dim_time (
    time_id INT PRIMARY KEY,
    hour_id INT,
    minute INT,
    second INT,
    am_pm VARCHAR(2),
    part_id INT,

    FOREIGN KEY (hour_id)
        REFERENCES sdim_hour(hour_id),

    FOREIGN KEY (part_id)
        REFERENCES sdim_part_name(part_id)
);


CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    address_id INT,
    city_id INT,
    country_id INT,

    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id),

    FOREIGN KEY (city_id)
        REFERENCES sdim_city(city_id),

    FOREIGN KEY (country_id)
        REFERENCES sdim_country(country_id)
);


CREATE TABLE dim_staff (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    address_id INT,
    city_id INT,
    country_id INT,

    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id),

    FOREIGN KEY (city_id)
        REFERENCES sdim_city(city_id),

    FOREIGN KEY (country_id)
        REFERENCES sdim_country(country_id)
);


CREATE TABLE dim_store (
    store_id INT PRIMARY KEY,
    manager_first_name VARCHAR(50),
    manager_last_name VARCHAR(50),
    address_id INT,
    city_id INT,
    country_id INT,

    FOREIGN KEY (address_id)
        REFERENCES sdim_address(address_id),

    FOREIGN KEY (city_id)
        REFERENCES sdim_city(city_id),

    FOREIGN KEY (country_id)
        REFERENCES sdim_country(country_id)
);


CREATE TABLE dim_film (
    film_id INT PRIMARY KEY,
    film_title VARCHAR(255),
    release_year VARCHAR(45),
    language_id INT,
    category_id INT,
    special_features TEXT,

    FOREIGN KEY (language_id)
        REFERENCES sdim_language(language_id),

    FOREIGN KEY (category_id)
        REFERENCES sdim_category(category_id)
);

CREATE TABLE bridge (
    bridge_id INT PRIMARY KEY,
    film_id INT,
    actor_id INT,

    FOREIGN KEY (film_id)
        REFERENCES dim_film(film_id),

    FOREIGN KEY (actor_id)
        REFERENCES sdim_actor(actor_id)
);

CREATE TABLE fact_rental (
    rental_id INT PRIMARY KEY,
    date_id INT,
    store_id INT,
    staff_id INT,
    film_id INT,
    time_id INT,
    customer_id INT,
    active_customer SMALLINT,
    active_staff SMALLINT,
    film_length SMALLINT,
    film_replacement_cost DECIMAL(10,2),
    film_rating DECIMAL,

    FOREIGN KEY (date_id)
        REFERENCES dim_date(date_id),

    FOREIGN KEY (store_id)
        REFERENCES dim_store(store_id),

    FOREIGN KEY (staff_id)
        REFERENCES dim_staff(staff_id),

    FOREIGN KEY (film_id)
        REFERENCES dim_film(film_id),

    FOREIGN KEY (time_id)
        REFERENCES dim_time(time_id),

    FOREIGN KEY (customer_id)
        REFERENCES dim_customer(customer_id)
);