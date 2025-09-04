USE bd_imobiliaria;

-- pesquisa rápida por município e estado
CREATE INDEX idx_municipio_estado ON Municipio (Estado_Id, Estado_Regiao_Id);

-- lookup por tipo de endereço (afeta PK composta de endereco)
CREATE INDEX idx_endereco_tipo ON endereco (tipo_endereco_id_tipo_endereco);

-- joins frequentes em tipo_imovel
CREATE INDEX idx_tipo_imovel_fks ON tipo_imovel (contrutora_id_contrutora, finalidade_busca_idfinalidade_busca);

-- localização por tipo_imovel
CREATE INDEX idx_localizacao_tipo ON localizacao (tipo_imovel_id_tipo_imovel, tipo_imovel_contrutora_id_contrutora, tipo_imovel_finalidade_busca_idfinalidade_busca);
