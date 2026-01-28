#!/bin/bash

# =============================================================================
# new-worktree.sh
# Script para criar git worktrees de forma organizada por projeto
# Uso: ./new-worktree.sh <nome-nova-branch> <branch-base>
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para exibir mensagens de erro
error() {
    echo -e "${RED}❌ ERRO: $1${NC}" >&2
    exit 1
}

# Função para exibir mensagens de sucesso
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Função para exibir mensagens informativas
info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Validação de argumentos
if [ $# -lt 2 ]; then
    error "Argumentos insuficientes.
    
Uso: $0 <nome-nova-branch> <branch-base>

Exemplo: $0 feature/model-training main"
fi

NEW_BRANCH="$1"
BASE_BRANCH="$2"

# Verifica se estamos em um repositório git
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    error "Este diretório não é um repositório Git."
fi

# Obtém o nome do diretório/projeto atual
PROJECT_NAME=$(basename "$(pwd)")

# Define os caminhos
WORKTREES_DIR="../worktrees-${PROJECT_NAME}"
NEW_WORKTREE_PATH="${WORKTREES_DIR}/${NEW_BRANCH}"

info "Projeto: ${PROJECT_NAME}"
info "Nova branch: ${NEW_BRANCH}"
info "Branch base: ${BASE_BRANCH}"
info "Caminho do worktree: ${NEW_WORKTREE_PATH}"

# Verifica se a branch base existe
if ! git rev-parse --verify "${BASE_BRANCH}" > /dev/null 2>&1; then
    error "A branch base '${BASE_BRANCH}' não existe neste repositório."
fi

# Verifica se já existe um worktree com esse nome
if git worktree list | grep -q "${NEW_BRANCH}"; then
    error "Já existe um worktree para a branch '${NEW_BRANCH}'.
    
Use 'git worktree list' para ver os worktrees existentes."
fi

# Verifica se o diretório já existe
if [ -d "${NEW_WORKTREE_PATH}" ]; then
    error "O diretório '${NEW_WORKTREE_PATH}' já existe.
    
Se você quer recriar o worktree, remova o diretório primeiro:
  rm -rf ${NEW_WORKTREE_PATH}
  git worktree prune"
fi

# Verifica se a branch já existe (se sim, usa ela ao invés de criar nova)
if git rev-parse --verify "${NEW_BRANCH}" > /dev/null 2>&1; then
    info "A branch '${NEW_BRANCH}' já existe. Será utilizada a branch existente."
    BRANCH_FLAG=""
else
    info "Criando nova branch '${NEW_BRANCH}' baseada em '${BASE_BRANCH}'..."
    BRANCH_FLAG="-b"
fi

# Cria o diretório de worktrees se não existir
if [ ! -d "${WORKTREES_DIR}" ]; then
    info "Criando diretório de worktrees: ${WORKTREES_DIR}"
    mkdir -p "${WORKTREES_DIR}"
fi

# Cria o worktree
echo ""
info "Criando worktree..."

if [ -n "${BRANCH_FLAG}" ]; then
    git worktree add "${NEW_WORKTREE_PATH}" ${BRANCH_FLAG} "${NEW_BRANCH}" "${BASE_BRANCH}"
else
    git worktree add "${NEW_WORKTREE_PATH}" "${NEW_BRANCH}"
fi

echo ""
success "Worktree criado com sucesso!"
echo ""
echo -e "📁 Localização: ${GREEN}${NEW_WORKTREE_PATH}${NC}"
echo -e "🌿 Branch: ${GREEN}${NEW_BRANCH}${NC}"
echo ""
echo -e "Para acessar o worktree:"
echo -e "  ${YELLOW}cd ${NEW_WORKTREE_PATH}${NC}"
echo ""
echo -e "Para listar todos os worktrees:"
echo -e "  ${YELLOW}git worktree list${NC}"
echo ""
echo -e "Para remover este worktree posteriormente:"
echo -e "  ${YELLOW}git worktree remove ${NEW_WORKTREE_PATH}${NC}"