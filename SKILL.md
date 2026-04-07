---
name: archive
description: >-
  Persistent knowledge wiki and memory system that compounds across conversations
  using an Obsidian-compatible vault. Consult at the START of any non-trivial
  task to recall project context, preferences, and past discoveries. Ingest
  sources and build wiki pages when accumulating knowledge on a topic. Save at
  the END when new knowledge was gained. Use when: starting work on a known
  project, dealing with auth/credentials/config, making stylistic choices, user
  corrects output, user says "as always"/"remember this"/"save this"/"don't make
  me repeat". Also trigger for: "ingest this", "add to my wiki", "what do I know
  about X", "research notes", "lint my wiki", deep research sessions, reading
  notes, competitive analysis, or any time the user wants knowledge to accumulate
  and compound across multiple sessions. Do NOT use for trivial one-line questions.
---

# Archive — Persistent Knowledge Wiki

You are the memory and knowledge layer for this user. Your job has two modes:

- **Fast memory** — recall preferences, project context, and hard-won discoveries so tokens are never wasted rediscovering the same things.
- **Wiki mode** — incrementally build and maintain a persistent, interlinked knowledge base from sources the user feeds you. Knowledge is compiled once and kept current, not re-derived on every query.

The key difference from a simple note store: **the wiki is a compounding artifact.** Cross-references are already there. Contradictions are flagged. Synthesis accumulates. Every source ingested makes the wiki richer.

## Vault Location

```bash
echo "${CLAUDE_KNOWLEDGE_PATH:-$HOME/.claude-knowledge}"
```

This resolved path is `$VAULT`. Use it for all file operations.

---

## Architecture — Three Layers

```
$VAULT/
├── _index.md          ← Content catalog — always read first
├── _log.md            ← Chronological append-only operation log
│
├── sources/           ← Raw immutable source documents (articles, notes, PDFs text)
│                         The LLM reads from here but NEVER modifies these files.
│
├── wiki/              ← LLM-maintained interlinked knowledge pages
│   ├── entities/      ← People, orgs, products, projects (one page each)
│   ├── concepts/      ← Ideas, patterns, technologies (one page each)
│   ├── topics/        ← Deep synthesis pages for a research area
│   └── _overview.md   ← Master summary of the entire wiki
│
├── preferences/       ← User conventions (code style, prose tone, git format)
├── projects/          ← Per-project context (auth, stack, endpoints)
└── domains/           ← Technology knowledge not tied to one project
```

**Routing rule of thumb:**
| Knowledge type | Target |
|---|---|
| User habit or convention | `preferences/` |
| Single-project fact (auth, stack, env) | `projects/{Name}/context.md` |
| Technology pattern across projects | `domains/{tech}.md` |
| Named entity (person, org, product) | `wiki/entities/{Name}.md` |
| Idea, concept, or pattern | `wiki/concepts/{Name}.md` |
| Research synthesis on a topic | `wiki/topics/{Topic}.md` |
| Raw article, transcript, PDF text | `sources/{slug}.md` (immutable) |

---

## Operations

### CONSULT — Read before acting

Consult at the START of a task if ANY apply:
- Task has more than ~2 steps
- About to touch auth, credentials, API keys, .env, config files
- About to make a stylistic choice (code format, prose tone, commit message)
- CWD matches a known project path
- User says "as always", "like before", "you know how I like it"
- Encountered an error that might have a known solution

**How to consult:**
1. Read `$VAULT/_index.md` — this is your dispatch map.
2. Identify relevant files from the index (project? preferences? wiki topic?).
3. Load **only the relevant 1–3 files**. Never load everything.
4. Use the knowledge silently. Announce only when it meaningfully changes your approach:
   > "Based on my notes on SecurSentry, auth is in `.env` — I'll go straight there."

If `_index.md` does not exist → **First Time Use** (see below).

---

### SAVE — Store new knowledge

Save at the END of a task (one batch) if ANY apply:
- User corrected your style, format, or convention → save the preference
- You discovered where credentials/config live → save the location (never the value)
- You solved something that took multiple attempts → save the approach
- You learned a non-obvious project convention → save it
- User said "always", "never", "from now on", "my preference is" → save **immediately**

**What NOT to save:** common public knowledge, ephemeral data, actual secret values, duplicates (check `_index.md` first).

**How to save:**
1. Identify the correct target file (routing table above).
2. Read the file first if it exists; append the new entry at the bottom.
3. Update `$VAULT/_index.md` if this is a new topic or file.
4. Append one line to `$VAULT/_log.md` (see Log Format).

---

### INGEST — Process a new source

When the user gives you a document, article, transcript, or any source to add to the wiki:

1. **Store the source** — write or confirm the file exists at `sources/{slug}.md`. Never modify it after creation.
2. **Extract key information** — identify: main claims, named entities (people, orgs, products), key concepts, data points, contradictions with existing wiki content.
3. **Discuss with the user** (if present and interactive) — ask what to emphasize before writing.
4. **Update wiki pages** — a single source may touch 5–15 pages:
   - Create or update entity pages for any named person/org/product.
   - Create or update concept pages for key ideas.
   - Update or create a topic synthesis page if this source belongs to a research area.
   - Update `wiki/_overview.md` if the source significantly shifts the synthesis.
   - Add `**Contradicts:** [[PageX]]` markers wherever this source conflicts with prior knowledge.
5. **Update `_index.md`** — add entries for any new pages created.
6. **Append to `_log.md`**:
   ```
   ## [YYYY-MM-DD] ingest | {Source title or slug}
   Pages updated: [[entity/Name]], [[concepts/Concept]], [[topics/Topic]]
   Key claims: {1-2 sentence summary of what was added}
   ```

---

### QUERY — Answer from accumulated wiki

When the user asks a question the wiki should be able to answer:

1. Read `_index.md` to locate relevant pages.
2. Load relevant wiki pages + any applicable preferences/projects files.
3. Synthesize an answer with citations to the wiki pages used.
4. **File valuable answers back** — if the synthesis is non-obvious or took real effort, save it as a new `wiki/topics/{slug}.md` page so it compounds into the knowledge base. Append to `_log.md`:
   ```
   ## [YYYY-MM-DD] query | {Question summary}
   Answer filed to: [[topics/Slug]] (or "not filed — ephemeral")
   ```

---

### LINT — Health-check the wiki

Run periodically or when the user asks "lint my wiki" / "check for issues":

Scan all wiki pages and check for:
- **Orphan pages** — pages with no inbound links from other pages
- **Stale claims** — facts in older pages that newer sources have superseded
- **Contradictions** — pages that claim conflicting things without a resolution note
- **Missing pages** — concepts mentioned inline (`[[ConceptX]]`) but with no dedicated page
- **Missing cross-references** — two pages that clearly relate but don't link each other
- **Data gaps** — important entities with thin pages that a targeted web search could fill

Report findings, fix what you can (add cross-references, flag contradictions), and suggest which gaps are worth filling next. Append to `_log.md`:
```
## [YYYY-MM-DD] lint | Health check
Issues found: {count} orphans, {count} contradictions, {count} missing pages
Actions taken: {brief summary}
```

---

## Entry Formats

### Preferences / Projects / Domains entries

```markdown
### {Prefix: short descriptive title}
**Context:** {When does this apply? Specific trigger situation.}
**Discovery:** {The actual knowledge — specific paths, commands, patterns. Not vague.}
**Source:** {User correction | User stated preference | Multi-attempt solve | Discovered during task | User instruction (apply always)}
**Date:** YYYY-MM-DD

---
```

**Title conventions:** `SecurSentry: Auth credentials location` | `Code style: Python f-strings` | `Git: Conventional Commits format`

### Wiki page format

```markdown
---
type: entity|concept|topic
tags: [tag1, tag2]
sources: [sources/slug1.md, sources/slug2.md]
updated: YYYY-MM-DD
---

# {Name}

**Summary:** {2–4 sentence synthesis of everything known.}

## Key Facts
- {Fact} *(Source: [[sources/slug]])*
- {Fact}

## Connections
- Related to [[concepts/ConceptX]] because {reason}
- Contrasts with [[entities/EntityY]] in that {difference}

## Contradictions / Open Questions
- *Claim A* (from [[sources/slug1]]) conflicts with *Claim B* (from [[sources/slug2]]). Unresolved.

## History / Timeline
*(If relevant)*
```

---

## _index.md Format

Keep under ~120 lines. This is what Claude reads first — every line should help it decide what to load next.

```markdown
# Knowledge Index
Last updated: YYYY-MM-DD

## Preferences
- `preferences/writing-style.md` — [one-line summary]
- `preferences/code-style.md` — [one-line summary]
- `preferences/git-conventions.md` — [one-line summary]

## Projects
- `projects/{Name}/context.md` — CWD: {path} | {key facts: auth method, stack}

## Domains
- `domains/{tech}.md` — [one-line summary]

## Wiki — Entities
- `wiki/entities/{Name}.md` — [one-line summary, tags]

## Wiki — Concepts
- `wiki/concepts/{Name}.md` — [one-line summary]

## Wiki — Topics
- `wiki/topics/{Topic}.md` — [one-line summary, source count]

## Sources
- `sources/{slug}.md` — {title} | ingested {date}

## Quick Facts
- {one-liner micro-facts that don't justify their own file}
```

---

## _log.md Format

Append-only. Each entry starts with a consistent prefix for grep-ability:
```bash
grep "^## \[" $VAULT/_log.md | tail -10   # last 10 operations
grep "ingest" $VAULT/_log.md               # all ingests
```

Entry types: `ingest`, `query`, `save`, `lint`. See operation sections for exact formats.

---

## Conflicting Information

If wiki knowledge conflicts with current reality (e.g., an endpoint the wiki says works now returns 404):

1. Trust what you observe now.
2. User correction mid-conversation overrides the wiki — update immediately.
3. Mark superseded entries with `**Supersedes:** {old claim}` so history is preserved.
4. In wiki pages, use the `## Contradictions / Open Questions` section to flag unresolved conflicts rather than silently picking one side.

---

## Forgetting

If the user says "forget that", "remove from memory", "delete that":
1. Read the relevant file.
2. Remove the specific entry (or the whole page if it is a wiki page).
3. Remove its line from `_index.md`.
4. Confirm: "He eliminado el contexto sobre X."

---

## First Time Use

If `$VAULT/_index.md` does not exist:
1. Tell the user: "No tengo bóveda de conocimiento aún. La creo ahora." (or English if the conversation is in English)
2. Run the setup script:
   ```bash
   bash ~/.claude/skills/archive/scripts/setup-vault.sh
   ```
   Or manually:
   ```bash
   mkdir -p "$VAULT/sources" "$VAULT/wiki/entities" "$VAULT/wiki/concepts" "$VAULT/wiki/topics"
   mkdir -p "$VAULT/preferences" "$VAULT/projects" "$VAULT/domains"
   ```
3. Create `_index.md` and `_log.md` with the templates above (today's date, empty sections).
4. Proceed with the current task and save at the end.

---

## Token Economy

The vault is a tool, not a ritual. Match depth to need:

| Situation | Approach |
|---|---|
| Quick preference/project lookup | `_index.md` + 1–2 files |
| Multi-topic research question | `_index.md` + relevant wiki pages (3–5 max) |
| Ingesting a new source | Full ingest pass: read source, update all relevant wiki pages |
| Lint | Full scan — budget extra tokens, do it as an explicit task |

- **Skip consultation** for truly trivial requests (one-liner questions, simple lookups)
- **Write concisely** — preference/domain entries rarely exceed 5 lines; wiki pages rarely exceed 40 lines
- **Batch saves** — save all new knowledge at the end of a task, not mid-task
- **Never interrupt active work** to consult or save

---

## Communicating Memory to the User

- Vault knowledge changes your approach → brief callout: "Based on my notes on SecurSentry, I'll go straight to `.env` for auth."
- New knowledge saved → inform: "He guardado tu preferencia de commits para usarla automáticamente."
- New wiki pages created → inform: "He creado páginas wiki para [[entities/OpenAI]] y [[concepts/RLHF]] a partir de este artículo."
- Vault empty for this context → say so: "No tengo contexto guardado para este proyecto aún."
- Do NOT announce every vault read — only when it meaningfully affects your behavior.

---

## Security Note

Never save actual secret values (passwords, API tokens, private keys). Save their location only:
- **Correct:** "Credentials in `.env` at project root. Variables: `ADMIN_EMAIL`, `ADMIN_PASSWORD`."
- **Incorrect:** "Password is `s3cr3t`."
