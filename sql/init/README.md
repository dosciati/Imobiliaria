-- tabelas essenciais com ao menos 1 linha?
SELECT 'Regiao' AS tabela, COUNT(*) AS qtd FROM Regiao
UNION ALL SELECT 'Estado', COUNT(*) FROM Estado
UNION ALL SELECT 'Municipio', COUNT(*) FROM Municipio
UNION ALL SELECT 'tipo_endereco', COUNT(*) FROM tipo_endereco
UNION ALL SELECT 'endereco', COUNT(*) FROM endereco
UNION ALL SELECT 'profissoes', COUNT(*) FROM profissoes
UNION ALL SELECT 'contato', COUNT(*) FROM contato
UNION ALL SELECT 'pessoa', COUNT(*) FROM pessoa
UNION ALL SELECT 'contrutora', COUNT(*) FROM contrutora
UNION ALL SELECT 'finalidade_busca', COUNT(*) FROM finalidade_busca
UNION ALL SELECT 'tipo_imovel', COUNT(*) FROM tipo_imovel
UNION ALL SELECT 'localizacao', COUNT(*) FROM localizacao;
