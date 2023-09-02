-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'week1_workshop' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS week1_workshop;
CREATE DATABASE week1_workshop;
-- connect via psql
\c week1_workshop

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE products (
    id SERIAL,
    name TEXT NOT NULL,
    discontinued BOOLEAN NOT NULL,
    supplier_id INT,
    category_id INT,
    PRIMARY KEY (id)
);


CREATE TABLE categories (
    id SERIAL,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    picture TEXT,
    PRIMARY KEY (id)
);

-- TODO create more tables here...

CREATE TABLE suppliers(
    id SERIAL UNIQUE,
    name TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE customers(
    id SERIAL UNIQUE,
    company_name TEXT NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE employees(
    id SERIAL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE orders(
    id SERIAL UNIQUE,
    date DATE,
    employee_id INTEGER,
    customer_id INTEGER NOT NULL,
    PRIMARY KEY(id)
);

/* bridge table for many-to-many relationship between Orders and Products */

CREATE TABLE orders_products(
    product_id SERIAL UNIQUE,
    order_id SERIAL UNIQUE,
    quantity INTEGER NOT NULL,
    discount NUMERIC NOT NULL,
    PRIMARY KEY (product_id, order_id)
);

CREATE TABLE territories(
    id SERIAL UNIQUE,
    description TEXT NOT NULL,
    PRIMARY KEY (id)
);

/* bridge table to implement the many-to-many relationship between Employee and Territory */

CREATE TABLE employees_territories(
    employee_id SERIAL UNIQUE,
    territory_id SERIAL,
    PRIMARY KEY (employee_id, territory_id)
);

CREATE TABLE offices (
    id SERIAL UNIQUE,
    address_line TEXT NOT NULL,
    territory_id INTEGER NOT NULL UNIQUE, 
    PRIMARY KEY(id)
);

CREATE TABLE us_states(
    id SERIAL UNIQUE,
    name TEXT NOT NULL UNIQUE,
    abbreviation CHARACTER(2) NOT NULL UNIQUE,
    PRIMARY KEY(id)
);




---
--- Add foreign key constraints
---/* add alter table to add foreign key constraints one-to-many*/

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (customer_id)
REFERENCES customers;

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employees
FOREIGN KEY (employee_id)
REFERENCES employees;

ALTER TABLE products
ADD CONSTRAINT fk_suppliers_products
FOREIGN KEY (supplier_id)
REFERENCES suppliers;

ALTER TABLE products
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY (category_id) 
REFERENCES categories (id);

/* one-to-one foreign key constraints */

ALTER TABLE offices
ADD CONSTRAINT fk_offices_territories
FOREIGN KEY (territory_id)
REFERENCES territories;

/* many-to-many foreign key constraints */

ALTER TABLE orders_products
ADD CONSTRAINT fk_orders_products_orders
FOREIGN KEY (order_id)
REFERENCES orders;

ALTER TABLE orders_products
ADD CONSTRAINT fk_orders_products_products 
FOREIGN KEY (product_id)
REFERENCES products;

ALTER TABLE employees_territories
ADD CONSTRAINT fk_employees_territories_employees
FOREIGN KEY(employee_id)
REFERENCES employees;

ALTER TABLE employees_territories
ADD CONSTRAINT fk_employees_territories_territories
FOREIGN KEY (territory_id)
REFERENCES territories;

-- TODO create more constraints here...

