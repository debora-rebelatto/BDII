# Prova 1 - Rec 2023/1  

1. A prova deve ser feita a caneta, em provas com a escrita a lápis, não serão aceitas reclamações relativas à correção. 2. Manter celulares desligados!
2. A compreensão das questões faz parte da prova.

1) (3,0 pontos) Apresente a saída do comando da linha 6, 9 e 11 da tabela abaixo com o nível de isolamento de **read commited** (leitura de dados comitados).

| Linha | Terminal 1                       | Terminal 2                            |
| ----- | -------------------------------- | ------------------------------------- |
| 1     | create table txn (id int);       |
| 2     | begin; (tx=1)                    |
| 3     | insert into txn values (1), (2); |
| 4     |                                  | begin; (tx=2)                         |
| 5     |                                  | insert into txn (id) values (3);      |
| 6     |                                  |                                       |
| 7     | select xmin, xmax, \* from txn;  |                                       |
| 8     |                                  | insert into txn values (1), (2);      |
| 9     |                                  | end;                                  |
| 10    | select xmin, xmax,\* from txn;   |
| 11    | end;                             |                                       |
| 12    |                                  | select xmin, xmax,\* from txn; (tx=3) |

2- (3,0 pontos)-Simule uma situação de dirty read (leitura suja) com os dados abaixo usando SQL, sabendo que o SGBD pode ler dados não comitados.

| Terminal 1                                 | Terminal 2 |
| ------------------------------------------ | ---------- |
| create table t1 (i int, nome varchar(50)); |            |

3- (2,5 Pontos) Demonstre se o escalonador abaixo respeita o protocolo 2PL usando **bloqueios exclusivos e compartilhados**.

|     | T1      | T2       |
| --- | ------- | -------- |
| 1   | Read(A) |
| 2   |         | Write(A) |
| 3   | Read(B) |          |
| 4   |         | Read(B)  |
| 5   | Read(C) |          |
| 6   | Commit  |          |
| 7   |         | Write(B) |
| 8   |         | Commit   |

4. (1,5 pontos) Assinale a alternativa que indica um cenário em que a propriedade atomicidade da sigla ACID seria violada num sistema de banco de dados.

A - Uma transação atualiza duas tabelas diferentes sem nenhuma característica em comum e realiza o "commit" com sucesso, implementando as atualizações nas tabelas.

B- Uma transação começa com uma atualização de uma tabela, mas não completa a atualização por causa de uma falha na rede, resultando na transação sendo revertida ao seu estado anterior (rollback).

C- Uma transação começa com uma atualização em uma tabela, finaliza a transação, implementando a atualização na tabela, mas, após a transação ser finalizada, há uma falha na rede.
D- Uma transação começa com uma atualização em uma tabela, mas outra transação realiza uma leitura na tabela antes da atualização ser Implementada (commit da primeira transação), resultando na primeira transação sendo revertida (rollback).

E - Uma transação começa com uma atualização em uma tabela, mas a atualização é interrompida pelo desligamento do servidor, resultando na reversão da transação (rollback).
