---
name: working-with-worktrees
description: Use OBRIGATÓRIAMENTE quando estiver trabalhando em uma sessão de git worktree ou ambiente paralelo isolado. Lida com configuração de ambiente do zero incluindo instalação de dependências, descoberta de porta disponível e inicialização do servidor. Dispara ao iniciar trabalho em um novo worktree, precisar rodar um servidor dev em sessões paralelas, ou configurar um ambiente de desenvolvimento isolado do zero.
---

# Trabalhando com Worktrees

Git worktrees criam cópias isoladas do seu repositório. Cada worktree é um ambiente novo que requer configuração completa.

## Regras Críticas

1. **Nunca mate processos** - Não encerre nenhuma porta ou processo, nem mesmo a porta padrão do projeto
2. **Isolamento completo** - Não acesse ou reutilize nada de outros worktrees
3. **Ambiente limpo** - Trate como um clone novo sem nada pré-instalado

## Workflow de Setup

### 1. Verificar Scripts de Init do Projeto

Antes do setup manual, verifique se o projeto tem automação de inicialização:

```bash
ls -la .claude/skills/ | grep -i init
ls -la scripts/ | grep -i setup
ls -la | grep -iE "setup|init|bootstrap"
cat package.json | grep -E '"(setup|init|bootstrap|prepare)"' 2>/dev/null
cat Makefile 2>/dev/null | grep -E '^(setup|init|bootstrap):'
```

Se encontrar, use o script/skill de init do projeto primeiro, depois continue com os passos restantes.

### 2. Instalar Dependências

Detecte e instale baseado no tipo do projeto:

| Arquivo                   | Comando                           |
| ------------------------- | --------------------------------- |
| `package-lock.json`       | `npm ci`                          |
| `yarn.lock`               | `yarn install --frozen-lockfile`  |
| `pnpm-lock.yaml`          | `pnpm install --frozen-lockfile`  |
| `package.json` (sem lock) | `npm install`                     |
| `requirements.txt`        | `pip install -r requirements.txt` |
| `Pipfile.lock`            | `pipenv install`                  |
| `poetry.lock`             | `poetry install`                  |
| `go.mod`                  | `go mod download`                 |
| `Gemfile.lock`            | `bundle install`                  |
| `composer.lock`           | `composer install`                |
| `Cargo.lock`              | `cargo fetch`                     |

### 3. Configuração de Ambiente

```bash
cp .env.example .env 2>/dev/null || cp .env.sample .env 2>/dev/null || true
```

Verifique variáveis de ambiente obrigatórias no README ou .env.example.

### 4. Encontrar Porta Disponível

Descubra a porta padrão do projeto inspecionando arquivos de configuração:

```bash
grep -riE 'port|PORT' .env .env.example .env.sample package.json config/ 2>/dev/null | head -20
```

Locais comuns onde a porta padrão pode estar definida:

- `.env` / `.env.example` (ex: `PORT=3000`, `APP_PORT=5000`)
- `package.json` scripts (ex: `--port 8080`)
- Arquivos de configuração em `config/`, `src/config/`
- `docker-compose.yml` (mapeamento de portas)
- `Procfile`, `Makefile`

Com a porta padrão identificada, use o script incluído para encontrar uma porta livre a partir dela:

```bash
${CLAUDE_PLUGIN_ROOT}/skills/working-with-worktrees/scripts/find_available_port.sh <porta_padrao_do_projeto>
```

Ou verificação inline (substitua `<porta_padrao>` pela porta descoberta):

```bash
port=<porta_padrao>
while lsof -i :$port > /dev/null 2>&1; do port=$((port + 1)); done
echo $port
```

### 5. Iniciar Servidor

Padrões comuns com porta customizada:

| Framework        | Comando                            |
| ---------------- | ---------------------------------- |
| Node/Express     | `PORT=$port npm run dev`           |
| Next.js          | `npm run dev -- -p $port`          |
| Vite             | `npm run dev -- --port $port`      |
| Create React App | `PORT=$port npm start`             |
| Django           | `python manage.py runserver $port` |
| Flask            | `flask run --port $port`           |
| Rails            | `rails server -p $port`            |
| Go               | `go run . --port $port` (varia)    |

Verifique os scripts do `package.json` ou docs do projeto para o comando dev correto.

### 6. Verificar

```bash
curl -s http://localhost:$port/health || curl -s http://localhost:$port
```

## Referência Rápida

```bash
# 1. Instalar dependências (adapte ao gerenciador do projeto)
npm ci && \
# 2. Descobrir porta padrão e encontrar uma livre
port=$(${CLAUDE_PLUGIN_ROOT}/skills/working-with-worktrees/scripts/find_available_port.sh <porta_padrao_do_projeto>) && \
# 3. Iniciar servidor na porta disponível
PORT=$port npm run dev
```
