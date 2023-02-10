# Funções
As funções em `PostgreSQL` são blocos de código reutilizáveis que realizam tarefas específicas e podem ser invocadas a partir de outras partes do banco de dados, como consultas SQL. Elas podem ser escritas em várias linguagens de programação, incluindo SQL, PL/pgSQL, C e outras. As funções podem aceitar parâmetros de entrada e retornar valores de saída. Elas são úteis para encapsular regras de negócio e cálculos complexos, ajudando a manter o código limpo e organizado. Além disso, as funções em PostgreSQL podem ser usadas em conjunto com gatilhos e regras para automatizar tarefas no banco de dados.

Exemplos de funções em PostgreSQL:

1. Função de soma: retorna a soma de dois números inteiros.

```sql
CREATE FUNCTION add_numbers(int, int) RETURNS int AS $$
BEGIN
    RETURN $1 + $2;
END;
$$ LANGUAGE plpgsql;
```

2. Função de formatação de data: retorna a data atual formatada como "dd/mm/aaaa".

```sql
CREATE FUNCTION format_date() RETURNS text AS $$
BEGIN
    RETURN to_char(current_date, 'dd/mm/yyyy');
END;
$$ LANGUAGE plpgsql;
```

3. Função de busca por ID: retorna um registro do banco de dados com base em um ID fornecido.

```sql
CREATE FUNCTION get_record(integer) RETURNS table (id integer, name text, age integer) AS $$
BEGIN
    RETURN QUERY SELECT * FROM records WHERE id = $1;
END;
$$ LANGUAGE plpgsql;
```

## Parâmetros
Os parâmetros de funções em PostgreSQL são valores ou expressões passados para a função quando ela é invocada. Eles são usados para fornecer informações adicionais à função, permitindo que ela se comporte de maneira diferente em diferentes invocações.

Ao criar uma função, você pode especificar quantos parâmetros desejar e, também, especificar seus tipos. Para cada invocação da função, você pode fornecer valores para cada um dos parâmetros.

Exemplo de função com parâmetros:
```sql
CREATE FUNCTION add_numbers(int, int) RETURNS int AS $$
BEGIN
    RETURN $1 + $2;
END;
$$ LANGUAGE plpgsql;
```

Neste exemplo, a função `add_numbers` tem dois parâmetros, ambos do tipo `int`. Ao invocar a função, você deve fornecer dois valores inteiros, que serão armazenados nas variáveis `$1` e `$2` no corpo da função. O resultado da função é a soma desses dois valores.

Além de tipos simples como `int` ou `text`, você também pode usar tipos complexos, como `record` ou `table`, como parâmetros de funções em PostgreSQL. Isso permite a passagem de valores mais complexos e flexíveis para a função, tornando-a ainda mais poderosa.

### Table
O parâmetro `table` em PostgreSQL é um tipo de dado que permite passar uma tabela inteira como parâmetro para uma função. Isso é útil quando você precisa passar múltiplas linhas de dados para uma função e trabalhar com elas como uma única estrutura de dados.

Ao usar um parâmetro `table`, você pode passar uma tabela inteira para a função e trabalhar com seus dados usando estruturas como loops e cursores. Além disso, você pode usar o tipo record como elemento da tabela para ter acesso aos dados de cada linha.

Exemplo de função com parâmetro `table`:

```sql
CREATE FUNCTION sum_values(sales table) RETURNS numeric AS $$
DECLARE
  total numeric;
BEGIN
  total = 0;
  FOR i IN 1..array_upper(sales, 1) LOOP
    total = total + sales[i].amount;
  END LOOP;
  RETURN total;
END;
$$ LANGUAGE plpgsql;
```

Neste exemplo, a função `sum_values` tem um parâmetro `table` chamado `sales`, que representa uma tabela inteira. No corpo da função, um loop é usado para percorrer a tabela `sales` e acumular o valor da coluna `amount` em uma variável total. Finalmente, o valor total é retornado.

O uso do parâmetro `table` permite passar dados complexos para a função e trabalhar com eles de maneira eficiente e fácil de manusear. É uma ótima maneira de realizar operações de agregação ou outros cálculos em grandes conjuntos de dados.

### Record

A variável `record` em PostgreSQL é um tipo de dado que permite representar uma linha de um resultado de consulta sem a necessidade de definir uma tabela com uma estrutura fixa. É uma maneira flexível e dinâmica de trabalhar com dados relacionais no PostgreSQL.

Ao usar a variável record, você pode selecionar várias colunas de uma tabela e armazená-las em uma única variável. Esta variável pode ser usada para acessar os dados selecionados e manipulá-los, como qualquer outra variável normal.

Exemplo de uso da variável record:
```sql
DECLARE 
  my_record record;
BEGIN
  SELECT * INTO my_record FROM records WHERE id = 1;
  RAISE NOTICE 'ID: %', my_record.id;
  RAISE NOTICE 'Nome: %', my_record.name;
END;
```

Neste exemplo, uma variável `record` chamada `my_record` é declarada e, em seguida, uma consulta SQL é executada para selecionar uma linha de uma tabela `records` com base no ID. A linha selecionada é armazenada na variável `my_record` e, finalmente, os valores das colunas são acessados usando a notação de ponto (.).

## Retorno
Em PostgreSQL, a declaração `RETURNS` especifica o tipo de dado que será retornado por uma função. O retorno de uma função pode ser um valor simples, como um número ou uma string, ou uma estrutura de dados mais complexa, como uma tabela ou um tipo `record`.

A função retorna o valor usando a instrução `RETURN`. Por exemplo, a seguinte função retorna um número inteiro:

```sql
CREATE FUNCTION add_numbers(int, int) RETURNS int AS $$
BEGIN
    RETURN $1 + $2;
END;
$$ LANGUAGE plpgsql;
```

Neste exemplo, a função `add_numbers` tem dois parâmetros `int` e retorna um valor inteiro, que é a soma dos dois parâmetros.

Você também pode retornar uma tabela inteira como resultado da função, usando a declaração `RETURNS TABLE`. Por exemplo:

```sql
CREATE FUNCTION get_employee_data(text) RETURNS TABLE(id int, name text, salary numeric) AS $$
BEGIN
    RETURN QUERY SELECT id, name, salary FROM employees WHERE name = $1;
END;
$$ LANGUAGE plpgsql;
```

Neste exemplo, a função `get_employee_data` retorna uma tabela com três colunas: `id`, `name` e `salary`. A função é invocada com um nome de funcionário e retorna as informações de salário correspondentes para esse funcionário.

O uso de retornos em funções em PostgreSQL permite que as funções sejam usadas para processar dados e retornar resultados, tornando-as uma ferramenta poderosa para realizar tarefas complexas de maneira eficiente e fácil de usar.
