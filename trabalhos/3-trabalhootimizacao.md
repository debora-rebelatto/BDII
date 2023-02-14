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

**Tempos de execução:**

```bash
1090ms
1463ms
1132ms
1117ms
1086ms
```

**Cálculo da Média**  
$ \frac{1090 + 1463 + 1132 + 1117 + 1086}{5} = 1180,2 $

**Cálculo do Desvio Padrão**  

1. Calcule a média dos valores: some todos os valores e divida pelo número total de valores.
2. Para cada valor, calcule a diferença entre o valor e a média.
3. Eleve ao quadrado cada diferença calculada no passo anterior.
4. Some todos os valores obtidos no passo 3.
5. Divida a soma obtida no passo 4 pelo número total de valores.
6. Calcule a raiz quadrada do valor obtido no passo 5.

$(1090 - 1180,2)^2 + (1463 - 1180,2)^2 + (1132 - 1180,2)^2 + (1117 - 1180,2)^2 + (1086 - 1180,2)^2 = 8857 $
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

**Tempos de execução:**

```bash
1076
1210
1151
1140
1222
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

**Tempos de execução:**

```bash
315
300
318
301
305
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

**Tempos de execução:**

```bash
301
303
301
297
305
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

