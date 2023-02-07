# Prova 2
1) Construa uma estrutura de hash extensível para a lista de valores abaixo.
Considere que o bucket tenha espaço para dois valores, e que a função de hash usada seja a mod. Faça o passo a passo iniciando com a função mod 2 (duas entradas no diretório de ponteiros). Faça o ponteiramento de acordo com o que foi visto em aula.
Lista: 1,3,5,7,9

2) Construa o diagrama de página a partir dos comandos abaixo em uma página com tamanho variado no Postgres. Os registros têm 200 bytes no máximo cada. Nesta questão ignore o consumo de espaço do header do atributo. Tamanho total da página 4kb.

A) CREATE TABLE teste (id int, x varchar(200));
B) INSERT INTO teste VALUES (1,'A');
INSERT INTO teste VALUES (2, 'BBBBB');
INSERT INTO teste VALUES (1, 'DDDDDDDDDDD');
C) UPDATE teste SET x="ABXXXXX" WHERE id=1;
D) DELETE FROM TESTE WHERE id=2;

3) Com relação à análise de desempenho e tunning de banco de dados, julgue o item subsequente (correto ou incorreto) e explique. Só a resposta "certo" ou "errado" não será considerada, favor explicar a lógica da afirmação.
"Com relação ao tempo de execução de uma consulta, o uso de indices em tabelas é recomendado para que os dados sejam exibidos rapidamente. A eficiência de uma operação está relacionada à quantidade de índices na tabela: quanto mais indices ela possuir, mais rápida será a execução das operações de escrita."
