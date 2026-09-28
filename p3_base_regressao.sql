SELECT
  CAST(f.flag_atraso AS INT64) AS atraso,
  f.distancia_km,
  f.peso_total_kg,
  CAST(f.flag_postagem_fora_prazo AS INT64) AS postagem_fora_prazo,
  d.regiao AS regiao_destino,
  t.ano_mes
FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
JOIN `mvp-olist-entregas.olist_dw`.dim_localidade AS d ON f.sk_localidade_destino = d.sk_localidade
WHERE f.flag_entregue AND t.periodo_analise
  AND f.distancia_km IS NOT NULL AND f.peso_total_kg IS NOT NULL AND f.flag_postagem_fora_prazo IS NOT NULL
