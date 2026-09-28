WITH base AS (
  SELECT
    f.flag_atraso,
    f.dias_entrega,
    f.valor_frete,
    o.uf AS uf_origem,
    d.uf AS uf_destino,
    CASE
      WHEN f.distancia_km < 100 THEN '1. até 100 km'
      WHEN f.distancia_km < 500 THEN '2. 100 a 500 km'
      WHEN f.distancia_km < 1000 THEN '3. 500 a 1.000 km'
      WHEN f.distancia_km < 2000 THEN '4. 1.000 a 2.000 km'
      ELSE '5. 2.000 km ou mais'
    END AS faixa_distancia
  FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
  JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
  JOIN `mvp-olist-entregas.olist_dw`.dim_localidade AS o ON f.sk_localidade_origem = o.sk_localidade
  JOIN `mvp-olist-entregas.olist_dw`.dim_localidade AS d ON f.sk_localidade_destino = d.sk_localidade
  WHERE f.flag_entregue AND t.periodo_analise AND f.distancia_km IS NOT NULL
)
SELECT
  faixa_distancia,
  COUNT(*) AS entregas,
  COUNTIF(flag_atraso) AS atrasadas,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(flag_atraso), COUNT(*)), 2) AS taxa_atraso_pct,
  ROUND(AVG(dias_entrega), 2) AS media_dias_entrega,
  ROUND(AVG(valor_frete), 2) AS frete_medio,
  ROUND(100 * SAFE_DIVIDE(COUNTIF(uf_origem = uf_destino), COUNT(*)), 1) AS pct_mesma_uf
FROM base
GROUP BY faixa_distancia
ORDER BY faixa_distancia
