#!/bin/bash
# Lists all CLAUDE_BROWSER_* environment variables
# Names are free-form and self-explanatory — the LLM interprets them
# Compatible with bash 3.x (macOS default)

PREFIX="CLAUDE_BROWSER_"

vars=$(env | grep "^${PREFIX}" | sort)

if [ -z "$vars" ]; then
    echo "Nenhuma variavel de ambiente com prefixo ${PREFIX} encontrada."
    echo ""
    echo "Configure variaveis com nomes autoexplicativos usando o prefixo ${PREFIX}"
    echo ""
    echo "Exemplos:"
    echo "  ${PREFIX}JIRA_STG_URL=https://jira-stg.empresa.com"
    echo "  ${PREFIX}JIRA_STG_LOGIN=user@email.com"
    echo "  ${PREFIX}JIRA_STG_PASSWORD=senha123"
    echo "  ${PREFIX}MYAPP_DEV_URL=http://localhost:3000"
    echo "  ${PREFIX}GITHUB_TOKEN=ghp_abc123"
    exit 0
fi

echo "=== Variaveis CLAUDE_BROWSER_ Disponiveis ==="
echo ""

while IFS= read -r line; do
    key="${line%%=*}"
    value="${line#*=}"
    name="${key#$PREFIX}"

    # Mask values of variables containing sensitive keywords in the name
    display_value="$value"
    case "$name" in
        *PASSWORD*|*SECRET*|*TOKEN*|*KEY*|*CREDENTIAL*) display_value="***" ;;
    esac

    echo "  ${name}=${display_value}"
done <<< "$vars"

echo ""
