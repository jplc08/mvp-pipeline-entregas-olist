SELECT
  t.ano_mes,
  COUNT(*) AS entregas,
  COUNTIF(f.flag_atraso) AS atrasadas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(f.flag_atraso), COUNT(*)), 2) AS taxa_atraso_pct,
  ROUND(AVG(f.dias_entrega), 2) AS media_dias_entrega,
  ROUND(AVG(f.dias_prazo_prometido), 2) AS media_prazo_prometido
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f
JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
WHERE f.flag_entregue AND t.periodo_analise
GROUP BY t.ano_mes
ORDER BY t.ano_mes
