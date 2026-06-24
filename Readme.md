# estudos-sql-postgresql

Repositório de estudos de SQL e modelagem relacional com PostgreSQL.
Parte da trilha de formação Full Stack com foco em segurança defensiva.

---

## Ambiente

| Componente | Versão / Detalhe             |
|------------|------------------------------|
| **SGBD**   | PostgreSQL 18                |
| **SO**     | Ubuntu 26.04 LTS             |
| **Acesso** | SSH Tunnel via chave ed25519 |
| **Client** | DBeaver 26 (Community)       |
| **Banco**  | `estudodb`                   |
| **Role**   | `devuser` (sem superuser)    |

A porta 5432 não é exposta na rede — o acesso ao banco é feito exclusivamente via SSH tunnel, mantendo o princípio do menor privilégio.

---

## Estrutura

```
estudos-sql-postgresql/
├── schemas/
│   ├── blog.sql                  # Sistema de blog (5 tabelas)
│   └── ecommerce.sql             # Sistema de e-commerce (7 tabelas)
├── diagrams/
│   ├── blog_erd.png              # Diagrama ER — Blog
│   └── ecommerce_erd.png         # Diagrama ER — E-commerce
├── docs/
│   ├── apostila_sql_modulo1.pdf  # Módulo 1 — Fundamentos e Modelagem
│   └── apostila_sql_modulo2.pdf  # Módulo 2 — DDL na Prática
└── README.md
```

---

## Documentação

| Arquivo | Conteúdo |
|---------|----------|
| `docs/apostila_sql_modulo1.pdf` | Introdução ao SQL, SGBDs, PostgreSQL, DBeaver, ERD e Modelagem Relacional |
| `docs/apostila_sql_modulo2.pdf` | DDL, Tipos de Dados, Constraints, SERIAL, IDENTITY e Sequences |

---

## Schemas

### Blog System (`schemas/blog.sql`)

Sistema de blog com usuários, posts, comentários e tags.

```
usuarios (1) ──< posts        (N)
usuarios (1) ──< comentarios  (N)
posts    (1) ──< comentarios  (N)
posts   (N) >──< tags         (N)  via post_tags
```

**Tabelas:** `usuarios`, `tags`, `posts`, `comentarios`, `post_tags`

---

### E-commerce System (`schemas/ecommerce.sql`)

Cadastro de clientes com endereços, telefones, produtos, estoque e pedidos.

```
customers (1) ──< addresses     (N)
customers (1) ──< phone_numbers (N)
customers (1) ──< orders        (N)
orders    (1) ──< order_items   (N)
products  (1) ──< order_items   (N)
products  (1) ──  stock         (1)
```

**Tabelas:** `customers`, `products`, `stock`, `addresses`, `phone_numbers`, `orders`, `order_items`

---

## Decisões de Modelagem

### ON DELETE CASCADE vs RESTRICT

| Relação                  | Estratégia | Motivo                                  |
|--------------------------|------------|-----------------------------------------|
| customer → addresses     | CASCADE    | Endereço não existe sem cliente         |
| customer → phone_numbers | CASCADE    | Telefone não existe sem cliente         |
| customer → orders        | RESTRICT   | Pedido tem valor histórico e fiscal     |
| product → order_items    | RESTRICT   | Não se apaga produto que já foi vendido |
| order → order_items      | CASCADE    | Item não existe sem o pedido            |
| product → stock          | CASCADE    | Estoque não existe sem produto          |

### `unit_price` em `order_items`

O preço é gravado no momento da compra, separado do `price` em `products`. Se o produto mudar de preço depois, o histórico financeiro do pedido permanece correto.

### `stock` como tabela separada

O estoque foi modelado como tabela independente com relação 1:1 com `products` (via `UNIQUE` em `product_id`). Isso permite rastrear movimentações futuramente sem tocar na tabela de produtos.

### `tax_id` em vez de `cpf`

Nomenclatura agnóstica ao país — compatível com projetos internacionais e com o Django ORM.

### `is_active` (soft delete)

Clientes e produtos não são deletados do banco — apenas desativados. Preserva integridade referencial e histórico de pedidos.

### `GENERATED ALWAYS AS IDENTITY` em vez de `SERIAL`

Padrão ANSI SQL a partir do PostgreSQL 10. Mais explícito, portável e seguro — impede sobrescrita acidental de IDs pela aplicação.

---

## Como executar

```bash
# Conectar ao banco
psql -U devuser -d estudodb

# Executar os schemas na ordem correta
psql -U devuser -d estudodb -f schemas/blog.sql
psql -U devuser -d estudodb -f schemas/ecommerce.sql
```

---

## Módulos Concluídos

| Módulo   | Conteúdo                                                                 | Apostila                        |
|----------|--------------------------------------------------------------------------|---------------------------------|
| Módulo 1 | Introdução ao SQL, SGBDs, PostgreSQL, instalação, DBeaver, ERD, modelagem | `docs/apostila_sql_modulo1.pdf` |
| Módulo 2 | DDL: schemas, tabelas, tipos de dados, constraints, IDENTITY, sequences  | `docs/apostila_sql_modulo2.pdf` |

---

## Próximos Passos

- [x] Modelagem e criação dos schemas blog e e-commerce
- [x] Diagramas ERD (PT e EN) no Lucidchart
- [x] Configuração do DBeaver via SSH Tunnel
- [ ] Módulo 3 — DML: INSERT, UPDATE, DELETE
- [ ] Módulo 4 — DQL básico: SELECT, WHERE, ORDER BY, LIMIT
- [ ] Módulo 5 — DQL avançado: JOIN, GROUP BY, subqueries, CTEs
- [ ] Módulo 6 — Performance: índices e EXPLAIN ANALYZE
- [ ] Módulo 7 — Integração com Django ORM: models e migrations
