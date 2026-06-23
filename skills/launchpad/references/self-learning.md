# Self-learning: the shared agent brain

How the project learns from experience and research so the same mistake is never made twice
and good techniques compound. This is what turns a pile of one-shot agents into a team that
gets smarter every session.

## Contents
- The three stores
- The core problem
- The inject-and-harvest loop
- Single-agent variant
- What goes where
- Maintenance rules
- claude.ai / API degradation

## The three stores

Bootstrapped into the project root (from `templates/`), read at session start, kept tight:

- **`MEMORY.md`**: decisions and *why* (plus rejected alternatives).
- **`ERRORS.md`**: failures and their fixes, so a known dead end isn't retried.
- **`LEARNINGS.md`**: durable techniques and research findings ("how to do X well here").

Each file carries its own maintenance protocol at the top. They are an index of high-signal
facts, not a transcript.

## The core problem

A subagent inherits the project `CLAUDE.md`, your prompt, a git-status snapshot, and any
preloaded skills, but **no** memory and **no** conversation history. So a subagent cannot, on
its own:
- know what already failed (it will happily repeat it), or
- know the technique the last agent discovered, or
- record what it just learned where the next agent will see it.

The orchestrator is the bridge. Learning only compounds if the orchestrator deliberately
moves knowledge in and out of each delegated task.

## The inject-and-harvest loop

For every delegation:

1. **Select.** Before spawning, scan the three stores for entries relevant to this task (the
   files are short, read them). Pull the handful that matter.
2. **Inject.** Paste those entries into the subagent's prompt under a clear heading, e.g.:
   ```
   ## What we already know (from this project's memory, obey it)
   - ERROR: <symptom> -> <fix/rule>
   - LEARNING: <technique stated as a rule>
   - DECISION: <constraint that bounds your work>
   ```
   This is non-optional for any non-trivial delegation. It's the difference between an agent
   that repeats history and one that builds on it.
3. **Require a return slot.** End the delegation prompt with:
   ```
   Finish your response with a NEW-KNOWLEDGE block (or "none"):
   - FAILURE: <symptom> | CAUSE: <root cause> | FIX: <what worked>
   - LEARNING: <durable technique or finding, as a reusable rule>
   ```
4. **Harvest.** When the subagent returns, take its NEW-KNOWLEDGE block and append each item
   to the right store (`ERRORS.md` / `LEARNINGS.md` / `MEMORY.md`), newest first, deduping
   against what's there. Skip one-offs that won't generalize.
5. **Compound.** The next relevant task selects these entries in step 1, for free.

For parallel formations, harvest from every agent, then dedupe across them before appending
(several agents often rediscover the same fact).

## Single-agent variant

When you're working solo in the main thread, there's nothing to inject; you can read the files
directly. The loop collapses to the classic ritual: **read the three stores at session start;
append to the right one the moment you make a non-obvious decision, resolve a real failure, or
find a durable technique; curate before you stop.**

## What goes where

| You learned... | Store | Example |
|---|---|---|
| A choice and its reasoning | `MEMORY.md` | "Chose SQLite over Postgres: single-writer, want zero ops." |
| Something broke + the fix | `ERRORS.md` | "Vitest hung on ESM: set `pool: 'forks'`." |
| A technique that works here | `LEARNINGS.md` | "This API rate-limits at 50/s; batch in 40s with backoff." |

Don't cross-file. A decision is not a failure; a technique is not a decision. One fact, one
file, one entry.

## Maintenance rules (enforced by each file's header)

- **Read first, every session.** Verify any named file/path/flag still exists before trusting
  an entry.
- **One fact per entry; newest first; absolute dates** (`YYYY-MM-DD`).
- **Log verified outcomes, not intentions.** "Will try X" is noise; "X worked because Y" is
  signal.
- **Don't duplicate** what the code or git history already records.
- **Bound growth.** Keep the newest ~20 entries detailed; fold older ones into the file's
  rolled-up summary section; delete entries proven wrong; compact if a file passes ~400 lines.
  Files left to grow unbounded stop being read.

## claude.ai / API degradation

No filesystem means no persistent files. The loop becomes in-session only: keep the running
knowledge in the conversation, and at the end offer the user the updated stores as copy-paste
blocks so they can persist them in their own repo. The discipline is identical; only the
storage moves.
