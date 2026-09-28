# Evidências da execução na nuvem

Esta pasta reúne as provas de que o pipeline foi executado na nuvem e de onde vêm os resultados. Todas as imagens são referenciadas no [README principal](../README.md), no ponto do texto que sustentam.

## 1. Geradas automaticamente pelo notebook

Ao final da execução, o notebook gera `evidencias_mvp_olist.zip` (Seção 13). Descompacte-o **na raiz do repositório**, porque ele já segue esta estrutura:

| Caminho | Conteúdo |
|---|---|
| `graficos/` | Gráficos das perguntas P1 a P5, do volume mensal e do modelo estrela (PNG, 150 dpi) |
| `tabelas/` | Tabelas de resultado de cada consulta, perfil e verificações de qualidade, log de carga, integridade, reconciliação, hipóteses e custos (CSV) |
| `metadados/` | `_metadados_coleta.json` (data, versão, volume, SHA-256), perfil da bronze e log de transformações |
| `resultados_resumo.md` | Leitura automática de todos os resultados, gerada a partir dos números da execução |

## 2. Capturas de tela a fazer manualmente

| Arquivo | O que mostrar | Onde |
|---|---|---|
| `01_drive_bronze.png` | Pasta `mvp_olist/bronze/olist/data_coleta=AAAA-MM-DD/` com os 9 CSVs e o `_metadados_coleta.json` | Google Drive |
| `02_drive_camadas.png` | Pastas `silver/` e `gold/` com os arquivos Parquet | Google Drive |
| `03_bigquery_dataset.png` | Dataset `olist_dw` com as 9 tabelas no painel *Explorer* | Console do BigQuery |
| `04_bigquery_esquema_fato.png` | Aba *Esquema* da `fato_entrega`, com as descrições das colunas vindas do catálogo | Console do BigQuery |
| `05_bigquery_preview.png` | Aba *Visualização* da `fato_entrega` com dados carregados | Console do BigQuery |
| `06_bigquery_consulta.png` | Uma das consultas de `scripts/sql/` (por exemplo, `p2_atraso_por_uf.sql`) executada no editor, com o resultado | Console do BigQuery |
| `07_colab_execucao.png` | Notebook no Colab com as células executadas (por exemplo, a verificação de persistência da Seção 8) | Google Colab |

Dica: antes de postar, abra o repositório em uma janela anônima para conferir se as imagens aparecem e se o repositório está público.
