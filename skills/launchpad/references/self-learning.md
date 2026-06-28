# Self-learning: the shared agent brain

How the project learns from experience and research so the same mistake is never made twice
and good techniques compound. This is what turns a pile of one-shot agents into a team that
gets smarter every session.

For the full memory system — hybrid model shapes, per-fact file format, graduation procedure,
hook wiring, and subagent access rules — see `references/memory.md`. This file covers the
inject-and-harvest loop that routes knowledge through delegations.

## Contents
- The hybrid memory model
- The core problem
- Hook automation
- The inject-and-harvest loop
- Single-agent variant
- What goes where
- Maintenance rules
- claude.ai / API degradation

## The hybrid memory model

Launchpad keeps two compatible memory shapes; the right one is chosen at provisioning time.

**Starter (single-file log).** A single `MEMORY.md` with four sections:

```
## Decisions
## Learnings
## Errors
## References
```

Each section holds bullet entries, newest first, one fact per bullet, with an absolute date.
This format is readable, requires no tooling, and is the right choice for small or throwaway
projects.

**Graduated (per-fact directory).** A `memory/` directory where each discrete fact lives in
its own file with frontmatter. `MEMORY.md` becomes a thin index — one line per fact — rather
than the facts themselves. Pro tier deploys this shape from day one; Starter and Standard
projects grow into it when the single file becomes hard to scan.

Type vocabulary (exact): `decision` | `learning` | `error` | `reference`. No other values.
See `references/memory.md` for frontmatter format and graduation procedure.

## The core problem

A subagent inherits the project `CLAUDE.md`, your prompt, a git-status snapshot, and any
preloaded skills, but **no** memory and **no** conversation history. So a subagent cannot, on
its own:
- know what already failed (it will happily repeat it), or
- know the technique the last agent discovered, or
- record what it just learned where the next agent will see it.

The orchestrator is the bridge. Learning only compounds if the orchestrator deliberately
moves knowledge in and out of each delegated task.

## Hook automation

Two hooks automate the memory lifecycle so discipline gaps don't silently drop facts.

**Load side (automated).** The `load-memory` hook runs at every session start — including
after `/clear` and after compaction, because both `clear` and `compact` matchers are
registered. It reads `MEMORY.md` (and up to eight recently-modified `memory/` fact files in
graduated projects) and injects them into Claude's context via
`hookSpecificOutput.additionalContext`. Memory loads every session without depending on
Claude remembering to open a file.

**Harvest side (nudge, not auto-write).** The `harvest-nudge` hook runs once per session at
the first `Stop` event. If this session hasn't already been nudged, it blocks the turn and
reminds Claude to file any new decision, learning, error, or reference before finishing. It
never writes to memory itself — what to write and where is always Claude's deliberate choice.
The flag is cleared by `load-memory` at the next session start so the nudge fires fresh.

**What hooks do not change.** The inject-into-subagents discipline described below is
unchanged: hooks automate what happens in the main thread, but a subagent's prompt is the
orchestrator's responsibility. The `load-memory` hook does not run inside a subagent's
context; the orchestrator must inject relevant facts explicitly.

## The inject-and-harvest loop

For every delegation:

1. **Select.** Before spawning, scan `MEMORY.md` (and relevant `memory/` fact files) for
   entries relevant to this task. Pull the handful that matter.
2. **Inject.** Paste those entries into the subagent's prompt under a clear heading, e.g.:
   ```
   ## What we already know (from this project's memory, obey it)
   - error: <symptom> -> <fix/rule>
   - learning: <technique stated as a rule>
   - decision: <constraint that bounds your work>
   ```
   This is non-optional for any non-trivial delegation. It's the difference between an agent
   that repeats history and one that builds on it.
3. **Require a return slot.** End the delegation prompt with:
   ```
   Finish your response with a NEW-KNOWLEDGE block (or "none"):
   - FAILURE: <symptom> | CAUSE: <root cause> | FIX: <what worked>
   - LEARNING: <durable technique or finding, as a reusable rule>
   ```
4. **Harvest.** When the subagent returns, take its NEW-KNOWLEDGE block and file each item
   in the right place: a `decision`, `learning`, `error`, or `reference` entry in `MEMORY.md`
   (or a new fact file in `memory/`), newest first, deduping against what's there. Skip
   one-offs that won't generalize.
5. **Compound.** The next relevant task selects these entries in step 1, for free.

For parallel formations, harvest from every agent, then dedupe across them before appending
(several agents often rediscover the same fact).

## Single-agent variant

When you're working solo in the main thread, the `load-memory` hook handles the read side
automatically. The loop collapses to: **review what loaded at session start; append to the
right section or create a new fact file the moment you make a non-obvious decision, resolve a
real failure, or find a durable technique; review before you stop** (the harvest-nudge hook
will remind you if you forget).

## What goes where

| You learned... | Type | Example |
|---|---|---|
| A choice and its reasoning | `decision` | "Chose SQLite over Postgres: single-writer, want zero ops." |
| Something broke and the fix | `error` | "Vitest hung on ESM: set `pool: 'forks'`." |
| A technique that works here | `learning` | "This API rate-limits at 50/s; batch in 40s with backoff." |
| An external resource or command | `reference` | "API docs live at …; auth token is in `.env.example`." |

Don't cross-type. A decision is not a failure; a technique is not a decision. One fact, one
entry (or one file in the graduated format).

## Maintenance rules

- **Read first, every session.** The `load-memory` hook does this automatically; verify any
  named file/path/flag still exists before trusting an entry.
- **One fact per entry; newest first; absolute dates** (`YYYY-MM-DD`).
- **Log verified outcomes, not intentions.** "Will try X" is noise; "X worked because Y" is
  signal.
- **Don't duplicate** what the code or git history already records.
- **Bound growth.** Keep the newest ~20 entries detailed; fold older ones into the file's
  rolled-up summary section; delete entries proven wrong; compact if a file passes ~400 lines.
  Files left to grow unbounded stop being read.

## claude.ai / API degradation

No filesystem means no persistent files and no hooks. The loop becomes in-session only: keep
the running knowledge in the conversation organized by the same four categories (Decisions /
Learnings / Errors / References), and at the end offer the user the updated `MEMORY.md`
content (and any new fact files, if the project uses the graduated format) as copy-paste
blocks so they can persist them in their own repo. The discipline is identical; only the
storage and automation move.
