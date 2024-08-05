// Criar índices para melhorar a performance nas consultas
CREATE INDEX log_data_hora_index FOR (log:LogAPI) ON (log.data_hora);
CREATE INDEX evento_data_ocorrencia_index FOR (evento:EventoMISP) ON (evento.data_ocorrencia);

// Carregar dados de logs_api
LOAD CSV WITH HEADERS FROM 'file:///trocar_para_path_logs_api.csv' AS row
MERGE (log:LogAPI {
  ip_origem: row.ip_origem,
  porta_origem: row.porta_origem,
  data_hora: datetime(row.data_hora),
  sistema: row.sistema,
  usuario: row.usuario,
  objeto: row.objeto,
  resultado: row.resultado,
  status_http: toInteger(row.status_http)
});

// Carregar dados de eventos_misp
LOAD CSV WITH HEADERS FROM 'file:///trocar_para_path_eventos_misp.csv' AS row
MERGE (evento:EventoMISP {
  data_ocorrencia: date(row.data_ocorrencia),
  grupo_compartilhamento: row.grupo_compartilhamento,
  nivel_ameaca: row.nivel_ameaca,
  estagio: row.estagio,
  tipo_incidente: row.tipo_incidente,
  instituicao_alvo: row.instituicao_alvo,
  referencia: row.referencia,
  categoria: row.categoria,
  tipo: row.tipo,
  detalhe: row.detalhe
});

// Criar relacionamento entre LogAPI e EventoMISP com data evitando produto cartesiano
MATCH (log:LogAPI)
WITH log
MATCH (evento:EventoMISP)
WHERE date(log.data_hora) = evento.data_ocorrencia
MERGE (log)-[r:OCORREU_EM]->(evento)
ON CREATE SET r.data = date(log.data_hora)
ON MATCH SET r.data = date(log.data_hora);

// Mostrar relacionamentos criados entre LogAPI e EventoMISP
MATCH (log:LogAPI)-[r:OCORREU_EM]->(evento:EventoMISP)
RETURN log, r, evento;

// Consulta principal: Retornar logs e eventos relacionados dos últimos 300 dias
MATCH (log:LogAPI)-[r:OCORREU_EM]->(evento:EventoMISP)
WHERE log.data_hora > datetime() - duration('P300D')
RETURN log, r, evento
ORDER BY log.data_hora DESC
LIMIT 100;

// Verificar a quantidade de logs
MATCH (l:LogAPI) 
RETURN COUNT(l) AS total_logs;

// Verificar a quantidade de eventos MISP
MATCH (e:EventoMISP) 
RETURN COUNT(e) AS total_eventos;

// Análise de eventos por nível de ameaça
MATCH (e:EventoMISP)
RETURN e.nivel_ameaca, COUNT(*) AS quantidade
ORDER BY quantidade DESC;

// Criar nós para os níveis de ameaça e relacionamentos para a contagem de eventos e eventos específicos
MATCH (e:EventoMISP)
WITH e.nivel_ameaca AS nivel, COUNT(e) AS quantidade, COLLECT(e) AS eventos
MERGE (n:NivelAmeaca {nivel: nivel})
MERGE (c:Quantidade {quantidade: quantidade, nivel: nivel})
MERGE (n)-[:TEM_QUANTIDADE]->(c)
WITH c, eventos
UNWIND eventos AS evento
MERGE (evento)-[:PERTENCE_A]->(c);

// Retornar os nós e relacionamentos para visualização em grafos
MATCH (n:NivelAmeaca)-[r:TEM_QUANTIDADE]->(c:Quantidade)
RETURN n, r, c
ORDER BY c.quantidade DESC;

// Mostrar eventos específicos ao clicar no nó de quantidade
MATCH (c:Quantidade)<-[:PERTENCE_A]-(e:EventoMISP)
RETURN c, e;

// Top 5 IPs de origem com mais logs
MATCH (l:LogAPI)
RETURN l.ip_origem, COUNT(*) AS quantidade
ORDER BY quantidade DESC
LIMIT 5;

// Criar nós para os IPs de origem e relacionamentos para a contagem de logs e logs específicos
MATCH (l:LogAPI)
WITH l.ip_origem AS ip, COUNT(l) AS quantidade, COLLECT(l) AS logs
ORDER BY quantidade DESC
LIMIT 5
MERGE (i:IPOrigem {ip: ip})
MERGE (c:Quantidade {quantidade: quantidade, ip: ip})
MERGE (i)-[:TEM_QUANTIDADE]->(c)
WITH c, logs
UNWIND logs AS log
MERGE (log)-[:PERTENCE_A]->(c);

// Retornar os nós e relacionamentos para visualização em grafos
MATCH (i:IPOrigem)-[r:TEM_QUANTIDADE]->(c:Quantidade)
RETURN i, r, c
ORDER BY c.quantidade DESC;

// Mostrar logs específicos ao clicar no nó de quantidade
MATCH (c:Quantidade)<-[:PERTENCE_A]-(l:LogAPI)
RETURN c, l;

// Criar nós para os tipos de incidente e relacionamentos para a contagem de eventos e eventos específicos
MATCH (e:EventoMISP)
WITH e.tipo_incidente AS tipo, COUNT(e) AS quantidade, COLLECT(e) AS eventos
ORDER BY quantidade DESC
MERGE (t:TipoIncidente {tipo: tipo})
MERGE (c:Quantidade {quantidade: quantidade, tipo: tipo})
MERGE (t)-[:TEM_QUANTIDADE]->(c)
WITH c, eventos
UNWIND eventos AS evento
MERGE (evento)-[:PERTENCE_A]->(c);

// Retornar os nós e relacionamentos para visualização em grafos
MATCH (t:TipoIncidente)-[r:TEM_QUANTIDADE]->(c:Quantidade)
RETURN t, r, c
ORDER BY c.quantidade DESC;

// Mostrar eventos específicos ao clicar no nó de quantidade
MATCH (c:Quantidade)<-[:PERTENCE_A]-(e:EventoMISP)
RETURN c, e;

// Logs associados a eventos de alto nível de ameaça
MATCH (l:LogAPI)-[:OCORREU_EM]->(e:EventoMISP)
WHERE e.nivel_ameaca = 'Alto'
RETURN l, e
LIMIT 100;

// Eventos sem logs associados
MATCH (e:EventoMISP)
WHERE NOT ((:LogAPI)-[:OCORREU_EM]->(e))
RETURN e
LIMIT 100;

// Análise temporal: contagem de logs e eventos por mês
MATCH (l:LogAPI)
WITH date(l.data_hora) AS dia, COUNT(*) AS quantidade_logs
RETURN dia.year + '-' + dia.month AS mes, SUM(quantidade_logs) AS total_logs
ORDER BY mes;

MATCH (e:EventoMISP)
WITH e.data_ocorrencia.year + '-' + e.data_ocorrencia.month AS mes, COUNT(e) AS quantidade_eventos
RETURN mes, quantidade_eventos
ORDER BY mes;

// Criar nós para os meses e relacionamentos para a contagem de logs
MATCH (l:LogAPI)
WITH date(l.data_hora) AS dia, l
WITH dia.year + '-' + dia.month AS mes, l
WITH mes, COUNT(l) AS quantidade_logs, COLLECT(l) AS logs
MERGE (m:Mes {mes: mes})
MERGE (c:QuantidadeLogs {quantidade: quantidade_logs, mes: mes})
MERGE (m)-[:TEM_QUANTIDADE_LOGS]->(c)
WITH c, logs
UNWIND logs AS log
MERGE (log)-[:PERTENCE_A]->(c);

// Criar nós para os meses e relacionamentos para a contagem de eventos
MATCH (e:EventoMISP)
WITH date(e.data_ocorrencia) AS dia, e
WITH dia.year + '-' + dia.month AS mes, e
WITH mes, COUNT(e) AS quantidade_eventos, COLLECT(e) AS eventos
MERGE (m:Mes {mes: mes})
MERGE (c:QuantidadeEventos {quantidade: quantidade_eventos, mes: mes})
MERGE (m)-[:TEM_QUANTIDADE_EVENTOS]->(c)
WITH c, eventos
UNWIND eventos AS evento
MERGE (evento)-[:PERTENCE_A]->(c);

// Cria relacionamentos entre logs e eventos baseados na data de ocorrência
MATCH (log:LogAPI)
WITH log, date(log.data_hora) AS log_date
MATCH (evento:EventoMISP {data_ocorrencia: log_date})
MERGE (log)-[:RELACIONADO_p2 {
  data: log_date,
  tipo: evento.tipo_incidente
}]->(evento);

// Consulta para visualizar o grafo com detalhes usando BFS
MATCH (start:LogAPI {ip_origem: '74.236.85.234'})  // Ajuste o IP de origem conforme necessário
CALL apoc.path.expandConfig(start, {
  relationshipFilter: "RELACIONADO_p2",
  minLevel: 1,
  maxLevel: 5,
  bfs: true
})
YIELD path
RETURN path
LIMIT 100;

// Retornar os nós e relacionamentos para visualização em grafos (logs)
MATCH (m:Mes)-[r:TEM_QUANTIDADE_LOGS]->(c:QuantidadeLogs)
RETURN m, r, c
ORDER BY m.mes;

// Retornar os nós e relacionamentos para visualização em grafos (eventos)
MATCH (m:Mes)-[r:TEM_QUANTIDADE_EVENTOS]->(c:QuantidadeEventos)
RETURN m, r, c
ORDER BY m.mes;

// Mostrar logs específicos ao clicar no nó de quantidade de logs
MATCH (c:QuantidadeLogs)<-[:PERTENCE_A]-(l:LogAPI)
RETURN c, l;

// Mostrar eventos específicos ao clicar no nó de quantidade de eventos
MATCH (c:QuantidadeEventos)<-[:PERTENCE_A]-(e:EventoMISP)
RETURN c, e;

// Encontrar caminhos entre logs e eventos (útil para visualização)
MATCH path = (l:LogAPI)-[:OCORREU_EM*1..3]->(e:EventoMISP)
RETURN path
LIMIT 100;