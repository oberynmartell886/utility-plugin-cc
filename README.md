# oberyn-utility

Plugin utilitario para Claude Code com comandos, hooks e skills para melhorar o fluxo de desenvolvimento.

## Instalacao

### 1. Adicionar o marketplace

No Claude Code, execute:

```
/plugin marketplace add oberynmartell886/utility-plugin-cc
```

Ou usando a URL completa do repositorio Git:

```
/plugin marketplace add https://github.com/oberynmartell886/utility-plugin-cc.git
```

### 2. Instalar o plugin

Apos adicionar o marketplace, instale o plugin:

```
/plugin install oberyn-utility@oberyn-mkplace
```

### Instalacao local (para desenvolvimento)

Clone o repositorio e adicione como marketplace local:

```bash
git clone https://github.com/oberynmartell886/utility-plugin-cc
```

```
/plugin marketplace add ./utility-plugin-cc
/plugin install oberyn-utility@oberyn-mkplace
```

### Atualizacao

Para atualizar o marketplace com as versoes mais recentes:

```
/plugin marketplace update
```

## Funcionalidades

### Comandos

| Comando | Descricao |
|---------|-----------|
| `/new-worktree` | Cria um novo git worktree organizado por projeto e branch |

**Exemplo de uso:**

```
/new-worktree feature/api-refactor main
```

### Skills

| Skill | Descricao |
|-------|-----------|
| `skill-creator` | Guia para criacao de skills eficazes para Claude Code |
| `working-with-worktrees` | Configuracao automatica de ambiente em git worktrees (dependencias, portas, servidor dev) |

### Hooks

| Evento | Funcao |
|--------|--------|
| `SessionStart` | Detecta se o diretorio atual e um git worktree |
| `UserPromptSubmit` | Forca avaliacao de skills e subagents antes de executar tarefas |

### Scripts utilitarios

- `find_available_port.sh` - Descobre portas de rede disponiveis
- `is-worktree-dir.sh` - Verifica se o diretorio e um git worktree
- `new-worktree.sh` - Cria worktrees organizados

## Estrutura do projeto

```
.claude-plugin/
  plugin.json          # Definicao do plugin
  marketplace.json     # Metadados do marketplace
commands/              # Comandos (markdown com frontmatter YAML)
hooks/
  hooks.json           # Configuracao dos event hooks
scripts/               # Scripts bash de implementacao
skills/                # Skills com documentacao e referencias
```

## Licenca

MIT
