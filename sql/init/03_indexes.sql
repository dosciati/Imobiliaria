USE bd_imobiliaria;

-- ============================
-- Localização administrativa
-- ============================
-- Estado -> Regiao
CREATE INDEX idx_estado_regiao_id ON estado (regiao_id);

-- Municipio -> Estado
CREATE INDEX idx_municipio_estado_id ON municipio (estado_id);

-- Bairro -> Municipio
CREATE INDEX idx_bairro_municipio_id ON bairro (municipio_id);

-- ============================
-- Endereço
-- ============================
-- Endereco -> tipo_endereco / bairro
CREATE INDEX idx_endereco_tipo_endereco_id ON endereco (tipo_endereco_id);
CREATE INDEX idx_endereco_bairro_id       ON endereco (bairro_id);

-- ============================
-- Pessoas e contatos
-- ============================
-- Pessoa -> Profissao / Endereco / Municipio / Contato
CREATE INDEX idx_pessoa_profissao_id ON pessoa (profissao_id);
CREATE INDEX idx_pessoa_endereco_id  ON pessoa (endereco_id);
CREATE INDEX idx_pessoa_municipio_id ON pessoa (municipio_id);
CREATE INDEX idx_pessoa_contato_id   ON pessoa (contato_id);

-- Contato x Origem de contato
CREATE INDEX idx_contato_origem_contato_id        ON contato_origem (contato_id);
CREATE INDEX idx_contato_origem_origem_contato_id ON contato_origem (origem_contato_id);

-- Pessoa x Documento
CREATE INDEX idx_pessoa_documento_pessoa_id      ON pessoa_documento (pessoa_id);
CREATE INDEX idx_pessoa_documento_documento_id   ON pessoa_documento (documento_identificacao_id);

-- ============================
-- Domínio imobiliário
-- ============================
-- Tipo de imóvel (FKs)
CREATE INDEX idx_tipo_imovel_construtora_id  ON tipo_imovel (construtora_id);
CREATE INDEX idx_tipo_imovel_finalidade_id   ON tipo_imovel (finalidade_busca_id);

-- Localização -> tipo_imovel
CREATE INDEX idx_localizacao_tipo_imovel_id  ON localizacao (tipo_imovel_id);

-- ============================
-- Acesso / permissões
-- ============================
-- Tipo de acesso -> Permissão
CREATE INDEX idx_tipo_acesso_permissao_id ON tipo_acesso (permissao_sistema_id);

-- Acesso -> TipoAcesso / Contato
CREATE INDEX idx_acesso_tipo_acesso_id    ON acesso (tipo_acesso_id);
CREATE INDEX idx_acesso_contato_id        ON acesso (contato_id);
