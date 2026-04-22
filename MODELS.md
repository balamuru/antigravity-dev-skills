# Validated Models Registry

This registry serves as the "Source of Truth" for model routing within the Antigravity framework.

## Supported Models

| Friendly Name | Technical ID | API Key Variable | Use Case |
| :--- | :--- | :--- | :--- |
| **Google Flash** | `gemini-3.5-flash` | `GOOGLE_API_KEY` | Coding, Formatting, Fast UI updates. |
| **Google Pro** | `gemini-3.5-pro` | `GOOGLE_API_KEY` | Complex logic, Architectural planning. |
| **Claude Sonnet** | `claude-3-5-sonnet` | `ANTHROPIC_API_KEY` | High-fidelity coding, Refactoring. |
| **Claude Opus** | `claude-3-opus` | `ANTHROPIC_API_KEY` | Deep reasoning, Bug hunting. |
| **GPT-4o** | `gpt-4o` | `OPENAI_API_KEY` | General purpose, Broad compatibility. |

## How to Add a New Model

1. **Update Registry**: Add the model's technical ID and the required environment variable for its API key to this table.
2. **Configure `.env`**: Add the corresponding API key to your local `.env` file.
3. **Update Skill**: Set the `ideal-model` frontmatter in your `SKILL.md` to match the **Technical ID**.

## Integration Note
The `.agents/hooks/pre_task.sh` script automatically reads this registry. If a skill requests a model that is missing an API key in your `.env`, the hook will provide a warning.
