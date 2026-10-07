
API REST para o sistema de gerenciamento de Equipamentos de Proteção Individual.

## Ferramentas

- Node.js
- Express
- MySQL 8
- mysql2
- Docker
- Docker Compose

Não há HTML ou CSS neste projeto. Ele fornece a API e o banco de dados para uma futura interface.

## Funcionalidades

- Criar colaborador
- Listar colaboradores
- Pesquisar por nome
- Filtrar por status
- Consultar por ID
- Atualizar colaborador
- Excluir colaborador
- Bloqueio de exclusão sem confirmação
- Bloqueio de exclusão quando existe histórico de empréstimos

Campos compatíveis com o layout fornecido:

- Nome completo
- Matrícula
- Cargo
- Setor
- E-mail
- Telefone
- Status

### EPIs

- Cadastro
- Listagem
- Controle de quantidade em estoque

- Registro de empréstimo
- Associação com colaborador
- Associação com usuário responsável
- Associação de um ou mais EPIs
- Baixa automática do estoque
- Consulta dos empréstimos

## Como executar

### 1. Instale Node.js e MySQL

Depois configure o banco usando:

```bash
mysql -u root -p < database.sql
```

### 2. Instale as dependências

```bash
npm install
```

### 3. Crie o arquivo `.env`

Copie `.env.example` para `.env`:

```text
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=root
DB_NAME=sistema_epi
```

Altere a senha conforme sua instalação.

### 4. Inicie

```bash
npm start
```

API:

```text
http://localhost:3000
```

Teste:

```text
GET http://localhost:3000/api/health
```

## CRUD de colaboradores

### Criar

```http
POST /api/colaboradores
Content-Type: application/json
```

```json
{
  "nome": "Ana Souza",
  "matricula": "00421",
  "cargo": "Operador têxtil",
  "setor": "Produção",
  "email": "ana@empresa.com",
  "telefone": "(75) 90000-0000",
  "status": "ATIVO"
}
```

### Listar

```http
GET /api/colaboradores
```

### Pesquisar por nome

```http
GET /api/colaboradores?nome=Ana
```

### Buscar por ID

```http
GET /api/colaboradores/1
```

### Atualizar

```http
PUT /api/colaboradores/1
Content-Type: application/json
```

```json
{
  "nome": "Ana Souza",
  "matricula": "00421",
  "cargo": "Operador têxtil",
  "setor": "Produção",
  "email": "ana.souza@empresa.com",
  "telefone": "(75) 90000-0000",
  "status": "ATIVO"
}
```

### Excluir

A API exige confirmação explícita:

```http
DELETE /api/colaboradores/1?confirm=true
```

Isso permite que a futura interface mostre um modal/alerta antes de executar a exclusão.

## Docker

Para executar tudo com Docker:

```bash
docker compose up --build
```

API:

```text
http://localhost:3000
```

MySQL:

```text
localhost:3306
```

Para parar:

```bash
docker compose down
```

Para apagar também os dados persistidos do banco:

```bash
docker compose down -v
```

## Observação sobre a atividade

A confirmação visual da exclusão, os campos da tela, mensagens Bootstrap e permanência na tela de cadastro pertencem à camada de interface. Como este projeto foi solicitado sem HTML/CSS, essas responsabilidades ficam disponíveis na API por meio dos códigos HTTP e mensagens JSON.

A API já está preparada para uma interface futura consumir os dados.

## Git

```bash
git init
git add .
git commit -m "Implementa API do sistema EPI"
git branch -M main
git remote add origin SEU_REPOSITORIO_GITHUB
git push -u origin main
```
