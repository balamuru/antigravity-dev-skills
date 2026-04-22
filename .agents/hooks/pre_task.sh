#!/bin/bash
# .agents/hooks/pre_task.sh
# This script is called before any Antigravity skill is executed.
# It enables dynamic model routing based on skill requirements.

SKILL_NAME=$1
SKILL_FILE=".agents/skills/$SKILL_NAME/SKILL.md"

if [ -f "$SKILL_FILE" ]; then
  # Extract the 'ideal-model' tag from the YAML frontmatter
  # Example: ideal-model: 'gemini-3.1-flash'
  MODEL=$(grep -m 1 "^ideal-model:" "$SKILL_FILE" | awk -F"'" '{print $2}')
  
  if [ ! -z "$MODEL" ]; then
    echo "Hook Triggered: Routing task to optimal model -> $MODEL"
    # Export the environment variable for your specific CLI/API client
    export ACTIVE_LLM_MODEL="$MODEL"
  else
    echo "No ideal model specified for skill '$SKILL_NAME'. Using default."
  fi
else
  echo "Skill specification not found at $SKILL_FILE. Proceeding with defaults."
fi
