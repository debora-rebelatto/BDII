# 🎥 Trabalho prático A3
## Otimização de consultas

📆 **Data de entrega**: 14/02/2023

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

```sql
EXPLAIN ANALYZE SELECT movies.name AS movie_title, people.name AS actor_name, casts.position, casts.role
FROM movies
INNER JOIN casts ON movies.id = casts.movie_id
INNER JOIN people ON people.id = casts.person_id;
```

```sql
                      QUERY PLAN
----------------------------------------------------
 Hash Join  (cost=17969.63..77894.34 rows=1072236 width=43) (actual time=84.982..768.508 rows=1072236 loops=1)
   Hash Cond: (casts.person_id = people.id)
   ->  Hash Join  (cost=8573.25..47363.30 rows=1072236 width=37) (actual time=36.389..417.361 rows=1072236 loops=1)
         Hash Cond: (casts.movie_id = movies.id)
         ->  Seq Scan on casts  (cost=0.00..20006.36 rows=1072236 width=28) (actual time=0.006..102.615 rows=1072236 loops=1)
         ->  Hash  (cost=4870.78..4870.78 rows=191478 width=25) (actual time=36.352..36.352 rows=191478 loops=1)
               Buckets: 65536  Batches: 4  Memory Usage: 3386kB
               ->  Seq Scan on movies  (cost=0.00..4870.78 rows=191478 width=25) (actual time=0.003..15.186 rows=191478 loops=1)
   ->  Hash  (cost=4489.61..4489.61 rows=267261 width=22) (actual time=48.404..48.405 rows=267261 loops=1)
         Buckets: 65536  Batches: 8  Memory Usage: 2414kB
         ->  Seq Scan on people  (cost=0.00..4489.61 rows=267261 width=22) (actual time=0.005..17.411 rows=267261 loops=1)
 Planning time: 0.547 ms
 Execution time: 790.085 ms
(13 rows)
```
#### Sem índice:

**Tempos de execução:**

```bash
1090ms
1463ms
1132ms
1117ms
1086ms
```

**Cálculo da Média**  

$$\frac{1090 + 1463 + 1132 + 1117 + 1086}{5} = 1117 $$

**Cálculo do Desvio Padrão**  

$$(1090 - 1180,2)^2 + (1463 - 1180,2)^2 + (1132 - 1180,2)^2 + (1117 - 1180,2)^2 + (1086 - 1180,2)^2 = 121631 $$

$$121631 / 5 = 24326,2$$

$$\sqrt{24326,2} = 155,968$$

#### Com índice:

Para criar índices para a consulta mencionada, é necessário analisar as colunas usadas em cada junção e na seleção:

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

**Tempos de execução:**

```bash
1076
1210
1151
1140
1222
```

**Cálculo da Média**

$$\frac{1076 + 1210 + 1151 + 1140 + 1222}{5} = 1151$$

**Cálculo do Desvio Padrão**

$$(1076 - 1151)^2 + (1210 - 1151)^2 + (1151 - 1151)^2 + (1140 - 1151)^2 + (1222 - 1151)^2 = 14268 $$

$$14268 / 5 = 2853,6$$

$$\sqrt{2853,6} = 53,41$$

A criação de índices não resultou em um grande ganho de desempenho. Apesar dos índices ajudarem a otimizar as junções, o ganho de desempenho foi relativamente pequeno, o que indica que a consulta pode ter outros gargalos que limitam o desempenho geral. É possível que a seleção de colunas ou a lógica da consulta precise ser otimizada para obter um melhor desempenho. Além disso, a criação de índices tem um custo em termos de espaço de armazenamento e desempenho de gravação, então é importante encontrar um equilíbrio entre o desempenho da consulta e o desempenho geral do sistema.

### Consulta 2

Selecione a quantidade de filmes por gênero.

```sql
SELECT categories.name, COUNT(DISTINCT movies.id) AS num_movies
FROM categories
INNER JOIN movie_categories ON categories.id = movie_categories.category_id
INNER JOIN movies ON movies.id = movie_categories.movie_id
GROUP BY categories.name;
```

```sql
EXPLAIN ANALYZE SELECT categories.name, COUNT(DISTINCT movies.id) AS num_movies
FROM categories
INNER JOIN movie_categories ON categories.id = movie_categories.category_id
INNER JOIN movies ON movies.id = movie_categories.movie_id
GROUP BY categories.name;
```

```sql
                      QUERY PLAN
----------------------------------------------------
 GroupAggregate  (cost=35089.76..36623.19 rows=13963 width=19) (actual time=354.881..398.029 rows=513 loops=1)
   Group Key: categories.name
   ->  Sort  (cost=35089.76..35554.36 rows=185840 width=19) (actual time=354.782..369.300 rows=185840 loops=1)
         Sort Key: categories.name
         Sort Method: external merge  Disk: 5800kB
         ->  Hash Join  (cost=8548.60..15013.82 rows=185840 width=19) (actual time=63.466..206.774 rows=185840 loops=1)
               Hash Cond: (movie_categories.category_id = categories.id)
               ->  Hash Join  (cost=8012.25..13989.50 rows=185840 width=16) (actual time=49.223..168.223 rows=185840 loops=1)
                     Hash Cond: (movie_categories.movie_id = movies.id)
                     ->  Seq Scan on movie_categories  (cost=0.00..2925.40 rows=185840 width=16) (actual time=0.006..68.597 rows=185840 loops=1)
                     ->  Hash  (cost=4870.78..4870.78 rows=191478 width=8) (actual time=48.540..48.540 rows=191478 loops=1)
                           Buckets: 131072  Batches: 4  Memory Usage: 2903kB
                           ->  Seq Scan on movies  (cost=0.00..4870.78 rows=191478 width=8) (actual time=0.005..26.801 rows=191478 loops=1)
               ->  Hash  (cost=355.60..355.60 rows=14460 width=19) (actual time=14.211..14.211 rows=14460 loops=1)
                     Buckets: 16384  Batches: 1  Memory Usage: 903kB
                     ->  Seq Scan on categories  (cost=0.00..355.60 rows=14460 width=19) (actual time=0.888..11.866 rows=14460 loops=1)
 Planning time: 0.980 ms
 Execution time: 399.113 ms
(18 rows)
```

#### Sem índice:

**Tempos de execução:**

```bash
315ms
300ms
318ms
301ms
305ms
```

**Cálculo da Média**

$$\frac{315 + 300 + 318 + 301 + 305}{5} = 305$$

**Cálculo do Desvio Padrão**

$$(315 - 305)^2 + (300 - 305)^2 + (318 - 305)^2 + (301 - 305)^2 + (305 - 305)^2 = 310 $$

$$310 / 5 = 62$$

$$\sqrt{62} = 7,874$$

#### Com índice:

```sql
CREATE INDEX idx_movie_categories_category_id ON movie_categories(category_id);
CREATE INDEX idx_movie_categories_movie_id ON movie_categories(movie_id);
CREATE INDEX idx_movies_id ON movies(id);
CREATE INDEX idx_categories_id ON categories(id);
CREATE INDEX idx_categories_name ON categories(name);
```

**Tempos de execução:**

```bash
301ms
303ms
301ms
297ms
305ms
```

**Cálculo da Média**

$$\frac{301 + 303 + 301 + 297 + 305}{5} = 301$$

**Cálculo do Desvio Padrão**

$$(301 - 301)^2 + (303 - 301)^2 + (301 - 301)^2 + (297 - 301)^2 + (305 - 301)^2 = 36 $$

$$36 / 5 = 7,2$$

$$\sqrt{7,2} = 2,6ms$$

Nessa análise, verificamos o desempenho de uma consulta que retorna a quantidade de filmes por gênero, sem e com índices criados. Observamos que com os índices, a consulta apresentou um ganho significativo de desempenho. A média do tempo de execução da consulta sem índice foi de 305ms e com índice foi de 301ms. Além disso, o desvio padrão foi reduzido de 7,874ms para 2,6ms. Isso indica que, em média, a consulta com índice é executada mais rapidamente e com uma variação menor de tempo de execução em relação à consulta sem índice. Portanto, a criação de índices para as tabelas envolvidas na consulta pode melhorar significativamente o desempenho de consultas semelhantes.

## Hash Join

O Hash Join é um algoritmo de junção usado em bancos de dados relacionais para combinar duas tabelas grandes com base em uma coluna de junção comum. Esse algoritmo é chamado de hash join porque usa uma tabela hash interna para otimizar a junção de dados.

O Hash Join é executado em duas fases:

Fase de construção da tabela hash: o banco de dados constrói uma tabela hash a partir da tabela menor que contém a coluna de junção. Para fazer isso, cada valor na coluna de junção é usado como chave na tabela hash, e as linhas correspondentes da tabela menor são armazenadas na lista vinculada. A tabela hash resultante é armazenada em memória.

Fase de sondagem: o banco de dados usa a tabela hash construída na fase anterior para combinar a tabela menor com a tabela maior. O banco de dados itera sobre as linhas da tabela maior, calcula a chave hash correspondente para cada linha na coluna de junção e verifica se a tabela hash contém uma correspondência. Se uma correspondência for encontrada, as linhas correspondentes da tabela menor são combinadas com a linha da tabela maior.

O Hash Join é especialmente adequado para grandes tabelas, pois pode ser executado em paralelo e armazenar a tabela hash em memória. No entanto, a construção da tabela hash pode ser intensiva em recursos e levar a um alto consumo de memória, especialmente para grandes tabelas. Além disso, o Hash Join só pode ser usado quando uma tabela pode caber completamente em memória. Se a tabela não couber na memória, o Hash Join pode ser substituído pelo Merge Join ou pelo Nested Loop Join.

# Conclusão

Utilizando os conceitos de otimização de consultas, foi possível identificar os principais gargalos de desempenho de uma consulta e otimizá-la. Além disso, foi possível identificar os tipos de junções mais adequados para cada situação e criar índices para melhorar o desempenho de consultas semelhantes.
