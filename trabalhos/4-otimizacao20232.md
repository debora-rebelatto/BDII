# Trabalho prático A3 - Otimização de consultas (05/12 - duplas)
 
 [Link Docs](https://docs.google.com/document/d/18HfXRSnD8DmN3SrCVPxFZPG-TSMB1Aw97SYm6ffIHcs/edit)  
 
Um cliente deseja melhorar o desempenho do seu banco de dados. Para isto, você foi acionado para verificar o que está ocorrendo com o banco de dados. Sua tarefa é verificar as consultas que estão rodando no sistema e verificar como o SGBD a está implementando.

As consultas serão as mesmas submetidas na atividade "Dojo SQL" entregue no SIGAA.  

https://github.com/dbguilherme/Sql-dojo

## Tarefa 1

Explicar o funcionamento com o comando explain das 3 consultas mais lentas.  
Executar a consulta 5 vezes, calcular a média e o desvio.  
Explicar o plano da consulta.  
Atentar: Qual algoritmo foi usado para realizar o Join? Explique o seu funcionamento.  
*Utilize o "ANALYZE” para atualizar o catálogo.  
*Para limpar o buffer, sugere-se reiniciar o processo Postgres.  

## Tarefa 2
Analisar a consulta visando possíveis melhorias na consulta.   
Qual etapa está gastando mais recursos? Será que a inserção de index pode ajudar a reduzir o tempo da consulta?   
Além disso, reescrever a consulta pode auxiliar o SBGB?  

## Entrega
A entrega deverá ser feita no formato de um relatório contendo a descrição das consultas e das modificações/otimizações que foram aplicadas para a melhoria do plano.
Uma sugestão é gerar os planos gráficos usando ferramentos como Pgadmin e outros sites como o [explain](https://explain.depesz.com/).

## Limpar o buffer no [ubuntu](https://stackoverflow.com/questions/1216660/see-and-clear-postgres-caches-buffers)
1. Shutdown the database server (pg_ctl, sudo service postgresql stop, sudo systemctl stop postgresql, etc.)  
2. echo 3 > /proc/sys/vm/drop_caches This will clear out the OS file/block caches - very important though I don't know how to do that on other OSs. (In case of permission denied, try sudo sh -c "echo 3 >
/proc/sys/vm/drop_caches" as in that question)  
3. Start the database server (e.g. sudo service postgresql start, sudo systemctl start postgresql)  
