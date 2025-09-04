-- ======================================================
-- Modelo v0.2 - Imobiliária (MySQL 8+)
-- Ajustes: semântica, naming, PKs simples, FKs, tipos, utf8mb4
-- ======================================================

/* Hardening & session */
SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS; SET UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS; SET FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE;
SET SQL_MODE = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- ======================================================
-- Esquema
-- ======================================================
CREATE SCHEMA IF NOT EXISTS `bd_imobiliaria`
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE `bd_imobiliaria`;

-- ======================================================
-- DROP (apenas se você quer um ambiente limpo)
-- ======================================================
-- DROP TABLE IF EXISTS acesso, tipo_acesso, permissao_sistema,
--   imobiliaria, localizacao, acabamento_imovel, caracteristica_imovel,
--   situacao_imovel, condicao_imovel, tipo_imovel, finalidade_busca, construtora,
--   pessoa_documento, pessoa, documento_identificacao,
--   endereco, tipo_endereco, contato_origem, origem_contato, contato,
--   bairro, municipio, estado, regiao, profissao;

-- ======================================================
-- Tabelas base de localização administrativa
-- ======================================================
CREATE TABLE IF NOT EXISTS regiao (
  id           INT NOT NULL AUTO_INCREMENT,
  nome         VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS estado (
  id         INT NOT NULL AUTO_INCREMENT,
  codigo_uf  INT NOT NULL,
  nome       VARCHAR(50) NOT NULL,
  uf         CHAR(2) NOT NULL,
  regiao_id  INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_estado_regiao (regiao_id),
  CONSTRAINT fk_estado_regiao
    FOREIGN KEY (regiao_id) REFERENCES regiao (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS municipio (
  id         INT NOT NULL AUTO_INCREMENT,
  codigo     INT NOT NULL,
  nome       VARCHAR(255) NOT NULL,
  estado_id  INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_municipio_estado (estado_id),
  CONSTRAINT fk_municipio_estado
    FOREIGN KEY (estado_id) REFERENCES estado (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS bairro (
  id            INT NOT NULL AUTO_INCREMENT,
  codigo        VARCHAR(10) NOT NULL,
  nome          VARCHAR(255) NOT NULL,
  municipio_id  INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_bairro_municipio (municipio_id),
  CONSTRAINT fk_bairro_municipio
    FOREIGN KEY (municipio_id) REFERENCES municipio (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- Tabelas de apoio (contato, endereço, profissao)
-- ======================================================
CREATE TABLE IF NOT EXISTS profissao (
  id         INT NOT NULL AUTO_INCREMENT,
  nome       VARCHAR(200) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tipo_endereco (
  id     INT NOT NULL AUTO_INCREMENT,
  nome   VARCHAR(45) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_tipo_endereco_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS contato (
  id_contato  INT NOT NULL AUTO_INCREMENT,
  nome        VARCHAR(100) NOT NULL,
  email       VARCHAR(120) NULL,
  PRIMARY KEY (id_contato),
  KEY idx_contato_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS origem_contato (
  id         INT NOT NULL AUTO_INCREMENT,
  origem     VARCHAR(45) NOT NULL COMMENT 'Ex.: stand, indicação, site, redes sociais',
  PRIMARY KEY (id),
  UNIQUE KEY uq_origem (origem)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabela de relacionamento contato/origem (sem AUTO_INCREMENT)
CREATE TABLE IF NOT EXISTS contato_origem (
  contato_id        INT NOT NULL,
  origem_contato_id INT NOT NULL,
  tipo_contato      VARCHAR(45) NULL,
  tipo_fone         VARCHAR(45) NULL,
  nome_recado       VARCHAR(45) NULL,
  PRIMARY KEY (contato_id, origem_contato_id),
  KEY idx_co_origem (origem_contato_id),
  CONSTRAINT fk_co_contato
    FOREIGN KEY (contato_id) REFERENCES contato (id_contato)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_co_origem
    FOREIGN KEY (origem_contato_id) REFERENCES origem_contato (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS endereco (
  id               INT NOT NULL AUTO_INCREMENT,
  rua              VARCHAR(120) NOT NULL,
  numero           VARCHAR(20)  NOT NULL,
  complemento      VARCHAR(120) NULL,
  tipo_endereco_id INT NOT NULL,
  bairro_id        INT NULL,
  PRIMARY KEY (id),
  KEY idx_endereco_tipo (tipo_endereco_id),
  KEY idx_endereco_bairro (bairro_id),
  CONSTRAINT fk_endereco_tipo
    FOREIGN KEY (tipo_endereco_id) REFERENCES tipo_endereco (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_endereco_bairro
    FOREIGN KEY (bairro_id) REFERENCES bairro (id)
    ON UPDATE RESTRICT ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Documentos/identificação (antes: identifica)
CREATE TABLE IF NOT EXISTS documento_identificacao (
  id                  INT NOT NULL AUTO_INCREMENT,
  rg                  VARCHAR(45) NULL,
  creci               VARCHAR(45) NULL,
  data_nasc           DATE NULL,
  cpf_cnpj            VARCHAR(20) NOT NULL,
  inscricao_municipal VARCHAR(45) NULL,
  PRIMARY KEY (id),
  KEY idx_doc_cpf_cnpj (cpf_cnpj)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Pessoa (PK simples; FKs diretas)
CREATE TABLE IF NOT EXISTS pessoa (
  id             INT NOT NULL AUTO_INCREMENT,
  nome           VARCHAR(80)  NOT NULL,
  sobrenome      VARCHAR(120) NULL,
  obs            VARCHAR(255) NULL,
  complemento    VARCHAR(120) NULL,
  profissao_id   INT NOT NULL,
  endereco_id    INT NOT NULL,
  municipio_id   INT NOT NULL,
  contato_id     INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_pessoa_profissao (profissao_id),
  KEY idx_pessoa_endereco (endereco_id),
  KEY idx_pessoa_municipio (municipio_id),
  KEY idx_pessoa_contato (contato_id),
  CONSTRAINT fk_pessoa_profissao
    FOREIGN KEY (profissao_id) REFERENCES profissao (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_pessoa_endereco
    FOREIGN KEY (endereco_id) REFERENCES endereco (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_pessoa_municipio
    FOREIGN KEY (municipio_id) REFERENCES municipio (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_pessoa_contato
    FOREIGN KEY (contato_id) REFERENCES contato (id_contato)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Relaciona pessoa a documento + metadados (antes: pessoa_has_identifica)
CREATE TABLE IF NOT EXISTS pessoa_documento (
  pessoa_id               INT NOT NULL,
  documento_identificacao_id INT NOT NULL,
  tipo_pessoa             ENUM('FISICA','JURIDICA') NOT NULL,
  estado_civil            VARCHAR(45) NULL,
  conjuge                 VARCHAR(120) NULL,
  PRIMARY KEY (pessoa_id, documento_identificacao_id),
  KEY idx_pd_doc (documento_identificacao_id),
  CONSTRAINT fk_pd_pessoa
    FOREIGN KEY (pessoa_id) REFERENCES pessoa (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_pd_documento
    FOREIGN KEY (documento_identificacao_id) REFERENCES documento_identificacao (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- Domínio imobiliário
-- ======================================================
CREATE TABLE IF NOT EXISTS construtora (
  id    INT NOT NULL AUTO_INCREMENT,
  nome  VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_construtora_nome (nome)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS finalidade_busca (
  id         INT NOT NULL AUTO_INCREMENT,
  descricao  VARCHAR(45) NOT NULL COMMENT 'moradia, investimento, negócios, outros',
  PRIMARY KEY (id),
  UNIQUE KEY uq_finalidade (descricao)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tipo_imovel (
  id                  INT NOT NULL AUTO_INCREMENT,
  descricao           VARCHAR(100) NOT NULL,
  construtora_id      INT NOT NULL,
  finalidade_busca_id INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_ti_construtora (construtora_id),
  KEY idx_ti_finalidade (finalidade_busca_id),
  CONSTRAINT fk_ti_construtora
    FOREIGN KEY (construtora_id) REFERENCES construtora (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_ti_finalidade
    FOREIGN KEY (finalidade_busca_id) REFERENCES finalidade_busca (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS condicao_imovel (
  id            INT NOT NULL AUTO_INCREMENT,
  descricao     VARCHAR(100) NOT NULL,
  tipo_imovel_id INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_ci_tipo (tipo_imovel_id),
  CONSTRAINT fk_ci_tipo
    FOREIGN KEY (tipo_imovel_id) REFERENCES tipo_imovel (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS situacao_imovel (
  id             INT NOT NULL AUTO_INCREMENT,
  descricao      VARCHAR(100) NOT NULL,
  tipo_imovel_id INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_si_tipo (tipo_imovel_id),
  CONSTRAINT fk_si_tipo
    FOREIGN KEY (tipo_imovel_id) REFERENCES tipo_imovel (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Características (antes: carac_imovel) - descrição textual
CREATE TABLE IF NOT EXISTS caracteristica_imovel (
  id             INT NOT NULL AUTO_INCREMENT,
  descricao      VARCHAR(100) NOT NULL,
  tipo_imovel_id INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_car_tipo (tipo_imovel_id),
  CONSTRAINT fk_car_tipo
    FOREIGN KEY (tipo_imovel_id) REFERENCES tipo_imovel (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Acabamentos (antes: acab_imovel)
CREATE TABLE IF NOT EXISTS acabamento_imovel (
  id             INT NOT NULL AUTO_INCREMENT,
  descricao      VARCHAR(100) NOT NULL,
  tipo_imovel_id INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_acab_tipo (tipo_imovel_id),
  CONSTRAINT fk_acab_tipo
    FOREIGN KEY (tipo_imovel_id) REFERENCES tipo_imovel (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Localização (antes: localizacao - correção de longitude/orientação)
CREATE TABLE IF NOT EXISTS localizacao (
  id               INT NOT NULL AUTO_INCREMENT,
  topografia       VARCHAR(45) NOT NULL,
  posicao          VARCHAR(45) NOT NULL,
  orientacao_solar VARCHAR(45) NOT NULL,
  latitude         DECIMAL(9,6) NULL,
  longitude        DECIMAL(9,6) NULL,
  tipo_imovel_id   INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_loc_tipo (tipo_imovel_id),
  CONSTRAINT fk_loc_tipo
    FOREIGN KEY (tipo_imovel_id) REFERENCES tipo_imovel (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Imobiliária (antes: imobiliaria com PK composta) → PK simples + FKs
CREATE TABLE IF NOT EXISTS imobiliaria (
  id                 INT NOT NULL AUTO_INCREMENT,
  nome               VARCHAR(100) NOT NULL,
  proprietario       VARCHAR(100) NOT NULL,
  pessoa_id          INT NOT NULL,
  endereco_id        INT NOT NULL,
  documento_id       INT NOT NULL,
  contato_id         INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_imob_pessoa (pessoa_id),
  KEY idx_imob_endereco (endereco_id),
  KEY idx_imob_doc (documento_id),
  KEY idx_imob_contato (contato_id),
  CONSTRAINT fk_imob_pessoa
    FOREIGN KEY (pessoa_id) REFERENCES pessoa (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_imob_endereco
    FOREIGN KEY (endereco_id) REFERENCES endereco (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_imob_documento
    FOREIGN KEY (documento_id) REFERENCES documento_identificacao (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_imob_contato
    FOREIGN KEY (contato_id) REFERENCES contato (id_contato)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- Permissões e acesso (antes: perm_system, acesso_tipo, acessos)
-- ======================================================
CREATE TABLE IF NOT EXISTS permissao_sistema (
  id        INT NOT NULL AUTO_INCREMENT,
  leitura   TINYINT(1) NOT NULL DEFAULT 0,
  escrita   TINYINT(1) NOT NULL DEFAULT 0,
  gravacao  TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS tipo_acesso (
  id                    INT NOT NULL AUTO_INCREMENT,
  nome                  VARCHAR(45) NOT NULL,
  permissao_sistema_id  INT NOT NULL,
  PRIMARY KEY (id),
  KEY idx_ta_perm (permissao_sistema_id),
  CONSTRAINT fk_ta_perm
    FOREIGN KEY (permissao_sistema_id) REFERENCES permissao_sistema (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS acesso (
  id             INT NOT NULL AUTO_INCREMENT,
  login          VARCHAR(100) NOT NULL,
  senha          VARCHAR(200) NOT NULL COMMENT 'armazenar hash, não texto puro',
  tipo_acesso_id INT NOT NULL,
  contato_id     INT NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_acesso_login (login),
  KEY idx_acesso_tipo (tipo_acesso_id),
  KEY idx_acesso_contato (contato_id),
  CONSTRAINT fk_acesso_tipo
    FOREIGN KEY (tipo_acesso_id) REFERENCES tipo_acesso (id)
    ON UPDATE RESTRICT ON DELETE RESTRICT,
  CONSTRAINT fk_acesso_contato
    FOREIGN KEY (contato_id) REFERENCES contato (id_contato)
    ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ======================================================
-- Restore session
-- ======================================================
SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
