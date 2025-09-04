USE bd_imobiliaria;

-- ============================
-- Localização administrativa
-- ============================
INSERT INTO regiao (nome) VALUES ('Sul');                                  -- id = 1

INSERT INTO estado (codigo_uf, nome, uf, regiao_id)
VALUES (43, 'Rio Grande do Sul', 'RS', 1);                                 -- id = 1

INSERT INTO municipio (codigo, nome, estado_id)
VALUES (4314902, 'Porto Alegre', 1);                                       -- id = 1

INSERT INTO bairro (codigo, nome, municipio_id)
VALUES ('90000', 'Centro', 1);                                             -- id = 1

-- ============================
-- Tipos / Endereço / Profissão
-- ============================
INSERT INTO tipo_endereco (nome) VALUES ('Residencial');                   -- id = 1

INSERT INTO endereco (rua, numero, complemento, tipo_endereco_id, bairro_id)
VALUES ('Rua Exemplo', '123', 'apto 101', 1, 1);                           -- id = 1

INSERT INTO profissao (nome) VALUES ('Analista de Sistemas');              -- id = 1

-- ============================
-- Contato e origem do contato (opcional)
-- ============================
INSERT INTO contato (nome, email)
VALUES ('Contato Principal', 'contato@exemplo.com');                       -- id_contato = 1

INSERT INTO origem_contato (origem) VALUES ('Indicação');                  -- id = 1
INSERT INTO contato_origem (contato_id, origem_contato_id, tipo_contato, tipo_fone, nome_recado)
VALUES (1, 1, 'Telefone', 'Celular', 'André');

-- ============================
-- Pessoa e documentos
-- ============================
INSERT INTO pessoa (nome, sobrenome, obs, complemento, profissao_id, endereco_id, municipio_id, contato_id)
VALUES ('André', 'Dosciati', 'registro de teste', 'apto 101', 1, 1, 1, 1); -- id = 1

INSERT INTO documento_identificacao (rg, creci, data_nasc, cpf_cnpj, inscricao_municipal)
VALUES ('123456789', NULL, '1988-01-01', '00000000000', NULL);             -- id = 1

INSERT INTO pessoa_documento (pessoa_id, documento_identificacao_id, tipo_pessoa, estado_civil, conjuge)
VALUES (1, 1, 'FISICA', 'SOLTEIRO', NULL);

-- ============================
-- Domínio imobiliário
-- ============================
INSERT INTO construtora (nome)
VALUES ('Construtora Exemplo');                                            -- id = 1

INSERT INTO finalidade_busca (descricao)
VALUES ('Moradia');                                                        -- id = 1

INSERT INTO tipo_imovel (descricao, construtora_id, finalidade_busca_id)
VALUES ('Apartamento', 1, 1);                                             -- id = 1

INSERT INTO localizacao (topografia, posicao, orientacao_solar, latitude, longitude, tipo_imovel_id)
VALUES ('Plana', 'Frente', 'Norte', -30.0346, -51.2177, 1);

-- ============================
-- Permissões e acesso (opcional)
-- ============================
INSERT INTO permissao_sistema (leitura, escrita, gravacao)
VALUES (1, 1, 0);                                                          -- id = 1

INSERT INTO tipo_acesso (nome, permissao_sistema_id)
VALUES ('Admin', 1);                                                       -- id = 1

-- senha deve ser HASH (ex.: bcrypt). Valor abaixo é placeholder.
INSERT INTO acesso (login, senha, tipo_acesso_id, contato_id)
VALUES ('admin@example.com', '$2b$12$substitua_pelo_hash_real', 1, 1);
