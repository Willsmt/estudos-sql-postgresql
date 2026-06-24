-- =============================================================
-- Schema: E-commerce System
-- Database: estudodb
-- Description: Customer registration with addresses, phones,
--              products and orders. Demonstrates 1:1, 1:N and
--              N:N relationships with ON DELETE strategies.
-- =============================================================

CREATE TABLE ecommerce.customers (
    id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name   VARCHAR(150) NOT NULL,
    email       VARCHAR(150) NOT NULL,
    tax_id      VARCHAR(14)  NOT NULL,
    is_active   BOOLEAN      NOT NULL DEFAULT true,
    created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_customers_email  UNIQUE (email),
    CONSTRAINT uq_customers_tax_id UNIQUE (tax_id)
);

CREATE TABLE ecommerce.addresses (
    id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER      NOT NULL,
    street      VARCHAR(200) NOT NULL,
    city        VARCHAR(100) NOT NULL,
    state       VARCHAR(2)   NOT NULL,
    zip_code    VARCHAR(9)   NOT NULL,
    is_active   BOOLEAN      NOT NULL DEFAULT true,
    CONSTRAINT fk_addresses_customer_id FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers (id) ON DELETE CASCADE
);

CREATE TABLE ecommerce.phone_numbers (
    id          INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER     NOT NULL,
    number      VARCHAR(20) NOT NULL,
    is_active   BOOLEAN     NOT NULL DEFAULT true,
    CONSTRAINT fk_phone_numbers_customer_id FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers (id) ON DELETE CASCADE
);

CREATE TABLE ecommerce.products (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    description TEXT,
    price       NUMERIC(10,2) NOT NULL,
    is_active   BOOLEAN       NOT NULL DEFAULT true,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_products_price CHECK (price >= 0)
);

CREATE TABLE ecommerce.stock (
    id          INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id  INTEGER   NOT NULL,
    quantity    INTEGER   NOT NULL DEFAULT 0,
    updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_stock_product_id  UNIQUE (product_id),
    CONSTRAINT chk_stock_quantity   CHECK  (quantity >= 0),
    CONSTRAINT fk_stock_product_id  FOREIGN KEY (product_id)
        REFERENCES ecommerce.products (id) ON DELETE CASCADE
);

CREATE TABLE ecommerce.orders (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id INTEGER       NOT NULL,
    total       NUMERIC(10,2) NOT NULL DEFAULT 0,
    status      VARCHAR(30)   NOT NULL DEFAULT 'pending',
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_orders_customer_id FOREIGN KEY (customer_id)
        REFERENCES ecommerce.customers (id) ON DELETE RESTRICT,
    CONSTRAINT chk_orders_total CHECK (total >= 0)
);

CREATE TABLE ecommerce.order_items (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id    INTEGER       NOT NULL,
    product_id  INTEGER       NOT NULL,
    quantity    INTEGER       NOT NULL,
    unit_price  NUMERIC(10,2) NOT NULL,
    CONSTRAINT fk_order_items_order_id   FOREIGN KEY (order_id)
        REFERENCES ecommerce.orders (id)   ON DELETE CASCADE,
    CONSTRAINT fk_order_items_product_id FOREIGN KEY (product_id)
        REFERENCES ecommerce.products (id) ON DELETE RESTRICT,
    CONSTRAINT chk_order_items_quantity   CHECK (quantity > 0),
    CONSTRAINT chk_order_items_unit_price CHECK (unit_price >= 0)
);
