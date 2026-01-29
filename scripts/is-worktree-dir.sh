#!/bin/bash
# SessionStart hook that detects worktree environment and guides skill activation

GIT_DIR=$(git rev-parse --git-dir 2>/dev/null)

if [[ "$GIT_DIR" == *"/worktrees/"* ]]; then
    cat <<'EOF'
INSTRUCTION: WORKTREE ENVIRONMENT DETECTED

You are working inside a Git worktree, not the main repository.

Step 1 - ACKNOWLEDGE:
State that you detected a worktree environment and will follow worktree best practices.

Step 2 - ACTIVATE SKILL:
You MUST invoke the worktree skill IMMEDIATELY:
> Skill(oberyn-utility:working-with-worktrees)

Step 3 - FOLLOW SKILL GUIDANCE:
After loading the skill, follow its instructions for working safely in worktree environments.

CRITICAL REMINDERS FOR WORKTREE ENVIRONMENTS:
- Do NOT run commands that affect the main repository without explicit user confirmation
- Be aware that changes here are isolated from the main working directory
- When committing, ensure you're on the correct branch
- Use `git worktree list` to understand the current worktree structure

[IMMEDIATELY invoke Skill(oberyn-utility:working-with-worktrees) before proceeding]
EOF
fi
