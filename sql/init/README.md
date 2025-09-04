USE bd_imobiliaria;

-- Tabelas essenciais com pelo menos 1 linha
SELECT *
FROM (
  SELECT 'regiao'            AS tabela, COUNT(*) AS qtd FROM regiao
  UNION ALL SELECT 'estado',                    COUNT(*)        FROM estado
  UNION ALL SELECT 'municipio',                 COUNT(*)        FROM municipio
  UNION ALL SELECT 'bairro',                    COUNT(*)        FROM bairro
  UNION ALL SELECT 'tipo_endereco',             COUNT(*)        FROM tipo_endereco
  UNION ALL SELECT 'endereco',                  COUNT(*)        FROM endereco
  UNION ALL SELECT 'profissao',                 COUNT(*)        FROM profissao
  UNION ALL SELECT 'contato',                   COUNT(*)        FROM contato
  UNION ALL SELECT 'pessoa',                    COUNT(*)        FROM pessoa
  UNION ALL SELECT 'construtora',               COUNT(*)        FROM construtora
  UNION ALL SELECT 'finalidade_busca',          COUNT(*)        FROM finalidade_busca
  UNION ALL SELECT 'tipo_imovel',               COUNT(*)        FROM tipo_imovel
  UNION ALL SELECT 'localizacao',               COUNT(*)        FROM localizacao
) t
WHERE qtd > 0
ORDER BY tabela;

