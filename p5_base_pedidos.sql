SELECT
  f.id_pedido,
  CAST(LOGICAL_OR(f.flag_atraso) AS INT64) AS atrasado,
  MAX(f.dias_atraso) AS dias_atraso,
  MAX(f.nota_avaliacao) AS nota
FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
WHERE f.flag_entregue AND t.periodo_analise AND f.nota_avaliacao IS NOT NULL
GROUP BY f.id_pedido
