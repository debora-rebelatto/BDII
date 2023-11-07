# Prova 2

1. Construa uma estrutura de hash extensível para a lista de valores abaixo.
   Considere que o bucket tenha espaço para dois valores, e que a função de hash usada seja a mod. Faça o passo a passo iniciando com a função mod 2 (duas entradas no diretório de ponteiros). Faça o ponteiramento de acordo com o que foi visto em aula.
   Lista: 1,3,5,7,9

2. Construa o diagrama de página a partir dos comandos abaixo em uma página com tamanho variado no Postgres. Os registros têm 200 bytes no máximo cada. Nesta questão ignore o consumo de espaço do header do atributo. Tamanho total da página 4kb.

A) CREATE TABLE teste (id int, x varchar(200));
B) INSERT INTO teste VALUES (1,'A');
INSERT INTO teste VALUES (2, 'BBBBB');
INSERT INTO teste VALUES (1, 'DDDDDDDDDDD');
C) UPDATE teste SET x="ABXXXXX" WHERE id=1;
D) DELETE FROM TESTE WHERE id=2;

3. Com relação à análise de desempenho e tunning de banco de dados, julgue o item subsequente (correto ou incorreto) e explique. Só a resposta "certo" ou "errado" não será considerada, favor explicar a lógica da afirmação.
   "Com relação ao tempo de execução de uma consulta, o uso de indices em tabelas é recomendado para que os dados sejam exibidos rapidamente. A eficiência de uma operação está relacionada à quantidade de índices na tabela: quanto mais indices ela possuir, mais rápida será a execução das operações de escrita."

## Respostas ChatGPT:

AS RESPOSTAS GERADAS POR CHATGPT PODEM CONTER ERROS E NÃO DEVEM SER CONSIDERADAS COMO RESPOSTAS OFICIAIS.

1. Para construir uma estrutura de hash extensível para a lista de valores dada, usaremos a função de hash mod 2 com dois slots iniciais no diretório de ponteiros. Vamos seguir um processo passo a passo:

Passo 1: Inicialização

- Começamos com um diretório de ponteiros com dois slots, numerados de 0 a 1.
- Cada slot pode apontar para um bucket (um local onde os valores são armazenados).
- Inicialmente, ambos os slots estão vazios.

Passo 2: Inserção dos Valores

- Inserimos os valores da lista (1, 3, 5, 7, 9) na estrutura de hash usando a função de hash mod 2.

1. Valor 1 (hash 1): Colocamos o valor 1 no bucket 1.

   Diretório de Ponteiros:
   Slot 0: Vazio
   Slot 1: Aponta para o Bucket 1

   Bucket 1: [1]

2. Valor 3 (hash 1): Como o bucket 1 já contém um valor, precisamos criar um novo bucket.

   Diretório de Ponteiros:
   Slot 0: Vazio
   Slot 1: Aponta para o Bucket 1 (com um overflow)

   Bucket 1: [1, 3]

   Bucket 1 (Overflow): [3]

3. Valor 5 (hash 1): Como o bucket 1 está cheio e não podemos criar mais buckets de overflow sob o slot 1, precisamos fazer uma expansão.

   Diretório de Ponteiros:
   Slot 0: Vazio
   Slot 1: Aponta para o Bucket 1 (com uma nova profundidade global)

   Bucket 1: [1, 3]

   Bucket 1 (Overflow): [3]

   Agora, duplicamos o diretório para acomodar a nova profundidade global.
   Diretório de Ponteiros duplicado:
   Slot 0: Aponta para o mesma estrutura que o Slot 1
   Slot 1: Aponta para a mesma estrutura que o Slot 1

   A profundidade global agora é 2.

   Continuamos inserindo os valores.

4. Valor 7 (hash 1): Como o slot 1 aponta para o mesmo local que o slot 0 (devido à duplicação do diretório), o valor 7 é colocado no bucket 1.

   Bucket 1: [1, 3, 7]

5. Valor 9 (hash 1): O valor 9 também é colocado no bucket 1.

   Bucket 1: [1, 3, 7, 9]

A estrutura de hash extensível foi construída com sucesso para a lista de valores dada. À medida que mais valores são inseridos, a estrutura pode continuar a crescer, com a duplicação do diretório quando necessário. Essa estrutura permite a recuperação eficiente dos valores com base em sua função de hash.

2.

Para construir o diagrama de página a partir dos comandos fornecidos, é importante entender como o PostgreSQL armazena dados em páginas e como esses comandos afetam o armazenamento de dados. Aqui estão os passos para construir o diagrama de página:

**Tamanho da Página:** A página tem um tamanho total de 4 KB (4096 bytes).

**Passo 1: Criação da Tabela (CREATE TABLE)**

- Quando a tabela "teste" é criada, o PostgreSQL alocará espaço para os atributos "id" (tipo int) e "x" (tipo varchar(200)).
- Não é necessário representar essa etapa no diagrama, pois apenas define a estrutura da tabela.

**Passo 2: Inserção de Registros (INSERT INTO)**

- Cada comando "INSERT INTO teste VALUES (id, x);" insere um registro na tabela "teste".
- Cada registro tem um "id" e um valor "x", que é armazenado como uma sequência de caracteres (varchar).
- Os registros são armazenados sequencialmente nas páginas de dados. Vamos começar com a primeira página de dados:

  **Página 1 (4096 bytes):**

  - Registro 1: (id=1, x='A') [Ocupa 204 bytes]
  - Registro 2: (id=2, x='BBBBB') [Ocupa 204 bytes]

**Passo 3: Atualização de Registro (UPDATE)**

- O comando "UPDATE teste SET x='ABXXXXX' WHERE id=1;" atualiza o registro com "id=1" para ter o valor de "x" igual a 'ABXXXXX'.
- Isso não altera o tamanho do registro, apenas seus dados.

  **Página 1 (4096 bytes):**

  - Registro 1: (id=1, x='ABXXXXX') [Ocupa 204 bytes]
  - Registro 2: (id=2, x='BBBBB') [Ocupa 204 bytes]

**Passo 4: Exclusão de Registro (DELETE)**

- O comando "DELETE FROM TESTE WHERE id=2;" exclui o registro com "id=2".
- Isso não altera o tamanho da página, mas marca o espaço do registro como disponível para ser reutilizado no futuro.

  **Página 1 (4096 bytes):**

  - Registro 1: (id=1, x='ABXXXXX') [Ocupa 204 bytes]
  - Espaço vazio onde o Registro 2 costumava estar

Observe que o espaço vazio deixado pela exclusão do Registro 2 pode ser reutilizado para futuras inserções.

Este é um exemplo simplificado do armazenamento de dados em uma página. Lembre-se de que na prática, o PostgreSQL também gerencia informações adicionais, como informações de cabeçalho da página e controle de espaço, que não foram representadas aqui, a fim de manter a simplicidade do exemplo.

3.

A afirmação "Com relação ao tempo de execução de uma consulta, o uso de índices em tabelas é recomendado para que os dados sejam exibidos rapidamente. A eficiência de uma operação está relacionada à quantidade de índices na tabela: quanto mais índices ela possuir, mais rápida será a execução das operações de escrita." é **incorreta**.

**Explicação:**

1. Índices são usados principalmente para melhorar o desempenho das operações de leitura, como SELECTs, que recuperam dados de uma tabela. Quando você executa uma consulta que envolve uma cláusula WHERE, um índice apropriado pode ajudar a acelerar a busca e a recuperação dos registros relevantes.

2. No entanto, o uso de índices não está diretamente relacionado à velocidade das operações de escrita, como INSERT, UPDATE e DELETE. Pelo contrário, os índices podem diminuir o desempenho das operações de escrita, uma vez que cada modificação nos dados principais da tabela pode exigir atualizações nos índices associados. Isso significa que a inserção, atualização e exclusão de registros podem ser mais lentas em tabelas com muitos índices, já que essas operações precisam ser refletidas nos índices correspondentes.

3. Portanto, a decisão de quantos índices usar em uma tabela deve ser baseada na natureza das consultas que você planeja realizar com mais frequência e nos requisitos de desempenho. Ter muitos índices pode acelerar as leituras, mas pode diminuir o desempenho das operações de escrita. É necessário encontrar um equilíbrio para atender às necessidades específicas do aplicativo.

Em resumo, o uso de índices é recomendado para acelerar operações de leitura, mas não é diretamente relacionado à velocidade das operações de escrita. A quantidade de índices em uma tabela deve ser determinada com base nos requisitos de consulta e desempenho do aplicativo.
