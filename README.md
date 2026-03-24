# Antigravity Developer Skills

This repository provides specialized Orchestrator Skills for Google Antigravity. It enforces an Artifact-Driven, Incremental Development Loop inspired by Kiro-Orchestrator and Claude Code. These skills prevent codebase corruption by compelling the AI agent to plan, execute, and verify atomic changes using persistent Markdown artifacts.

## The Ideology: Skills as Roles

Antigravity operates as a single, highly capable agent. We define **Skills** (`.agents/skills/`) to constrain the agent to specific personas instead of spawning disjointed sub-agents. 

- **Persistent Context**: Goals are defined in `requirements.md` and tracked in `task.md`. The agent perfectly restores context after a system crash by reading these files.
- **Atomic Loops**: The agent cannot edit 10 files at once. It must Execute, Verify, Commit, and Repeat.

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

## Step-by-Step Usage Workflow

Guide Antigravity through these specific phases by adopting the generated skills to apply this framework and solve a software task from scratch.

### Phase 1: Planning (The Architect Role)

1. **Define the Goal**: Create a `requirements.md` file in your project root detailing what you want to build (e.g., *"Implement a new Redis caching layer"*).
2. **Equip Team Lead**: Prompt Antigravity: *"Adopt the `team-lead-orchestrator` skill. Read the `requirements.md` and generate our `implementation_plan.md` and `task.md` checklists."*
3. **Review**: Review the newly created artifacts. Move to execution if the plan is satisfactory.

### Phase 2: External Tracking (Optional Admin Role)

4. **Equip Issue Creator**: Prompt Antigravity: *"Adopt the `issue-creator` skill and convert the uncompleted tasks in `task.md` into GitHub Issues."*

### Phase 3: Execution (The Builder Role)

5. **Equip Incremental Orchestrator**: Prompt Antigravity: *"Switch to the `incremental-orchestrator` skill and begin executing the first task in `task.md`."*

The strict incremental loop takes over. Antigravity automatically:
- Identifies the single next sub-task.
- Writes the code.
- Verifies the code against `requirements.md`.
- Creates an atomic Git commit.
- Pauses and asks you to proceed to the next item in `task.md`.

**Why this works**: Forcing the AI to write the plan, save the plan to disk (Artifacts), and write one small feature at a time eliminates massive context loss and broken "Big-Bang" pull requests.

## Phase 4: Co-opting Community Skills (Advanced)

The ecosystem provides thousands of "Builder" and "Validator" skills. You can plug these directly into our Orchestrators using the `skild` package manager.

**Prerequisites**:
- Node.js and NPM installed.
- Antigravity environment configured.

**Guidelines for Co-opting Skills**:

1. **Install the package manager**:
   ```bash
   npm install -g skild
   ```

2. **Search for skills**:
   ```bash
   skild search python
   ```

3. **Install specialized skills**:
   Pull a community skill (e.g., `python-expert`) into your local environment.
   ```bash
   skild install sickn33/antigravity-awesome-skills/python-expert
   ```

4. **Plan with the Lead**:
   Continue using our `team-lead-orchestrator` to generate your `requirements.md` and `task.md` artifacts.

5. **Delegate the Build**:
   When executing a task, tell Antigravity: *"Equip the `python-expert` skill and complete task 1 in `task.md`."*

6. **Enforce the Validation Loop**:
   Once the community skill writes the code, immediately equip our `incremental-orchestrator` to perform the mandatory Verify -> Commit cycle. This ensures the community agent's work aligns with your specifications.

Treating our Orchestrators as the "Foreman" and community skills as the "Hammers and Drills" provides massive capability without losing the strict, artifact-driven safety net.