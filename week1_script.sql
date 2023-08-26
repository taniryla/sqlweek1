CREATE TABLE categories (
    id SERIAL NOT NULL UNIQUE,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    picture TEXT,
    PRIMARY KEY (id)
);

CREATE TABLE products (
    id SERIAL NOT NULL UNIQUE,
    name TEXT NOT NULL,
    discontinued BOOLEAN NOT NULL,
    category_id INTEGER,
    PRIMARY KEY (id)
);

ALTER TABLE products
ADD CONSTRAINT fk_products_categories
FOREIGN KEY (category_id)
REFERENCES categories;