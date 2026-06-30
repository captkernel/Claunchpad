<p align="center">
  <img src="assets/logo.svg" alt="Claunchpad" width="440">
</p>

# Claunchpad

**▶ [See the interactive showcase](https://htmlpreview.github.io/?https://github.com/captkernel/Claunchpad/blob/master/showcase.html)** &nbsp;·&nbsp; [Read the story](.share/substack-claunchpad.md)

**Install one skill and Claude starts working like it has a senior engineer's habits — without
you knowing how any of it works.** Claunchpad switches on persistent memory, self-organizing
agent teams, knowledge-passing between those agents, the best free ecosystem skills, and the
orchestration discipline that experts otherwise spend weeks assembling. You don't configure it.
You don't learn it. You drop it in, answer one question, and the good defaults are simply on.

It's the portable, generalized version of a setup that normally takes weeks of trial and error:
the context discipline of a great `CLAUDE.md`, a self-learning memory shared across agents, a
right-sized team playbook, decision frameworks, and a one-tap install of the ecosystem's best
tools — all grounded in how Claude actually works.

## What one install turns on

You get all of this automatically. **No expertise required.**

- **🧠 Persistent memory** — Claude remembers your project across `/clear` and context
  compaction: the decisions you made and why, the bugs you already fixed, the techniques that
  work here. No note-taking discipline needed — a hook reloads it at the start of every
  session, so Claude never starts from zero again.
- **👥 Agent team structures** — work runs as a team that sizes itself: a solo pass for small
  things, a builder-plus-reviewer pair for real changes, parallel agents for independent
  research, a scripted assembly line for big migrations. You don't pick the structure;
  Claunchpad escalates only when the task earns it and drops back the moment it doesn't.
- **✉️ Knowledge-passing between agents** — agents don't work in the dark. The orchestrator
  injects the memory that matters into each agent's brief and harvests their findings back into
  the shared memory, so every agent builds on what the others learned instead of repeating it.
- **🧩 The best skills, one tap** — at setup, Claunchpad offers to install the high-value
  ecosystem skills (**Superpowers**, **Skills Curator**, **Agent Browser**) the right way for
  your machine. **Skills Curator is deeply integrated as the curation layer**: every other skill
  is evaluated, security-scanned, and *rebuilt for your project* through its `--customize` —
  decomposed, with only the parts that fit your stack kept and rewritten in your voice.
  *Infuse, don't invoke.*
- **✅ Best-practice guardrails** — the things experienced users do by reflex, on by default:
  spend agents only when they pay off (multi-agent runs cost ~15× the tokens), never call work
  "done" without an independent review and verification, route cheap models to cheap roles, and
  stop to pressure-test big, irreversible decisions.
- **🎚️ Tuned to you** — a beginner gets a tiny, safe setup with nothing to break; an expert
  gets the full machine. Claunchpad reads who you are and what you're building, deploys exactly
  that, then grows with the project one non-destructive upgrade at a time.
- **🧭 Decision frameworks** — built-in councils that pressure-test a consequential choice (5
  adversarial advisors) or a whole project's viability (4 functional lenses) before you commit.
- **📈 Gets smarter every session** — a built-in self-learning protocol captures every fix,
  decision, and technique as it happens and reloads it next time, so the project compounds
  instead of resetting.
- **🌍 Works everywhere** — the same skill runs on Claude Code, claude.ai, and the API; where
  there's no filesystem it applies the behavior in-session and hands you the files to keep.

Under the hood, that's three pillars — **Memory, Delegation, Orchestration** — plus a hook
layer and the councils, deployed in the depth your project actually needs. Tier is chosen via a
short interview at first run:

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
