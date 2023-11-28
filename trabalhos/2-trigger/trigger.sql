-- UFFS - Universidade Federal da Fronteira Sul
-- Banco de Dados II
-- Débora Rebelatto

-- Atividade 1 - Triggers
-- A partir do banco de dados (Dojo), construa 4 gatilhos para as seguintes funcionalidades:
-- 1- Armazenar o histórico de alterações dos salários. Ou seja, deve ser criado uma tabela adicional para
-- armazenar o usuário que fez a alteração, data, salário antigo e o novo salário.
-- 2- Armazenar o histórico de alterações do departamento.
-- 3- Evite a inserção ou atualização de um salário do empregado que seja maior do que seu chefe.
-- 4- Faça um trigger para armazenar o total de salário pagos em cada departamento.
-- Caso um novo empregado seja adicionado (ou atualizado), o total gasto no departamento deve ser atualizado.

-- Entrega:
-- Deve ser feita em um arquivo .sql
-- Pode ser feito em dupla

-- Utilizar o dojo disponibilizado em:
-- https://github.com/dbguilherme/Sql-dojo
-- sql -U <user> dojo
-- \i trigger.sql
-- \c postgres

-- drop everything
/*
DROP TRIGGER IF EXISTS salarios_historico_trigger ON empregados;
DROP TRIGGER IF EXISTS departamentos_historico ON departamentos;
DROP TRIGGER IF EXISTS verifica_salario_trigger ON empregados;
DROP TRIGGER IF EXISTS atualiza_total_salario_departamento_trigger ON empregados;
DROP TABLE IF EXISTS salarios_historico;
DROP TABLE IF EXISTS departamentos_historico;
DROP TABLE IF EXISTS empregados;
DROP TABLE IF EXISTS departamentos;
DROP FUNCTION IF EXISTS salarios_historico();
DROP FUNCTION IF EXISTS departamentos_historico();
DROP FUNCTION IF EXISTS verifica_salario();
DROP FUNCTION IF EXISTS atualiza_total_salario_departamento();
*/

drop database dojo;

create database dojo;

\c dojo

CREATE TABLE departamentos (
    dep_id serial PRIMARY KEY,
    nome varchar(255) DEFAULT NULL
);

CREATE TABLE empregados (
    emp_id serial PRIMARY KEY,
    dep_id int NOT NULL REFERENCES departamentos(dep_id),
    supervisor_id int DEFAULT NULL,
    nome varchar(255) DEFAULT NULL,
    salario int DEFAULT NULL
);

CREATE TABLE salarios_historico (
    id_historico serial PRIMARY KEY,
    id_empregado int NOT NULL REFERENCES empregados(emp_id),
    salario_antigo int NOT NULL,
    salario_novo int NOT NULL,
    data_alteracao timestamp NOT NULL,
    usuario_alteracao varchar(255) NOT NULL
);

CREATE TABLE departamentos_historico (
    id_historico serial PRIMARY KEY,
    id_departamento int NOT NULL REFERENCES departamentos(dep_id),
    nome_antigo varchar(255) NOT NULL,
    nome_novo varchar(255) NOT NULL,
    data_alteracao timestamp NOT NULL,
    usuario_alteracao varchar(255) NOT NULL
);

INSERT INTO departamentos (dep_id, nome)
VALUES
    (1,'TI'),
    (2,'RH'),
    (3,'Vendas'),
    (4,'Marketing');

INSERT INTO empregados (emp_id, dep_id, supervisor_id, nome, salario)
VALUES
    (1,1,0,'Jose','8000'),
    (2,3,5,'Joao','6000'),
    (3,1,1,'Guilherme','5000'),
    (4,1,1,'Maria','9500'),
    (5,2,0,'Pedro','7500'),
    (6,1,1,'Claudia','10000'),
    (7,4,1,'Ana','12200'),
    (8,2,5,'Luiz','8000');

CREATE FUNCTION salarios_historico() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO salarios_historico (id_empregado, salario_antigo, salario_novo, data_alteracao, usuario_alteracao)
        VALUES (OLD.cdemp_id, OLD.salario, NEW.salario, NOW(), CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS salarios_historico ON empregados;
CREATE TRIGGER salarios_historico
AFTER UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION salarios_historico();

CREATE OR REPLACE FUNCTION departamentos_historico() RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        INSERT INTO departamentos_historico (id_departamento, nome_antigo, nome_novo, data_alteracao, usuario_alteracao)
        VALUES (OLD.dep_id, OLD.nome, NEW.nome, NOW(), CURRENT_USER);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS departamentos_historico ON departamentos;
CREATE TRIGGER departamentos_historico
AFTER UPDATE ON departamentos
FOR EACH ROW
EXECUTE FUNCTION departamentos_historico();


CREATE OR REPLACE FUNCTION verifica_salario() RETURNS TRIGGER AS $$
DECLARE
    supervisor_salary INT;
BEGIN
    SELECT salario INTO supervisor_salary
    FROM empregados
    WHERE emp_id = NEW.supervisor_id;

    IF NEW.salario > supervisor_salary THEN
        RAISE EXCEPTION 'Employee % cannot have a higher salary than their supervisor (Supervisor Salary: %, Employee Salary: %).', NEW.emp_id, supervisor_salary, NEW.salario;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS salarios_historico_trigger ON empregados;
CREATE TRIGGER verifica_salario_trigger
BEFORE INSERT OR UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION verifica_salario();


CREATE OR REPLACE FUNCTION atualiza_total_salario_departamento() RETURNS TRIGGER AS $$
BEGIN
    UPDATE departamentos
    SET total_salary = (
        SELECT SUM(salario)
        FROM empregados
        WHERE dep_id = NEW.dep_id
    )
    WHERE dep_id = NEW.dep_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

ALTER TABLE departamentos
ADD COLUMN IF NOT EXISTS total_salary INT DEFAULT 0;

DROP TRIGGER IF EXISTS atualiza_total_salario_departamento_trigger ON empregados;
CREATE TRIGGER atualiza_total_salario_departamento_trigger
AFTER INSERT OR UPDATE ON empregados
FOR EACH ROW
EXECUTE FUNCTION atualiza_total_salario_departamento();

-- Testes de trigger
-- Deveria atualizar o salário e inserir no histórico
UPDATE empregados SET salario = 20000 WHERE emp_id = 1;
SELECT * FROM salarios_historico;
/*
Resultado:
id_historico | id_empregado | salario_antigo | salario_novo |       data_alteracao       | usuario_alteracao
--------------+--------------+----------------+--------------+----------------------------+-------------------
            1 |            1 |          20000 |        20000 | 2023-09-13 18:35:51.156418 | deb
*/

-- Deveria atualizar o departamento e inserir no histórico
UPDATE departamentos SET nome = 'TI - Novo' WHERE dep_id = 1;
SELECT * FROM departamentos_historico;
/*
Resultado:
id_historico | id_departamento | nome_antigo | nome_novo |       data_alteracao       | usuario_alteracao
--------------+-----------------+-------------+-----------+----------------------------+-------------------
            1 |               1 | TI - Novo   | TI - Novo | 2023-09-13 18:38:27.544306 | deb
*/

-- Não deveria atualizar o salário
UPDATE empregados SET salario = 10000 WHERE emp_id = 2;
/*
ERROR:  Employee 2 cannot have a higher salary than their supervisor (Supervisor Salary: 7500, Employee Salary: 10000).
CONTEXT:  PL/pgSQL function check_salary() line 11 at RAISE
*/

-- Deveria atualizar o total de salário do departamento
UPDATE empregados SET salario = 10000 WHERE emp_id = 1;
UPDATE empregados SET salario = 1000 WHERE emp_id = 2;
INSERT INTO empregados (emp_id, dep_id, supervisor_id, nome, salario) VALUES (9, 3, 5, 'Joana', '1000');

SELECT * FROM departamentos;
/*
Resultado:
dep_id |   nome    | total_salary
------+-----------+--------------
    2 | RH        |            0
    4 | Marketing |            0
    1 | TI - Novo |        39500
    3 | Vendas    |         1000
*/