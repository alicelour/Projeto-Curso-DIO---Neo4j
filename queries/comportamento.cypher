// 1. Compras de Alto Valor vs Salário Mensal
// Filtra transações que comprometem mais de 100% da renda declarada em um único item
MATCH (p:Pessoa)-[:REALIZOU]->(t:Transacao)
WHERE t.valor > p.salario
RETURN p.nome AS Cliente, 
       p.salario AS Renda, 
       t.item AS Produto, 
       t.valor AS Valor,
       round(toFloat(t.valor) / p.salario, 2) AS Impacto_Salarial
ORDER BY Impacto_Salarial DESC;

// 2. Perfil de Consumo por Categoria de Rede
// Média de gastos em "Luxo" para pessoas indicadas por clientes VIP
MATCH (vip:Pessoa {score: 900})-[:INDICOU]->(indicado)-[:REALIZOU]->(t:Transacao {categoria: 'Luxo'})
RETURN indicado.nome, avg(t.valor) AS Media_Gasto_Luxo;
