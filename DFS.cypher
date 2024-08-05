// Consulta para visualizar o grafo com detalhes usando BFS e incluir campo causa_raiz com limitador
MATCH (evento:EventoMISP {tipo_incidente: 'RANSOMWARE'})
CALL apoc.path.expandConfig(evento, {
  relationshipFilter: "RELACIONADO_p2",
  bfs: FALSE,
  limit: 600  // Limite para restringir a quantidade de nós e relacionamentos retornados
})
YIELD path
WITH nodes(path) AS nodes, relationships(path) AS rels
UNWIND nodes AS node
WITH DISTINCT node, nodes, rels
ORDER BY node.data_ocorrencia DESC // Ordenar pela data de ocorrência mais recente primeiro
WITH collect(node) AS ordered_nodes, rels
UNWIND range(0, size(ordered_nodes)-1) AS idx
WITH ordered_nodes[idx] AS node, idx, ordered_nodes, rels
WITH node, 
     CASE 
         WHEN idx = 0 THEN 'sim'
         WHEN idx = size(ordered_nodes) - 1 THEN 'não'
         ELSE 'intermediário'
     END AS causa_raiz,
     rels
// Definindo a propriedade causa_raiz nos nós
SET node.causa_raiz = causa_raiz
RETURN node, node.causa_raiz, rels
LIMIT 600  // Limite para restringir a quantidade de nós e relacionamentos retornados