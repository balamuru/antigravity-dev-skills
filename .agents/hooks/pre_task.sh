#!/bin/bash
# .agents/hooks/pre_task.sh
# This script is called before any Antigravity skill is executed.
# It enables dynamic model routing and credential validation.

SKILL_NAME=$1
SKILL_FILE=".agents/skills/$SKILL_NAME/SKILL.md"
REGISTRY="MODELS.md"

if [ -f "$SKILL_FILE" ]; then
  # Extract the 'ideal-model' tag from the YAML frontmatter
  MODEL=$(grep -m 1 "^ideal-model:" "$SKILL_FILE" | awk -F"'" '{print $2}')
  
  if [ ! -z "$MODEL" ]; then
    echo "Hook Triggered: Routing task to requested model -> $MODEL"
    
    # Cross-reference with MODELS.md to find the required API Key variable
    if [ -f "$REGISTRY" ]; then
      VAR_NAME=$(grep "| .* | \`$MODEL\` |" "$REGISTRY" | awk -F'|' '{print $4}' | tr -d ' `')
      
      if [ ! -z "$VAR_NAME" ]; then
        # Check if the environment variable is set
        if [ -z "${!VAR_NAME}" ]; then
          echo "WARNING: Model '$MODEL' requires '$VAR_NAME' but it is not set in your .env."
          echo "Please configure it to avoid execution errors."
        else
          echo "Validation: API Key '$VAR_NAME' is present."
          export ACTIVE_LLM_MODEL="$MODEL"
        fi
      else
        echo "Note: Model '$MODEL' is not in the validated registry. Proceeding with caution."
        export ACTIVE_LLM_MODEL="$MODEL"
      fi
    fi
  else
    echo "No ideal model specified for skill '$SKILL_NAME'. Using default."
  fi
else
  echo "Skill specification not found at $SKILL_FILE. Proceeding with defaults."
fi
