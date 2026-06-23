-- =============================================================
-- Schema: E-commerce System
-- Database: estudodb
-- Description: Customer registration with addresses, phones,
--              products and orders. Demonstrates 1:1, 1:N and
--              N:N relationships with ON DELETE strategies.
-- =============================================================

-- Root entity — no foreign keys
CREATE TABLE IF NOT EXISTS customers (
    id         SERIAL PRIMARY KEY,
    full_name  VARCHAR(100) NOT NULL,
    email      VARCHAR(255) NOT NULL UNIQUE,
    tax_id     VARCHAR(14)  NOT NULL UNIQUE,
    birth_date DATE,
    is_active  BOOLEAN      DEFAULT true,
    created_at TIMESTAMPTZ  DEFAULT NOW()
);

-- Independent entity — no foreign keys
CREATE TABLE IF NOT EXISTS products (
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(255)   NOT NULL,
    description TEXT,
    price       NUMERIC(10, 2) NOT NULL,
    stock       INTEGER        DEFAULT 0,
    is_active   BOOLEAN        DEFAULT true,
    created_at  TIMESTAMPTZ    DEFAULT NOW()
);

-- Depends on: customers (1:N)
-- CASCADE: deleting a customer removes their addresses
CREATE TABLE IF NOT EXISTS addresses (
    id           SERIAL PRIMARY KEY,
    customer_id  INTEGER      NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    street       VARCHAR(255) NOT NULL,
    number       VARCHAR(10),
    complement   VARCHAR(100),
    neighborhood VARCHAR(100),
    city         VARCHAR(100) NOT NULL,
    state        CHAR(2)      NOT NULL,
    zip_code     VARCHAR(9)   NOT NULL,
    is_primary   BOOLEAN      DEFAULT false
);

-- Depends on: customers (1:N)
-- CASCADE: deleting a customer removes their phone numbers
CREATE TABLE IF NOT EXISTS phone_numbers (
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER     NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    number      VARCHAR(15) NOT NULL,
    type        VARCHAR(20) DEFAULT 'mobile'
);

-- Depends on: customers (1:N)
-- RESTRICT: cannot delete a customer who has orders
CREATE TABLE IF NOT EXISTS orders (
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER        NOT NULL REFERENCES customers(id) ON DELETE RESTRICT,
    status      VARCHAR(20)    DEFAULT 'pending',
    total       NUMERIC(10, 2) DEFAULT 0,
    created_at  TIMESTAMPTZ    DEFAULT NOW()
);

-- N:N pivot: orders <-> products
-- unit_price stores the price at time of purchase (immutable history)
-- RESTRICT on product: cannot delete a product already sold
CREATE TABLE IF NOT EXISTS order_items (
    id         SERIAL PRIMARY KEY,
    order_id   INTEGER        NOT NULL REFERENCES orders(id)   ON DELETE CASCADE,
    product_id INTEGER        NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity   INTEGER        NOT NULL DEFAULT 1,
    unit_price NUMERIC(10, 2) NOT NULL
);
