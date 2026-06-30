# Memory pillar reference

How Claunchpad captures, stores, retrieves, and routes project memory across sessions,
subagents, and environments. This reference covers the full system; read it when you
need to understand why a choice was made, how hooks behave, or how to grow the memory
structure without destroying what exists.

## Contents

- Hybrid model — Starter vs. graduated
- Per-fact file format
- MEMORY.md index line and wikilinks
- Graduation procedure
- Hook wiring — load-memory and harvest-nudge
- Subagent access — both, situationally
- claude.ai / API degradation

---

## Hybrid model

Claunchpad keeps two compatible memory shapes and selects one at provisioning time.

**Starter (single-file log).** A single `MEMORY.md` with four sections:

```
## Decisions
## Learnings
## Errors
## References
```

Each section holds bullet entries, newest first, one fact per bullet, with an absolute
date. The header comment instructs: read at session start, append the moment a
non-obvious decision is made or a failure is resolved, log the fact *and* the why.
This format is readable, requires no tooling, and is the right choice for tiny or
throwaway projects where a file directory would be ceremony without payoff.

**Graduated (per-fact directory).** A `memory/` directory where each discrete fact
lives in its own file. `MEMORY.md` becomes a thin index — one line per fact — rather
than the facts themselves. Pro tier deploys this shape from day one. Starter and
Standard projects grow into it when the single file becomes hard to scan.

The two shapes are interoperable: the `load-memory` hook reads both. The graduation
procedure migrates from one to the other without losing anything.

---

## Per-fact file format

Each file in `memory/` follows the frontmatter defined in `templates/memory-fact.md`:

```markdown
---
name: <kebab-case-slug>
description: <one-line summary — used to judge relevance on recall>
metadata:
  type: decision | learning | error | reference
  date: YYYY-MM-DD
---

<The fact, stated once and tersely. For an error: the symptom, then **Fix:** what
resolved it. Link related facts with [[other-slug]].>
```

**Field rules:**

- `name` is the slug used in index links and wikilink references. Use kebab-case,
  stable enough not to change — renaming breaks links.
- `description` is the single line Claude reads when scanning the index to decide
  whether to open a file. Make it a complete, specific sentence.
- `metadata.type` must be one of exactly four values: `decision`, `learning`,
  `error`, or `reference`. No other values. Do not cross-file: a choice and its
  reasoning is a decision; a technique is a learning; a failure with its fix is an
  error; an external resource or command is a reference.
- `metadata.date` is `YYYY-MM-DD` in absolute form (not relative like "yesterday").

The body holds the fact itself. One fact per file. For error facts, write the symptom
first so the description is scannable, then `**Fix:**` followed by what resolved it.
Link to related facts with `[[slug]]` — the slug of the other file without the `.md`
extension.

---

## MEMORY.md index line and wikilinks

When `MEMORY.md` serves as the index to a `memory/` directory, each entry follows
this format:

```
- [Title](memory/<slug>.md) — one-line hook
```

The hook is a brief phrase (not a sentence) that gives enough context to decide whether
to open the file without opening it. For example:

```
- [SQLite over Postgres](memory/db-choice.md) — single-writer, zero ops
- [ESM vitest hang](memory/vitest-esm-fix.md) — fix: pool:forks
```

Keep the index lean: one line per fact. If a fact deserves more than one line in the
index, it belongs in the fact file, not the index.

`[[wikilinks]]` appear in fact file bodies to link related facts: `[[db-choice]]`
refers to `memory/db-choice.md`. They are a reading aid, not a machine-processed
graph; Claude reads them as pointers to open if the linked fact is relevant to the
task at hand.

---

## Graduation procedure

**Trigger.** Graduation is appropriate when the single-file `MEMORY.md` becomes hard
to scan — roughly when any section approaches a screenful, or when the file exceeds
approximately 400 lines. The header comment in the Starter `MEMORY.md` states this
trigger explicitly. Claude may suggest graduation when it notices the signal
mid-session, but execution requires the user's go-ahead: it never migrates
automatically.

**Procedure (non-destructive).** Nothing is dropped.

1. For each bullet entry in each section of the existing `MEMORY.md`, create one
   `memory/<slug>.md` fact file. Infer frontmatter from the entry:
   - `name`: a kebab-case slug derived from the entry's subject.
   - `description`: the bullet's first clause, rewritten as a full sentence.
   - `metadata.type`: map from section — Decisions → `decision`, Learnings →
     `learning`, Errors → `error`, References → `reference`.
   - `metadata.date`: the date recorded in the bullet, or today's date if absent.
   - Body: the full bullet text, expanded to prose if it was telegraphic.
2. Rewrite `MEMORY.md` as an index: the four section headers remain, but each
   section's bullets become index lines in the format above.
3. Verify every fact file is listed and no entry was dropped.

The old `MEMORY.md` content is entirely preserved — as the bodies of the new fact
files. There is nothing to roll back; the migration is complete when the index is
written and every entry is accounted for.

---

## Hook wiring

Two hooks automate the memory lifecycle. Both are POSIX sh scripts under
`templates/hooks/` and are deployed to `.claude/hooks/` during provisioning.

### load-memory (SessionStart)

Registered in `settings.json` as a `SessionStart` hook with matcher
`startup|resume|clear|compact`. It runs at the start of every session, including
sessions that begin after `/clear` and after compaction.

**What it does:**

1. Reads the JSON input from stdin and extracts the `source` field (the event subtype:
   `startup`, `resume`, `clear`, `compact`, or empty).
2. Resets the per-session harvest-nudge flag: on `startup`, `clear`, `resume`, or an
   empty source, it removes `.claunchpad/.harvest-nudged` so the harvest-nudge hook
   will fire again this session.
3. Reads `MEMORY.md` if it exists and adds it to the context buffer under the heading
   `=== Project memory index (MEMORY.md) ===`.
4. If a `memory/` directory exists, reads up to eight of the most recently modified
   `.md` files in that directory (sorted by modification time, newest first) and appends
   each under `=== memory/<filename> ===`.
5. On a `compact` source, if `.claunchpad/handoff.md` exists, appends it under
   `=== Session handoff buffer (.claunchpad/handoff.md) ===`. This reloads the
   `.claunchpad/handoff.md` buffer — a Claude-maintained file (Pro tier) that Claude
   keeps updated with current task state before long sessions or context compaction.
   No separate handoff hook exists; only `load-memory` and `harvest-nudge` are
   registered as hooks. Context survives compaction because `load-memory` reloads the
   buffer on a `compact` source.
6. Emits the assembled content via `hookSpecificOutput.additionalContext` as a JSON
   object. Claude Code injects this string as additional context at session start.

If there is nothing to load (no `MEMORY.md`, no `memory/` files, no handoff), the
hook exits silently without emitting any output.

The `additionalContext` injection is the reliability win: memory loads every session
without depending on Claude remembering to read it, and it survives `/clear` and
compaction because the `clear` and `compact` matchers are both registered.

### harvest-nudge (Stop)

Registered as a `Stop` hook (Standard and Pro tiers). Runs at the end of every turn.

**What it does:**

1. Checks for `.claunchpad/.harvest-nudged`. If the flag file exists, the hook exits
   with code 0 — silently, allowing the stop to proceed.
2. If the flag does not exist, it creates the directory `.claunchpad/` if needed,
   writes the flag file (`.claunchpad/.harvest-nudged`), and emits a `block` decision:
   ```json
   {"decision":"block","reason":"Before finishing: if this turn produced a durable
   decision, a resolved failure, or a reusable technique, append it to MEMORY.md
   (or a memory/ fact file). If nothing is worth keeping, say so briefly and stop.
   This reminder fires once per session."}
   ```

**Critical behavior:** harvest-nudge **never writes to memory itself**. It blocks
the turn once per session to remind Claude to harvest, then steps aside. Whether
to write, what to write, and where to put it are Claude's decisions, not the hook's.
This is the explicit "load auto, harvest nudge" contract: automation loads reliably,
but writing is always under deliberate control.

**Flag lifecycle:** the `.harvest-nudged` flag is created by `harvest-nudge` on its
first fire. It is cleared by `load-memory` at the start of the next session (on
`startup`, `clear`, or `resume`). The flag therefore spans exactly one session: once
the harvest reminder has fired in a session, it will not fire again until the next
session begins.

---

## Subagent access — both, situationally

General-purpose subagents and Explore/Plan agents behave differently, and the memory
strategy must account for both.

**Standing pointer (free, via CLAUDE.md).** The provisioned `CLAUDE.md` carries a
"Project memory" block instructing any agent that reads it: read `MEMORY.md` (and the
`memory/` directory if it exists) at session start, verify any named path still
exists before trusting it, and append to the right place the moment something durable
is learned. It also tells subagents explicitly: "your task prompt should carry the
1–3 memory facts that matter most; if you need more history, read `MEMORY.md` and
`memory/` yourself before starting."

General-purpose subagents inherit `CLAUDE.md`, so they receive this pointer at no
extra token cost. They can then use `Read` to open the index and any relevant fact
files before acting.

**Inline injection (guaranteed, for must-haves).** For facts that are genuinely
critical to a task — a known error that must not be repeated, a hard constraint from
a prior decision — paste the relevant 1–3 facts directly into the delegation prompt
under a heading like `## What we already know`. Do not rely on the subagent deciding
to open memory; inject what matters.

**Explore/Plan caveat.** Explore and Plan subagents skip `CLAUDE.md` entirely. They
are cheap precisely because they are context-blind, and the standing pointer never
reaches them. If an Explore or Plan agent needs any project context — constraints,
known errors, architectural decisions — everything must be injected explicitly in its
prompt. The CLAUDE.md pointer is not a fallback for Explore/Plan.

The combined strategy is "both, situationally": CLAUDE.md pointer for the general
case (free), inline injection for must-haves and for all Explore/Plan agents.

---

## claude.ai / API degradation

When running on claude.ai or directly via the Anthropic API, there is no filesystem,
no hook infrastructure, and no subagents. Memory works in-session only.

**Adapted behavior:**

- Maintain a running in-context memory block in the conversation, organized by the
  same four categories (Decisions / Learnings / Errors / References).
- Update it incrementally: when a decision is made or a failure is resolved, add the
  fact to the in-context block before moving on.
- At the end of the session, offer the user the updated `MEMORY.md` content (and any
  new fact files, if the project uses the graduated format) as copy-paste blocks so
  they can persist the memory in their repository themselves.

The discipline of one fact per entry, absolute dates, and the decision/learning/error/
reference vocabulary applies identically — only the storage mechanism changes.
Hook-loaded memory is replaced by this in-session block; subagent delegation is
replaced by sequential in-thread role passes.
