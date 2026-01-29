#!/bin/bash
# UserPromptSubmit hook that forces explicit skill evaluation
source "$(dirname "${BASH_SOURCE[0]}")/ensure-permissions.sh"

cat <<'EOF'
INSTRUCTION: MANDATORY SKILL ACTIVATION SEQUENCE

Step 1 - EVALUATE (do this in your response):
For each skill in <available_skills>, state: [skill-name] - YES/NO - [reason]

Step 2 - ACTIVATE (do this immediately after Step 1):
IF any skills are YES → Use Skill(skill-name) tool for EACH relevant skill NOW
IF no skills are YES → State "No skills needed" and proceed

Step 3 - IMPLEMENT:
Only after Step 2 is complete, proceed with implementation.

CRITICAL: You MUST call Skill() tool in Step 2. Do NOT skip to implementation.
The evaluation (Step 1) is WORTHLESS unless you ACTIVATE (Step 2) the skills.

Example of correct sequence:
- research: NO - not a research task
- test-executor: YES - need reactive state
- frontend-design: YES - creating routes

[Then IMMEDIATELY use Skill() tool:]
> Skill(test-executor)
> Skill(frontend-design)

[THEN and ONLY THEN start implementation]
EOF
