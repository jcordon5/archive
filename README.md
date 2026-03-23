# Archive: Long-Term Memory System for Agents

Archive is a persistent memory system that allows Agents to remember knowledge, preferences, and work patterns across conversations, using an Obsidian-compatible vault. This skill transforms the experience of working with AI models, avoiding repetition of already solved tasks and progressively adapting to your working style.

## 🚀 Key Advantages

### 💰 Significant Token Savings
- **Avoid rethinking solved tasks**: Archive stores solutions, patterns, and acquired knowledge, eliminating the need to rediscuss already addressed problems.
- **Intelligent adaptation**: The system learns from your corrections, preferences, and conventions, reducing unnecessary iterations.
- **Persistent context**: Maintains project state, configurations, and decisions between sessions, optimizing token usage.

### 🧠 Learning and Adaptation
- **Personalized memory**: Adapts to your way of working, remembering code styles, commit conventions, credential locations, and problem-solving patterns.
- **Proactive consultations**: Automatically consults the vault at the start of complex tasks, applying prior knowledge without manual intervention.
- **Continuous improvement**: Each interaction enriches the knowledge base, making Agents more efficient and personalized over time.

## 📁 Vault Structure

The system uses an Obsidian-compatible vault located at `~/.claude-knowledge/`:

```
~/.claude-knowledge/
├── _index.md                    # Dispatch map and summary
├── preferences/
│   ├── writing-style.md         # Writing style and tone
│   ├── code-style.md            # Code conventions
│   └── git-conventions.md       # Commit and PR styles
├── projects/
│   └── <ProjectName>/
│       └── context.md           # Project-specific context
└── domains/
    └── <technology>.md          # Technology-specific knowledge
```

## ⚙️ Automatic Configuration

To have Claude use Archive automatically in all tasks, add these lines to your `CLAUDE.md`:

```markdown

On every non-trivial task, first determine whether any available skill is relevant and use it when applicable. If the task requires retrieving prior context, preferences, reusable solutions, writing conventions, or previously discovered steps, consult the archive skill before re-solving anything.

After completing the work, evaluate whether any newly learned information should be stored in archive. If the solution is confirmed to work, tests pass, and the issue is resolved, prepare a git commit only when working inside a git repository and following the archive conventions.
```

## 🛠️ Installation

1. Clone or download this repository
2. Move it to `~/.claude/.skills/`
3. Run the setup script:
   ```bash
   ./scripts/setup-vault.sh
   ```
4. Add the configuration lines to `~/.claude/CLAUDE.md`

Experience how Archive transforms your workflow, making every conversation with Agents more efficient and personalized!</content>
