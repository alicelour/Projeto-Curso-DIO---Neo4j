// 1. Detecção de Sociedades Suspeitas
// Busca por pessoas que são sócias, mas uma é inadimplente e a outra está pedindo crédito alto
MATCH (p1:Pessoa {inadimplente: true})-[:SOCIOS_DE]-(p2:Pessoa {inadimplente: false})
MATCH (p2)-[:REALIZOU]->(t:Transacao)
WHERE t.valor > 10000
RETURN p1.nome AS Socio_Inadimplente, p2.nome AS Solicitante_Em_Risco, t.item, t.valor;

// 2. Verificação de "Caminho de Confiança"
// Verifica se existe um caminho de indicações entre um cliente novo e um cliente antigo de confiança
MATCH (confianca:Pessoa {nome: 'Ricardo Mendonça'}), (novo:Pessoa {nome: 'Leticia K.'})
MATCH path = shortestPath((confianca)-[:INDICOU*]-(novo))
RETURN path;
