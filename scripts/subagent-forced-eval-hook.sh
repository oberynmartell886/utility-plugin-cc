#!/bin/bash
# UserPromptSubmit hook that forces explicit subagent evaluation
source "$(dirname "${BASH_SOURCE[0]}")/ensure-permissions.sh"

cat <<'EOF'
INSTRUCTION: MANDATORY SUBAGENT EVALUATION SEQUENCE

Step 1 - EVALUATE (do this in your response):
For complex tasks, evaluate which subagent(s) from the Task tool would be most effective:

| Subagent | Use When |
|----------|----------|
| Explore | Searching codebase, finding files, understanding structure |
| Plan | Designing implementation strategy, architectural decisions |
| codebase-locator | Finding specific files/directories for a feature |
| codebase-analyzer | Deep analysis of specific components |
| codebase-pattern-finder | Finding similar implementations or usage examples |
| web-search-researcher | Researching external info, modern docs, APIs |
| Bash | Git operations, running commands |
| general-purpose | Multi-step tasks requiring various tools |

Step 2 - DECIDE (do this immediately after Step 1):
For each potential subagent, state: [subagent-name] - YES/NO - [reason]

Step 3 - ACTIVATE:
IF any subagents are YES → Use Task tool with appropriate subagent_type NOW
IF no subagents are YES → State "Direct action preferred" and proceed manually

CRITICAL: Do NOT use Glob/Grep/Read directly for exploratory searches.
Use the appropriate subagent to reduce context and improve accuracy.

Example of correct sequence:
- Explore: YES - need to understand codebase structure
- codebase-locator: NO - already know the file locations
- web-search-researcher: NO - no external research needed

[Then IMMEDIATELY use Task tool:]
> Task(subagent_type="Explore", prompt="Find all authentication-related files...")

[THEN proceed with implementation based on results]
EOF
