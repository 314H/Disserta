# Projeto de Dissertação - Proposta de Arquitetura para Cibersegurança no Open Finance: O Poder da Análise com Grafos

## Visão Geral
Este repositório contém scripts e arquivos de consulta desenvolvidos para simulação de dados e análise de grafos no contexto do Open Finance. O projeto faz parte da dissertação do Mestrado em Computação Aplicada do Instituto de Pesquisas Tecnológicas (IPT) e contribui para a pesquisa e desenvolvimento no mercado financeiro.

## Estrutura do Repositório

```
.
├── Scripts
│   └── SimulaImportCSV.py
├── Consultas
│   ├── DFS.cypher
│   ├── BFS.cypher
│   ├── consultas.cypher
│   └── kg.cypher
├── Datasets
│   ├── eventos_misp.csv (links)
│   └── logs_api.csv (links)
└── README.md
```

## Descrição dos Componentes

### Scripts

#### SimulaImportCSV.py
- **Função**: Gera dados sintéticos simulando logs de API e eventos do MISP (Malware Information Sharing Platform).
- **Saída**: Arquivos CSV - `Datasets`.
- **Uso**: Execute o script Python para gerar os datasets.

### Consultas

#### DFS.cypher
- **Função**: Realiza uma busca em profundidade (Depth-First Search) em um grafo.
- **Uso**: Execute na interface de consulta Neo4j.

#### BFS.cypher
- **Função**: Realiza uma busca em largura (Breadth-First Search) em um grafo.
- **Uso**: Execute na interface de consulta Neo4j.

#### consultas.cypher
- **Conteúdo**: Conjunto de consultas Cypher para análise de dados em grafos.
- **Operações**: Inclui filtragem, agregação e análise de relacionamentos.
- **Uso**: Execute as consultas individualmente na interface Neo4j conforme necessário.

#### kg.cypher
- **Função**: Operações específicas para grafos de conhecimento (Knowledge Graphs).
- **Operações**: Criação de nós e arestas, consultas para extração de informações.
- **Uso**: Execute na interface de consulta Neo4j.

### Datasets (links)

- **eventos_misp.csv**: Contém eventos simulados do MISP.
- **logs_api.csv**: Contém logs simulados de API.

## Instruções de Uso

1. Clone este repositório para sua máquina local.
2. Execute `SimulaImportCSV.py` para gerar os datasets, se necessário.
3. Configure um ambiente Neo4j e importe os datasets gerados.
4. Utilize os scripts Cypher na interface de consulta Neo4j para análise dos dados.

## Requisitos

- Python 3.x
- Neo4j (versão recomendada: 4.x ou superior)
- Bibliotecas Python: pandas, numpy (instale via `pip install pandas numpy`)

## Contribuições

Contribuições são bem-vindas! Por favor, abra uma issue para discutir mudanças propostas ou envie um pull request com suas melhorias.

## Contato

Para mais informações sobre este projeto, entre em contato com paulo.salkys@ensino.ipt.br.
