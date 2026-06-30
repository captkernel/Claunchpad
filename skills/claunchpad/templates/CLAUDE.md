# CLAUDE.md: <PROJECT NAME>

> Project context and working rules for Claude. Loaded every session, keep it short,
> specific, and true (aim < 200 lines). Delete the <angle-bracket> prompts as you fill them.

## What this is
<One to three sentences: what this project does and who it's for.>

## Tech stack (locked: do not silently swap)
- Language: <e.g. TypeScript 5.x>
- Framework: <e.g. Next.js 15 / FastAPI / none>
- Package manager: <e.g. pnpm / uv / pip>
- Tests: <e.g. vitest / pytest>
- Lint / format: <e.g. eslint + prettier / ruff>

## Run / test / build (exact commands)
- Run (dev): `<command>`
- Test: `<command>`
- Build: `<command>`
- Lint: `<command>`

## Working rules (the four that matter)
1. **Ask, don't assume.** If intent, architecture, or requirements are unclear, ask before
   writing a line. No silent guesses.
2. **Simplest solution first.** Build the simplest thing that works. No abstractions or
   flexibility nobody asked for.
3. **Don't touch unrelated code.** Change only what the task needs, no drive-by refactors,
   renames, or reformatting outside scope.
4. **Flag uncertainty.** If you're not confident about an approach or a fact, say so before
   proceeding.

## Conventions
- Follow the existing patterns in this codebase over any personal default.
- <Naming, file layout, and code-style notes specific to this project.>

## Hard stops: ask before doing
Deletes/overwrites of files you didn't create, schema changes, migrations, deploys, spending
money, sending anything to external services, or anything else irreversible.

## Project memory (read at session start, update before session end)
<!-- CLAUNCHPAD-MEMORY-POINTER: this block is inherited by general-purpose subagents. Keep it. -->
This project keeps a durable, shared memory. **Read `MEMORY.md` first thing each session**
(and the `memory/` directory if it exists); verify any named file/path/flag still exists
before trusting it. **Append** to the right place the moment you make a non-obvious decision,
resolve a real failure, or find a durable technique — one fact, newest first, absolute dates.

**If you are a subagent:** your task prompt should carry the 1–3 memory facts that matter most.
If you need more history, **read `MEMORY.md` (and `memory/`) yourself** before starting — you do
not inherit the parent's conversation or memory, only this file. (Explore/Plan agents do not even
get this file; they must be given everything in their prompt.)

**Handoff buffer (Pro tier):** if `.claunchpad/handoff.md` exists, keep it updated with current task state (what's in progress, next step) before long sessions or context compaction — `load-memory` reloads it on a `compact` source so context survives `/clear` and compaction.

## Orchestration (work as a team only when it pays off)
For substantial multi-step, multi-file, or high-stakes work, invoke the **claunchpad** skill and
use its efficiency-gated ladder: Solo → Pair → parallel fan-out → Workflow. Default to the
smallest structure that clears the bar; escalate only on a real trigger. When you delegate,
inject the critical memory facts into the subagent's prompt (it can't read this project's
memory on its own beyond this file) and require a return-learnings slot you harvest back.
