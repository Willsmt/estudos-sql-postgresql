-- =============================================================
-- Schema: Blog System
-- Database: estudodb
-- Description: Entities for a blog with users, posts, comments
--              and tags. Demonstrates 1:N and N:N relationships.
-- =============================================================


CREATE TABLE blog.usuarios (
    id            INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    username      VARCHAR(50)  NOT NULL,
    email         VARCHAR(150) NOT NULL,
    password_hash TEXT         NOT NULL,
    is_active     BOOLEAN      NOT NULL DEFAULT true,
    created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_usuarios_username UNIQUE (username),
    CONSTRAINT uq_usuarios_email    UNIQUE (email)
);

CREATE TABLE blog.tags (
    id   INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    CONSTRAINT uq_tags_name UNIQUE (name)
);

CREATE TABLE blog.posts (
    id         INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id    INTEGER      NOT NULL,
    title      VARCHAR(200) NOT NULL,
    content    TEXT         NOT NULL,
    is_active  BOOLEAN      NOT NULL DEFAULT true,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_posts_user_id FOREIGN KEY (user_id)
        REFERENCES blog.usuarios (id) ON DELETE RESTRICT
);

CREATE TABLE blog.comentarios (
    id         INTEGER   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id    INTEGER   NOT NULL,
    user_id    INTEGER   NOT NULL,
    content    TEXT      NOT NULL,
    is_active  BOOLEAN   NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comentarios_post_id  FOREIGN KEY (post_id)
        REFERENCES blog.posts (id)     ON DELETE CASCADE,
    CONSTRAINT fk_comentarios_user_id  FOREIGN KEY (user_id)
        REFERENCES blog.usuarios (id)  ON DELETE RESTRICT
);

CREATE TABLE blog.post_tags (
    post_id INTEGER NOT NULL,
    tag_id  INTEGER NOT NULL,
    PRIMARY KEY (post_id, tag_id),
    CONSTRAINT fk_post_tags_post_id FOREIGN KEY (post_id)
        REFERENCES blog.posts (id) ON DELETE CASCADE,
    CONSTRAINT fk_post_tags_tag_id  FOREIGN KEY (tag_id)
        REFERENCES blog.tags (id)  ON DELETE RESTRICT
);

