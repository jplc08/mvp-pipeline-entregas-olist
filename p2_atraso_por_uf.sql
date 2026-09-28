SELECT
  d.uf,
  d.regiao,
  COUNT(*) AS entregas,
  COUNTIF(f.flag_atraso) AS atrasadas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(f.flag_atraso), COUNT(*)), 2) AS taxa_atraso_pct,
  ROUND(AVG(f.dias_entrega), 2) AS media_dias_entrega,
  ROUND(AVG(f.dias_prazo_prometido), 2) AS media_prazo_prometido,
  ROUND(AVG(f.dias_prazo_prometido - f.dias_entrega), 2) AS folga_media_dias,
  APPROX_QUANTILES(f.dias_entrega, 100)[OFFSET(50)] AS p50_dias_entrega,
  APPROX_QUANTILES(f.dias_entrega, 100)[OFFSET(90)] AS p90_dias_entrega,
  APPROX_QUANTILES(f.dias_prazo_prometido, 100)[OFFSET(50)] AS p50_prazo_prometido
FROM `seu-projeto-gcp.olist_dw`.fato_entrega AS f
JOIN `seu-projeto-gcp.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
JOIN `seu-projeto-gcp.olist_dw`.dim_localidade AS d ON f.sk_localidade_destino = d.sk_localidade
WHERE f.flag_entregue AND t.periodo_analise
GROUP BY d.uf, d.regiao
ORDER BY taxa_atraso_pct DESC
