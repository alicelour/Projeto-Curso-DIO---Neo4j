# Análise de Score bancário com o Neo4j

Este projeto foi desenvolvido como parte do desafio de modelagem de dados em Grafos, utilizando o **Neo4j**. O objetivo é ir além do Credit Score tradicional, analisando o **comportamento de rede** e a **proximidade com inadimplentes** para decisões de crédito mais assertivas.


## Contexto do Problema

Modelos de análise de crédito tradicionais (relacionais) focam no indivíduo de forma isolada (Salário vs. Dívidas). 
**Este projeto resolve:**
- Identifica se um bom pagador está cercado por uma rede de inadimplência.
- Detecta gastos incompatíveis com a renda declarada.
- Avalia o risco de "contágio" financeiro através de vínculos de sociedade e indicação.


## Modelo do Grafo

O grafo é composto por 25 pessoas interconectadas e transações de alto valor.

### Entidades (Labels):
- `:Pessoa`: Contém propriedades como `nome`, `salario`, `profissao`, `score` e `inadimplente`.
- `:Transacao`: Contém `item`, `valor`, `data` e `categoria`.

### Relacionamentos:
- `[:INDICOU]`: Estabelece um vínculo de confiança ou recomendação.
- `[:SOCIOS_DE]`: Indica vínculo jurídico e responsabilidade compartilhada.
- `[:REALIZOU]`: Conecta a pessoa ao seu histórico de consumo recente.

> **Visualização do Esquema:**


## Queries de Negócio (Insights)

### 1. Risco de Contágio (Análise de 2º Nível)
Identifica solicitantes que possuem score alto, mas estão vinculados a pessoas inadimplentes por sociedade ou indicação.
```cypher
MATCH (inad:Pessoa {inadimplente: true})-[r]-(solicitante:Pessoa {inadimplente: false})
RETURN solicitante.nome, type(r) AS Vinculo, inad.nome AS Pessoa_Risco
```


### 2. Alerta de Incompatibilidade de Renda
Filtra transações onde o valor do item supera em 200% o salário mensal do cliente.
```cypher
MATCH (p:Pessoa)-[:REALIZOU]->(t:Transacao)
WHERE t.valor > (p.salario * 2)
RETURN p.nome, p.salario, t.item, t.valor, (t.valor / p.salario) AS Multiplo_Salarial
ORDER BY Multiplo_Salarial DESC
```

### 3. Caminho Curto até o Risco
Mostra o caminho de conexões entre um cliente VIP e o inadimplente mais próximo.
```Cypher
MATCH p = shortestPath((n1:Pessoa {nome: 'Claudia R.'})-[*]-(n2:Pessoa {inadimplente: true}))
RETURN p
```
