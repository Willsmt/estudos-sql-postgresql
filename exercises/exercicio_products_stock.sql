-- =============================================================
-- Exercicio: Relacionamento entre as tabelas Products e Stock
-- Curso: EBAC - SQL e PostgreSQL
-- Banco:  estudodb (PostgreSQL 18)
-- Autor:  Willians (github.com/Willsmt)
--
-- Objetivo: modelar um relacionamento 1:1 entre produtos e
--           estoque, onde cada produto possui no maximo uma
--           linha de estoque. A cardinalidade 1:1 e garantida
--           pela combinacao de FOREIGN KEY + UNIQUE na FK.
-- =============================================================

-- Schema dedicado ao exercicio (isola dos demais objetos do banco)
CREATE SCHEMA IF NOT EXISTS ecommerce;

-- Remocao previa para permitir re-execucao do script (idempotente).
-- A ordem respeita a dependencia: filha (stock) antes da pai (products).
DROP TABLE IF EXISTS ecommerce.stock;
DROP TABLE IF EXISTS ecommerce.products;


-- -------------------------------------------------------------
-- Tabela PAI: products
-- -------------------------------------------------------------
CREATE TABLE ecommerce.products (
    id          INTEGER       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(200)  NOT NULL,
    description TEXT,
    price       NUMERIC(10,2) NOT NULL,
    is_active   BOOLEAN       NOT NULL DEFAULT true,
    created_at  TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_products_price CHECK (price >= 0)
);


-- -------------------------------------------------------------
-- Tabela FILHA: stock
--
-- O relacionamento 1:1 e formado por duas regras:
--   1) fk_stock_product_id -> liga cada estoque a um produto
--      existente (integridade referencial).
--   2) uq_stock_product_id -> impede que o mesmo product_id
--      apareca mais de uma vez, travando a cardinalidade em 1:1.
--      (Sem este UNIQUE, o relacionamento seria 1:N.)
--
-- ON DELETE CASCADE: o estoque nao faz sentido sem o produto,
-- entao e removido junto quando o produto e excluido.
-- -------------------------------------------------------------
CREATE TABLE ecommerce.stock (
    id          INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id  INTEGER   NOT NULL,
    quantity    INTEGER   NOT NULL DEFAULT 0,
    updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_stock_product_id UNIQUE (product_id),
    CONSTRAINT chk_stock_quantity  CHECK  (quantity >= 0),
    CONSTRAINT fk_stock_product_id FOREIGN KEY (product_id)
        REFERENCES ecommerce.products (id) ON DELETE CASCADE
);


-- -------------------------------------------------------------
-- Dados de demonstracao
-- -------------------------------------------------------------
INSERT INTO ecommerce.products (name, description, price) VALUES
    ('Teclado Mecanico',  'Switch marrom, ABNT2',      349.90),
    ('Mouse Gamer',       '16000 DPI, RGB',            199.90),
    ('Monitor 27 144Hz',  'IPS, 2K, FreeSync',        1899.00);

INSERT INTO ecommerce.stock (product_id, quantity) VALUES
    (1, 25),
    (2, 80),
    (3, 12);


-- -------------------------------------------------------------
-- Consulta de demonstracao: INNER JOIN unindo produto + estoque
-- -------------------------------------------------------------
SELECT p.id,
       p.name,
       p.price,
       s.quantity AS stock_quantity
FROM ecommerce.products p
INNER JOIN ecommerce.stock s ON s.product_id = p.id
WHERE p.is_active = true
ORDER BY p.id;
