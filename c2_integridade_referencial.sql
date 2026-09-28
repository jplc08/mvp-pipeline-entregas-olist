SELECT 'Chave duplicada na fato (id_pedido, sk_vendedor)' AS verificacao, COUNT(*) AS ocorrencias
FROM (SELECT id_pedido, sk_vendedor FROM `seu-projeto-gcp.olist_dw`.fato_entrega GROUP BY id_pedido, sk_vendedor HAVING COUNT(*) > 1) AS d
UNION ALL
SELECT 'Chave duplicada em dim_tempo', COUNT(*) - COUNT(DISTINCT sk_data) FROM `seu-projeto-gcp.olist_dw`.dim_tempo
UNION ALL
SELECT 'Chave duplicada em dim_localidade', COUNT(*) - COUNT(DISTINCT sk_localidade) FROM `seu-projeto-gcp.olist_dw`.dim_localidade
UNION ALL
SELECT 'Chave duplicada em dim_vendedor', COUNT(*) - COUNT(DISTINCT sk_vendedor) FROM `seu-projeto-gcp.olist_dw`.dim_vendedor
UNION ALL
SELECT 'FK sem correspondência: sk_vendedor', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_vendedor AS v ON f.sk_vendedor = v.sk_vendedor WHERE v.sk_vendedor IS NULL
UNION ALL
SELECT 'FK sem correspondência: sk_localidade_origem', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_localidade AS l ON f.sk_localidade_origem = l.sk_localidade WHERE l.sk_localidade IS NULL
UNION ALL
SELECT 'FK sem correspondência: sk_localidade_destino', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_localidade AS l ON f.sk_localidade_destino = l.sk_localidade WHERE l.sk_localidade IS NULL
UNION ALL
SELECT 'FK sem correspondência: sk_data_compra', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data WHERE t.sk_data IS NULL
UNION ALL
SELECT 'FK sem correspondência: sk_data_entrega_prevista', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_entrega_prevista = t.sk_data WHERE t.sk_data IS NULL
UNION ALL
SELECT 'FK sem correspondência: sk_data_entrega (quando preenchida)', COUNT(*)
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f LEFT JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_entrega = t.sk_data
WHERE f.sk_data_entrega IS NOT NULL AND t.sk_data IS NULL
