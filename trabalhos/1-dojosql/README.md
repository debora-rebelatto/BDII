# Dojo SQL

## Setup
- Clonar o repositorio:
  `git clone `https://github.com/dbguilherme/Sql-dojo.git

- Para a base de dados de teste: Rodar o script: 
 `psql -h localhost -U postgres -d postgres -f script.sql `

**Se não tiver Python instalado:**
**Ubuntu**

Abra o Terminal `Ctrl + Alt + T`

Rode o comando:

```bash
sudo apt update
```

Instale o Python:

```bash
sudo apt install python3
```

Instale as dependências:

```bash
sudo apt-get install build-dep python-psycopg2
pip install psycopg2-binary 
```

## Carregue os dados

- Em `create_data/data.py` atualize a linha 29 com a senha do seu usuário do postgres

- Para a base de dados de produção: rodar o script create_data/data.py
 `python3 create_data/data.py`
 
- Acessar o terminal
  `sudo -u postgres psql postgres`
  \c dojo

- Fazer as questões do arquivo questions.sql :)

- Para ampliar o número de tupla no banco de dados, acesse o diretório `create_data`e rode:
     pip install -r requirements.txt
  
     python data.py

## Colab
 Os exercícios podem ser feitos no Google Colab, neste (link)[https://colab.research.google.com/drive/1oN6QWKMLxbgpIMY6Ww9F3qCXDNZZUcV_?usp=sharing] 

---

## Exemplo de arquivo de entrega no dataset com tamanho N: 

| id 	| query                 	| Tempo 1  	| Tempo 2 	| Tempo 3 	|
|----	|-----------------------	|----------	|---------	|---------	|
| 1  	| select * from dados;  	| 1        	| 1       	| 1       	|
| 2  	| select * from dados;  	| 2        	| 2       	| 2       	|
| 3  	| select * from dados;  	| 3        	| 3       	| 3       	|


## Documentação para relembrar a sintaxe do SQL: 

- (Documentação oficial)[https://www.postgresql.org/docs/current/sql-select.html]
- (Tutorials Point)[https://www.tutorialspoint.com/postgresql/postgresql_syntax.htm]
- (Psql commands)[https://www.postgresqltutorial.com/postgresql-administration/psql-commands/]
- (Window Function)[https://www.postgresqltutorial.com/postgresql-window-function/]

## Boa atividade :)
