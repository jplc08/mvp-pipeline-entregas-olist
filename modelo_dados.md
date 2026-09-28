# Modelo de dados — esquema estrela (`olist_dw`)

![Diagrama do modelo estrela](modelo_estrela.png)

## Decisão de modelagem

O Data Warehouse segue um **esquema estrela** (Kimball) com uma tabela fato e três dimensões desnormalizadas. As dimensões são pequenas (milhares de linhas): normalizá-las em *snowflake* só acrescentaria junções, sem ganho analítico.

### Grão da fato: uma linha por **remessa** (pedido × vendedor)

| Alternativa de grão | Problema | Decisão |
|---|---|---|
| Item do pedido | Repetiria as datas e a nota do pedido em cada item e inflaria as contagens de entregas. | Descartada |
| Pedido | Perderia o vendedor nos pedidos com itens de mais de um vendedor; o prazo-limite de postagem e a origem geográfica são do vendedor. | Descartada |
| **Remessa (pedido × vendedor)** | O vendedor é quem prepara e posta o pacote; é a unidade logística real. | **Adotada** |

Nos poucos pedidos com mais de um vendedor, as datas e a nota do pedido se repetem entre as remessas. A análise de satisfação (P5) agrega por pedido antes de calcular, e a fato traz `flag_multivendedor` para auditoria.

### Tabelas

| Tabela | Tipo | Conteúdo |
|---|---|---|
| `fato_entrega` | Fato | Uma linha por remessa. **Aditivas:** `qtd_itens`, `valor_produtos`, `valor_frete`, `peso_total_kg`. **Não aditivas** (usar média, mediana ou percentil): `distancia_km`, `dias_*`, `nota_avaliacao`. **Indicadores:** `flag_*`. **Dimensão degenerada:** `id_pedido`. |
| `dim_tempo` | Dimensão com papéis | Um dia por linha. Três papéis na fato: `sk_data_compra`, `sk_data_entrega_prevista`, `sk_data_entrega`. |
| `dim_localidade` | Dimensão com papéis | Um CEP-prefixo por linha, com cidade, UF, região e centroide. Dois papéis: `sk_localidade_origem` (vendedor) e `sk_localidade_destino` (cliente). |
| `dim_vendedor` | Dimensão | Um vendedor por linha, com volume histórico e porte. |

Tabelas de metadados carregadas no mesmo dataset: `meta_catalogo_dados`, `meta_log_transformacoes`, `meta_coleta`, `meta_perfil_qualidade` e `meta_verificacoes_qualidade`.

## Diagrama entidade-relacionamento

```mermaid
erDiagram
    dim_tempo ||--o{ fato_entrega : "compra / prevista / entrega"
    dim_localidade ||--o{ fato_entrega : "origem / destino"
    dim_vendedor ||--o{ fato_entrega : "vendedor"

    fato_entrega {
        STRING id_pedido "dimensao degenerada"
        INT64 sk_vendedor FK
        INT64 sk_localidade_origem FK
        INT64 sk_localidade_destino FK
        INT64 sk_data_compra FK
        INT64 sk_data_entrega_prevista FK
        INT64 sk_data_entrega FK
        STRING status_pedido
        INT64 qtd_itens
        FLOAT64 valor_produtos
        FLOAT64 valor_frete
        FLOAT64 peso_total_kg
        FLOAT64 distancia_km
        FLOAT64 dias_preparacao
        FLOAT64 dias_transporte
        FLOAT64 dias_entrega
        INT64 dias_prazo_prometido
        INT64 dias_atraso
        INT64 nota_avaliacao
        BOOL flag_entregue
        BOOL flag_atraso
        BOOL flag_postagem_fora_prazo
    }
    dim_tempo {
        INT64 sk_data PK
        DATE data
        STRING ano_mes
        INT64 dia_semana
        BOOL periodo_analise
    }
    dim_localidade {
        INT64 sk_localidade PK
        STRING cep_prefixo
        STRING cidade
        STRING uf
        STRING regiao
        FLOAT64 latitude
        FLOAT64 longitude
    }
    dim_vendedor {
        INT64 sk_vendedor PK
        STRING id_vendedor
        INT64 qtd_pedidos
        STRING porte_vendedor
    }
```

O diagrama acima mostra os atributos principais. A lista completa, com domínio e linhagem de cada atributo, está no [Catálogo de Dados](catalogo_dados.md), e o esquema equivalente em DDL está em [`scripts/ddl_modelo_estrela.sql`](../scripts/ddl_modelo_estrela.sql).

## Linhagem (visão geral)

```mermaid
flowchart LR
    O1["olist_orders_dataset"] --> F["fato_entrega"]
    O2["olist_order_items_dataset"] -->|"R08: agrega por pedido × vendedor"| F
    O3["olist_products_dataset"] -->|"peso (R06)"| F
    O4["olist_order_reviews_dataset"] -->|"nota (R05)"| F
    O5["olist_customers_dataset"] -->|"CEP destino (R03)"| L["dim_localidade"]
    O6["olist_sellers_dataset"] -->|"CEP origem (R03)"| L
    O7["olist_geolocation_dataset"] -->|"centroide (R04)"| L
    O6 --> V["dim_vendedor"]
    O1 -->|"datas (R13, R15)"| T["dim_tempo"]
    L --> F
    V --> F
    T --> F
```
