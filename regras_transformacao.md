# Regras de transformação e linhagem

Cada regra é aplicada no notebook (Seções 6 e 7) e registra **quantas linhas afetou** em `meta_log_transformacoes` (BigQuery) e `evidencias/metadados/log_transformacoes.csv`. As regras que alteram o significado dos dados (conversões, deduplicação, padronização de chaves) estão explícitas abaixo, porque afetam diretamente a interpretação dos resultados.

| Regra | Camada | O que faz | Por quê |
|---|---|---|---|
| **R01** | silver | Tipagem explícita: datas ISO 8601, números, identificadores como texto. Valores não conversíveis viram nulo e são contados. | A bronze é lida inteiramente como texto para preservar o dado original. |
| **R02** | silver | Padronização de texto: cidades em minúsculas, sem acentos e sem espaços extras; UF em maiúsculas. | "São Paulo", "sao paulo" e "SAO PAULO" são a mesma cidade. |
| **R03** | silver | CEP-prefixo sempre com 5 dígitos (zeros à esquerda). | Evita que CEPs como 01310 virem 1310 e deixem de casar com a geolocalização. |
| **R04** | silver | Geolocalização: remove duplicatas, descarta coordenadas fora do retângulo do território brasileiro (lat −33,75 a 5,30; lon −73,99 a −34,79) e agrega por CEP-prefixo (centroide = mediana de latitude e longitude). | A tabela tem vários pontos por CEP, repetições e coordenadas no exterior. A mediana é robusta a pontos residuais mal posicionados. |
| **R05** | silver | Avaliações: remove linhas duplicadas e mantém uma avaliação por pedido (a respondida mais recentemente). | Evita contar a nota do mesmo pedido mais de uma vez. |
| **R06** | silver | Produtos: renomeia colunas com erro de digitação (`lenght`), categoria nula → `sem_categoria`, peso zero → nulo, tradução da categoria (sem tradução → nome original). | Peso zero é fisicamente implausível e distorceria somas e médias. |
| **R07** | silver | Remove duplicatas de chave primária em pedidos, itens, clientes, vendedores e produtos. | Garante a unicidade das entidades. |
| **R08** | gold | Grão da fato = remessa (pedido × vendedor). Itens agregados: `COUNT` de itens, `SUM` de preço, frete e peso, `MAX` do prazo-limite de postagem. Pedidos sem itens ficam fora da fato. | O vendedor é quem prepara e posta; a remessa é a unidade logística. |
| **R09** | gold | Durações em dias: aprovação (compra → aprovação), preparação (aprovação → postagem), transporte (postagem → entrega) e total (compra → entrega). Durações negativas viram nulo e a remessa recebe `flag_inconsistencia_temporal`. "Entregue" = status `delivered` **e** data de entrega preenchida. | Datas fora de ordem são erro de registro e não devem contaminar médias. |
| **R10** | gold | `dias_atraso` = data da entrega − data prometida (dias corridos). Atrasada = `dias_atraso > 0`. | Entregar no próprio dia prometido cumpre a promessa. |
| **R11** | gold | `flag_postagem_fora_prazo` = data de postagem > prazo-limite de postagem da remessa. | Isola o atraso originado no vendedor. |
| **R12** | gold | `distancia_km` = distância de Haversine entre os centroides dos CEPs de origem e destino. Nula quando falta centroide. | Aproximação da distância de transporte (a base não traz a rota). |
| **R13** | gold | `dim_tempo.periodo_analise` = jan/2017 a ago/2018. | Fora da janela, o volume é irrisório (2016) ou os pedidos estão em aberto (set–out/2018), o que causaria viés de truncamento. |
| **R14** | silver | Minimização (LGPD): descarta `customer_unique_id` e o título e o texto dos comentários das avaliações; mantém só `tem_comentario`. | Dados desnecessários às perguntas não devem circular. O texto livre pode conter dados pessoais. |
| **R15** | gold | Chaves substitutas inteiras nas dimensões; `sk_data` = AAAAMMDD. Na `dim_localidade`, cidade e UF = valor mais frequente do CEP-prefixo. | Chaves compactas e estáveis, independentes dos *hashes* da origem. |
| **R16** | gold | Porte do vendedor: pequeno (< 10 pedidos), médio (10 a 99), grande (≥ 100), no período total da base. | Permite comparar vendedores de escalas diferentes. |

## Conversões e unidades

| Atributo | Origem | Conversão |
|---|---|---|
| `peso_total_kg` | `product_weight_g` (gramas, por produto) | Soma por remessa ÷ 1.000 |
| `dias_*` | *timestamps* da origem | Diferença em segundos ÷ 86.400, com 2 casas decimais |
| `dias_prazo_prometido`, `dias_atraso` | datas | Diferença em dias corridos entre datas (sem hora) |
| `distancia_km` | latitude/longitude (graus) | Haversine com raio terrestre de 6.371 km |
| `valor_produtos`, `valor_frete` | `price`, `freight_value` (R$) | Soma por remessa, 2 casas decimais |
