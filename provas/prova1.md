# Prova 1 - 2023/1

1. A prova deve ser feita a caneta, em provas com a escrita a lápis, não serão aceitas reclamações relativas à correção.
2. Manter celulares desligados!
3. A compreensão das questões faz parte da prova.

1) (3 pontos) Apresente a saída do comando da linha 7 e 10 da tabela abaixo.

| Linha | Terminal 1                                  | Terminal 2                           |
| ----- | ------------------------------------------- | ------------------------------------ |
| 1     | create table txn (id int);                  |
| 2     | begin; (tx=1)                               |
| 3     | insert into txn values (1), (2);            |
| 4     |                                             | begin; (tx=2)                        |
| 5     |                                             | insert into txn (id) values (3, 10); |
| 6     |                                             | end;                                 |
| 7     |                                             | insert into txn values (4); (tx=3)   |
| 8     | select xmin, xmax, \* from txn where id = 4 |
| 9     | end;                                        |
| 10    | select xmin, xmax, \* from txn where id>=2; |


2- (2,5 pontos)
A-Crie uma situação de Deadlock com instruções SQL utilizando a tabela "deadlock" conforme abaixo.
B- Mostre como o Postgres irá lidar com as transações conforme a situação de Deadlock anterior. Ou seja, qual transação será abortada?

| Terminal A                                        | Terminal B |
| ------------------------------------------------- | ---------- |
| create table deadlock (id int, nome varchar(50)); |



3- (2,5 Pontos) Demonstre se o escalonador abaixo respeita o protocolo 2PL usando somente bloqueios exclusivos.
||T1|T2|
|--|---|---|
|1|Read(A)|
|2|Read(B)|
|3||Read(A)|
|4|Write(B)||
|5|Commit||
|6||Read(B)|
|7||Write(B)|
|8||Commit|

4- (2 Ponto): No PostgreSQL, o MVCC é uma técnica fundamental para manter a consistência dos dados em ambientes de múltiplos usuários. Assinale a alternativa correta referente ao MVCC:  
A) Garante a integridade referencial dos dados.  
B) Evita bloqueios e permitir que múltiplos usuários acessem simultaneamente.  
C) Permite a criação de índices para consultas mais rápidas.  
D) Reduz o espaço em disco utilizado pelo banco de dados.  
