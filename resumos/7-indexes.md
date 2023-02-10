# Índices (Indexes)

## Introdução

Indices em PostgreSQL são estruturas de dados utilizadas para melhorar a performance de consultas a banco de dados. Eles permitem que as consultas sejam realizadas de forma mais rápida ao fornecer uma forma organizada e acessível de localizar os dados desejados.

Os índices em PostgreSQL podem ser criados para uma coluna ou conjunto de colunas de uma tabela, e eles funcionam como uma tabela auxiliar que armazena valores organizados para que as consultas possam ser realizadas rapidamente. Existem vários tipos de índices em PostgreSQL, incluindo índices B-Tree, Hash e GiST.

Ao criar um índice, é importante considerar o tamanho da tabela e o tipo de consulta que será realizada, pois a escolha do tipo de índice certo pode ter um impacto significativo na performance da consulta. Além disso, o uso excessivo de índices também pode afetar negativamente a performance de escrita das operações no banco de dados.

Em resumo, os índices em PostgreSQL são uma ferramenta valiosa para melhorar a performance de consultas ao banco de dados, mas é importante usá-los com sabedoria para evitar problemas de performance.

## índices primários e secundários

Índice Primário: É um índice especial que é criado automaticamente quando uma tabela é criada. Ele é usado para identificar de forma única cada linha da tabela. Um índice primário é criado usando a chave primária da tabela, que é uma coluna ou conjunto de colunas que não pode ter valores duplicados. O índice primário é usado para garantir que não haja duplicidade de dados na tabela.

Índice Secundário: É um índice criado manualmente pelo usuário. Ele é usado para melhorar a performance das consultas que usam determinadas colunas da tabela. Um índice secundário pode ser criado em uma ou mais colunas da tabela, e pode ser criado como um índice simples ou composto (usando mais de uma coluna). O índice secundário é usado para melhorar a performance das consultas, pois permite que o banco de dados localize rapidamente os dados que precisa sem precisar percorrer todas as linhas da tabela.

## Classificação de índices

A classificação "clustered" e "unclustered" se refere a como os dados são armazenados na tabela de banco de dados.

- Clustered: Quando um índice é "clustered", significa que os dados na tabela são reorganizados de acordo com a ordem do índice. Isso significa que as linhas da tabela ficam fisicamente organizadas na ordem do índice, tornando a consulta mais rápida. No entanto, isso também significa que as operações de inserção, atualização e exclusão podem ser mais lentas, pois a tabela precisa ser reorganizada constantemente.

- Unclustered: Quando um índice é "unclustered", significa que os dados na tabela não são reorganizados de acordo com a ordem do índice. Isso significa que as operações de inserção, atualização e exclusão são mais rápidas, pois a tabela não precisa ser reorganizada constantemente. No entanto, isso também significa que as consultas podem ser mais lentas, pois os dados não estão organizados de acordo com a ordem do índice.

Alguns exemplos de índices incluem:

## Índice B-Tree
É o tipo de índice mais comum e amplamente utilizado em banco de dados relacionais. Ele organiza os dados em uma estrutura de árvore binária, o que permite uma busca muito rápida.

## Índice Hash
Usa uma função hash para mapear os dados a seus respectivos índices. É útil quando as consultas envolvam igualdade (por exemplo, WHERE campo = valor).

**Exemplo:**
Suponha que você tenha uma tabela de clientes com os seguintes dados:

```sql
CREATE TABLE clients (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(50)
);

INSERT INTO clients (id, name, email)
VALUES (1, 'John Doe', 'johndoe@example.com'),
       (2, 'Jane Doe', 'janedoe@example.com'),
       (3, 'John Smith', 'johnsmith@example.com'),
       (4, 'Jane Smith', 'janesmith@example.com');

```

Agora, imagine que você quer buscar todos os clientes com nome 'John Doe'. Sem um índice, o banco de dados teria que escanear todas as linhas da tabela para encontrar as linhas correspondentes. Para melhorar a performance, você pode criar um índice hash na coluna 'name':

```sql
CREATE INDEX clients_name_idx ON clients (name);
```

Agora, quando você executar a consulta abaixo, o banco de dados usará o índice hash para encontrar as linhas correspondentes:

```sql
SELECT * FROM clients WHERE name = 'John Doe';
```

O resultado será:

| id  | name     | email               |
| --- | -------- | ------------------- |
| 1   | John Doe | johndoe@example.com |

Note que, neste exemplo, o índice hash torna a busca por nome muito mais eficiente do que sem um índice.

## Índice de texto:

É usado para melhorar a performance de consultas que envolvem pesquisas em campos de texto. Eles usam uma estrutura de dados chamada índice invertido para indexar as palavras do texto.

## Índice Geográfico:

É usado para melhorar a performance de consultas que envolvem informações geográficas, como locais, endereços, coordenadas etc.

## Índice Bitmap:

É uma estrutura de dados que usa bits para representar as linhas de uma tabela. Ele é útil em consultas que envolvem múltiplos critérios de seleção.
