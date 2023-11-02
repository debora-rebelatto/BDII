# :notebook: BD II - Trabalho Prático de Log

## [:paperclip: Descrição da tarefa](https://docs.google.com/document/d/12ExZiKP9j_zXwnjbZfGA74m5fSXff2ErAOLCdfs0ye0/edit)
[Repositório do trabalho](https://github.com/debora-rebelatto/BDII-LogUndo)

Objetivo: implementar o mecanismo de log Undo com checkpoint usando o SGBD
Funcionamento:
O código, que poderá utilizar qualquer linguagem de programação, deverá ser capaz de ler o arquivo de log (entradaLog) e o arquivo de Metadado e validar as informações no banco de dados através do modelo UNDO.
O código receberá como entrada o arquivo de metadados (dados salvos) e os dados da tabela que irá operar no banco de dados.
Exemplo de tabela do banco de dados:

<table>
  <tr>
    <th>ID</th>
    <th>A</th>
    <th>B</th>
  </tr>
  <tr>
    <td>1</td>
    <td>20</td>
    <td>55</td>
  </tr>
  <tr>
    <td>2</td>
    <td>20</td>
    <td>30</td>
  </tr>
</table>

Arquivo de Metadado (json):

```json
{
  "INITIAL": {
    "id": [1, 2],
    "A": [20, 20],
    "B": [55, 30]
  }
}
```

Arquivo de log no formato <transação, “id da tupla”,”coluna”, “valor antigo”, “valor novo”>. Exemplo:

Arquivo de Log:

```bash
<start T1>
<T1,1, A,20>
<start T2>
<commit T1>
<START CKPT(T2)>
<T2,2, B,20>
<commit T2>
<END CKPT>
<start T3>
<start T4>
<T4,1, B,55>
```

Saída:
“Transação T3 realizou UNDO”
“Transação T4 realizou UNDO”

Imprima as variáveis, exemplo:

```json
{
  "table": {
    "A": [500,20],
    "B": [20,30]
  }
} * 500 e 30 são os novos valores

```

## Detalhes

Funções a serem implementadas:

- [x] Carregar o banco de dados com a tabela antes de executar o código do log (para zerar as configurações e dados parciais). Notem que a tabela pode ter um número diferente de colunas e linhas.
- [x] Carregar o arquivo de log;
- [x] Verifique quais transações devem realizar UNDO. Imprimir o nome das transações que irão sofrer Undo.
- [x] Checar quais valores estão salvos nas tabelas (com o select) e atualizar valores inconsistentes (update);
- [x] Reportar quais dados foram atualizados;
- [x] Seguir o fluxo de execução conforme o método de UNDO, conforme visto em aula;

