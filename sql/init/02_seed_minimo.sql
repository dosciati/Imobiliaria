USE bd_imobiliaria;

-- Regiões, Estado e Município (respeitando PKs compostas)
INSERT INTO Regiao (Nome) VALUES ('Sul');                       -- Id = 1
INSERT INTO Estado (CodigoUf, Nome, Uf, Regiao_Id)
VALUES (43, 'Rio Grande do Sul', 'RS', 1);                      -- Id = 1, Regiao_Id = 1
INSERT INTO Municipio (Codigo, Nome, Estado_Id, Estado_Regiao_Id)
VALUES (4314902, 'Porto Alegre', 1, 1);                         -- Id = 1, Estado_Id = 1, Estado_Regiao_Id = 1

-- Bairro (depende de Município)
INSERT INTO Bairro (Codigo, Nome, Municipio_Id, Municipio_Estado_Id, Municipio_Estado_Regiao_Id)
VALUES ('90000', 'Centro', 1, 1, 1);                            -- Id = 1,...

-- Tipos de Endereço e Endereço (PK composta com tipo_endereco)
INSERT INTO tipo_endereco (tipo_endereco) VALUES ('Residencial'); -- id_tipo_endereco = 1
INSERT INTO endereco (rua, num, tipo_endereco_id_tipo_endereco) VALUES ('Rua Exemplo', '123', 1);
-- assumindo id_endereco = 1 pelo autoincrement

-- Profissão
INSERT INTO profissoes (nome_prof) VALUES ('Analista de Sistemas'); -- id_prof = 1

-- Contato (o campo tem espaço no nome na sua definição: `id contato`)
INSERT INTO contato (contato, email) VALUES ('(51) 90000-0000', 'contato@exemplo.com');
-- assumindo `id contato` = 1

-- Pessoa (requer várias FKs: profissão, endereço, município e contato)
INSERT INTO pessoa (
  nome, sobrenome, obs, complemento,
  profissoes_id_prof,
  endereco_id_endereco, endereco_tipo_endereco_id_tipo_endereco,
  Municipio_Id, Municipio_Estado_Id, Municipio_Estado_Regiao_Id,
  `contato_id contato`
) VALUES (
  'André', 'Dosciati', 'registro de teste', 'apto 101',
  1,
  1, 1,
  1, 1, 1,
  1
);
-- id_pessoa = 1

-- Tabelas do domínio de imóvel
INSERT INTO contrutora (nome_const) VALUES ('Construtora Exemplo');               -- id_contrutora = 1
INSERT INTO finalidade_busca (desc_finalidade) VALUES ('Moradia');                -- idfinalidade_busca = 1

INSERT INTO tipo_imovel (desc, contrutora_id_contrutora, finalidade_busca_idfinalidade_busca)
VALUES ('Apartamento', 1, 1);                                                    -- id_tipo_imovel = 1

-- Localização (depende de tipo_imovel e suas chaves compostas)
INSERT INTO localizacao (
  topografia, posicao, orien_solar, latitude, logintude,
  tipo_imovel_id_tipo_imovel, tipo_imovel_contrutora_id_contrutora, tipo_imovel_finalidade_busca_idfinalidade_busca
) VALUES (
  'Plana', 'Frente', 'Norte', '-30.0346', '-51.2177',
  1, 1, 1
);

-- Identificação e vínculo pessoa-identificação
INSERT INTO identifica (rg, creci, dat_nasc, cpf_cnpj, insc_munic)
VALUES ('123456789', NULL, '1988-01-01', '000.000.000-00', NULL);                -- id_identifica = 1

INSERT INTO pessoa_has_identifica (pessoa_id_pessoa, pessoa_profissoes_id_prof, identifica_id_identifica, tipo_pessoa, est_civil, conjuge)
VALUES (1, 1, 1, 'FISICA', 'SOLTEIRO', NULL);
