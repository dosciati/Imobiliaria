erDiagram
  %% =========================
  %% RELACIONAMENTOS (CARDINALIDADES)
  %% =========================
  TIPO_ENDERECO ||--o{ ENDERECO : "classifica"
  REGIAO        ||--o{ ESTADO   : "contém"
  ESTADO        ||--o{ MUNICIPIO: "contém"
  MUNICIPIO     ||--o{ BAIRRO   : "contém"

  PROFISSOES ||--o{ PESSOA      : "exerce"
  ENDERECO   ||--o{ PESSOA      : "reside_em"
  MUNICIPIO  ||--o{ PESSOA      : "pertence"
  CONTATO    ||--o{ PESSOA      : "referência"

  CONTRUTORA       ||--o{ TIPO_IMOVEL : "oferta"
  FINALIDADE_BUSCA ||--o{ TIPO_IMOVEL : "finalidade"
  TIPO_IMOVEL      ||--o{ CONDICAO_IMOVEL : "tem"
  TIPO_IMOVEL      ||--o{ SITUACAO_IMOVEL : "tem"
  TIPO_IMOVEL      ||--o{ CARAC_IMOVEL    : "tem"
  TIPO_IMOVEL      ||--o{ ACAB_IMOVEL     : "tem"
  TIPO_IMOVEL      ||--o{ LOCALIZACAO     : "tem"

  CONTATO         ||--o{ CONTATO_ORIGEM   : "origina"
  ORIGEM_CONTATO  ||--o{ CONTATO_ORIGEM   : "classifica"

  PESSOA     ||--o{ PESSOA_IDENTIFICA : "possui"
  IDENTIFICA ||--o{ PESSOA_IDENTIFICA : "detalha"

  PESSOA     ||--o{ IMOBILIARIA : "representa"
  ENDERECO   ||--o{ IMOBILIARIA : "sede"
  IDENTIFICA ||--o{ IMOBILIARIA : "doc"
  CONTATO    ||--o{ IMOBILIARIA : "contato"

  PERM_SYSTEM ||--o{ ACESSO_TIPO : "define"
  ACESSO_TIPO ||--o{ ACESSOS     : "usa"
  CONTATO     ||--o{ ACESSOS     : "dono"

  %% =========================
  %% ENTIDADES E CAMPOS
  %% =========================
  PROFISSOES {
    int id_prof PK
    varchar nome_prof
  }

  TIPO_ENDERECO {
    int id_tipo_endereco PK
    varchar tipo_endereco
  }

  ENDERECO {
    int id_endereco PK
    int tipo_endereco_id_tipo_endereco PK, FK
    varchar rua
    varchar num
  }

  REGIAO {
    int id PK
    varchar nome
  }

  ESTADO {
    int id PK
    int regiao_id PK, FK
    int codigoUf
    varchar nome
    char uf
  }

  MUNICIPIO {
    int id PK
    int estado_id PK, FK
    int estado_regiao_id PK, FK
    int codigo
    varchar nome
  }

  BAIRRO {
    int id PK
    int municipio_id PK, FK
    int municipio_estado_id PK, FK
    int municipio_estado_regiao_id PK, FK
    char codigo
    varchar nome
  }

  CONTATO {
    int id_contato PK  %% (MySQL: `id contato`)
    varchar contato
    varchar email
  }

  PESSOA {
    int id_pessoa PK
    int profissoes_id_prof PK, FK
    int endereco_id_endereco PK, FK
    int endereco_tipo_endereco_id_tipo_endereco PK, FK
    int municipio_id PK, FK
    int municipio_estado_id PK, FK
    int municipio_estado_regiao_id PK, FK
    int contato_id_contato PK, FK  %% (MySQL: `contato_id contato`)
    varchar nome
    varchar sobrenome
    varchar obs
    varchar complemento
  }

  CONTRUTORA {  %% (MySQL: `contrutora`)
    int id_contrutora PK
    varchar nome_const
  }

  FINALIDADE_BUSCA {
    int idfinalidade_busca PK
    varchar desc_finalidade
  }

  TIPO_IMOVEL {
    int id_tipo_imovel PK
    int contrutora_id_contrutora PK, FK
    int finalidade_busca_idfinalidade_busca PK, FK
    varchar desc
  }

  CONDICAO_IMOVEL {
    int id_condicao_imovel PK
    int tipo_imovel_id_tipo_imovel PK, FK
    int tipo_imovel_contrutora_id_contrutora PK, FK
    int tipo_imovel_finalidade_busca_idfinalidade_busca PK, FK
    varchar desc_cond_imovel
  }

  SITUACAO_IMOVEL {  %% (MySQL: `situaçao_imovel`)
    int id_situacao_imovel PK
    int tipo_imovel_id_tipo_imovel PK, FK
    int tipo_imovel_contrutora_id_contrutora PK, FK
    int tipo_imovel_finalidade_busca_idfinalidade_busca PK, FK
    varchar desc_sit_imovel
  }

  ORIGEM_CONTATO {
    int id_origem_contato PK
    varchar origem
  }

  IDENTIFICA {
    int id_identifica PK
    varchar rg
    varchar creci
    varchar dat_nasc
    varchar cpf_cnpj
    varchar insc_munic
  }

  IMOBILIARIA {
    int idimobiliaria PK
    int pessoa_id_pessoa PK, FK
    int endereco_id_endereco PK, FK
    int endereco_tipo_endereco_id_tipo_endereco PK, FK
    int identifica_id_identifica PK, FK
    int contato_id_contato PK, FK   %% (MySQL: `contato_id contato`)
    varchar imobiliaria
    varchar proprietario
  }

  CARAC_IMOVEL {
    int id_carac_imovel PK
    int tipo_imovel_id_tipo_imovel PK, FK
    int tipo_imovel_contrutora_id_contrutora PK, FK
    tinyint desc_carac_imovel
  }

  ACAB_IMOVEL {
    int id_acab_imovel PK
    int tipo_imovel_id_tipo_imovel PK, FK
    int tipo_imovel_contrutora_id_contrutora PK, FK
    varchar desc_acab_imovel
  }

  CONTATO_ORIGEM {  %% (MySQL: `contato_has_origem_contato`)
    int contato_id_contato PK, FK      %% (MySQL: `contato_id contato`)
    int origem_contato_id_origem_contato PK, FK
    varchar tipo_contato
    varchar tipo_fone
    varchar nome_recado
  }

  PERM_SYSTEM {
    int id_perm_system PK
    tinyint leitura
    tinyint escrita
    tinyint gravacao
  }

  ACESSO_TIPO {
    int id_acesso_tipo PK
    int perm_system_id_perm_system PK, FK
    varchar acesso
  }

  ACESSOS {
    int id_acessos PK
    int acesso_tipo_id_acesso_tipo PK, FK
    int acesso_tipo_perm_system_id_perm_system PK, FK
    int contato_id_contato PK, FK  %% (MySQL: `contato_id contato`)
    varchar login
    varchar senha
  }

  PESSOA_IDENTIFICA {  %% (MySQL: `pessoa_has_identifica`)
    int pessoa_id_pessoa PK, FK
    int pessoa_profissoes_id_prof PK, FK
    int identifica_id_identifica PK, FK
    varchar tipo_pessoa
    varchar est_civil
    varchar conjuge
  }

  LOCALIZACAO {
    int id_localizaca PK
    int tipo_imovel_id_tipo_imovel PK, FK
    int tipo_imovel_contrutora_id_contrutora PK, FK
    int tipo_imovel_finalidade_busca_idfinalidade_busca PK, FK
    varchar topografia
    varchar posicao
    varchar orien_solar
    varchar latitude
    varchar logintude
  }
