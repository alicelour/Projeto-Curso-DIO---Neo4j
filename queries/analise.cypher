// 1. Busca de Inadimplentes na Rede de Contatos (Até 2º Grau)
// Identifica se o solicitante possui vínculos diretos ou indiretos com devedores
MATCH (solicitante:Pessoa {nome: 'Marcos Viana'})
MATCH (devedor:Pessoa {inadimplente: true})
MATCH path = allShortestPaths((solicitante)-[*..2]-(devedor))
RETURN path;

// 2. Localização de "Hubs" de Risco
// Pessoas que não são inadimplentes, mas indicaram vários inadimplentes (potenciais fraudadores)
MATCH (indicador:Pessoa)-[:INDICOU]->(inad:Pessoa {inadimplente: true})
WITH indicador, count(inad) AS qtd_inadimplentes
WHERE qtd_inadimplentes > 1
RETURN indicador.nome, qtd_inadimplentes
ORDER BY qtd_inadimplentes DESC;
