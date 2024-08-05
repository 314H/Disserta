// Cria relacionamentos entre logs e eventos baseados na data de ocorrência
MATCH (log:LogAPI)
WITH log, date(log.data_hora) AS log_date
MATCH (evento:EventoMISP {data_ocorrencia: log_date})
MERGE (log)-[:RELACIONADO {
  data: log_date,
  tipo: evento.tipo_incidente
}]->(evento);

// Função para prever os itens afetados usando BFS (Busca em Largura) até 5 saltos
MATCH (n:LogAPI {ip_origem: '74.236.85.234'})  // Ajuste o IP de origem conforme necessário
CALL apoc.path.subgraphNodes(n, {
  relationshipFilter: "RELACIONADO",
  maxLevel: 5
})
YIELD node
RETURN DISTINCT node;

// Consulta para visualizar o grafo com detalhes
MATCH (log:LogAPI)-[r:RELACIONADO]->(evento:EventoMISP)
RETURN log.ip_origem AS IP_Origem, log.data_hora AS Data_Hora_Log, log.sistema AS Sistema_Log, 
       evento.data_ocorrencia AS Data_Ocorrencia_Evento, evento.tipo_incidente AS Tipo_Incidente, 
       r.data AS Data_Relacao, r.tipo AS Tipo_Relacao
LIMIT 100;

// Consulta para visualizar o grafo com detalhes
MATCH (log:LogAPI)-[r:RELACIONADO]->(evento:EventoMISP)
RETURN log, r, evento
LIMIT 100;

// Cria relacionamentos entre logs e eventos baseados no status HTTP e nível de ameaça
MATCH (log:LogAPI)
MATCH (evento:EventoMISP)
WHERE evento.nivel_ameaca = CASE 
  WHEN log.status_http >= 400 THEN 'Alto'
  WHEN log.status_http >= 300 THEN 'Médio'
  ELSE 'Baixo'
END
MERGE (log)-[:RELACIONADO_POR_STATUS {
  status_http: log.status_http,
  nivel_ameaca: evento.nivel_ameaca
}]->(evento);

// Realiza uma busca em largura (BFS) para encontrar relacionamentos de eventos com nível de ameaça 'Alto' para logs com status_http 500
MATCH (evento:EventoMISP {nivel_ameaca: 'Alto'})
CALL apoc.path.expandConfig(evento, {
  relationshipFilter: 'RELACIONADO_POR_STATUS',
  minLevel: 1,
  maxLevel: 5,
  bfs: true
}) YIELD path
WITH evento, last(nodes(path)) AS log, relationships(path) AS relacao
WHERE log.status_http = 500
RETURN evento, log, relacao;

// Realiza uma busca em largura (BFS) para encontrar relacionamentos de eventos com nível de ameaça 'Alto' para logs com status_http 500 e de um sistema específico
MATCH (evento:EventoMISP {nivel_ameaca: 'Alto'})
CALL apoc.path.expandConfig(evento, {
  relationshipFilter: 'RELACIONADO_POR_STATUS',
  minLevel: 1,
  maxLevel: 5,
  bfs