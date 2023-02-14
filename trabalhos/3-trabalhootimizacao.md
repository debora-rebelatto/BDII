# 🎥 Trabalho prático A3
## Otimização de consultas
## Débora Rebelatto

📆 **Data de entrega**: 14/02/2020

📝 **Descrição**: Um cliente deseja melhorar o desempenho do seu banco de dados. Para isto, você foi acionado para verificar o que está ocorrendo com o banco de dados. Nesse contexto, sua tarefa é criar consultas e verificar como o SGBD a está implementando. A tarefa será apresentada para o cliente (e a turma ;))

**Banco de dados**: será utilizado o banco disponível neste link https://github.com/credativ/omdb-postgresql

**Tarefa 1**  
Carregar o dataset no SGBD Postgres.

**Tarefa 2**  
Criar duas consultas com joins sobre as tabelas com os maiores número de tuplas;

**Tarefa 3**  
Comparar e reportar o **custo de execução** com e sem índice (usar o comando explain*). A consulta está utilizando o índice? Executar a consulta 5 vezes e calcular a média e o desvio. Explicar o plano da consulta.
Atentar: Qual algoritmo foi usado para realizar o Join? Explique o seu funcionamento.

## Como carregar o banco de dados
Primeiro, é necessário clonar o repositório do github.

```bash
git clone https://github.com/credativ/omdb-postgresql
```

Caso seu nome de usuário do postgres seja diferente do usuário do sistema, é necessário criar. Para isso, basta executar o comando abaixo.

```bash
sudo -u postgres createuser -s $USER
```

Em seguida, seguindo as instruções do repositório, é necessário criar o banco de dados e carregar os dados.

```bash
cd omdb-postgresql	
./download
./import
```

Para acessar o banco de dados, basta executar o comando abaixo.

```bash
sudo -u postgres psql
\c omdb
```
## Análise de desempenho
Para analisar o desempenho das consultas, foi utilizado o comando `EXPLAIN` do Postgres. O comando `EXPLAIN` retorna o plano de execução da consulta, que é composto por uma árvore de operações. Cada nó da árvore representa uma operação que será realizada para executar a consulta. O comando `EXPLAIN` também retorna o custo estimado de cada operação e o custo total da consulta.

Todos os cálculos foram realizados utilizando o comando `EXPLAIN ANALYZE`, que além de retornar o plano de execução, também executa a consulta e retorna o tempo de execução.

Os cálculos podem ser encontrados também [nesta planilha](https://docs.google.com/spreadsheets/d/1-Kdt59DL8dX9xvrQSFzTBdK3uidualAdOoZVBnuLlVA/)

### Consulta 1:

Selecione o título dos filmes, o nome dos atores, a posição deles no elenco e o papel que interpretam no filme.

```sql
SELECT movies.name AS movie_title, people.name AS actor_name, casts.position, casts.role
FROM movies 
INNER JOIN casts ON movies.id = casts.movie_id
INNER JOIN people ON people.id = casts.person_id;
```

**Sem índice:**

```sql
EXPLAIN ANALYZE SELECT movies.name AS movie_title, people.name AS actor_name, casts.position, casts.role
FROM movies 
INNER JOIN casts ON movies.id = casts.movie_id
INNER JOIN people ON people.id = casts.person_id;
```

```bash
                        QUERY PLAN
-----------------------------------------------------------
 Hash Join  (cost=18110.38..79664.24 rows=1108049 width=43) (actual time=90.342..755.412 rows=1072236 loops=1)
   Hash Cond: (casts.person_id = people.id)
   ->  Hash Join  (cost=8714.01..48479.19 rows=1108049 width=37) (actual time=41.343..376.593 rows=1072236 loops=1)
         Hash Cond: (casts.movie_id = movies.id)
         ->  Seq Scan on casts  (cost=0.00..20364.49 rows=1108049 width=28) (actual time=0.047..84.346 rows=1072236 loops=1)
         ->  Hash  (cost=4918.67..4918.67 rows=196267 width=25) (actual time=41.143..41.144 rows=191478 loops=1)
               Buckets: 65536  Batches: 4  Memory Usage: 3386kB
               ->  Seq Scan on movies  (cost=0.00..4918.67 rows=196267 width=25) (actual time=0.004..17.049 rows=191478 loops=1)
   ->  Hash  (cost=4489.61..4489.61 rows=267261 width=22) (actual time=48.843..48.844 rows=267261 loops=1)
         Buckets: 65536  Batches: 8  Memory Usage: 2414kB
         ->  Seq Scan on people  (cost=0.00..4489.61 rows=267261 width=22) (actual time=0.005..18.206 rows=267261 loops=1)
 Planning time: 0.502 ms
 Execution time: 777.348 ms
(13 rows)

Time: 778.633 ms
```

**Tempos de execução:**

```bash
Execution time: 777,348 ms
Execution time: 761,008 ms
Execution time: 767,481 ms
Execution time: 779,423 ms
Execution time: 754,740 ms
```

**Cálculo da Média**  
$(777.348 + 761.008 + 767.481 + 779.423 + 754.740) / 5 = 768 ms$

**Cálculo do Desvio Padrão**  

1. Calcule a média dos valores: some todos os valores e divida pelo número total de valores.
2. Para cada valor, calcule a diferença entre o valor e a média.
3. Eleve ao quadrado cada diferença calculada no passo anterior.
4. Some todos os valores obtidos no passo 3.
5. Divida a soma obtida no passo 4 pelo número total de valores.
6. Calcule a raiz quadrada do valor obtido no passo 5.

$(777,348 - 768)^2 + (761,008 - 768)^2 + (767,481 - 768)^2 + (779,423 - 768)^2 + (754,74 - 768)^2 = 442,86 $

$442,855 / 5 = 88,57$

$\sqrt{8857} = 9,4$

**Com índice:**

ara criar índices para a consulta mencionada, é necessário analisar as colunas usadas em cada junção e na seleção:

`movies.id`  
`casts.movie_id`  
`people.id`  
`casts.person_id`  

Com base nisso, pode-se criar os seguintes índices:

```sql
CREATE INDEX idx_movies_id ON movies (id);
CREATE INDEX idx_casts_movie_id ON casts (movie_id);
CREATE INDEX idx_people_id ON people (id);
CREATE INDEX idx_casts_person_id ON casts (person_id);
```
Esses índices ajudarão a otimizar as junções da consulta e podem melhorar o desempenho geral. No entanto, é importante lembrar que a criação de índices também tem um custo em termos de espaço de armazenamento e desempenho de gravação, então é importante encontrar um equilíbrio entre o desempenho da consulta e o desempenho geral do sistema.

```sql
                        QUERY PLAN
-----------------------------------------------------------
 Hash Join  (cost=17969.63..77894.34 rows=1072236 width=43) (actual time=93.874..768.522 rows=1072236 loops=1)
   Hash Cond: (casts.person_id = people.id)
   ->  Hash Join  (cost=8573.25..47363.30 rows=1072236 width=37) (actual time=38.799..386.895 rows=1072236 loops=1)
         Hash Cond: (casts.movie_id = movies.id)
         ->  Seq Scan on casts  (cost=0.00..20006.36 rows=1072236 width=28) (actual time=0.008..98.869 rows=1072236 loops=1)
         ->  Hash  (cost=4870.78..4870.78 rows=191478 width=25) (actual time=38.756..38.756 rows=191478 loops=1)
               Buckets: 65536  Batches: 4  Memory Usage: 3386kB
               ->  Seq Scan on movies  (cost=0.00..4870.78 rows=191478 width=25) (actual time=0.003..16.124 rows=191478 loops=1)
   ->  Hash  (cost=4489.61..4489.61 rows=267261 width=22) (actual time=54.941..54.941 rows=267261 loops=1)
         Buckets: 65536  Batches: 8  Memory Usage: 2414kB
         ->  Seq Scan on people  (cost=0.00..4489.61 rows=267261 width=22) (actual time=0.007..20.430 rows=267261 loops=1)
 Planning time: 0.612 ms
 Execution time: 789.259 ms
(13 rows)
```

**Tempos de execução:**

```bash
Execution time: 789,259 ms
Execution time: 831,134 ms
Execution time: 812,750 ms
Execution time: 829,235 ms
Execution time: 785,251 ms
```

**Cálculo da Média**
$(789,259 + 831,134 + 812,750 + 829,235 + 785,251) / 5 = 812,75 ms$

**Cálculo do Desvio Padrão**
$(789,259 - 812,75)^2 + (831,134 - 812,75)^2 + (812,750 - 812,75)^2 + (829,235 - 812,75)^2 + (785,251 - 812,75)^2 = 1917,748ms$

$1917,748 / 5 = 383,55$

$\sqrt{383,55} = 19,5$

### Consulta 2

Selecione a quantidade de filmes por gênero.

```sql
SELECT categories.name, COUNT(DISTINCT movies.id) AS num_movies
FROM categories
INNER JOIN movie_categories ON categories.id = movie_categories.category_id
INNER JOIN movies ON movies.id = movie_categories.movie_id
GROUP BY categories.name;
```

**Sem índice:**

```sql
EXPLAIN ANALYZE SELECT categories.name, COUNT(DISTINCT movies.id) AS num_movies
FROM categories
INNER JOIN movie_categories ON categories.id = movie_categories.category_id
INNER JOIN movies ON movies.id = movie_categories.movie_id
GROUP BY categories.name;
```

```sql
                        QUERY PLAN
-----------------------------------------------------------
 GroupAggregate  (cost=36709.67..38321.73 rows=13963 width=19) (actual time=294.789..364.090 rows=513 loops=1)
   Group Key: categories.name
   ->  Sort  (cost=36709.67..37200.48 rows=196324 width=19) (actual time=294.749..319.670 rows=185840 loops=1)
         Sort Key: categories.name
         Sort Method: external merge  Disk: 5800kB
         ->  Hash Join  (cost=8675.36..15421.47 rows=196324 width=19) (actual time=50.931..146.448 rows=185840 loops=1)
               Hash Cond: (movie_categories.category_id = categories.id)
               ->  Hash Join  (cost=8139.01..14369.61 rows=196324 width=16) (actual time=47.345..117.349 rows=185840 loops=1)
                     Hash Cond: (movie_categories.movie_id = movies.id)
                     ->  Seq Scan on movie_categories  (cost=0.00..3030.24 rows=196324 width=16) (actual time=0.005..16.054 rows=185840 loops=1)
                     ->  Hash  (cost=4918.67..4918.67 rows=196267 width=8) (actual time=46.989..46.989 rows=191478 loops=1)
                           Buckets: 131072  Batches: 4  Memory Usage: 2903kB
                           ->  Seq Scan on movies  (cost=0.00..4918.67 rows=196267 width=8) (actual time=0.025..23.789 rows=191478 loops=1)
               ->  Hash  (cost=355.60..355.60 rows=14460 width=19) (actual time=3.556..3.556 rows=14460 loops=1)
                     Buckets: 16384  Batches: 1  Memory Usage: 903kB
                     ->  Seq Scan on categories  (cost=0.00..355.60 rows=14460 width=19) (actual time=0.055..1.987 rows=14460 loops=1)
 Planning time: 0.536 ms
 Execution time: 365.309 ms
(18 rows)
```

**Tempos de execução:**

```bash
Execution time: 353,979 ms
Execution time: 332,943 ms
Execution time: 328,810 ms
Execution time: 326,834 ms
Execution time: 365,309 ms
```

**Cálculo da Média**
(353.979 + 332.943 + 328.810 + 326.834 + 365.309) / 5 = 341,575 ms

**Cálculo do Desvio Padrão**
$ (353,979 - 341,575)^2 + (332,943 - 341,575)^2 + (328,810 - 341,575)^2 + (326,834 - 341,575)^2 + (365,309 - 341,575)^2 = 1171,915 $

$1171,915 / 5 = 234,383$

$\sqrt{234,383} = 15,3$

**Com índice:**

```sql
CREATE INDEX idx_movie_categories_category_id ON movie_categories(category_id);
CREATE INDEX idx_movie_categories_movie_id ON movie_categories(movie_id);
CREATE INDEX idx_movies_id ON movies(id);
CREATE INDEX idx_categories_id ON categories(id);
CREATE INDEX idx_categories_name ON categories(name);
```

```sql
                        QUERY PLAN
-----------------------------------------------------------
 GroupAggregate  (cost=35089.76..36623.19 rows=13963 width=19) (actual time=247.674..298.886 rows=513 loops=1)
   Group Key: categories.name
   ->  Sort  (cost=35089.76..35554.36 rows=185840 width=19) (actual time=247.615..265.010 rows=185840 loops=1)
         Sort Key: categories.name
         Sort Method: external merge  Disk: 5800kB
         ->  Hash Join  (cost=8548.60..15013.82 rows=185840 width=19) (actual time=34.621..118.357 rows=185840 loops=1)
               Hash Cond: (movie_categories.category_id = categories.id)
               ->  Hash Join  (cost=8012.25..13989.50 rows=185840 width=16) (actual time=31.212..91.812 rows=185840 loops=1)
                     Hash Cond: (movie_categories.movie_id = movies.id)
                     ->  Seq Scan on movie_categories  (cost=0.00..2925.40 rows=185840 width=16) (actual time=0.002..12.853 rows=185840 loops=1)
                     ->  Hash  (cost=4870.78..4870.78 rows=191478 width=8) (actual time=31.167..31.167 rows=191478 loops=1)
                           Buckets: 131072  Batches: 4  Memory Usage: 2903kB
                           ->  Seq Scan on movies  (cost=0.00..4870.78 rows=191478 width=8) (actual time=0.004..14.723 rows=191478 loops=1)
               ->  Hash  (cost=355.60..355.60 rows=14460 width=19) (actual time=3.401..3.401 rows=14460 loops=1)
                     Buckets: 16384  Batches: 1  Memory Usage: 903kB
                     ->  Seq Scan on categories  (cost=0.00..355.60 rows=14460 width=19) (actual time=0.023..1.526 rows=14460 loops=1)
  Planning time: 0.397 ms
  Execution time: 299.646 ms  
  (18 rows)
```

**Tempos de execução:**

```bash
Execution time: 299,646 ms  
Execution time: 284,957 ms
Execution time: 315,243 ms
Execution time: 286,699 ms
Execution time: 317,077 ms
```

**Cálculo da Média**
(299.646 + 284.957 + 315.243 + 286.699 + 317.077) / 5 = 767,481 ms

**Cálculo do Desvio Padrão**

$ (299,646 - 299,646)^2 + (284,957 - 299,646)^2 + (315,243 - 299,646)^2 + (286,699 - 299,646)^2 + (317,077 - 299,646)^2 = 444,201 $

$444,201 / 5 = 88,840$

$\sqrt{0,519} = 9,42ms$

## Hash Join

O Hash Join é um algoritmo de junção usado em bancos de dados relacionais para combinar duas tabelas grandes com base em uma coluna de junção comum. Esse algoritmo é chamado de hash join porque usa uma tabela hash interna para otimizar a junção de dados.

O Hash Join é executado em duas fases:

Fase de construção da tabela hash: o banco de dados constrói uma tabela hash a partir da tabela menor que contém a coluna de junção. Para fazer isso, cada valor na coluna de junção é usado como chave na tabela hash, e as linhas correspondentes da tabela menor são armazenadas na lista vinculada. A tabela hash resultante é armazenada em memória.

Fase de sondagem: o banco de dados usa a tabela hash construída na fase anterior para combinar a tabela menor com a tabela maior. O banco de dados itera sobre as linhas da tabela maior, calcula a chave hash correspondente para cada linha na coluna de junção e verifica se a tabela hash contém uma correspondência. Se uma correspondência for encontrada, as linhas correspondentes da tabela menor são combinadas com a linha da tabela maior.

O Hash Join é especialmente adequado para grandes tabelas, pois pode ser executado em paralelo e armazenar a tabela hash em memória. No entanto, a construção da tabela hash pode ser intensiva em recursos e levar a um alto consumo de memória, especialmente para grandes tabelas. Além disso, o Hash Join só pode ser usado quando uma tabela pode caber completamente em memória. Se a tabela não couber na memória, o Hash Join pode ser substituído pelo Merge Join ou pelo Nested Loop Join.

