# Planos de Consulta

[Slide](../slides/11-QueryOptimization_final.pdf)

## Otimizador de consulta

Problema: Uma query SQL é declarativa - não especifica o plano de execução.  
Solução: Converter a query para um pl ano equivalente da álgebra relacional.

## Esquema Geral do Otimizador

```mermaid
graph TD
    A[Usuário] -->|Consulta SQL| B[SQL Parser]
    B --> C[Otimizador]
    C -->|Melhor Plano de Execução| D((Resultado))

    subgraph Bloco_SQL_Simples["Bloco SQL Simples"]
        style Bloco_SQL_Simples stroke:#333,stroke-width:2px;
        E[Transforma em Álgebra]
        F[Plano Canônico]
        G[Criação de Planos Alternativos]
        H[Planos Alternativos]
        I[Estima de Custos]

        E -->|Passo 1| F
        F -->|Passo 2| G
        G -->|Passo 3| H
        H -->|Passo 4| I
    end

    C --> Bloco_SQL_Simples
```

- Estratégia que o banco utiliza para executar uma consulta
- Normalmente, vários planos são proposto e um deles é escolhido
- O plano é um pseudocódigo em forma de árvore e álgebra relacional

```mermaid
graph TD
    op1 --> op2
    op2 --> Tabela3
    op2 --> op3
    op3 --> Tabela1
    op3 --> Tabela2
```

• A consulta é convertida em álgebra relacional
• Álgebra relacional é convertida em uma árvore
• Cada operador pode ser alterado
• Operadores podem ser aplicados em diferentes ordens

```sql
SELECT S.sname
FROM Reserves R, Sailors S
WHERE R.id = S.id
AND R.id = 100
AND S.rating > 5
```

```mermaid
%%{init: {"flowchart": {"htmlLabels": true}} }%%
graph TD
    pi("π<sub>sname</sub>") --> delta("δ<sub>bid = 100</sub>")
    pi("π<sub>sname</sub>") --> rating("rating = 5")
    delta("δ<sub>bid = 100</sub>") --> join("⨝ id = id") --> r(Reserves)
    join("⨝ id = id") --> s(Sailors)
```

## Estratégias para processar consulta

- Qual tabela processar primeiro
  - Mais ou menos volumosa
- Utilizar índice
- Ordenar tabela
- Tratamento junção
- Melhor decomposição
- Quantos planos propor
- Como escolher o melhor plano
- Algoritmo de tratamento dos operadores

## Esquema de exemplo

Sailors (id: integer, sname: string, rating: integer, age: real)
Reserves (id: integer, bid: integer, day: dates, rname: string)

**Reserves:**

- Cada tupla com 40 bytes, 100 tuplas por página , 1000 páginas.
- Assumir que existe 100 barcos diferentes, **distribuídos uniformemente;**

**Sailors:**

- Cada tupla com 50 bytes, 80 tuplas por página, 500 páginas;
- Assumir que existem 10 diferentes ratings, **distribuídos uniformemente;**
- Assumir que temos 5 páginas no buffer

```sql
SELECT S.sname
FROM Reserves R, Sailors S
WHERE R.id=S.id AND
 R.id=100 AND S.rating>5
```

- Custo

Plan:
π δ ⨝

```mermaid
%%{init: {"flowchart": {"htmlLabels": true}} }%%
graph TD
    pi("π<sub>sname</sub>") --> delta("δ<sub>bid=100</sub>")
    pi("π<sub>sname</sub>") --> rating("rating = 5")

    delta("δ<sub>bid=100</sub>") --> join("⨝<sub>sid = sid</sub>")
    join("⨝<sub>sid = sid</sub>") --> s(Sailors)
    join("⨝<sub>sid = sid</sub>") --> reserves(Reserves)

    subgraph OnTheFly[on-the-fly]
        rating
        delta
    end

    subgraph OnTheFlyPi[on-the-fly]
        pi
    end

    subgraph PageOriented["Page Oriented Nested Loops"]
        join
    end


    style OnTheFly color:#f66;
    style OnTheFly fill: none;
    style OnTheFly stroke:none;
    style OnTheFlyPi color:#f66;
    style OnTheFlyPi fill: none;
    style OnTheFlyPi stroke:none;
    style PageOriented color:#f66;
    style PageOriented fill: none;
    style PageOriented stroke:none;
```

# Planos alternativos

```mermaid
%%{init: {"flowchart": {"htmlLabels": true}} }%%
graph TD
    pi("π<sub>sname</sub>") --> delta("δ<sub>bid=100</sub>")
    pi("π<sub>sname</sub>") --> rating("rating = 5")

    delta("δ<sub>bid=100</sub>") --> join("⨝<sub>sid = sid</sub>")
    join("⨝<sub>sid = sid</sub>") --> s(Sailors)
    join("⨝<sub>sid = sid</sub>") --> reserves(Reserves)

    subgraph OnTheFly[on-the-fly]
        rating
        delta
    end

    subgraph OnTheFlyPi[on-the-fly]
        pi
    end

    subgraph PageOriented["Page Oriented Nested Loops"]
        join
    end

    style OnTheFly fill: none;
    style OnTheFly stroke:none;
    style OnTheFlyPi fill: none;
    style OnTheFlyPi stroke:none;
    style PageOriented fill: none;
    style PageOriented stroke:none;
```

=> 500.500 IOs

```mermaid
%%{init: {"flowchart": {"htmlLabels": true}} }%%
graph TD
    pi("π<sub>sname</sub>") --> delta1("δ<sub>bid=100</sub>")
    delta1("δ<sub>bid=100</sub>") --> join("⨝<sub>sid = sid</sub>")
    join("⨝<sub>sid = sid</sub>") --> delta2("δ<sub>rating>5</sub>")
    join("⨝<sub>sid = sid</sub>") --> reserves(Reserves)
    delta2("δ<sub>rating>5</sub>") --> sailors(Sailors)

    subgraph OnTheFly[on-the-fly]
        pi
    end

    subgraph OnTheFly2[on-the-fly]
        delta1
    end

    subgraph OnTheFly3[on-the-fly]
        delta2
        reserves
    end

    subgraph PageOriented1[Page Oriented Nest Loops]
        join
    end

    style OnTheFly fill: none;
    style OnTheFly stroke:none;
    style OnTheFly2 fill: none;
    style OnTheFly2 stroke:none;
    style OnTheFly3 fill: none;
    style OnTheFly3 stroke:none;
    style PageOriented1 fill: none;
    style PageOriented1 stroke:none;
```

250.500 IOs

## Plano de Consulta

Na álgebra relacional, várias operações têm equivalências entre si, o que significa que expressões diferentes podem representar a mesma operação ou a mesma saída, embora possam ser expressas de maneira distinta. Essas equivalências também têm impacto nos planos de custo ao executar consultas no banco de dados.

### Equivalências na Álgebra Relacional

π δ ⨝

**Seleções**
δ<sub>c<sub>1</sub>^c<sub>2</sub>...c<sub>n</sub></sub> (R) = δ <sub>c<sub>1</sub></sub>(δ<sub>c<sub>2</sub></sub>(... (δ<sub>c<sub>n</sub></sub>(R))))

δ<sub>c<sub>1</sub></sub>(δ<sub>c<sub>2</sub></sub>(R)) = δ<sub>c<sub>2</sub></sub>(δ<sub>c<sub>1</sub></sub>(R))

**Projeção**
π <sub>a<sub>1</sub></sub>(R) = π <sub>a<sub>1</sub></sub>

**Produtos Cartesianos e Junções**

**Seleções Projeções e Junções**

## Heurística

Aqui estão as ideias contidas nos bullet points organizadas:

### Heurística para Otimização de Consultas:

1. **Empurrar Projeções para a Parte Inferior da Árvore:**

   - Reduz o tamanho da resposta.
   - Exemplo: Em uma relação R(a, b, c) com 20.000 tuplas:
     - Cada tupla é de 190 bytes (header = 24 bytes, a = 8 bytes, b = 8 bytes, c = 150 bytes).
     - Se um bloco é de 1024 bytes, então 1 bloco pode conter 5 tuplas (5 \* 190 = 950).
     - Para 20.000 tuplas, seriam necessários 4.000 blocos.
     - Ao fazer uma projeção eliminando o atributo c, reduz-se para 40 bytes por tupla, cabendo 25 em um bloco.
     - Isso resulta em apenas 800 blocos necessários (fator de redução de 5).

2. **Deixar as Seleções Próximas às Tabelas Aplicadas:**
   - Diminui o número de tuplas a serem processadas mais adiante.
3. **Aplicar Joins por Último (Quando Possível):**
   - Realizar os joins depois das projeções e seleções.
   - Ajuda a reduzir o número de tuplas que passarão pelo processo de junção, otimizando o desempenho da consulta.

Essas heurísticas são diretrizes úteis para a otimização de consultas SQL, ajudando a reduzir o custo das consultas através da manipulação estratégica das operações, projeções, seleções e joins, quando possível.

## Plano de Consulta - Baseado em Heurística

**Algoritmo básico**

Passo 1: Quebre as seleção com condições conjuntivas (and) em uma cascata de operações de seleção
Passo 2: Mova cada operação de seleção o mais baixo possível na árvore de consulta
Passo 3: Reordene os nós folhas de forma que as seleções mais restritivas sejam executadas primeiro
Passo 4: Combine as operações de produto cartesiano com seleções subseqüentes (formando junções)
Passo 5: Quebre e mova as projeção o mais baixo possível na árvore e crie novas projeção quando necessário
Passo 6: Identifique subárvore que representam grupos de operações que podem ser executadas em um único algoritmo

**Exemplo**
Dada a consulta:

```sql
select * from R natural join S natural join T natural join V;
```

```mermaid

```

## Passos Otimizador de Consultas

## Conclusões

- Consultas são as operações mais caras do SGBD
- Encontrar a melhor forma de executar uma consulta é um problema intratável em computação
- O dicionário de dados tem um papel importante no processamento de consultas
- Índices são essenciais
- O SGBD tenta resolver os problemas de otimização de forma automática

# Explain Analyze

The `EXPLAIN ANALYZE` command in PostgreSQL is a powerful tool used to understand and optimize the execution plan of a query. It provides detailed information about how PostgreSQL intends to execute a query and how it actually performs during execution.

Here's a breakdown of how to interpret the output of `EXPLAIN ANALYZE`:

1. **Query Plan Structure:**
   - The output shows a tree-like structure representing the steps PostgreSQL takes to execute the query. Each step is called a "Node" and is represented by a keyword such as `Seq Scan`, `Index Scan`, `Nested Loop`, `Hash Join`, etc.

2. **Operation Type:**
   - Each node in the query plan performs a specific operation to retrieve, filter, or join data. For instance:
     - `Seq Scan`: Sequentially scans a table.
     - `Index Scan`: Uses an index to retrieve rows.
     - `Nested Loop`: Performs nested loop joins between tables.
     - `Hash Join`: Performs hash joins between tables.

3. **Costs and Statistics:**
   - PostgreSQL estimates the cost of each operation based on various factors like disk I/O, CPU usage, etc. These estimated costs are displayed alongside the actual execution times.
   - Important columns include `cost`, `rows`, `actual time`, `loops`, `actual rows`, and more, depending on the query plan node.

4. **Execution Time:**
   - The `actual time` column shows the actual time taken by PostgreSQL to execute a specific node during query execution.

5. **Filtering and Joining Conditions:**
   - Conditions used for filtering rows (`Filter` node) or joining tables (`Join` nodes) are shown, aiding in understanding how PostgreSQL applies WHERE clauses, JOIN conditions, etc.

6. **Order of Execution:**
   - The plan depicts the order in which PostgreSQL executes different parts of the query. It usually starts from the innermost nodes and works its way outwards.

7. **Index Usage and Scan Methods:**
   - Information about the usage of indexes, scan methods (sequential, bitmap, etc.), and access methods is included in the output.

8. **Actual vs. Estimated Rows:**
   - PostgreSQL provides estimates for the number of rows it expects at each step (`rows` column). The `actual rows` column shows the actual number of rows processed during execution. Significant discrepancies between estimated and actual rows could indicate a need for query optimization.

When interpreting the output of `EXPLAIN ANALYZE`, look for inefficiencies, such as sequential scans when an index scan could be more efficient, high costs, unexpected join methods, or significant differences between estimated and actual rows. This information helps in optimizing queries by adding/changing indexes, rewriting queries, or restructuring tables.

Understanding `EXPLAIN ANALYZE` output is crucial for optimizing query performance in PostgreSQL databases. Experiment with different query structures, indexes, and table designs to improve performance based on the insights provided by this command.