# antigravity-dev-skills

This repository houses a suite of **Orchestrator Skills** designed for Google Antigravity, drawing inspiration from the Kiro-Orchestrator architecture and Claude Code's tracking workflows. 

The primary ideology behind these skills is to enforce an **Artifact-Driven, Incremental Development Loop**. By treating the file system (via markdown artifacts) as the source of truth, and forcing the AI to review atomic commits rather than massive batch-writes, we eliminate "big-bang" codebase corruption and context loss.

## The Ideology: Skills as Roles

Antigravity operates as a single, highly capable agent. Rather than spawning disjointed sub-agents, we define **Skills** (`.agents/skills/`) that constraint the agent to a specific persona.

- **Specs = Persistent Context**: Goals are defined in `requirements.md` and tracked in `task.md`. If the system crashes, context is perfectly restored by reading these files.
- **Atomic Loops**: The agent is forbidden from editing 10 files at once. It must Execute -> Verify -> Commit -> Repeat.

## Comparison: Kiro vs. Claude Code vs. Antigravity

| Feature / Concept | Kiro CLI | Claude Code | Antigravity (This Repo) |
| :--- | :--- | :--- | :--- |
| **State Management** | Markdown Specs (`requirements.md`) | Variable Conversation History | Persistent Artifacts (`task.md`) |
| **Sub-task Tracking** | Internal spec files | GitHub Issues | Artifact Checklists OR GitHub Issues |
| **Agent Architecture** | Multiple specialized sub-agents | Single versatile agent | Single base agent with modular "Skills" |
| **Execution Flow** | Builder → Validator Handoffs | Iterative conversation | Strict `incremental-orchestrator` loop |
| **Code Review** | Dedicated Validator Agents | Manual Developer-in-the-loop | "Verify" step strictly enforced within loop |
| **Time Efficiency** | Slow (Heavy multi-agent handoffs) | Fast (For initial rapid prototyping) | Moderate (Incremental loops take time but save debugging) |
| **Token Usage** | High (Spinning up multiple agents repeatedly) | Medium-High (Context window fills up linearly) | Medium (Artifacts consolidate context without history bloat) |
| **Context Loss Risk** | Low (Spec-driven) | High (If context window is exceeded) | Zero (Disk-based Artifacts survive restarts) |

### Strengths, Weaknesses, & Ideal Use Cases

**Kiro CLI**
- **Strengths**: Excellent separation of concerns. Nearly impossible to drift from the specification.
- **Weaknesses**: Over-engineered for simple tasks. Extremely slow execution and expensive token usage due to constant API calls for handoffs.
- **Ideal Use Case**: Massive, enterprise-level greenfield projects with strict compliance needs.

**Claude Code**
- **Strengths**: Incredible developer experience. Extremely fast for iterative prototyping and getting off the ground quickly.
- **Weaknesses**: Prone to the "Big-Bang Commit." The context window fills up fast, and if the agent fails mid-task, it's hard to recover the exact train of thought.
- **Ideal Use Case**: Rapid prototyping, bug fixing, exploring undocumented codebases, and simple 1-2 file features.

**Antigravity (This Repo's Approach)**
- **Strengths**: The "Goldilocks" zone. Artifacts provide the ironclad memory safety of Kiro without the overhead of massive multi-agent networks. The granular loop prevents giant PRs.
- **Weaknesses**: Requires discipline. The initial planning phase (Artifact generation) is slower than just shouting "build this!" at Claude.
- **Ideal Use Case**: Building full-stack features incrementally, tracking progress formally, and any situation where context loss or massive unstructured commits are unacceptable.

## Available Orchestrators

### 1. Team Lead Orchestrator
**Path**: `.agents/skills/team-lead-orchestrator/SKILL.md`
**Role**: The Architect / Project Manager.
**Usage**: Instruct Antigravity to adopt this skill when you have raw requirements. It will output an `implementation_plan.md` and a granular `task.md`. It will not write implementation code.

### 2. Incremental Orchestrator
**Path**: `.agents/skills/incremental-orchestrator/SKILL.md`
**Role**: The Builder / Code Reviewer.
**Usage**: After tasks are planned, adopt this skill to execute the checklist. It guarantees that the agent will verify its own code against the specifications before creating an atomic Git commit and moving to the next task.

### 3. Issue Creator
**Path**: `.agents/skills/issue-creator/SKILL.md`
**Role**: The Kanban Administrator.
**Usage**: Adopts Claude Code's methodology. Translates the internal `task.md` checklist into formal GitHub Issues using the `gh` CLI for external visibility and tracking.

## Step-by-Step Usage Workflow

To apply this framework and solve a software task from scratch, guide Antigravity through these specific phases by adopting the generated skills:

### Phase 1: Planning (The Architect Role)
1. **Define the Goal**: Create a `requirements.md` file in your project root detailing what you want to build (e.g., *"Implement a new Redis caching layer"*).
2. **Equip Team Lead**: Prompt Antigravity: *"Adopt the `team-lead-orchestrator` skill. Read the `requirements.md` and generate our `implementation_plan.md` and `task.md` checklists."*
3. **Review**: Review the artifacts it creates. If the plan looks good, move to execution.

### Phase 2: External Tracking (Optional Admin Role)
4. **Equip Issue Creator**: If you want these tasks tracked externally, prompt Antigravity: *"Adopt the `issue-creator` skill and convert the uncompleted tasks in `task.md` into GitHub Issues."*

### Phase 3: Execution (The Builder Role)
5. **Equip Incremental Orchestrator**: Prompt Antigravity: *"Switch to the `incremental-orchestrator` skill and begin executing the first task in `task.md`."*

The strict incremental loop will now take over. Antigravity will automatically:
- Identify the single next sub-task.
- Write the code.
- Verify the code against `requirements.md`.
- Create an atomic Git commit.
- Pause and ask you to proceed to the next item in `task.md`.

**Why this works**: By forcing the AI to write the plan, save the plan to disk (Artifacts), and constrain it to writing one small feature at a time, we eliminate massive context loss and broken "Big-Bang" pull requests.