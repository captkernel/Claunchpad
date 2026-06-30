---
name: claunchpad
description: >-
  Sets a project up so Claude works at its best: profiles the user and project,
  provisions tiered infrastructure (memory that survives /clear and compaction,
  delegation contracts, orchestration structures, and hooks), and repositions
  councils as an application on that foundation. Use when starting or
  initializing a project, configuring a repo for Claude, planning or executing
  substantial multi-step or multi-file work, or before a consequential,
  hard-to-reverse decision. Trigger phrases include "set up this project",
  "initialize Claunchpad", "run this as a team", "orchestrate this",
  "spin up agents", "review board", "debug task force", "council this",
  "feasibility council", "is this project viable", and
  "pressure-test this decision".
---

# Claunchpad — project operating system for Claude Code

Claunchpad is the cheapest structure that clears the quality bar — deployed once at
project start so you never rebuild it from scratch. It provisions three pillars
(Memory, Delegation, Orchestration) in the tier the project actually needs, wires
hooks so memory loads automatically and harvesting is nudged but never forced, and
positions councils as one application on top. Power is spent on purpose; nothing is
added that the work hasn't earned.

---

## First-run bootstrap

When the project has no `CLAUDE.md`, run the provisioning interview (full procedure:
`references/provisioning.md`). It gathers expertise and project-shape signals, picks a
tier, and deploys exactly that tier's artifacts — nothing more.

**Three tiers, decided at install time:**

| Tier | Deploys |
|---|---|
| **Starter** — beginner / tiny / throwaway | `CLAUDE.md`, sectioned `MEMORY.md`, load-only `SessionStart` hook |
| **Standard** — real project / comfortable user | Everything Starter deploys, plus `harvest-nudge` `Stop` hook and full delegation contract |
| **Pro** — advanced / large / high-stakes / team | Everything Standard deploys, plus per-fact `memory/` directory, Claude-maintained `.claunchpad/handoff.md` buffer (reloaded by `load-memory` on compact), and council presets |

Tier is a recommendation the user can override. Run `claunchpad upgrade` to add the
next tier's artifacts non-destructively when a project outgrows its current one.

After the tier is deployed, offer to install a curated set of high-value plugins/skills
(Superpowers, Skills Curator, Agent Browser) — bundle / customise / skip on Claude Code, a
manual list on the app. The editable set lives in `templates/recommended-skills.md`; the flow
is in `references/provisioning.md`.

On claude.ai or the API (no filesystem): skip file writes, apply behaviors in-session,
offer templates as copy-paste blocks.

---

## The three pillars

**Memory** (`references/memory.md`) — durable project knowledge across sessions,
compaction, and subagents; hybrid single-file log (Starter) or per-fact `memory/`
directory (Standard→Pro), with `MEMORY.md` as the thin index.

**Delegation** (`references/delegation.md`) — the 7-point contract (objective, scope,
context, output format, tool guidance, stop criteria, return-learnings slot) plus
grounded inheritance rules: general-purpose subagents inherit `CLAUDE.md`; Explore/Plan
agents are context-blind and require full inline injection; model routing (Haiku for
mechanical, Sonnet for most work, Opus for hard reasoning).

**Orchestration** (`references/orchestration.md`) — the 4-tier front door: Solo
(default), Pair (build + independent review + verify), Parallel fan-out (3+ genuinely
independent angles), Workflow (10+ uniform targets). Escalate one tier only on a fired
trigger; de-escalate the moment a cheaper structure would finish correctly.

---

## Hooks

Two hooks automate the memory lifecycle (full wiring detail: `references/memory.md`):

- **`load-memory` (SessionStart, all tiers)** — reads `MEMORY.md` and recent `memory/`
  facts, emits them via `additionalContext`. Memory loads every session, including after
  `/clear` and compaction, without depending on Claude remembering to read it.
- **`harvest-nudge` (Stop, Standard+)** — blocks once per session to remind Claude to
  file any new decision/learning/error before stopping. Never writes to memory itself.

The "load auto, harvest nudge" contract: automation loads reliably; writing is always
under deliberate control.

---

## Councils (application)

Councils are one application built on the OS — they use the memory pillar for framing
and findings, and the orchestration pillar for parallel lenses.

- **Decision Council** (`references/council.md`) — adversarial 5-advisor pressure-test
  for a consequential, hard-to-reverse choice (launch, hire, pivot, architecture,
  large spend). Convene before you act, not after.
- **Feasibility Council** (`references/feasibility-council.md`) — 4-lens project-viability
  review (tech, finance, GTM, marketing) gated by the weakest link. Convene when evaluating
  whether a whole project or product can actually work before committing resources.

Pro tier wires council presets into `CLAUDE.md`. Standard mentions councils on request.
Starter hides them unless asked.

---

## When NOT to use

A one-line fix, a quick question, or tightly-coupled edits to a single file: stay solo.
Spinning up the OS there wastes tokens and slows you down.

---

## Reference map

| File | What it contains | Load when |
|---|---|---|
| `references/provisioning.md` | Provisioning interview, signals, tier table, deploy steps, re-provision/graduation | Starting or upgrading a project |
| `references/memory.md` | Hybrid memory model, per-fact format, graduation procedure, hook wiring, subagent access | Setting up memory or delegating |
| `references/delegation.md` | 7-point contract, inheritance rules, model routing, harvest loop | Writing any non-trivial delegation prompt |
| `references/orchestration.md` | 4-tier front door, efficiency governor, escalation triggers, de-escalation, degradation | Any work beyond Solo/Pair |
| `references/org-structures.md` | Full 13-structure catalog with cost/quality profiles (Pro appendix) | Choosing or escalating a structure beyond Pair |
| `references/self-learning.md` | Inject-and-harvest loop detail — routing knowledge through delegations | Delegating, or wiring up agent memory |
| `references/council.md` | 5-advisor decision pressure-test | Before a consequential, hard-to-reverse decision |
| `references/feasibility-council.md` | 4-lens project-viability review (tech, finance, GTM, marketing) | Evaluating whether a whole project can work |
