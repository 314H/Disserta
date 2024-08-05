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

### DFS.cypher

Este arquivo contém um script Cypher para realizar uma busca em profundidade (Depth-First Search) em um grafo. Esta técnica de busca é utilizada para explorar todos os vértices e arestas de um grafo de maneira profunda, começando de um nó raiz e indo o mais fundo possível antes de retroceder.

#### Uso

Este script pode ser executado em uma interface de consulta Neo4j, bastando copiar o conteúdo e colar na interface de consulta.

### BFS.cypher

O script Cypher neste arquivo é utilizado para realizar uma busca em largura (Breadth-First Search) em um grafo. Esta técnica explora os nós vizinhos de forma sistemática antes de avançar para o próximo nível de nós vizinhos.

#### Uso

Assim como o script DFS, este script deve ser executado em uma interface de consulta Neo4j.

### consultas.cypher

Contém um conjunto de consultas Cypher para serem utilizadas em um banco de dados de grafos. Estas consultas podem incluir operações como filtragem, agregação, e análise de relacionamentos.

#### Uso

As consultas devem ser copiadas e coladas na interface de consulta do Neo4j conforme necessário.

### kg.cypher

Este arquivo contém scripts Cypher voltados para operações em grafos de conhecimento (Knowledge Graphs). Essas operações podem envolver a criação de nós e arestas, bem como consultas específicas para extrair informações do grafo.

#### Uso

Como os outros arquivos Cypher, este script é executado na interface de consulta Neo4j.

