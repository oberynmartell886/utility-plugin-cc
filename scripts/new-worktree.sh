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
WORKTREES_DIR="../.worktrees-${PROJECT_NAME}"
# Substitui / por - no nome do diretório para evitar criação de subdiretórios
WORKTREE_DIR_NAME="${NEW_BRANCH//\//-}"
NEW_WORKTREE_PATH="${WORKTREES_DIR}/${WORKTREE_DIR_NAME}"

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

# Verifica se a branch já existe - se sim, retorna erro
if git rev-parse --verify "${NEW_BRANCH}" > /dev/null 2>&1; then
    error "A branch '${NEW_BRANCH}' já existe. Este comando é para criar novas branches."
fi

info "Criando nova branch '${NEW_BRANCH}' baseada em 'origin/${BASE_BRANCH}'..."

# Cria o diretório de worktrees se não existir
if [ ! -d "${WORKTREES_DIR}" ]; then
    info "Criando diretório de worktrees: ${WORKTREES_DIR}"
    mkdir -p "${WORKTREES_DIR}"
fi

# Faz fetch da branch base para garantir referência atualizada
echo ""
info "Atualizando referência origin/${BASE_BRANCH}..."
git fetch origin "${BASE_BRANCH}"

# Cria o worktree
echo ""
info "Criando worktree..."

git worktree add -b "${NEW_BRANCH}" "${NEW_WORKTREE_PATH}" "origin/${BASE_BRANCH}"

# =============================================================================
# Copia arquivos de configuração do Claude e .env que não estão no git
# =============================================================================
CLAUDE_CONFIG_FILES=(".claude" "CLAUDE.md" ".mcp.json")
SOURCE_DIR="$(pwd)"
COPIED_FILES=()

info "Verificando arquivos de configuração do Claude..."

for config_file in "${CLAUDE_CONFIG_FILES[@]}"; do
    # Verifica se o arquivo/diretório está tracked no git
    if ! git ls-files --error-unmatch "$config_file" > /dev/null 2>&1; then
        # Não está no git - verifica se existe no diretório de origem
        if [ -e "${SOURCE_DIR}/${config_file}" ]; then
            if [ -d "${SOURCE_DIR}/${config_file}" ]; then
                cp -r "${SOURCE_DIR}/${config_file}" "${NEW_WORKTREE_PATH}/"
            else
                cp "${SOURCE_DIR}/${config_file}" "${NEW_WORKTREE_PATH}/"
            fi
            COPIED_FILES+=("$config_file")
        fi
    fi
done

# Copia arquivos .env* que não estão no git
info "Verificando arquivos .env..."

for env_file in "${SOURCE_DIR}"/.env*; do
    # Verifica se o glob encontrou algum arquivo
    [ -e "$env_file" ] || continue

    env_filename=$(basename "$env_file")

    # Verifica se o arquivo está tracked no git
    if ! git ls-files --error-unmatch "$env_filename" > /dev/null 2>&1; then
        cp "$env_file" "${NEW_WORKTREE_PATH}/"
        COPIED_FILES+=("$env_filename")
    fi
done

if [ ${#COPIED_FILES[@]} -gt 0 ]; then
    info "Arquivos copiados para o worktree: ${COPIED_FILES[*]}"
else
    info "Nenhum arquivo adicional para copiar."
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