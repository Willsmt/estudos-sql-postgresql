-- =============================================================
-- Schema: Blog System
-- Database: estudodb
-- Description: Entities for a blog with users, posts, comments
--              and tags. Demonstrates 1:N and N:N relationships.
-- =============================================================

CREATE TABLE IF NOT EXISTS usuarios (
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    email     VARCHAR(255) NOT NULL UNIQUE,
    ativo     BOOLEAN      DEFAULT true,
    criado_em TIMESTAMPTZ  DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tags (
    id   SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

-- Depends on: usuarios
CREATE TABLE IF NOT EXISTS posts (
    id         SERIAL PRIMARY KEY,
    titulo     VARCHAR(255) NOT NULL,
    conteudo   TEXT         NOT NULL,
    usuario_id INTEGER      NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criado_em  TIMESTAMPTZ  DEFAULT NOW()
);

-- Depends on: posts, usuarios
CREATE TABLE IF NOT EXISTS comentarios (
    id         SERIAL PRIMARY KEY,
    texto      TEXT        NOT NULL,
    post_id    INTEGER     NOT NULL REFERENCES posts(id)    ON DELETE CASCADE,
    usuario_id INTEGER     NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    criado_em  TIMESTAMPTZ DEFAULT NOW()
);

-- N:N pivot: posts <-> tags
CREATE TABLE IF NOT EXISTS post_tags (
    post_id INTEGER REFERENCES posts(id) ON DELETE CASCADE,
    tag_id  INTEGER REFERENCES tags(id)  ON DELETE CASCADE,
    PRIMARY KEY (post_id, tag_id)
);
