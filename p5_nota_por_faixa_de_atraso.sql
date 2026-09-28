WITH pedidos AS (
SELECT
  f.id_pedido,
  CAST(LOGICAL_OR(f.flag_atraso) AS INT64) AS atrasado,
  MAX(f.dias_atraso) AS dias_atraso,
  MAX(f.nota_avaliacao) AS nota
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f
JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
WHERE f.flag_entregue AND t.periodo_analise AND f.nota_avaliacao IS NOT NULL
GROUP BY f.id_pedido
)
SELECT
  CASE
    WHEN dias_atraso <= -15 THEN '1. 15+ dias antes'
    WHEN dias_atraso <= -8 THEN '2. 8 a 14 dias antes'
    WHEN dias_atraso <= -1 THEN '3. 1 a 7 dias antes'
    WHEN dias_atraso = 0 THEN '4. no dia prometido'
    WHEN dias_atraso <= 7 THEN '5. 1 a 7 dias de atraso'
    WHEN dias_atraso <= 14 THEN '6. 8 a 14 dias de atraso'
    ELSE '7. 15+ dias de atraso'
  END AS faixa,
  COUNT(*) AS pedidos,
  ROUND(AVG(nota), 2) AS nota_media,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(nota <= 2), COUNT(*)), 2) AS pct_negativas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(nota = 5), COUNT(*)), 2) AS pct_nota_5
FROM pedidos
GROUP BY faixa
ORDER BY faixa
