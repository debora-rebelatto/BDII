# Revisão de SQL

- Clonar o repositorio: git clone

- Rodar o script:
  `psql -h localhost -U postgres -d postgres -f script.sql`

- Rodar o script para popular o banco na pasta do repositório:
  `sudo -u postgres psql postgres \c dojo`

- Fazer as questões do arquivo questions.sql

1- Listar os empregados (nomes) que tem salário maior que seu chefe

empregado | chefe | emp sal | chef sal
----------+-------+---------+----------
Maria | Jose | 9500 | 8000
Claudia | Jose | 10000 | 8000
Ana | Jose | 12200 | 8000
Luiz | Pedro | 8000 | 7500

2- Listar o maior salario de cada departamento (pode ser usado o group by)

3- Listar o nome do funcionario com maior salario dentro de cada departamento (pode ser usado o IN)
-- dep_id | nome | salario
-- --------+---------+---------
-- 3 | Joao | 6000
-- 1 | Claudia | 10000
-- 4 | Ana | 12200
-- 2 | Luiz | 8000

4- Listar os nomes departamentos que tem menos de 3 empregados;
-- nome

---

-- Marketing
-- RH
-- Vendas

6- Listar os departamentos com o número de colaboradores
-- nome | count
-- -----------+-------
-- Marketing | 1
-- RH | 2
-- TI | 4
-- Vendas | 1

7- Listar os empregados que não possuem chefes no mesmo departamento
-- nome | dep_id
-- ------+--------
-- Joao | 3
-- Ana | 4

8- Listar os departamentos com o total de salários pagos

9- Listar os colaboradores com salario maior que a média do seu departamento;

10- Compare o salario de cada colaborados com média do seu setor. Dica: usar slide windows functions (https://www.postgresqltutorial.com/postgresql-window-function/)

-- emp_id | nome | dep_id | salario | avg  
-- --------+-----------+--------+---------+------------------------
-- 1 | Jose | 1 | 8000 | 8125.0000000000000000
-- 6 | Claudia | 1 | 10000 | 8125.0000000000000000
-- 3 | Guilherme | 1 | 5000 | 8125.0000000000000000
-- 4 | Maria | 1 | 9500 | 8125.0000000000000000
-- 8 | Luiz | 2 | 8000 | 7750.0000000000000000
-- 5 | Pedro | 2 | 7500 | 7750.0000000000000000
-- 2 | Joao | 3 | 6000 | 6000.0000000000000000
-- 7 | Ana | 4 | 12200 | 12200.0000000000000000

11- Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)

-- nome | salario | dep_id | avg_salary  
-- ---------+---------+--------+------------------------
-- Claudia | 10000 | 1 | 8125.0000000000000000
-- Maria | 9500 | 1 | 8125.0000000000000000
-- Luiz | 8000 | 2 | 7750.0000000000000000
-- Joao | 6000 | 3 | 6000.0000000000000000
-- Ana | 12200 | 4 | 12200.0000000000000000

N- Faça um questão livre e responda com join e subconsulta;
