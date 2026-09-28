SELECT
  f.flag_postagem_fora_prazo AS postagem_fora_prazo,
  COUNT(*) AS entregas,
  COUNTIF(f.flag_atraso) AS atrasadas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(f.flag_atraso), COUNT(*)), 2) AS taxa_atraso_pct
FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
WHERE f.flag_entregue AND t.periodo_analise AND f.flag_postagem_fora_prazo IS NOT NULL
GROUP BY postagem_fora_prazo
ORDER BY postagem_fora_prazo
