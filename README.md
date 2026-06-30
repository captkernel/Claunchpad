# claunchpad

> **Working name, not final.** This project ships under the provisional name `claunchpad`
> while the final, originality-checked name is locked. See `RENAME.md`.

One importable skill that makes Claude operate at its best on any project. Drop it in, and
Claude profiles the project, provisions the right tier of infrastructure, keeps a memory that
survives `/clear` and context compaction, and runs work as an **efficiency-gated team of
agents**, scaling from a solo pass up to a full org only when the task earns it.

It's the portable, generalized version of a setup that otherwise takes weeks of trial and
error to assemble: the context discipline of a good `CLAUDE.md`, a self-learning memory shared
across agents, and an orchestration playbook grounded in how Claude actually works.

## What you get

Claunchpad provisions three pillars — Memory, Delegation, Orchestration — in the depth
the project actually needs. Tier is chosen via a short interview at first run:

| Tier | Who it's for | What it deploys |
|---|---|---|
| **Starter** | Beginner / tiny / throwaway | `CLAUDE.md`, sectioned `MEMORY.md`, `SessionStart` load-memory hook |
| **Standard** | Real project / comfortable user | Everything Starter, plus `harvest-nudge` `Stop` hook and full delegation contract |
| **Pro** | Advanced / large / high-stakes / team | Everything Standard, plus per-fact `memory/` directory, `.claunchpad/handoff.md` buffer, and council presets |

**Memory** — hybrid model: Starter uses a single `MEMORY.md` (four sections: Decisions,
Learnings, Errors, References). Pro uses a per-fact `memory/` directory with `MEMORY.md`
as a thin index. Both shapes are read by the `load-memory` hook on every session start,
including after `/clear` and compaction. Standard projects can graduate to the per-fact
shape non-destructively when the file grows too large to scan.

**Hooks** — two POSIX sh hooks automate the memory lifecycle:
- `load-memory` (SessionStart, all tiers) — injects memory into context via `additionalContext`.
- `harvest-nudge` (Stop, Standard+) — blocks once per session to remind Claude to file any
  new decision/learning/error before stopping. Never writes to memory itself.

**Orchestration** — the 4-tier efficiency-gated ladder (Solo → Pair → Parallel fan-out →
Workflow) plus the full 13-structure org catalog (Pro appendix). The first rule is
restraint: most tasks never leave Solo or Pair. Bigger structures activate only on observable
triggers and de-escalate the moment a cheaper structure would do.

**Delegation** — the 7-point contract (objective, scope, context, output format, tool
guidance, stop criteria, return-learnings slot) plus grounded inheritance rules covering what
general-purpose and Explore/Plan subagents actually receive, and model routing (Haiku /
Sonnet / Opus) as the single biggest cost lever in a multi-agent run.

**Councils** — one application built on the OS: a 5-advisor Decision Council for
consequential choices, and a 4-lens Feasibility Council for project-viability reviews.

## Install

The skill folder is identical on every surface; only delivery differs.

**Claude Code**, copy the skill folder into your skills directory:
```bash
cp -r skills/claunchpad ~/.claude/skills/          # available in all projects
# or, per-project:
cp -r skills/claunchpad <your-repo>/.claude/skills/
```
Then it auto-triggers from its description, or invoke it explicitly.

**claude.ai** (Pro/Max/Team/Enterprise), upload `skills/dist/claunchpad.zip` via
**Settings → Capabilities → Skills**, or add it to a Project. (No filesystem there, so it
applies the behavior in-session and hands you the templates to paste.)

**Claude API**, upload via the skills endpoint and reference it by id (requires the current
skills/code-execution beta headers).

## How it stays cheap

Multi-agent work costs roughly 15× the tokens of a single pass and actively hurts on tightly
coupled changes. So the playbook's first rule is restraint: most tasks never leave Solo or
Pair. Bigger structures activate only on observable triggers (three or more independent
subtasks, real context-pollution risk, a need for independent verification, high stakes), and
the skill de-escalates the moment a cheaper structure would do. The org catalog is power you
spend deliberately, not by default.

## Design & sources

The full design rationale and the research it's built on (Claude Code memory/skills/subagent
docs, Anthropic's multi-agent and context-engineering writing) live in `docs/design.md`.

## License

MIT, see `LICENSE`.
