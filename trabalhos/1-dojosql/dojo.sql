-- Perguntas:
-- https://github.com/dbguilherme/Sql-dojo/blob/main/questions.sql

-- Colab:
-- https://colab.research.google.com/drive/13MqPprZ71YRmAouADVLz2vAim-X99meo?usp=drive_open#scrollTo=nKXsFeseSE_b

-- 1- Listar os empregados (nomes) que tem salário maior que seu chefe (usar o join)
SELECT e.nome as "empregado", e2.nome as "chefe" , e.salario as "emp sal" , e2.salario as "chef sal"
FROM empregados e
JOIN empregados e2 ON e.supervisor_id = e2.emp_id
WHERE e2.salario < e.salario;

-- 2- Listar o maior salario de cada departamento (usa o group by )
SELECT d.dep_id as x, max(salario) as y
FROM departamentos d JOIN empregados e
ON e.dep_id = d.dep_id
GROUP BY d.dep_id;

-- 3- Listar o dep_id, nome e o salario do funcionario com maior salario dentro de cada departamento (usar o with)
SELECT dep_id, nome, salario 
FROM empregados 
WHERE (dep_id,salario) 
IN (SELECT dep_id, MAX(salario) 
FROM empregados 
GROUP BY dep_id)

-- 4- Listar os nomes departamentos que tem menos de 3 empregados;
select d.nome 
from empregados e
join departamentos d 
on e.dep_id=d.dep_id 
group by d.nome 
HAVING count(*)>3;

-- 5- Listar os departamentos com o número de colaboradores
select d.nome, count(e.emp_id) 
from departamentos d 
join empregados e on d.dep_id=e.dep_id 
group by d.nome;

-- 6 Listar os empregados que não possue o seu chefe no mesmo departamento/ 
select e1.nome, e1.dep_id from empregados e1 join
empregados e2 on e1.supervisor_id=e2.emp_id
where e1.dep_id!=e2.dep_id;

-- 7- Listar os nomes dos  departamentos com o total de salários pagos (sliding windows function)
SELECT d.dep_id, d.nome AS departamento, SUM(e.salario) AS "Salario total"
FROM departamentos d
LEFT OUTER JOIN empregados e ON d.dep_id = e.dep_id
GROUP BY d.dep_id, d.nome;

-- 8- Listar os nomes dos colaboradores com salario maior que a média do seu departamento (dica: usar subconsultas);
select emp_id,nome, dep_id, salario 
from empregados e1 
where salario > (select avg(salario) 
from empregados e2 
where e1.dep_id = e2.dep_id);

-- 9- Faça uma consulta capaz de listar os dep_id, nome, salario, e as médias de cada departamento utilizando o windows function;
SELECT emp_id, nome, dep_id, salario, AVG(salario) 
OVER (PARTITION BY dep_id) 
FROM empregados;

-- 10 - Encontre os empregados com salario maior ou igual a média do seu departamento. Deve ser reportado o salario do empregado e a média do departamento (dica: usar window function com subconsulta)
SELECT e.nome, e.dep_id, e.salario, AVG(e.salario) 
OVER (PARTITION BY e.dep_id) AS media_salario_departamento
FROM empregados e
JOIN (SELECT dep_id, AVG(salario) AS media_salario 
FROM empregados GROUP BY dep_id) AS t
ON e.dep_id = t.dep_id
WHERE e.salario >= t.media_salario;