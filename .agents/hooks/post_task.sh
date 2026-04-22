#!/bin/bash
# .agents/hooks/post_task.sh
# This script is called after any Antigravity skill completes a task.
# Use this for automated cleanup, formatting, or auditing.

SKILL_NAME=$1

echo "Task completed by skill: $SKILL_NAME"

# Example: Automatically run the markdown formatter if the skill modified .md files
# if [[ $(git diff --name-only | grep ".md") ]]; then
#   echo "Post-Task Hook: Running markdown-formatter..."
#   # (Trigger the markdown-formatter skill logic here)
# fi

# Example: Run the Project Auditor after a Builder skill finishes
# if [ "$SKILL_NAME" == "incremental-orchestrator" ]; then
#   echo "Post-Task Hook: Triggering Project Audit..."
#   # (Trigger the project-auditor skill logic here)
# fi
