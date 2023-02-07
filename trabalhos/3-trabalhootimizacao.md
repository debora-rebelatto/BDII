# Trabalho 3

Trabalho prático A3 - Otimização de consultas (Apresentação 14/02- Pode ser feito em duplas - Submeter o link da apresentação no Moodle)
Um cliente deseja melhorar o desempenho do seu banco de dados. Para isto, você foi acionado para verificar o que está ocorrendo com o banco de dados. Nesse contexto, sua tarefa é criar consultas e verificar como o SGBD a está implementando. A tarefa será apresentada para o cliente (e a turma ;))
Banco de dados: será utilizado o banco disponível neste link https://github.com/credativ/omdb-postgresql
Tarefa 1
Carregar o dataset no SGBD Postgres.
Tarefa 2
Criar duas consultas com joins sobre as tabelas com os maiores número de tuplas;
Tarefa 3
Comparar e reportar o custo de execução com e sem índice (usar o comando explain*). A consulta está utilizando o índice? Executar a consulta 5 vezes e calcular a média e o desvio. Explicar o plano da consulta.
Atentar: Qual algoritmo foi usado para realizar o Join? Explique o seu funcionamento.


*Utilize o "ANALYZE❞ para atualizar o catálogo.
*Para limpar o buffer, sugere-se reiniciar o processo Postgres.