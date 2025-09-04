<p align="center">
  <img src="https://img.shields.io/badge/status-em%20desenvolvimento-yellow?style=for-the-badge" alt="Status: em desenvolvimento"/>
  <img src="https://img.shields.io/badge/stack-SQL-blue?style=for-the-badge" alt="Stack: SQL"/>
  <img src="https://img.shields.io/badge/domain-Imobiliaria-334155?style=for-the-badge" alt="Domínio: Imobiliária"/>
  <img src="https://img.shields.io/badge/SaaS-modelagem-0ea5e9?style=for-the-badge" alt="SaaS: modelagem"/>
</p>

# 💼 Imobiliaria — Modelagem de Banco para SaaS

> **Objetivo:** disponibilizar uma **modelagem inicial** de banco de dados para um sistema **SaaS de imobiliárias**. O foco é oferecer um ponto de partida limpo e didático para evoluir em **normalização, multitenancy e governança de dados**.

- 📂 Esquema principal: `bd_imobiliaria.sql`  
- 🧭 Status: **inicial** (em evolução; ajustes de *tenant* planejados)  
- 🧪 Ideal para: estudos, POCs e bases de TCC/portfólio

---

## 📑 Sumário
- [Visão Geral](#visao-geral)
- [Como Executar](#como-executar)
- [Estratégia de Multitenancy (Roadmap)](#estrategia-de-multitenancy-roadmap)
- [Boas Práticas e Padrões](#boas-praticas-e-padroes)
- [Consultas de Exemplo](#consultas-de-exemplo)
- [Roadmap Técnico](#roadmap-tecnico)
- [Contribuição](#contribuicao)
- [Autor](#autor)

---

## 🔎 Visão Geral
<a id="visao-geral"></a>

Este repositório oferece um **esquema SQL** para o domínio imobiliário (aluguel/venda, contratos, partes envolvidas, etc.).  
A proposta é ser **claro e extensível**, permitindo evoluir para cenários comuns de multi-empresas (*multi-tenant*), auditoria e relatórios.

Sugestões de entidades típicas do domínio (podem variar conforme sua evolução do schema):

- **imovel**, **endereco**, **proprietario**, **locatario**, **contrato**, **pagamento**, **manutencao**
- Entidades de apoio: **usuario**, **perfil**, **permissao**
- Entidade de isolamento (futuro): **tenant** (ex.: imobiliária/cliente)

> Para visualizar o modelo: importe o `.sql` em ferramentas como **DBeaver**, **pgAdmin**, **MySQL Workbench** ou gere um ERD via **dbdiagram.io**.

---

## ⚙️ Como Executar
<a id="como-executar"></a>

> O arquivo `bd_imobiliaria.sql` contém a estrutura (DDL). Abaixo, exemplos rápidos para **PostgreSQL** e **MySQL/MariaDB**.  
> Ajuste nomes/usuários/senhas conforme seu ambiente.

### PostgreSQL (local)
```bash
# 1) Criar banco
createdb imobiliaria

# 2) Importar schema
psql -d imobiliaria -f bd_imobiliaria.sql
```

### MySQL/MariaDB (local)
```bash
# 1) Criar banco
mysql -u root -p -e "CREATE DATABASE imobiliaria CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2) Importar schema
mysql -u root -p imobiliaria < bd_imobiliaria.sql
```

### Docker (Postgres) — opcional
```bash
docker run -d --name pg-imob -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=imobiliaria -p 5432:5432 postgres:16
# Quando o container estiver pronto:
docker cp bd_imobiliaria.sql pg-imob:/bd_imobiliaria.sql
docker exec -it pg-imob psql -U postgres -d imobiliaria -f /bd_imobiliaria.sql
```

> *Seeds (opcional):* crie um `scripts/seed_exemplo.sql` com **inserts** fictícios para testes e execute após a importação do schema.

---

## 🏷️ Estratégia de Multitenancy (Roadmap)
<a id="estrategia-de-multitenancy-roadmap"></a>

A evolução natural é suportar **múltiplas imobiliárias/empresas** no mesmo banco (**isolamento lógico**):

- Adicionar **`tenant_id`** nas tabelas de domínio.
- Garantir **chaves estrangeiras** com `tenant_id` acoplado (ex.: `(id, tenant_id)` como PK composta, ou `tenant_id` + PK simples).
- Criar **índices** por `tenant_id` e aplicar **políticas de acesso** (ex.: RLS no PostgreSQL) para cada usuário/empresa ver apenas seus dados.
- Alternativas: **schema por tenant** (isolamento por schema) ou **database por tenant** (isolamento máximo) — com custos/benefícios distintos.

---

## 🧭 Boas Práticas e Padrões
<a id="boas-praticas-e-padroes"></a>

- **Nomes descritivos** para tabelas/colunas (snake_case).
- **Chaves primárias** inteiras (`BIGSERIAL`/`AUTO_INCREMENT`) ou UUIDs conforme necessidade.
- **Integridade referencial** (FKs obrigatórias).
- **Campos de auditoria**: `created_at`, `updated_at`, `created_by`, `updated_by`.
- **Soft delete** (opcional): `deleted_at` para preservar histórico.
- **Índices** para consultas frequentes (por `tenant_id`, `status`, `created_at`).
- **Views** para relatórios (ex.: `vw_contratos_ativos`, `vw_inadimplencia`).
- **Segurança/PII:** dados pessoais (CPF, e-mail, telefone) devem seguir boas práticas de privacidade e LGPD.

---

## 🔍 Consultas de Exemplo
<a id="consultas-de-exemplo"></a>

> Ajuste nomes de tabelas/colunas conforme seu schema.

### Contratos ativos por período
```sql
SELECT c.id, c.data_inicio, c.data_fim, l.nome AS locatario, i.codigo AS imovel
FROM contrato c
JOIN locatario l ON l.id = c.locatario_id
JOIN imovel i    ON i.id = c.imovel_id
WHERE c.data_inicio <= CURRENT_DATE
  AND (c.data_fim IS NULL OR c.data_fim >= CURRENT_DATE);
```

### Inadimplência (pagamentos em atraso)
```sql
SELECT p.id, p.vencimento, p.valor, l.nome AS locatario
FROM pagamento p
JOIN contrato c ON c.id = p.contrato_id
JOIN locatario l ON l.id = c.locatario_id
WHERE p.status = 'EM_ABERTO'
  AND p.vencimento < CURRENT_DATE;
```

### Vacância de imóveis (sem contrato ativo)
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

## 🗺️ Roadmap Técnico
<a id="roadmap-tecnico"></a>

- **v0.2**
  - Documentar entidades principais no README (tabelas e relações).
  - Adicionar **seeds** básicos (`scripts/seed_exemplo.sql`).
  - Criar **diagramas ER** (PNG/SVG) em `/docs/erd`.

- **v0.3**
  - Introduzir **`tenant_id`** e índices por tenant.
  - Adicionar **views** de relatórios: contratos ativos, inadimplência, vacância.
  - Configurar **GitHub Actions** para validar o schema (spin-up de DB + import DDL).

- **v0.4**
  - Criar **políticas de acesso** (RLS no Postgres) ou equivalente.
  - **Migrations** com **Flyway** ou **Liquibase**.
  - Publicar **Release v1.0** quando o modelo estabilizar.

> **Topics sugeridos (GitHub):** `sql`, `database`, `er-diagram`, `saas`, `real-estate`, `multitenancy` (e o SGBD preferido: `postgresql` ou `mysql`).

---

## 🤝 Contribuição
<a id="contribuicao"></a>

1. Faça um **fork** do projeto.  
2. Crie uma **branch**: `git checkout -b feat/minha-melhoria`  
3. Commit: `git commit -m "feat: descreva sua melhoria"`  
4. Push: `git push origin feat/minha-melhoria`  
5. Abra um **Pull Request** com contexto e screenshots (se houver).

> Sugestões bem-vindas: diagramas ER, seeds, views, índices, RLS, migrações.

---

## 👤 Autor
<a id="autor"></a>

**André Dosciati**  
Especialista em **Redes | Dados e Segurança | Educador em Tecnologia**  
🔗 **LinkedIn:** https://www.linkedin.com/in/andredosciati/  
🔗 **GitHub:** https://github.com/dosciati
