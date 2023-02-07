# Trabalho 3

## BD II - Trabalho Prático de Log

### [:paperclip: Descrição da tarefa](https://docs.google.com/document/d/12ExZiKP9j_zXwnjbZfGA74m5fSXff2ErAOLCdfs0ye0/edit)

[Repositório do trabalho](https://github.com/debora-rebelatto/BDII-Log)

Objetivo: implementar o mecanismo de log Redo com checkpoint usando o SGBD.

O código, que poderá utilizar qualquer linguagem de programação, deverá ser capaz de ler o arquivo de log (entradaLog) e o arquivo de Metadado e validar as informações no banco de dados através do modelo REDO.

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

```
<start T1>
<T1,1, A,20,500>
<start T2>
<commit T1>
<CKPT (T2)>
<T2,2, A,20,50>
<start T3>
<start T4>
<commit T2>
<T4,1, B,55,100>
```

Saída:
“Transação T2 realizou REDO”
“Transação T3 não realizou REDO”
“Transação T4 não realizou REDO”

Imprima as variáveis, exemplo:

```json
{
  "INITIAL": {
    "A": [500, 20],
    "B": [20, 30]
  }
}
```

O checkpoint Redo permite que parte do log já processada seja descartada para evitar o reprocessamento.

## Detalhes

Funções a serem implementadas:

- [ ] Ler o arquivo de metadados (dados salvos) e os dados da tabela que irá operar no banco de dados;

- [ ] carregar o banco de dados com a tabela antes de executar o código do log (para zerar as configurações e dados parciais);

- [ ] Carregar o arquivo de log;

- [ ] Verifique quais transações devem realizar REDO. Imprimir o nome das transações que irão sofrer Redo. Observem a questão do checkpoint;

- [ ] Checar quais valores estão salvos nas tabelas (com o select) e atualizar valores inconsistentes (update);

- [ ] Reportar quais dados foram atualizados;

- [ ] Seguir o fluxo de execução conforme o método de REDO, conforme visto em aula;
