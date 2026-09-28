SELECT
  v.id_vendedor,
  v.porte_vendedor,
  COUNT(*) AS entregas,
  COUNTIF(f.flag_atraso) AS atrasadas,
  COUNTIF(f.flag_postagem_fora_prazo) AS postagens_fora_prazo
FROM `mvp-olist-entregas.olist_dw`.fato_entrega AS f
JOIN `mvp-olist-entregas.olist_dw`.dim_tempo AS t ON f.sk_data_compra = t.sk_data
JOIN `mvp-olist-entregas.olist_dw`.dim_vendedor AS v ON f.sk_vendedor = v.sk_vendedor
WHERE f.flag_entregue AND t.periodo_analise
GROUP BY v.id_vendedor, v.porte_vendedor
