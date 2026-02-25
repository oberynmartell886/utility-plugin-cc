---
name: browser-access
description: Use SEMPRE E OBRIGATÓRIAMENTE quando o usuario solicitar acesso a um navegador/browser para qualquer finalidade - validacoes visuais, testes manuais, verificacao de UI, acesso a sistemas web, debug de frontend, inspecao de paginas, criacao de testes e2e, ou qualquer tarefa que envolva abrir e interagir com um navegador web. Dispara ao detectar mencoes a navegador, browser, acessar URL, abrir pagina, verificar tela, testar interface, ou acessar ambientes de desenvolvimento/staging/producao.
---

# Browser Access

Skill para acessar ambientes web usando ferramentas de navegador disponiveis.

## Workflow

### 1. Detectar ferramenta de browser disponivel

Verificar quais ferramentas de navegador estao disponiveis na sessao atual. Exemplos conhecidos por tipo:

**MCP Servers:**

- `@playwright/mcp` — MCP oficial do Playwright para automacao de browser
- `BrowserMCP` (BrowserMCP/mcp) — MCP + extensao Chrome, controla o browser real do usuario com sessoes logadas
- `@anthropic/puppeteer-mcp` — MCP do Puppeteer para controle de browser
- `browserbase/mcp-server-browserbase` — MCP do Browserbase para browsers na nuvem

**Skills:**

- `playwright-skill` (lackeyjb/playwright-skill) — Skill que gera e executa codigo Playwright sob demanda

**Plugins:**

- `dev-browser` (SawyerHood/dev-browser) — Plugin que lanca Chromium ou controla Chrome existente via extensao

Listar as ferramentas disponiveis e usar a que estiver acessivel. **Nao se prender a nenhuma ferramenta especifica** — qualquer recurso que permita controlar um navegador e valido.

Se nenhuma ferramenta de browser estiver disponivel, informar ao usuario e sugerir configurar uma das opcoes acima.

### 2. Recuperar credenciais e URLs dos ambientes

Executar o script para listar as variaveis de ambiente configuradas:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/list-browser-envs.sh"
```

As variaveis usam o prefixo `CLAUDE_BROWSER_` e nomes autoexplicativos — sem convencao rigida. Interpretar o nome de cada variavel para entender seu proposito.

O script mascara valores de variaveis que contenham PASSWORD, SECRET, TOKEN, KEY ou CREDENTIAL no nome. Para obter o valor real durante a autenticacao:

```bash
echo "$CLAUDE_BROWSER_NOME_DA_VARIAVEL"
```

### 3. Selecionar sistema e ambiente

Com base no prompt do usuario e nos nomes das variaveis disponiveis, inferir qual sistema e ambiente acessar. Se houver ambiguidade ou multiplas opcoes possiveis, perguntar ao usuario.

### 4. Navegar e autenticar

1. Acessar a URL do sistema/ambiente selecionado
2. Se existirem credenciais (LOGIN, PASSWORD, TOKEN, etc.), realizar autenticacao
3. Prosseguir com a tarefa solicitada pelo usuario

## Notas importantes

- **Seguranca**: O script mascara variaveis com PASSWORD, SECRET, TOKEN, KEY ou CREDENTIAL no nome. Para autenticacao, ler o valor real diretamente via `echo "$CLAUDE_BROWSER_..."`
