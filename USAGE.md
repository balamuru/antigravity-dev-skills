This guide details the step-by-step lifecycle for applying the Google Antigravity Orchestrator Skills to autonomously build software from scratch.

## 🛠️ Installation Modes

Depending on your project state, use one of these three modes:

| Mode | Command / Action | Use Case |
| :--- | :--- | :--- |
| **New Project** | [Download ZIP](https://github.com/balamuru/antigravity-dev-skills/archive/refs/heads/main.zip) | Clean start with fresh Git history. |
| **Existing Project** | `cp -r /path/to/framework/.agents .` | Adding AI personas to your current app. |
| **Scaffolding** | `Equip project-scaffolder` | Creating an isolated sandbox directory. |

---

## 💬 Day 1: Sample Conversation

Here is how you actually talk to Antigravity to trigger the persona chain.

**You**: "Adopt the `product-manager` skill. I want to build a simple Todo app in React."

**Antigravity (PM)**: "Great! I've adopted the PM persona. Let's define the MVP. Question 1: Should we use local storage for the tasks, or do you want a backend database like Supabase?"

**You**: "Local storage is fine for now. Keep it simple."

**Antigravity (PM)**: "...[After 3 more questions]... I have enough info. Synthesizing `requirements.md` now. Done! You should now equip the `team-lead-orchestrator` to plan the architecture."

**You**: "Adopt `team-lead-orchestrator` and plan this using the React requirements."

**Antigravity (Team Lead)**: "I've analyzed `requirements.md`. I'm generating your `implementation_plan.md` and a granular `task.md` checklist... Done! Your first task is setting up the project structure. Switch to `incremental-orchestrator` to begin building."

**You**: "Go. Switch to `incremental-orchestrator` and start Task 1."

---

## Step-by-Step Usage Workflow

Guide Antigravity through these specific phases by adopting the generated skills.

### Prerequisites: Workspace Setup

Do NOT clone the framework repository via `git clone` and build inside it, or your git commits will mistakenly point to the framework's history. 

Before starting Phase 0, you must effectively isolate your workspace:
- **Download as ZIP**: Download this repository as a [ZIP](https://github.com/balamuru/antigravity-dev-skills/archive/refs/heads/main.zip) from GitHub (which drops the `.git` tracking folder). Extract it, rename the folder, and run `git init` to start a completely fresh commit history.

### Phase 0: Discovery (The Product Manager Role)

*Use this phase if you don't know exactly what to build or what tech stack to use.*

1. **Equip Product Manager**: Prompt Antigravity: *"Adopt the `product-manager` skill. I want to build a social media app for dogs, but I don't know where to start."*
2. **The Interview**: The agent will ask you sequential questions to define the features, audience, and tech stack interactively.
3. **The Deliverable**: It will synthesize your conversation and automatically write a comprehensive `requirements.md` file for you.

### Phase 1: Planning (The Architect Role)

1. **Define the Goal**: Ensure your `requirements.md` file exists in your project root detailing what you want to build.
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

## Phase 5: Pre- and Post-Execution Hooks (Extensibility)

You can extend the Orchestrator loop by injecting custom hooks. Because the agent actively runs terminal commands during Phase 3, you can force it to run validation scripts automatically.

### Implementing a Post-Hook Example

1. Create a bash script at `./hooks/post_execution.sh` that runs your test suite (e.g., `npm run test`).
2. Update your `requirements.md` to establish the core constraint:
> *"Constraint: After executing a task, you must run `./hooks/post_execution.sh`. If it exits with a non-zero code, you must fix the error before executing the atomic Git commit."*

The `incremental-orchestrator` will obey this soft hook, ensuring that broken code is never committed to your repository.
