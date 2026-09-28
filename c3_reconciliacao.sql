SELECT
  COUNT(*) AS remessas,
  COUNT(DISTINCT id_pedido) AS pedidos,
  ROUND(SUM(valor_produtos), 2) AS soma_valor_produtos,
  ROUND(SUM(valor_frete), 2) AS soma_valor_frete,
  COUNTIF(flag_entregue) AS remessas_entregues,
  COUNTIF(flag_atraso) AS remessas_atrasadas
FROM `mvp-olist-entregas.olist_dw`.fato_entrega
