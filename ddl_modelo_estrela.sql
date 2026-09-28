-- DDL do modelo estrela no BigQuery (gerado a partir do Catálogo de Dados).
-- O notebook cria estas tabelas por load jobs (WRITE_TRUNCATE) com exatamente este esquema;
-- este arquivo documenta o modelo e permite recriá-lo manualmente. Substitua `seu-projeto-gcp`.

CREATE OR REPLACE TABLE `seu-projeto-gcp.olist_dw.dim_tempo` (
  sk_data INT64 NOT NULL OPTIONS(description="Chave substituta da data, no formato AAAAMMDD (PK). Domínio: 20160901 a 20181231."),
  data DATE NOT NULL OPTIONS(description="Data do calendário. Domínio: 2016-09-01 a 2018-12-31."),
  ano INT64 NOT NULL OPTIONS(description="Ano civil. Domínio: 2016 a 2018."),
  trimestre INT64 NOT NULL OPTIONS(description="Trimestre do ano. Domínio: 1 a 4."),
  mes INT64 NOT NULL OPTIONS(description="Mês do ano. Domínio: 1 a 12."),
  nome_mes STRING NOT NULL OPTIONS(description="Nome do mês em português. Domínio: janeiro, fevereiro, março, abril, maio, junho, julho, agosto, setembro, outubro, novembro, dezembro."),
  ano_mes STRING NOT NULL OPTIONS(description="Ano e mês no formato AAAA-MM (agrupamento mensal). Domínio: Padrão ^\\d{4}-(0[1-9]|1[0-2])$."),
  dia INT64 NOT NULL OPTIONS(description="Dia do mês. Domínio: 1 a 31."),
  dia_semana INT64 NOT NULL OPTIONS(description="Dia da semana ISO 8601 (1 = segunda-feira … 7 = domingo). Domínio: 1 a 7."),
  nome_dia_semana STRING NOT NULL OPTIONS(description="Nome do dia da semana em português. Domínio: segunda-feira, terça-feira, quarta-feira, quinta-feira, sexta-feira, sábado, domingo."),
  fim_de_semana BOOL NOT NULL OPTIONS(description="Verdadeiro para sábado e domingo. Domínio: verdadeiro, falso."),
  periodo_analise BOOL NOT NULL OPTIONS(description="Verdadeiro se a data está na janela de análise (jan/2017 a ago/2018). Domínio: verdadeiro, falso.")
)
OPTIONS(description="Dimensão calendário (papéis: data da compra, data prometida e data da entrega).");

CREATE OR REPLACE TABLE `seu-projeto-gcp.olist_dw.dim_localidade` (
  sk_localidade INT64 NOT NULL OPTIONS(description="Chave substituta da localidade (PK). Domínio: 1 a 99999."),
  cep_prefixo STRING NOT NULL OPTIONS(description="Cinco primeiros dígitos do CEP (chave natural). Domínio: Padrão ^\\d{5}$."),
  cidade STRING NOT NULL OPTIONS(description="Município, em minúsculas e sem acentos; quando o CEP-prefixo abrange mais de uma cidade, a mais frequente. Domínio: Texto livre."),
  uf STRING NOT NULL OPTIONS(description="Unidade federativa (sigla). Domínio: AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT, PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO."),
  regiao STRING NOT NULL OPTIONS(description="Grande região do IBGE. Domínio: Norte, Nordeste, Centro-Oeste, Sudeste, Sul."),
  latitude FLOAT64 OPTIONS(description="Latitude do centroide do CEP-prefixo (graus decimais). Domínio: -33.75 a 5.3."),
  longitude FLOAT64 OPTIONS(description="Longitude do centroide do CEP-prefixo (graus decimais). Domínio: -73.99 a -34.79.")
)
OPTIONS(description="Dimensão geográfica por CEP-prefixo (papéis: origem = vendedor; destino = cliente).");

CREATE OR REPLACE TABLE `seu-projeto-gcp.olist_dw.dim_vendedor` (
  sk_vendedor INT64 NOT NULL OPTIONS(description="Chave substituta do vendedor (PK). Domínio: 1 a 99999."),
  id_vendedor STRING NOT NULL OPTIONS(description="Identificador anonimizado do vendedor (hash de 32 caracteres). Domínio: Padrão ^[0-9a-f]{32}$."),
  qtd_pedidos INT64 NOT NULL OPTIONS(description="Quantidade de pedidos distintos do vendedor em toda a base. Domínio: 0 a 5000."),
  porte_vendedor STRING NOT NULL OPTIONS(description="Porte pelo volume de pedidos: pequeno (< 10), médio (10 a 99), grande (≥ 100). Domínio: pequeno, médio, grande.")
)
OPTIONS(description="Dimensão de vendedores, com volume histórico de pedidos e porte.");

CREATE OR REPLACE TABLE `seu-projeto-gcp.olist_dw.fato_entrega` (
  id_pedido STRING NOT NULL OPTIONS(description="Identificador anonimizado do pedido (dimensão degenerada). Com sk_vendedor forma a chave da remessa. Domínio: Padrão ^[0-9a-f]{32}$."),
  sk_vendedor INT64 NOT NULL OPTIONS(description="Vendedor responsável pela remessa (FK → dim_vendedor). Domínio: 1 a 99999."),
  sk_localidade_origem INT64 NOT NULL OPTIONS(description="Localidade do vendedor (FK → dim_localidade, papel 'origem'). Domínio: 1 a 99999."),
  sk_localidade_destino INT64 NOT NULL OPTIONS(description="Localidade do cliente (FK → dim_localidade, papel 'destino'). Domínio: 1 a 99999."),
  sk_data_compra INT64 NOT NULL OPTIONS(description="Data da compra (FK → dim_tempo). Domínio: 20160901 a 20181231."),
  sk_data_entrega_prevista INT64 NOT NULL OPTIONS(description="Data de entrega prometida ao cliente (FK → dim_tempo). Domínio: 20160901 a 20181231."),
  sk_data_entrega INT64 OPTIONS(description="Data da entrega ao cliente (FK → dim_tempo). Domínio: 20160901 a 20181231."),
  status_pedido STRING NOT NULL OPTIONS(description="Status do pedido na data da extração. Domínio: delivered, shipped, canceled, unavailable, invoiced, processing, created, approved."),
  data_hora_compra DATETIME NOT NULL OPTIONS(description="Data e hora da compra. Domínio: 2016-09-01 a 2018-12-31."),
  data_hora_aprovacao DATETIME OPTIONS(description="Data e hora da aprovação do pagamento. Domínio: 2016-09-01 a 2018-12-31."),
  data_hora_postagem DATETIME OPTIONS(description="Data e hora em que o vendedor entregou o pacote à transportadora. Domínio: 2016-09-01 a 2018-12-31."),
  data_hora_entrega DATETIME OPTIONS(description="Data e hora da entrega ao cliente. Domínio: 2016-09-01 a 2018-12-31."),
  data_limite_postagem DATETIME NOT NULL OPTIONS(description="Prazo-limite para o vendedor postar a remessa (o maior entre os itens). Domínio: 2016-09-01 a 2018-12-31."),
  data_entrega_prevista DATE NOT NULL OPTIONS(description="Data de entrega prometida ao cliente no momento da compra. Domínio: 2016-09-01 a 2018-12-31."),
  qtd_itens INT64 NOT NULL OPTIONS(description="Quantidade de itens na remessa. Domínio: 1 a 30."),
  valor_produtos FLOAT64 NOT NULL OPTIONS(description="Soma do preço dos itens da remessa (R$). Domínio: 0.01 a 15000."),
  valor_frete FLOAT64 NOT NULL OPTIONS(description="Soma do frete dos itens da remessa (R$). Domínio: 0 a 2000."),
  peso_total_kg FLOAT64 OPTIONS(description="Peso total dos itens da remessa (kg). Domínio: 0.001 a 500."),
  distancia_km FLOAT64 OPTIONS(description="Distância em linha reta entre os centroides dos CEPs de origem e destino (km). Domínio: 0 a 4500."),
  dias_aprovacao FLOAT64 OPTIONS(description="Dias entre a compra e a aprovação do pagamento. Domínio: 0 a 60."),
  dias_preparacao FLOAT64 OPTIONS(description="Dias entre a aprovação e a postagem (etapa do vendedor). Domínio: 0 a 180."),
  dias_transporte FLOAT64 OPTIONS(description="Dias entre a postagem e a entrega (etapa da transportadora). Domínio: 0 a 210."),
  dias_entrega FLOAT64 OPTIONS(description="Dias entre a compra e a entrega (prazo total realizado). Domínio: 0 a 210."),
  dias_prazo_prometido INT64 NOT NULL OPTIONS(description="Dias corridos entre a data da compra e a data prometida. Domínio: 0 a 160."),
  dias_atraso INT64 OPTIONS(description="Dias corridos entre a data prometida e a data da entrega (positivo = atraso; negativo = antecipação). Domínio: -150 a 190."),
  nota_avaliacao INT64 OPTIONS(description="Nota dada pelo cliente ao pedido (1 a 5 estrelas). Domínio: 1 a 5."),
  flag_entregue BOOL NOT NULL OPTIONS(description="Verdadeiro se o status é 'delivered' e há data de entrega. Domínio: verdadeiro, falso."),
  flag_atraso BOOL OPTIONS(description="Verdadeiro se a remessa foi entregue depois da data prometida. Domínio: verdadeiro, falso."),
  flag_postagem_fora_prazo BOOL OPTIONS(description="Verdadeiro se o vendedor postou depois do prazo-limite de postagem. Domínio: verdadeiro, falso."),
  flag_inconsistencia_temporal BOOL NOT NULL OPTIONS(description="Verdadeiro se alguma etapa tinha datas fora de ordem (duração negativa). Domínio: verdadeiro, falso."),
  flag_multivendedor BOOL NOT NULL OPTIONS(description="Verdadeiro se o pedido tem itens de mais de um vendedor (mais de uma remessa). Domínio: verdadeiro, falso.")
)
OPTIONS(description="Fato de entregas. Grão: remessa (pedido × vendedor). Prazos, atraso, distância, valores e avaliação.");
