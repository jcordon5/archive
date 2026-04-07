# Wiki Page Templates

Reference for the three wiki page types. Use these when creating or updating pages in `$VAULT/wiki/`.

---

## Entity page — `wiki/entities/{Name}.md`

For: people, organizations, products, companies, projects with a name.

```markdown
---
type: entity
tags: [person|org|product|project, relevant-domain]
sources: [sources/slug1.md]
updated: YYYY-MM-DD
---

# {Name}

**Summary:** {2–4 sentences covering who/what this is and why it matters in this knowledge base.}

## Key Facts
- {Specific, verifiable fact} *(Source: [[sources/slug]])*
- {Another fact}

## Connections
- Related to [[entities/OtherEntity]] because {reason}
- Key work in [[concepts/CoreConcept]]
- Mentioned in [[topics/TopicSynthesis]]

## Contradictions / Open Questions
- Claim from [[sources/A]] says X; [[sources/B]] says Y. Unresolved as of YYYY-MM-DD.

## Timeline
- YYYY — {event}
- YYYY — {event}
```

---

## Concept page — `wiki/concepts/{Name}.md`

For: ideas, patterns, techniques, terminology, methodologies.

```markdown
---
type: concept
tags: [domain, sub-domain]
sources: [sources/slug1.md, sources/slug2.md]
updated: YYYY-MM-DD
---

# {Concept Name}

**Summary:** {2–4 sentence definition and significance.}

## Core Idea
{1–3 paragraphs explaining the concept clearly, as if writing for someone new to it.}

## Key Properties / Variants
- {Property or variant}: {explanation}

## Examples
- {Concrete example from sources}

## Connections
- Builds on [[concepts/FoundationalConcept]]
- Used by [[entities/EntityThatAppliesThis]]
- Contrasts with [[concepts/AlternativeApproach]] because {reason}

## Open Questions
- {Unresolved question or active debate in the sources}
```

---

## Topic page — `wiki/topics/{Slug}.md`

For: research synthesis, deep dives, answers filed back into the wiki, competitive analyses.

```markdown
---
type: topic
tags: [domain, research-area]
sources: [sources/slug1.md, sources/slug2.md, sources/slug3.md]
updated: YYYY-MM-DD
---

# {Topic Title}

**Summary:** {2–4 sentence synthesis of the current state of knowledge on this topic.}

## Overview
{Narrative synthesis — what do we know, how does it fit together?}

## Key Findings
1. {Finding with citation [[sources/slug]]}
2. {Finding}

## Entities Involved
- [[entities/A]], [[entities/B]]

## Core Concepts
- [[concepts/X]], [[concepts/Y]]

## Contradictions / Debate
- {Claim from source A} vs {claim from source B} — {current best interpretation}

## Gaps & Next Steps
- {What would be valuable to find / read next?}
- {Open question worth investigating}
```

---

## Cross-referencing conventions

- Use `[[wiki/entities/Name]]` syntax for links (Obsidian-compatible wikilinks).
- You can shorten to `[[entities/Name]]` within wiki pages (Obsidian resolves relative links).
- When a source contradicts an existing wiki claim, add to the Contradictions section of BOTH pages.
- A concept mentioned multiple times across different entity or topic pages should get its own concept page.
- If a term appears in `[[double brackets]]` but has no page yet, that's a stub — note it in `_index.md` as a missing page and the lint operation will surface it.
