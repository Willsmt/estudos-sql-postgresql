-- =============================================================
-- Seed: ecommerce schema
-- Banco:  estudodb | Role: devuser
-- Módulo: 3 — DML (INSERT, UPDATE, DELETE, Subqueries)
-- Uso:    psql -h localhost -U devuser -d estudodb -f seeds/ecommerce_seed.sql
-- =============================================================

-- Limpar e reiniciar sequences (ordem respeitando FKs)
TRUNCATE ecommerce.products  RESTART IDENTITY CASCADE;
TRUNCATE ecommerce.customers RESTART IDENTITY CASCADE;

-- -------------------------------------------------------------
-- Customers
-- -------------------------------------------------------------
INSERT INTO ecommerce.customers (full_name, email, tax_id)
VALUES
  ('Willians Matos', 'willians@email.com', '111.111.111-11'),
  ('Maria Silva',    'maria@email.com',    '222.222.222-22'),
  ('João Oliveira',  'joao@email.com',     '333.333.333-33'),
  ('Ana Costa',      'ana@email.com',      '444.444.444-44'),
  ('Carlos Pereira', 'carlos@email.com',   '555.555.555-55');

-- -------------------------------------------------------------
-- Addresses
-- -------------------------------------------------------------
INSERT INTO ecommerce.addresses (customer_id, street, city, state, zip_code)
VALUES
  (1, 'Rua das Flores, 100',    'Ferraz de Vasconcelos', 'SP', '08500-000'),
  (2, 'Av. Paulista, 1000',     'São Paulo',             'SP', '01310-100'),
  (3, 'Rua XV de Novembro, 50', 'Curitiba',              'PR', '80020-310'),
  (4, 'Rua das Palmeiras, 200', 'Rio de Janeiro',        'RJ', '20040-020'),
  (5, 'Av. Beira Mar, 300',     'Florianópolis',         'SC', '88010-000');

-- -------------------------------------------------------------
-- Phone Numbers
-- -------------------------------------------------------------
INSERT INTO ecommerce.phone_numbers (customer_id, number)
VALUES
  (1, '(11) 91111-1111'),
  (2, '(11) 92222-2222'),
  (2, '(11) 92222-3333'),
  (3, '(41) 93333-3333'),
  (4, '(21) 94444-4444'),
  (5, '(48) 95555-5555');

-- -------------------------------------------------------------
-- Products
-- -------------------------------------------------------------
INSERT INTO ecommerce.products (name, description, price)
VALUES
  ('Teclado Mecânico', 'Switch blue, ABNT2',         349.90),
  ('Mouse Gamer',      '16000 DPI, RGB',             199.90),
  ('Monitor 24"',      'Full HD, 144hz, IPS',       1299.90),
  ('Headset USB',      'Som surround 7.1',           249.90),
  ('Webcam Full HD',   '1080p, microfone embutido',  189.90);

-- -------------------------------------------------------------
-- Stock
-- -------------------------------------------------------------
INSERT INTO ecommerce.stock (product_id, quantity)
VALUES
  (1, 50),
  (2, 80),
  (3, 20),
  (4, 35),
  (5, 45);

-- -------------------------------------------------------------
-- Orders
-- -------------------------------------------------------------
INSERT INTO ecommerce.orders (customer_id, total, status)
VALUES
  (1, 549.80,  'completed'),
  (2, 1299.90, 'completed'),
  (3, 249.90,  'pending'),
  (4, 389.80,  'completed'),
  (5, 189.90,  'cancelled');

-- -------------------------------------------------------------
-- Order Items
-- -------------------------------------------------------------
INSERT INTO ecommerce.order_items (order_id, product_id, quantity, unit_price)
VALUES
  (1, 1, 1, 349.90),
  (1, 2, 1, 199.90),
  (2, 3, 1, 1299.90),
  (3, 4, 1, 249.90),
  (4, 1, 1, 349.90),
  (4, 2, 1, 199.90),
  (5, 5, 1, 189.90);
