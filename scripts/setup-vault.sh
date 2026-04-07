#!/usr/bin/env bash
# setup-vault.sh — Initialize the Claude persistent knowledge vault
#
# Usage:
#   bash setup-vault.sh                          # Uses ~/.claude-knowledge/ (default)
#   bash setup-vault.sh ~/path/to/custom/vault   # Custom location
#   CLAUDE_KNOWLEDGE_PATH=~/vault bash setup-vault.sh  # Via env var
#
# After running, open Obsidian → "Open folder as vault" → select the vault path.

set -euo pipefail

VAULT="${1:-${CLAUDE_KNOWLEDGE_PATH:-$HOME/.claude-knowledge}}"
TODAY=$(date +%Y-%m-%d)

echo "Claude Knowledge Vault — Setup"
echo "================================"
echo "Vault path: $VAULT"
echo ""

# ── Directory structure ──────────────────────────────────────────────────────

mkdir -p "$VAULT/sources"
mkdir -p "$VAULT/wiki/entities"
mkdir -p "$VAULT/wiki/concepts"
mkdir -p "$VAULT/wiki/topics"
mkdir -p "$VAULT/preferences"
mkdir -p "$VAULT/projects"
mkdir -p "$VAULT/domains"
echo "✓ Directory structure created"

# ── _index.md ────────────────────────────────────────────────────────────────

if [ ! -f "$VAULT/_index.md" ]; then
cat > "$VAULT/_index.md" << INDEXEOF
# Knowledge Index
Last updated: ${TODAY}

## Preferences
<!-- Format: \`preferences/<file>.md\` — one-line summary -->

## Projects
<!-- Format: \`projects/<Name>/context.md\` — CWD: <path> | key facts -->

## Domains
<!-- Format: \`domains/<technology>.md\` — one-line summary -->

## Wiki — Entities
<!-- Format: \`wiki/entities/<Name>.md\` — one-line summary, tags -->

## Wiki — Concepts
<!-- Format: \`wiki/concepts/<Name>.md\` — one-line summary -->

## Wiki — Topics
<!-- Format: \`wiki/topics/<Topic>.md\` — one-line summary, source count -->

## Sources
<!-- Format: \`sources/<slug>.md\` — Title | ingested YYYY-MM-DD -->

## Quick Facts
<!-- One-liner micro-facts: timezone, language preference, employer, key paths, etc. -->
INDEXEOF
  echo "✓ _index.md created"
else
  echo "  _index.md already exists — skipping"
fi

# ── _log.md ──────────────────────────────────────────────────────────────────

if [ ! -f "$VAULT/_log.md" ]; then
cat > "$VAULT/_log.md" << LOGEOF
# Knowledge Log
Append-only. Each entry: \`## [YYYY-MM-DD] {type} | {title}\`
Types: ingest | query | save | lint

<!-- grep "^## \[" _log.md | tail -10   → last 10 operations  -->
<!-- grep "ingest" _log.md              → all ingests          -->

## [${TODAY}] save | Vault initialized
Setup complete. Empty vault created.
LOGEOF
  echo "✓ _log.md created"
else
  echo "  _log.md already exists — skipping"
fi

# ── wiki/_overview.md ────────────────────────────────────────────────────────

if [ ! -f "$VAULT/wiki/_overview.md" ]; then
cat > "$VAULT/wiki/_overview.md" << OVEREOF
# Wiki Overview
Last updated: ${TODAY}

## Current Research Areas
<!-- List active topics with links to wiki/topics/ pages -->

## Key Entities
<!-- Most important people, orgs, products in the wiki -->

## Core Concepts
<!-- Central ideas that many pages link back to -->

## Open Questions
<!-- Unresolved contradictions or gaps across the wiki -->
OVEREOF
  echo "✓ wiki/_overview.md created"
else
  echo "  wiki/_overview.md already exists — skipping"
fi

# ── Preference stubs ─────────────────────────────────────────────────────────

for fname in writing-style code-style git-conventions; do
  fpath="$VAULT/preferences/$fname.md"
  if [ ! -f "$fpath" ]; then
    echo "# ${fname}" > "$fpath"
    echo "" >> "$fpath"
    echo "<!-- Entries added by Claude as preferences are discovered -->" >> "$fpath"
    echo "✓ preferences/$fname.md created"
  else
    echo "  preferences/$fname.md already exists — skipping"
  fi
done

# ── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "Vault ready at: $VAULT"
echo ""
echo "Next steps:"
echo "  • Open Obsidian → Open folder as vault → select: $VAULT"
echo "  • Enable the Obsidian Graph View to see wiki connections"
echo "  • To use a custom path: set CLAUDE_KNOWLEDGE_PATH=$VAULT in your environment"
echo "  • Claude will populate the vault automatically during tasks"
echo ""
echo "Vault structure:"
echo "  sources/      ← Drop raw articles/transcripts here for Claude to ingest"
echo "  wiki/         ← LLM-maintained interlinked knowledge pages"
echo "  preferences/  ← Code style, writing tone, git conventions"
echo "  projects/     ← Per-project auth, stack, endpoints"
echo "  domains/      ← Technology knowledge across projects"
