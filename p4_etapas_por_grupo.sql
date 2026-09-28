SELECT
  CASE WHEN f.flag_atraso THEN 'Atrasadas' ELSE 'No prazo' END AS grupo,
  COUNT(*) AS entregas,
  ROUND(AVG(f.dias_aprovacao), 2) AS media_aprovacao,
  ROUND(AVG(f.dias_preparacao), 2) AS media_preparacao,
  ROUND(AVG(f.dias_transporte), 2) AS media_transporte,
  ROUND(APPROX_QUANTILES(f.dias_preparacao, 100)[OFFSET(50)], 2) AS mediana_preparacao,
  ROUND(APPROX_QUANTILES(f.dias_transporte, 100)[OFFSET(50)], 2) AS mediana_transporte,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(f.flag_postagem_fora_prazo), COUNTIF(f.flag_postagem_fora_prazo IS NOT NULL)), 2) AS pct_postagem_fora_prazo
FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
WHERE f.flag_entregue AND t.periodo_analise
GROUP BY grupo
ORDER BY grupo DESC
