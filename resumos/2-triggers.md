# Triggers
Triggers são ações que são executadas automaticamente no banco de dados PostgreSQL sempre que uma determinada operação é realizada, como inserir, atualizar ou excluir dados. Eles são usados para automatizar tarefas que seriam realizadas manualmente, como atualizar campos, registrar alterações em um log, ou validar dados antes de permitir que eles sejam inseridos no banco de dados.

A sintaxe para criar uma função de trigger no PostgreSQL é a seguinte:

```sql
CREATE TRIGGER nome_do_gatilho
[BEFORE | AFTER] [INSERT | UPDATE | DELETE]
ON nome_da_tabela
FOR EACH ROW [EXECUTE FUNCTION | EXECUTE PROCEDURE] nome_da_funcao();
```

- `nome_do_gatilho` é o nome que você escolhe para o seu gatilho.

- `BEFORE` ou `AFTER` indicam se a função deve ser executada antes ou depois da operação que está sendo monitorada (inserção, atualização ou exclusão de dados).

- `INSERT`, `UPDATE` ou `DELETE` indicam a operação que deve ser monitorada.

- `ON nome_da_tabela` especifica a tabela que será monitorada pelo gatilho.

- `FOR EACH ROW` indica que a função será executada para cada linha afetada na tabela.

- `EXECUTE FUNCTION` ou `EXECUTE PROCEDURE` indica se a função deve ser uma função ou procedimento armazenado.

- `nome_da_funcao` é o nome da função que será executada quando o gatilho for acionado.

Para criar um gatilho, você especifica a tabela que deseja monitorar e a ação que deseja que seja executada quando determinada operação é realizada na tabela. Por exemplo, o seguinte código cria um gatilho que registra em um log sempre que uma nova linha é inserida na tabela `employees`:

```sql
CREATE TRIGGER log_employee_insert
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_change();
```

Neste exemplo, o gatilho é ativado após uma inserção na tabela `employees`. A função `log_employee_change` é invocada a cada linha inserida, permitindo que você acesse os dados da linha inserida e registre as informações necessárias.

Os gatilhos são uma ferramenta poderosa que permitem que você personalize e automatize as tarefas do seu banco de dados, garantindo a consistência e a integridade dos dados, e simplificando o processo de gerenciamento do banco de dados.