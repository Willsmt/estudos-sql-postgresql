-- =============================================================
-- Seed: blog schema
-- Banco:  estudodb | Role: devuser
-- Módulo: 3 — DML (INSERT, UPDATE, DELETE, Subqueries)
-- Uso:    psql -h localhost -U devuser -d estudodb -f seeds/blog_seed.sql
-- =============================================================

-- Limpar e reiniciar sequences (ordem respeitando FKs)
TRUNCATE blog.tags     RESTART IDENTITY CASCADE;
TRUNCATE blog.usuarios RESTART IDENTITY CASCADE;

-- -------------------------------------------------------------
-- Usuarios
-- -------------------------------------------------------------
INSERT INTO blog.usuarios (username, email, password_hash)
VALUES
  ('willians',    'willians@email.com', 'hash_w'),
  ('maria_silva', 'maria@email.com',    'hash_m'),
  ('joao_dev',    'joao@email.com',     'hash_j'),
  ('ana_tech',    'ana@email.com',      'hash_a');

-- -------------------------------------------------------------
-- Tags
-- -------------------------------------------------------------
INSERT INTO blog.tags (name)
VALUES
  ('postgresql'),
  ('backend'),
  ('segurança');

-- -------------------------------------------------------------
-- Posts
-- -------------------------------------------------------------
INSERT INTO blog.posts (user_id, title, content)
VALUES
  (1, 'Meu primeiro post',  'Conteúdo sobre PostgreSQL e DML.'),
  (2, 'Dicas de Python',    'Conteúdo sobre Python e boas práticas.'),
  (2, 'Linux para devs',    'Comandos essenciais do terminal Linux.'),
  (3, 'Node.js na prática', 'APIs REST com Node e Express.');

-- -------------------------------------------------------------
-- Comentarios
-- -------------------------------------------------------------
INSERT INTO blog.comentarios (post_id, user_id, content)
VALUES
  (1, 2, 'Muito bom!'),
  (2, 3, 'Excelente conteúdo.'),
  (3, 1, 'Gostei bastante.');

-- -------------------------------------------------------------
-- DML praticado na Aula 3
-- -------------------------------------------------------------

-- Soft delete: ana_tech desativada
UPDATE blog.usuarios
SET is_active = false
WHERE username = 'ana_tech';

-- Update: willians renomeado para willians_dev
UPDATE blog.usuarios
SET username = 'willians_dev'
WHERE id = 1;
