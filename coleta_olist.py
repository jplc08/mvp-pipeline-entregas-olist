"""Coleta do conjunto público da Olist (Kaggle) para a camada bronze do Data Lake.

Os dados brutos NÃO são versionados no repositório (licença CC BY-NC-SA 4.0 e boa prática);
este script reproduz a coleta a partir da fonte oficial e registra os metadados de reprodutibilidade.
É a mesma lógica da Seção 4 do notebook, para uso fora do Colab.

Uso:
    pip install kagglehub pandas
    python scripts/coleta_olist.py --destino /caminho/do/data_lake/bronze/olist
"""
import argparse
import datetime as dt
import hashlib
import json
import os
import re
import shutil

import kagglehub
import pandas as pd

DATASET = "olistbr/brazilian-ecommerce"
FONTE = "https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce"
LICENCA = "CC BY-NC-SA 4.0"
ARQUIVOS = {
    "olist_orders_dataset.csv": "pedidos",
    "olist_order_items_dataset.csv": "itens",
    "olist_customers_dataset.csv": "clientes",
    "olist_sellers_dataset.csv": "vendedores",
    "olist_products_dataset.csv": "produtos",
    "olist_order_reviews_dataset.csv": "avaliacoes",
    "olist_order_payments_dataset.csv": "pagamentos",
    "olist_geolocation_dataset.csv": "geolocalizacao",
    "product_category_name_translation.csv": "categorias",
}


def sha256(caminho):
    h = hashlib.sha256()
    with open(caminho, "rb") as f:
        for bloco in iter(lambda: f.read(1 << 20), b""):
            h.update(bloco)
    return h.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--destino", required=True, help="pasta da camada bronze (ex.: .../mvp_olist/bronze/olist)")
    args = parser.parse_args()

    agora = dt.datetime.now(dt.timezone(dt.timedelta(hours=-3)))
    origem = kagglehub.dataset_download(DATASET)   # conjunto público: não exige login
    versao = re.search(r"versions/(\d+)", origem)
    pasta = os.path.join(args.destino, f"data_coleta={agora:%Y-%m-%d}")
    os.makedirs(pasta, exist_ok=True)

    registros = []
    for arquivo, nome in ARQUIVOS.items():
        caminho = os.path.join(pasta, arquivo)
        shutil.copy2(os.path.join(origem, arquivo), caminho)
        linhas = len(pd.read_csv(caminho, dtype=str, encoding="utf-8-sig"))
        registros.append({"tabela": nome, "arquivo": arquivo, "linhas": linhas,
                          "tamanho_mb": round(os.path.getsize(caminho) / 2**20, 2), "sha256": sha256(caminho)})
        print(f"{arquivo:<42} {linhas:>10,} linhas")

    metadados = {"fonte": FONTE, "dataset_kaggle": DATASET, "versao_dataset": versao.group(1) if versao else None,
                 "licenca": LICENCA, "data_hora_coleta": agora.isoformat(timespec="seconds"),
                 "pasta_bronze": pasta, "arquivos": registros}
    with open(os.path.join(pasta, "_metadados_coleta.json"), "w", encoding="utf-8") as f:
        json.dump(metadados, f, ensure_ascii=False, indent=2)
    print("Metadados gravados em", os.path.join(pasta, "_metadados_coleta.json"))


if __name__ == "__main__":
    main()
