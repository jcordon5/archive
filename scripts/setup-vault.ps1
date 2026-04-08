# setup-vault.ps1 — Initialize the Claude persistent knowledge vault (Windows)
#
# Usage:
#   .\setup-vault.ps1                                    # Uses ~/.claude-knowledge/ (default)
#   .\setup-vault.ps1 -VaultPath "C:\path\to\vault"      # Custom location
#   $env:CLAUDE_KNOWLEDGE_PATH="C:\vault"; .\setup-vault.ps1  # Via env var
#
# After running, open Obsidian → "Open folder as vault" → select the vault path.

param(
    [string]$VaultPath
)

$ErrorActionPreference = "Stop"

if ($VaultPath) {
    $VAULT = $VaultPath
} elseif ($env:CLAUDE_KNOWLEDGE_PATH) {
    $VAULT = $env:CLAUDE_KNOWLEDGE_PATH
} else {
    $VAULT = Join-Path $HOME ".claude-knowledge"
}

$TODAY = Get-Date -Format "yyyy-MM-dd"

Write-Host "Claude Knowledge Vault - Setup"
Write-Host "================================"
Write-Host "Vault path: $VAULT"
Write-Host ""

# -- Directory structure -------------------------------------------------------

$dirs = @(
    "sources",
    "wiki/entities",
    "wiki/concepts",
    "wiki/topics",
    "preferences",
    "projects",
    "domains"
)

foreach ($d in $dirs) {
    $full = Join-Path $VAULT $d
    if (-not (Test-Path $full)) {
        New-Item -ItemType Directory -Path $full -Force | Out-Null
    }
}
Write-Host "[OK] Directory structure created"

# -- _index.md -----------------------------------------------------------------

$indexPath = Join-Path $VAULT "_index.md"
if (-not (Test-Path $indexPath)) {
    @"
# Knowledge Index
Last updated: $TODAY

## Preferences
<!-- Format: ``preferences/<file>.md`` - one-line summary -->

## Projects
<!-- Format: ``projects/<Name>/context.md`` - CWD: <path> | key facts -->

## Domains
<!-- Format: ``domains/<technology>.md`` - one-line summary -->

## Wiki - Entities
<!-- Format: ``wiki/entities/<Name>.md`` - one-line summary, tags -->

## Wiki - Concepts
<!-- Format: ``wiki/concepts/<Name>.md`` - one-line summary -->

## Wiki - Topics
<!-- Format: ``wiki/topics/<Topic>.md`` - one-line summary, source count -->

## Sources
<!-- Format: ``sources/<slug>.md`` - Title | ingested YYYY-MM-DD -->

## Quick Facts
<!-- One-liner micro-facts: timezone, language preference, employer, key paths, etc. -->
"@ | Set-Content -Path $indexPath -Encoding UTF8
    Write-Host "[OK] _index.md created"
} else {
    Write-Host "     _index.md already exists - skipping"
}

# -- _log.md -------------------------------------------------------------------

$logPath = Join-Path $VAULT "_log.md"
if (-not (Test-Path $logPath)) {
    @"
# Knowledge Log
Append-only. Each entry: ``## [YYYY-MM-DD] {type} | {title}``
Types: ingest | query | save | lint

<!-- grep "^## \[" _log.md | tail -10   -> last 10 operations  -->
<!-- grep "ingest" _log.md              -> all ingests          -->

## [$TODAY] save | Vault initialized
Setup complete. Empty vault created.
"@ | Set-Content -Path $logPath -Encoding UTF8
    Write-Host "[OK] _log.md created"
} else {
    Write-Host "     _log.md already exists - skipping"
}

# -- wiki/_overview.md ---------------------------------------------------------

$overviewPath = Join-Path $VAULT "wiki/_overview.md"
if (-not (Test-Path $overviewPath)) {
    @"
# Wiki Overview
Last updated: $TODAY

## Current Research Areas
<!-- List active topics with links to wiki/topics/ pages -->

## Key Entities
<!-- Most important people, orgs, products in the wiki -->

## Core Concepts
<!-- Central ideas that many pages link back to -->

## Open Questions
<!-- Unresolved contradictions or gaps across the wiki -->
"@ | Set-Content -Path $overviewPath -Encoding UTF8
    Write-Host "[OK] wiki/_overview.md created"
} else {
    Write-Host "     wiki/_overview.md already exists - skipping"
}

# -- Preference stubs ----------------------------------------------------------

foreach ($fname in @("writing-style", "code-style", "git-conventions")) {
    $fpath = Join-Path $VAULT "preferences/$fname.md"
    if (-not (Test-Path $fpath)) {
        @"
# $fname

<!-- Entries added by Claude as preferences are discovered -->
"@ | Set-Content -Path $fpath -Encoding UTF8
        Write-Host "[OK] preferences/$fname.md created"
    } else {
        Write-Host "     preferences/$fname.md already exists - skipping"
    }
}

# -- Done ----------------------------------------------------------------------

Write-Host ""
Write-Host "Vault ready at: $VAULT"
Write-Host ""
Write-Host "Next steps:"
Write-Host "  - Open Obsidian -> Open folder as vault -> select: $VAULT"
Write-Host "  - Enable the Obsidian Graph View to see wiki connections"
Write-Host "  - To use a custom path: set CLAUDE_KNOWLEDGE_PATH=$VAULT in your environment"
Write-Host "  - Claude will populate the vault automatically during tasks"
Write-Host ""
Write-Host "Vault structure:"
Write-Host "  sources/      <- Drop raw articles/transcripts here for Claude to ingest"
Write-Host "  wiki/         <- LLM-maintained interlinked knowledge pages"
Write-Host "  preferences/  <- Code style, writing tone, git conventions"
Write-Host "  projects/     <- Per-project auth, stack, endpoints"
Write-Host "  domains/      <- Technology knowledge across projects"
