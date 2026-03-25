# Antigravity Developer Skills

This repository provides specialized Orchestrator Skills for Google Antigravity. It enforces an Artifact-Driven, Incremental Development Loop inspired by Kiro-Orchestrator and Claude Code. These skills prevent codebase corruption by compelling the AI agent to plan, execute, and verify atomic changes using persistent Markdown artifacts.

## The Ideology: Skills as Roles

Antigravity operates as a single, highly capable agent. We define **Skills** (`.agents/skills/`) to constrain the agent to specific personas instead of spawning disjointed sub-agents. 

- **Persistent Context**: Goals are defined in `requirements.md` and tracked in `task.md`. The agent perfectly restores context after a system crash by reading these files.
- **Atomic Loops**: The agent cannot edit 10 files at once. It must Execute, Verify, Commit, and Repeat.

## ⚙️ Installation & Setup (Solving the Git Problem)

**Important**: If you clone this repository via `git clone` and build a production app directly inside it, your `git commit` history will mistakenly point to this framework's repository. 

To build real projects safely, **Download as ZIP**.

Because these skills are highly customized for this framework (e.g., `project-auditor`), the easiest way to start a new project is to download this repository as a ZIP file from GitHub (Code -> Download ZIP). Extract it, rename the folder to your new project name, and run `git init` in your terminal. Because downloading a ZIP strips the original `.git` tracking folder, your commits will perfectly isolate to your own fresh repository.

## 🚀 Quickstart: Test Drive the Framework

Want to see the framework in action immediately without any setup? We've created a pre-configured, sandboxed environment in the `app/` directory.

1. **Review the Goal**: Open `app/requirements.md`. You will see a strict constraint demanding the agent build an Express.js server *only* within that folder.
2. **Review the Tasks**: Open `app/task.md` to view the step-by-step checklist.
3. **Unleash the Builder**: Prompt your Antigravity agent:
   > *"Adopt the `incremental-orchestrator` skill and execute the tasks in `app/task.md`."*
4. **Watch the Loop**: The agent will read the artifacts, execute the first step, verify its work against the requirements, make an atomic Git commit, and pause for your approval before continuing.

## Comparison: Kiro vs. Claude Code vs. Antigravity

| Feature / Concept       | Kiro CLI                            | Claude Code                                 | Antigravity (This Repo)                                      |
| :---------------------- | :---------------------------------- | :------------------------------------------ | :----------------------------------------------------------- |
| **State Management**    | Markdown Specs (`requirements.md`)  | Variable Conversation History               | Persistent Artifacts (`task.md`)                             |
| **Sub-task Tracking**   | Internal spec files                 | GitHub Issues                               | Artifact Checklists OR GitHub Issues                         |
| **Agent Architecture**  | Multiple specialized sub-agents     | Single versatile agent                      | Single base agent with modular "Skills"                      |
| **Execution Flow**      | Builder → Validator Handoffs        | Iterative conversation                      | Strict `incremental-orchestrator` loop                       |
| **Code Review**         | Dedicated Validator Agents          | Manual Developer-in-the-loop                | "Verify" step strictly enforced within loop                  |
| **Time Efficiency**     | Slow (Heavy multi-agent handoffs)   | Fast (For initial rapid prototyping)        | Moderate (Incremental loops take time but save debugging)    |
| **Token Usage**         | High (Spinning up multiple agents)  | Medium-High (Context window fills linearly) | Medium (Artifacts consolidate context without history bloat) |
| **Context Loss Risk**   | Low (Spec-driven)                   | High (If context window is exceeded)        | Zero (Disk-based Artifacts survive restarts)                 |

### Strengths, Weaknesses, and Ideal Use Cases

**Kiro CLI**
- **Strengths**: Excellent separation of concerns. Nearly impossible to drift from the specification.
- **Weaknesses**: Over-engineered for simple tasks. Extremely slow execution and expensive token usage due to constant API calls for handoffs.
- **Ideal Use Case**: Massive, enterprise-level greenfield projects with strict compliance needs.

**Claude Code**
- **Strengths**: Incredible developer experience. Extremely fast for iterative prototyping and getting off the ground quickly.
- **Weaknesses**: Prone to the "Big-Bang Commit." The context window fills up fast, and recovering the exact train of thought is difficult if the agent fails mid-task.
- **Ideal Use Case**: Rapid prototyping, bug fixing, exploring undocumented codebases, and simple 1-2 file features.

**Antigravity (This Repo's Approach)**
- **Strengths**: The optimal balance. Artifacts provide the ironclad memory safety of Kiro without the overhead of massive multi-agent networks. The granular loop prevents giant Pull Requests (PRs).
- **Weaknesses**: Requires discipline. The initial artifact generation phase is slower than issuing direct commands to Claude.
- **Ideal Use Case**: Building full-stack features incrementally, tracking progress formally, and prioritizing context retention over unstructured speed.

## Available Orchestrators

### Product Manager

**Path**: `.agents/skills/product-manager/SKILL.md`
**Role**: The Interactive Interviewer / Planner.
**Usage**: Equip this skill when you have a vague idea. It asks you sequential questions to define your MVP features and stack, and outputs a highly detailed `requirements.md` file.

### Team Lead Orchestrator

**Path**: `.agents/skills/team-lead-orchestrator/SKILL.md`
**Role**: The Architect / Project Manager.
**Usage**: Instruct Antigravity to adopt this skill when you have raw requirements. It outputs an `implementation_plan.md` and a granular `task.md`. It does not write implementation code.

### Incremental Orchestrator

**Path**: `.agents/skills/incremental-orchestrator/SKILL.md`
**Role**: The Builder / Code Reviewer.
**Usage**: Adopt this skill to execute the checklist after tasks are planned. It guarantees the agent verifies its own code against the specifications before creating an atomic Git commit and moving to the next task.

### Issue Creator

**Path**: `.agents/skills/issue-creator/SKILL.md`
**Role**: The Kanban Administrator.
**Usage**: Adopts Claude Code's methodology. It translates the internal `task.md` checklist into formal GitHub Issues using the `gh` CLI for external visibility and tracking.

### Doc Reviewer

**Path**: `.agents/skills/doc-reviewer/SKILL.md`
**Role**: The Senior Technical Writer.
**Usage**: Use this skill to restructure, edit, and clarify Markdown documentation. It focuses entirely on tone and narrative flow without touching the underlying source code.

### Markdown Formatter

**Path**: `.agents/skills/markdown-formatter/SKILL.md`
**Role**: The Documentation Linter.
**Usage**: Use this skill to strictly enforce formatting rules (spacing, headers, backticks) across your Markdown files to keep them clean and easily readable.

### Project Auditor

**Path**: `.agents/skills/project-auditor/SKILL.md`
**Role**: The Final Gatekeeper / QA.
**Usage**: Equip this skill before merging PRs or marking tasks as complete. It will cross-reference your actual file system against the `README.md` and `task.md` to spot undocumented code or missed requirements.

### Project Scaffolder

**Path**: `.agents/skills/project-scaffolder/SKILL.md`
**Role**: The Environment Initializer.
**Usage**: Equip this skill when starting a new project. It safely sandboxes future work by generating an isolated boundary directory (e.g., `/app`) and pre-populating baseline `requirements.md` and `task.md` specs before handoff.

## 🪝 Advanced: Pre- and Post-Execution Hooks

Because this framework relies entirely on persistent Markdown artifacts and native file-system access, you can easily define automated hooks to run before or after the Orchestrator executes a task.

**1. Script-Based Hooks (Hard Hooks)**
If you create executable bash scripts in your project workspace (e.g., `./hooks/pre_task.sh` or `./hooks/post_task.sh`), you can instruct the `incremental-orchestrator` to execute them. For example, a post-hook could enforce that `npm run test` and `npm run lint` execute successfully before the agent is allowed to commit its code.

**2. Instructional Hooks (Soft Hooks)**
Because the Orchestrators read the `task.md` file, you can explicitly add instructional hooks directly into your checklists. (e.g., `"Before starting any sub-task, run git pull. After finishing, run the project-auditor"`).

## 🔄 Workflows (Automated SOPs)

Beyond standalone skills, Antigravity supports automated Workflows. Workflows are predefined lists of instructions (SOPs) that tell the AI exactly how to execute a specific, standardized process.

### Defining Workflows
Workflows are defined as `.md` files located in the `[.agents, .agent, _agents, _agent]/workflows/` directory. They require a simple YAML frontmatter block for the description, followed by the specific execution steps.

Example (`.agents/workflows/status-check.md`):
```markdown
---
description: Run a comprehensive status check on the project workspace
---
1. List all skills available in the `.agents/skills` directory.
2. Read the `README.md` to understand the project's current state.
// turbo
3. Run `git status` to see if there are any uncommitted changes.
4. Report the findings concisely.
```

### Executing Workflows
You can execute a workflow by either:
1. **Slash Commands**: Typing the workflow name directly in the chat (e.g., `/status-check`).
2. **Natural Language**: Asking the agent to "run the status check workflow".

### The `// turbo` Annotations
When executing workflows, the agent will normally pause to ask for your permission before running any terminal commands. To bypass this for safe, repetitive commands, you can add a `// turbo` annotation on the line directly above the step. This grants the agent permission to auto-execute that specific command. To auto-execute all commands in a workflow, place `// turbo-all` anywhere in the file.

## 🤖 Execution Models & Task Delegation

Because Antigravity relies entirely on persistent Markdown files (`task.md`, `requirements.md`) instead of internal agent memory context windows, **state is completely decoupled from the underlying LLM**. 

**Out of the Box (Manual Routing):**
All tasks and skills execute using whichever default model you've selected in your CLI/interface environment. However, since the context is entirely on disk, you can effortlessly swap models mid-project to optimize for cost and speed:
1. **Low-cost/Fast Models (e.g., Claude Haiku, Gemini Flash):** Switch to this model when invoking boilerplate skills like `markdown-formatter`, `issue-creator`, or `doc-reviewer`.
2. **High-capability Models (e.g., Claude Opus, Gemini Pro):** Swap back to heavy models for complex logic, like when invoking `team-lead-orchestrator` or `incremental-orchestrator`.
The new model picks up seamlessly by reading the exact same artifacts.

**Advanced (Automated Routing via Hooks):**
To make model selection automatic without manual intervention, you can modify your `.agents/hooks/pre_task.sh` execution scripts to read YAML frontmatter from the `SKILL.md` files (e.g., parsing an `ideal-model: 'gemini-3.1-flash'` tag) to programmatically alter your CLI's target endpoint/environment payload prior to execution.

*Example `.agents/skills/markdown-formatter/SKILL.md` frontmatter:*
```yaml
---
description: Format all markdown documentation.
ideal-model: 'gemini-3.1-flash'
---
```

*Example `.agents/hooks/pre_task.sh`:*
```bash
#!/bin/bash
# Assume $1 is the name of the skill being invoked (e.g., 'markdown-formatter')
SKILL_FILE=".agents/skills/$1/SKILL.md"

if [ -f "$SKILL_FILE" ]; then
  # Extract the model name from the YAML frontmatter
  MODEL=$(grep -m 1 "^ideal-model:" "$SKILL_FILE" | awk -F"'" '{print $2}')
  
  if [ ! -z "$MODEL" ]; then
    echo "Hook Triggered: Routing task to optimal model -> $MODEL"
    # Export the environment variable referenced by your specific CLI or API client
    export ACTIVE_LLM_MODEL="$MODEL"
  else
    echo "No ideal model specified. Using the default configured model."
  fi
fi
```

## 📚 Usage Documentation

For a comprehensive guide on how to apply these personas to build a complete software project (from discovery and planning to atomic code execution and QA), please read the full **[Usage Guide](USAGE.md)**.