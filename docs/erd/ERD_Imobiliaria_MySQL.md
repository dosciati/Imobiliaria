# ERD — Imobiliaria (MySQL)

> Diagrama lógico gerado a partir do script **MySQL Workbench** enviado.  
> Abra este `.md` no GitHub (ou outro renderer) para visualizar o **Mermaid ER diagram**.

---

## 📦 Tabelas & Relacionamentos (Mermaid)

```mermaid
erDiagram
  regiao {
    INT id PK
    VARCHAR(50) nome
    DATETIME created_at
    DATETIME updated_at
  }

  estado {
    INT id PK
    INT codigo_uf
    VARCHAR(50) nome
    CHAR(2) uf
    INT regiao_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  municipio {
    INT id PK
    INT codigo
    VARCHAR(255) nome
    INT estado_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  bairro {
    INT id PK
    CHAR(10) codigo
    VARCHAR(255) nome
    INT municipio_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  tipo_endereco {
    INT id PK
    VARCHAR(45) descricao
  }

  endereco {
    INT id PK
    VARCHAR(120) rua
    VARCHAR(20) numero
    VARCHAR(120) complemento
    INT tipo_endereco_id FK
    INT bairro_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  profissao {
    INT id PK
    VARCHAR(200) nome
    DATETIME created_at
    DATETIME updated_at
  }

  contato {
    INT id PK
    VARCHAR(45) telefone
    VARCHAR(45) email
    DATETIME created_at
    DATETIME updated_at
  }

  pessoa {
    INT id PK
    VARCHAR(80) nome
    VARCHAR(120) sobrenome
    VARCHAR(200) observacoes
    INT profissao_id
    INT endereco_id FK
    INT municipio_id FK
    INT contato_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  construtora {
    INT id PK
    VARCHAR(120) nome
  }

  finalidade_busca {
    INT id PK
    VARCHAR(45) descricao
  }

  tipo_imovel {
    INT id PK
    VARCHAR(60) descricao
    INT construtora_id FK
    INT finalidade_busca_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  localizacao {
    INT id PK
    VARCHAR(45) topografia
    VARCHAR(45) posicao
    VARCHAR(45) orientacao_solar
    DOUBLE latitude
    DOUBLE longitude
    INT tipo_imovel_id FK
    DATETIME created_at
    DATETIME updated_at
  }

  contato_origem {
    INT id PK
    VARCHAR(45) origem
    DATETIME created_at
    DATETIME updated_at
  }

  contato_contato_origem {
    INT contato_id FK
    INT contato_origem_id FK
    VARCHAR(45) tipo_contato
    VARCHAR(45) tipo_fone
    VARCHAR(45) nome_recado
    PK "contato_id,contato_origem_id"
  }

  permissao_sistema {
    INT id PK
    TINYINT leitura
    TINYINT escrita
    TINYINT gravacao
  }

  acesso_tipo {
    INT id PK
    VARCHAR(45) nome
    INT permissao_sistema_id FK
  }

  acessos {
    INT id PK
    VARCHAR(45) login
    VARCHAR(255) senha
    INT acesso_tipo_id FK
    INT contato_id FK
  }

  identificacao {
    INT id PK
    VARCHAR(45) rg
    VARCHAR(45) creci
    DATE data_nascimento
    VARCHAR(45) cpf_cnpj
    VARCHAR(45) inscricao_municipal
  }

  pessoa_identificacao {
    INT pessoa_id FK
    INT identificacao_id FK
    VARCHAR(20) tipo_pessoa
    VARCHAR(20) estado_civil
    VARCHAR(120) conjuge
    PK "pessoa_id,identificacao_id"
  }

  %% Relações
  estado }o--|| regiao : "regiao_id"
  municipio }o--|| estado : "estado_id"
  bairro }o--|| municipio : "municipio_id"
  endereco }o--|| tipo_endereco : "tipo_endereco_id"
  endereco }o--|| bairro : "bairro_id"
  pessoa }o--|| endereco : "endereco_id"
  pessoa }o--|| municipio : "municipio_id"
  pessoa }o--o| profissao : "profissao_id"
  pessoa }o--|| contato : "contato_id"
  tipo_imovel }o--|| construtora : "construtora_id"
  tipo_imovel }o--|| finalidade_busca : "finalidade_busca_id"
  localizacao }o--|| tipo_imovel : "tipo_imovel_id"
  contato_contato_origem }o--|| contato : "contato_id"
  contato_contato_origem }o--|| contato_origem : "contato_origem_id"
  acesso_tipo }o--|| permissao_sistema : "permissao_sistema_id"
  acessos }o--|| acesso_tipo : "acesso_tipo_id"
  acessos }o--|| contato : "contato_id"
  pessoa_identificacao }o--|| pessoa : "pessoa_id"
  pessoa_identificacao }o--|| identificacao : "identificacao_id"

```
  
---

## 🧭 Observações
- **Mapeamento fiel do SQL**; normalizado nomes apenas para evitar espaços/acentos no diagrama.
- **PKs compostas** marcadas nas entidades dependentes (ex.: `PESSOA`, `IMOBILIARIA`, `TIPO_IMOVEL` e derivadas).
