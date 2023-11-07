# Hash, Heap & others

## Heap Files

**Resumo sobre Heap Files**

Os arquivos de heap (heap files) são uma das estruturas de armazenamento de dados mais simples em bancos de dados e sistemas de gerenciamento de banco de dados. Aqui estão os principais pontos a serem compreendidos sobre heap files:

**Definição de Arquivos de Heap:**

Os arquivos de heap são uma forma simples de armazenar dados em um banco de dados.
Eles consistem em páginas de dados que contêm registros de dados não organizados, sem uma estrutura de índice específica.
Inserção de Registros:

Os registros são inseridos em uma página de heap na ordem em que são recebidos.
Não há ordenação específica ou organização dos registros, e eles são simplesmente anexados à página.

**Busca e Recuperação de Dados:**
A busca em arquivos de heap pode ser ineficiente, pois requer a varredura de todas as páginas para encontrar um registro específico.
Não existem índices para acelerar a recuperação de dados.

**Atualizações e Exclusões:**
Atualizações e exclusões de registros em arquivos de heap podem resultar em espaços vazios nas páginas.
O espaço liberado não é reutilizado automaticamente, levando à fragmentação.

**Fragmentação:**
Com o tempo, os arquivos de heap podem sofrer de fragmentação, o que significa que as páginas contêm espaços vazios significativos.
Isso pode levar a um desperdício de espaço em disco e impactar o desempenho das consultas.
Indicado para Cargas de Trabalho Simples:

Os arquivos de heap são mais adequados para cargas de trabalho simples em que a inserção e recuperação de registros são as operações predominantes.
Eles são menos apropriados para cargas de trabalho de leitura intensiva ou consultas complexas.

**Uso de Índices:**
Em cenários onde a eficiência é crucial, índices podem ser usados em conjunto com arquivos de heap para acelerar a recuperação de dados.
Backup e Recuperação:

Arquivos de heap são fáceis de fazer backup e restaurar, pois não envolvem estruturas complexas de índice.

**Flexibilidade de Esquema:**
Arquivos de heap oferecem flexibilidade no esquema de dados, pois não impõem restrições rígidas sobre a estrutura dos registros.
Em resumo, os arquivos de heap são uma forma simples de armazenar dados em um banco de dados, adequada para cargas de trabalho de inserção simples e recuperação de registros, mas geralmente não recomendados para cenários que exigem consultas complexas ou alta eficiência. A fragmentação e a falta de índices podem tornar as operações de busca ineficientes em arquivos de heap. Portanto, em cenários mais complexos, estruturas de armazenamento e índices adicionais podem ser preferíveis.

## Hash Indexes

[Hash Intro](https://www.postgresql.org/docs/current/hash-intro.html)
[Re-Introducing Hash Indexes in PostgreSQL The Ugly Duckling of index types](https://hakibenita.com/postgresql-hash-index#hash-index)

"There is another type of index you are probably not using, and may have never even heard of. It is wildly unpopular, and until a few PostgreSQL versions ago it was highly discouraged and borderline unusable, but under some circumstances it can out-perform even a B-Tree index.

In this article we re-introduce the Hash index in PostgreSQL!"

O PostgreSQL oferece uma implementação de índices hash persistentes em disco que são totalmente recuperáveis em caso de falha. Esses índices são adequados para qualquer tipo de dados, incluindo tipos de dados que não possuem uma ordenação linear bem definida. As principais características dos índices hash no PostgreSQL incluem:

1. **Suporte a Qualquer Tipo de Dados:** Qualquer tipo de dado pode ser indexado por um índice hash, e não existem restrições quanto ao tamanho da coluna de dados sendo indexada.

2. **Índices de Uma Coluna:** Os índices hash suportam apenas índices de uma única coluna e não permitem a verificação de unicidade.

3. **Operador =:** Os índices hash suportam apenas o operador de igualdade (=), portanto, cláusulas WHERE que especificam operações de intervalo não se beneficiarão dos índices hash.

4. **Armazenamento de Valor de Hash:** Os índices hash armazenam apenas o valor de 4-bits de hash dos dados indexados, não o valor real da coluna. Isso pode resultar em índices muito menores do que índices B-tree, especialmente ao indexar dados longos, como UUIDs ou URLs.

5. **Escaneamento de Índice Hash:** Os índices hash participam de varreduras de índices bitmap e varreduras retroativas.

6. **Desempenho em Cargas de Trabalho Específicas:** Os índices hash são otimizados para cargas de trabalho com muitas operações SELECT e UPDATE que usam varreduras de igualdade em tabelas maiores. Isso ocorre porque os índices hash permitem o acesso direto às páginas de bucket.

7. **Manuseio de Distribuição Desigual:** Os índices hash foram projetados para lidar com distribuições desiguais de valores de hash. Eles podem acomodar hash values adicionais através de páginas de overflow, o que pode levar a um aumento no número de acessos a blocos em índices hash desequilibrados.

8. **Melhor para Dados Únicos ou Quase Únicos:** Os índices hash são mais adequados para dados únicos, quase únicos ou dados com um baixo número de linhas por bucket. Para evitar problemas em índices com valores altamente não únicos, pode-se usar uma condição de índice parcial.

9. **Manutenção de Índices:** Assim como os índices B-tree, os índices hash suportam exclusão de tuplas de índice e tentam remover tuplas de índice mortas durante operações de inserção.

10. **Expansão Incremental:** Os índices hash podem ser expandidos à medida que o número de linhas indexadas cresce. A expansão ocorre em primeiro plano e pode aumentar o tempo de execução para inserções de usuários.

11. **Limitações:** Não existe uma maneira de reduzir o número de buckets em um índice hash, e a redução de tamanho de um índice hash só é possível por meio de uma reconstrução completa com REINDEX.

Em resumo, os índices hash no PostgreSQL são uma opção valiosa para otimizar o desempenho de consultas específicas, especialmente em cargas de trabalho que envolvem consultas de igualdade em tabelas maiores. No entanto, eles requerem um entendimento cuidadoso de suas características e limitações para serem usados de forma eficaz.
