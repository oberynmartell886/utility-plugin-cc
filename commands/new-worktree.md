---
allowed-tools: Bash
description: Cria um novo git worktree organizado por projeto e branch
---

Execute o script `${CLAUDE_PLUGIN_ROOT}/scripts/new-worktree.sh` passando os argumentos fornecidos.

**IMPORTANTE**: Execute o script diretamente sem modificações, interpretações ou perguntas adicionais.

Argumentos esperados: `<branch-name> <branch-base>`

Caso os argumentos esperados não sejam recebidos, não execute o script e informe ao usuário que os argumentos são obrigatórios e explique cada um deles com exemplos

Exemplo de uso: `/new-worktree feature/api-refactor main`

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/new-worktree.sh" $ARGUMENTS
```
