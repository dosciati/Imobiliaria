
<p align="center">
  <img src="https://img.shields.io/badge/status-em%20desenvolvimento-yellow?style=for-the-badge" alt="Status: em desenvolvimento"/>
  <img src="https://img.shields.io/badge/stack-MySQL-blue?style=for-the-badge" alt="Stack: MySQL"/>
  <img src="https://img.shields.io/badge/domain-Imobili%C3%A1ria-334155?style=for-the-badge" alt="Domínio: Imobiliária"/>
  <img src="https://img.shields.io/badge/SaaS-modelagem-0ea5e9?style=for-the-badge" alt="SaaS: modelagem"/>
</p>

# 💼 Imobiliaria — Modelagem de Banco para SaaS

> **Objetivo:** disponibilizar uma **modelagem inicial** de banco de dados para um sistema **SaaS de imobiliárias**. O foco é oferecer um ponto de partida limpo e didático para evoluir em **normalização, multitenancy e governança de dados**.

- 📂 Esquema principal: `sql/01_schema.sql`  
- 🧭 Status: **inicial**, em evolução (multitenancy em roadmap)  
- 🧪 Ideal para: estudos, POCs e bases de TCC/portfólio

---

## 📑 Sumário

- [Visão Geral](#visao-geral)
- [Estrutura e Padrões](#estrutura-e-padroes)
- [Como Executar](#como-executar)
- [Consultas de Exemplo](#consultas-de-exemplo)
- [Roadmap (inclui Multitenancy)](#roadmap-inclui-multitenancy)
- [Contribuição](#contribuicao)
- [Autor](#autor)

---

## 🔎 Visão Geral
<a id="visao-geral"></a>

Este repositório oferece um **esquema SQL** para o domínio imobiliário (aluguel/venda, contratos, partes envolvidas, etc.), com foco em simplicidade e extensibilidade.

Entidades centrais do domínio (nomes podem variar conforme a evolução do schema):

- **profissoes**, **tipo_endereco**, **endereco**, **contato**, **pessoa**
- **Regiao**, **Estado**, **Municipio**, **Bairro**
- **contrutora**, **finalidade_busca**, **tipo_imovel**, **localizacao**
- Tabelas de apoio/segurança: **perm_system**, **acesso_tipo**, **acessos**, **pessoa_has_identifica**, **identifica**
- (Futuro) **tenant** para isolamento lógico multi-empresa

> Para visualizar o modelo, importe o `.sql` em ferramentas como **DBeaver**, **MySQL Workbench** ou gere um ERD via **dbdiagram.io**. Diagramas estáticos podem ser adicionados em `docs/erd`.

---

## 🧭 Estrutura e Padrões
<a id="estrutura-e-padroes"></a>

- **Banco/SGBD:** MySQL 8+
- **Charset/Collation:** `utf8mb4` / `utf8mb4_unicode_ci`
- **Convenções**
  - Tabelas/colunas em `snake_case`
  - **PKs inteiras autoincrement** (`INT` + `AUTO_INCREMENT`), FKs obrigatórias
  - **Campos de auditoria** (sugeridos): `created_at`, `updated_at` (ainda não implementados)
  - **Soft delete** (opcional): `deleted_at`
- **Índices** otimizados para joins e consultas frequentes (ver `sql/indexes.sql`)
- **Seeds** para popular dados mínimos (ver `sql/seed.sql`)

---

## ⚙️ Como Executar
<a id="como-executar"></a>

> Os arquivos ficam no diretório `sql/`:
> - `sql/01_schema.sql` — DDL
> - `02_seed_minimo.sql` — dados iniciais
> - `03_indexes.sql` — índices adicionais

### Opção A — Docker Compose (recomendado)
```bash
# 1) Subir serviços
docker compose up -d

# 2) (Opcional) Acompanhar logs
docker compose logs -f mysql

# 3) Importar schema + seeds + índices
docker exec -i mysql \
  sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h127.0.0.1' < sql/01_schema.sql.sql

docker exec -i mysql \
  sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h127.0.0.1 01_schema.sql' < sql/02_seed_minimo.sql

docker exec -i mysql \
  sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h127.0.0.1 01_schema.sql' < sql/03_indexes.sql
```

> O workflow de CI usa `127.0.0.1` para conexão MySQL (compatibilidade com GitHub Actions).

### Opção B — MySQL local
```bash
# 1) Criar banco com charset/collation recomendados
mysql -u root -p -e "CREATE DATABASE 01_schema.sql CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2) Importar schema, seed e índices
mysql -u root -p bd_imobiliaria < sql/01_schema.sql.sql
mysql -u root -p bd_imobiliaria < sql/02_seed_minimo.sql
mysql -u root -p bd_imobiliaria < sql/03_indexes.sql
```

### Verificação rápida
```sql
-- Tabelas essenciais com ao menos 1 linha?
SELECT 'Regiao' AS tabela, COUNT(*) AS qtd FROM Regiao
UNION ALL SELECT 'Estado', COUNT(*) FROM Estado
UNION ALL SELECT 'Municipio', COUNT(*) FROM Municipio
UNION ALL SELECT 'tipo_endereco', COUNT(*) FROM tipo_endereco
UNION ALL SELECT 'endereco', COUNT(*) FROM endereco
UNION ALL SELECT 'profissoes', COUNT(*) FROM profissoes
UNION ALL SELECT 'contato', COUNT(*) FROM contato
UNION ALL SELECT 'pessoa', COUNT(*) FROM pessoa
UNION ALL SELECT 'construtora', COUNT(*) FROM contrutora
UNION ALL SELECT 'finalidade_busca', COUNT(*) FROM finalidade_busca
UNION ALL SELECT 'tipo_imovel', COUNT(*) FROM tipo_imovel
UNION ALL SELECT 'localizacao', COUNT(*) FROM localizacao;
```

---

## 🔍 Consultas de Exemplo
<a id="consultas-de-exemplo"></a>

> Ajuste nomes de colunas conforme seu client/visões.

**Contratos ativos por período (exemplo conceitual)**  
```sql
SELECT c.id, c.data_inicio, c.data_fim, l.nome AS locatario, i.codigo AS imovel
FROM contrato c
JOIN locatario l ON l.id = c.locatario_id
JOIN imovel i    ON i.id = c.imovel_id
WHERE c.data_inicio <= CURRENT_DATE
  AND (c.data_fim IS NULL OR c.data_fim >= CURRENT_DATE);
```

**Inadimplência (pagamentos em atraso) — conceitual**  
```sql
SELECT p.id, p.vencimento, p.valor, l.nome AS locatario
FROM pagamento p
JOIN contrato c ON c.id = p.contrato_id
JOIN locatario l ON l.id = c.locatario_id
WHERE p.status = 'EM_ABERTO'
  AND p.vencimento < CURRENT_DATE;
```

**Vacância de imóveis (sem contrato ativo) — conceitual**  
```sql
SELECT i.id, i.codigo, i.tipo, i.cidade
FROM imovel i
LEFT JOIN contrato c
  ON c.imovel_id = i.id
 AND c.data_inicio <= CURRENT_DATE
 AND (c.data_fim IS NULL OR c.data_fim >= CURRENT_DATE)
WHERE c.id IS NULL;
```

---

## 🗺️ Roadmap (inclui Multitenancy)
<a id="roadmap-inclui-multitenancy"></a>

- **v0.2**
  - Documentar entidades principais no README (tabelas e relações).
  - Adicionar **seeds** básicos (`sql/02_seed_minimo.sql`).
  - Criar **diagramas ER** (PNG/SVG) em `docs/erd`.

- **v0.3**
  - Introduzir **tenant_id** e índices por tenant (em tabelas de domínio).
  - Adicionar **views** de relatórios: contratos ativos, inadimplência, vacância.
  - Configurar **GitHub Actions** para validar o schema (spin-up de DB + import DDL).

- **v0.4**
  - Criar **políticas de acesso** (RLS equivalente no MySQL via views + filtros por usuário).
  - **Migrations** com **Flyway** ou **Liquibase**.
  - Publicar **Release v1.0** quando o modelo estabilizar.

> **Topics sugeridos (GitHub):** `sql`, `database`, `er-diagram`, `saas`, `real-estate`, `multitenancy`, `mysql`.

---

## 🤝 Contribuição
<a id="contribuicao"></a>

1. Faça um **fork** do projeto.  
2. Crie uma **branch**: `git checkout -b feat/minha-melhoria`  
3. Commit: `git commit -m "feat: descreva sua melhoria"`  
4. Push: `git push origin feat/minha-melhoria`  
5. Abra um **Pull Request** com contexto e screenshots (se houver).

> Sugestões bem-vindas: diagramas ER, seeds, views, índices, políticas de acesso, migrações.

---

## 👤 Autor
<a id="autor"></a>

**André Dosciati**  
Especialista em **Redes | Dados e Segurança | Educador em Tecnologia**  
🔗 **LinkedIn:** https://www.linkedin.com/in/andredosciati/  
🔗 **GitHub:** https://github.com/dosciati
