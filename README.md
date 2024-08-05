# Projeto para Diseertação do Mestrado de Computação Aplicada do IPT e Pesquisa e Desenvolvimento para o mercado financeiro no ecossistema do Open Finance.

Este repositório contém scripts e arquivos de consulta desenvolvidos para simulação de dados e execução de consultas em grafos. Os arquivos estão divididos em scripts de simulação e arquivos de consulta no formato Cypher. Este projeto faz parte da dissertação do Mestrado em Computação Aplicada do IPT e da pesquisa e desenvolvimento para o mercado financeiro no Open Finance.

## Estrutura do Repositório

- `SimulaImportCSV.py`: Script Python para geração de dados sintéticos.
- `DFS.cypher`: Script Cypher para execução da busca em profundidade em um grafo.
- `BFS.cypher`: Script Cypher para execução da busca em largura em um grafo.
- `consultas.cypher`: Conjunto de consultas diversas em um grafo.
- `kg.cypher`: Scripts de operações relacionadas a grafos de conhecimento.
- `Datasets/`: Pasta que contém os conjuntos de dados gerados.
  - `eventos_misp.csv`: Arquivo CSV com eventos do MISP gerados pelo script Python.
  - `logs_api.csv`: Arquivo CSV com logs de API gerados pelo script Python.

## Descrição dos Arquivos

### SimulaImportCSV.py

Este script em Python é responsável por gerar dados sintéticos, simulando logs de API e eventos do MISP (Malware Information Sharing Platform). Os dados gerados são exportados para arquivos CSV localizados na pasta `Datasets`.
