# launchpad

> **Working name — not final.** This project ships under the provisional name `launchpad`
> while the final, originality-checked name is locked. See `RENAME.md`.

One importable skill that makes Claude operate at its best on any project. Drop it in, and
Claude sets the repo up for itself, keeps a memory that survives `/clear`, writes in a
non-generic voice, and runs work as an **efficiency-gated team of agents** — scaling from a
solo pass up to a full org only when the task earns it.

It's the portable, generalized version of a setup that otherwise takes weeks of trial and
error to assemble: the context discipline of a good `CLAUDE.md`, a self-learning memory shared
across agents, and an orchestration playbook grounded in how Claude actually works.

## What you get

When you invoke the skill in a fresh project, it offers to bootstrap five always-on files:

| File | Role |
|---|---|
| `CLAUDE.md` | Project context, locked tech stack, the four working rules, hard-stops — read every session |
| `MEMORY.md` | Decision log (what was chosen and why) |
| `ERRORS.md` | Failure log (what broke and the fix) — so mistakes aren't repeated |
| `LEARNINGS.md` | Techniques & research findings (how to do things well here) |
| `anti-style.md` | Voice guide that kills generic-AI writing |

And it loads, on demand, the orchestration brain:

- **Efficiency governor** — the rule that keeps agent teams cheap: start with the smallest
  structure, escalate only on a real trigger, never fan out coupled work, route models by role.
- **A 13-structure org catalog** — Solo, Pair, Generator–Critic, Scout-then-Build, Strike
  Team, Debug Task Force, Research Pod, Review Board, Best-of-N, Red/Blue, Council, Assembly
  Line, and Program — each with when-to-activate and a cost/quality profile.
- **A self-learning protocol** — agents read the project's accumulated knowledge, get the
  relevant slice injected into their task, and return new failures/fixes/learnings that get
  harvested back. The project gets smarter every session.
- **A decision council** — five adversarial advisors + a chair for consequential,
  hard-to-reverse calls.

## Install

The skill folder is identical on every surface; only delivery differs.

**Claude Code** — copy the skill folder into your skills directory:
```bash
cp -r skills/launchpad ~/.claude/skills/          # available in all projects
# or, per-project:
cp -r skills/launchpad <your-repo>/.claude/skills/
```
Then it auto-triggers from its description, or invoke it explicitly.

**claude.ai** (Pro/Max/Team/Enterprise) — upload `skills/dist/launchpad.zip` via
**Settings → Capabilities → Skills**, or add it to a Project. (No filesystem there, so it
applies the behavior in-session and hands you the templates to paste.)

**Claude API** — upload via the skills endpoint and reference it by id (requires the current
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

MIT — see `LICENSE`.
