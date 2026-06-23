# CLAUDE.md — <PROJECT NAME>

> Project context and working rules for Claude. Loaded every session — keep it short,
> specific, and true (aim < 200 lines). Delete the <angle-bracket> prompts as you fill them.

## What this is
<One to three sentences: what this project does and who it's for.>

## Tech stack (locked — do not silently swap)
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
3. **Don't touch unrelated code.** Change only what the task needs — no drive-by refactors,
   renames, or reformatting outside scope.
4. **Flag uncertainty.** If you're not confident about an approach or a fact, say so before
   proceeding.

## Conventions
- Follow the existing patterns in this codebase over any personal default.
- <Naming, file layout, and code-style notes specific to this project.>

## Hard stops — ask before doing
Deletes/overwrites of files you didn't create, schema changes, migrations, deploys, spending
money, sending anything to external services, or anything else irreversible.

## Self-learning (read at session start, update before session end)
This project keeps a shared, durable brain. Each session:
- **Read** `MEMORY.md` (decisions & why), `ERRORS.md` (failures & their fixes), and
  `LEARNINGS.md` (techniques & research findings) before starting. Verify any named file,
  path, or flag still exists before trusting it.
- **Append** to the right file the moment you make a non-obvious decision, hit a real
  failure you resolved, or discover a durable technique. One fact per entry, newest first,
  absolute dates. Each file carries its own maintenance protocol at the top — follow it.
- Don't log what the code or git history already records.

## Orchestration (work as a team when it pays off)
For substantial multi-step, multi-file, or high-stakes work, invoke the **launchpad** skill
and use its efficiency-gated playbook. Default to the smallest team that fits (often just
you); escalate only on a real trigger. When you delegate to a subagent, paste the relevant
MEMORY/ERRORS/LEARNINGS entries into its prompt — subagents can't read this project's memory
on their own.

## Voice
See `anti-style.md`. Lead with the answer; say "I'm not sure" when you aren't; no filler.
