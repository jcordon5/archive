# Archive: Persistent Knowledge Wiki for AI Agents

Archive is a long-term memory and wiki system for AI agents, inspired by [Andrej Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Instead of re-discovering knowledge on every conversation, the agent incrementally builds and maintains a persistent, interlinked wiki — preferences, project context, and accumulated research that compounds over time.

## How it works

Three layers, following Karpathy's architecture:

- **Sources** — raw immutable documents you feed the agent (articles, transcripts, notes)
- **Wiki** — LLM-maintained interlinked markdown pages (entities, concepts, topic synthesis)
- **Index + Log** — `_index.md` as navigation catalog, `_log.md` as chronological operation history

```
~/.claude-knowledge/
├── _index.md          # Content catalog — always read first
├── _log.md            # Append-only operation log (grep-friendly)
├── sources/           # Raw immutable documents
├── wiki/
│   ├── entities/      # People, orgs, products
│   ├── concepts/      # Ideas, patterns, technologies
│   ├── topics/        # Research synthesis pages
│   └── _overview.md   # Master wiki summary
├── preferences/       # Code style, writing tone, git conventions
├── projects/          # Per-project auth, stack, endpoints
└── domains/           # Technology knowledge across projects
```

## Five operations

| Operation | When to use | Example |
|-----------|-------------|---------|
| **Consult** | Start of any non-trivial task | Auto-triggered — loads relevant context silently |
| **Save** | End of session when something new was learned | *"Recuerda que usamos gitmoji + Jira ID"* |
| **Ingest** | You have a document to add to the wiki | *"Ingesta este artículo"* → updates 5–15 wiki pages |
| **Query** | Ask against accumulated wiki knowledge | *"¿Qué sé sobre RAG?"* → synthesis with citations |
| **Lint** | Periodic wiki health check | *"Haz un lint de mi wiki"* → finds orphans, contradictions, gaps |

The key insight from Karpathy: **ingest compiles knowledge once, permanently.** Cross-references are already there, contradictions are flagged, synthesis accumulates. Nothing is re-derived from scratch on every query.

## Installation

```bash
# 1. Install the skill
npx skills add jcordon5/archive

# 2. Initialize the vault (only once)
bash "$(npx skills list | grep archive | awk '{print $NF}' | perl -pe 's/\e\[[0-9;]*m//g' | sed "s|^~|$HOME|")/scripts/setup-vault.sh"

# 3. Open in Obsidian (optional but recommended)
# Obsidian → Open folder as vault → ~/.claude-knowledge
```

Add to `~/.claude/CLAUDE.md` or `~/.codex/AGENTS.md`for automatic activation:

```markdown
On every non-trivial task, first determine whether any available skill is relevant
and use it when applicable. If the task requires retrieving prior context,
preferences, reusable solutions, or previously discovered steps, consult the
archive skill before re-solving anything.

After completing the work, evaluate whether any newly learned information should
be stored in archive.
```
