---
name: launchpad
description: >-
  Sets a project up so Claude performs at its best and coordinates multi-agent work. Use when
  starting or initializing a project, configuring a repo for Claude, planning or executing
  substantial multi-step or multi-file work, or before a consequential, hard-to-reverse
  decision. Trigger phrases include "set up this project", "initialize launchpad", "run this
  as a team", "orchestrate this", "spin up agents", "review board", "debug task force",
  "council this", and "pressure-test this decision".
---

# Launchpad

Make Claude operate at its best on a project: disciplined context, a memory that survives
`/clear` and is shared across agents, a non-generic voice, and an agent-team playbook that
scales only as far as the task earns.

The guiding rule: **the cheapest structure that clears the quality bar wins.** Agents are
power you spend on purpose, never by default.

## When to use

- **Setting up** a new or unconfigured project for Claude. Run the bootstrap (below).
- **Substantial work** (multi-step, multi-file, research-heavy, or high-risk). Load
  `references/orchestration.md` + `references/org-structures.md` and pick a structure.
- **A consequential, hard-to-reverse decision** (launch, hire, pivot, architecture, big
  spend). Load `references/council.md` and convene.

**When NOT to use:** a one-line fix, a quick question, or tightly-coupled edits to a single
file. Stay solo. Spinning up a team there wastes tokens and slows you down.

## First-run bootstrap (Claude Code)

When the project has no `CLAUDE.md`, offer to set it up:

1. **Inspect** the repo: language, framework, package manager, test/build/lint commands,
   existing conventions.
2. **Plan.** Tell the user which files you'll create. Don't write yet.
3. **Write** these from `templates/`, filling `CLAUDE.md` from what you found: `CLAUDE.md`
   (context, locked stack, working rules, hard-stops), `MEMORY.md` (decision log), `ERRORS.md`
   (failure + fix log), `LEARNINGS.md` (techniques + research), and `anti-style.md` (voice
   guide). **Skip any file that already exists**; never clobber the user's work unless they
   say so.
4. **Report** what was created and what placeholders the user should fill.

On claude.ai or the API (no filesystem): skip the writes, apply the behaviors in-session, and
offer the templates as copy-paste blocks.

## The self-learning loop (one paragraph; full detail in `references/self-learning.md`)

The project keeps three durable stores: `MEMORY.md` (decisions), `ERRORS.md` (failures +
fixes), `LEARNINGS.md` (techniques + research). Read the relevant entries at the start of any
task. Subagents can't read these files, so when you delegate, **paste the relevant entries
into the subagent's prompt**, and require it to return any new failure/fix or learning in its
result. **Harvest** those back into the right store. Next time, that knowledge is free.

## Orchestration overview

Default to the smallest structure. Escalate one tier only on an observable trigger;
de-escalate the moment a cheaper structure would do. Quick routing:

1. A consequential, hard-to-reverse decision? Convene the **Council**.
2. Trivial, or tightly coupled / same-file? Stay **Solo**.
3. A normal change worth reviewing? **Pair** (build, independent review, verify). The default.
4. A focused multi-step feature, or a bug with rival theories? **Strike Team** or
   **Debug Task Force**.
5. 3+ independent angles? A parallel formation: **Research Pod**, **Review Board**,
   **Best-of-N**, or **Red / Blue**.
6. 10+ uniform targets, or a multi-module program? **Assembly Line** or **Program**, handed
   to a Workflow.

The efficiency governor, escalation triggers, delegation-prompt contract, model routing, the
full decision tree, and the claude.ai degradation path live in `references/orchestration.md`.
The full catalog of 13 structures (purpose, activate-when, roles, cost, output lift) lives in
`references/org-structures.md`. Load them when you escalate beyond Pair.

## Hold the line

Violating the letter of the efficiency rules is violating their spirit. Common failure modes:

| Rationalization | Reality |
|---|---|
| "More agents = better quality, so fan out." | Multi-agent multiplies token cost (Anthropic's research system measured ~15x vs. a single chat) and *hurts* on coupled work. Quality comes from the right structure, not the biggest one. |
| "This is fine, I'll skip the review/verify step." | Unverified work isn't done. The Pair's reviewer + verify gate is the cheapest quality you'll ever buy. Keep it. |
| "I'll spawn a subagent and it'll figure out the context." | Subagents inherit no memory and no history, only `CLAUDE.md` + your prompt. Vague delegation means duplicate work and gaps. |
| "Logging a learning is overhead, skip it." | The self-learning loop is the whole point. Five seconds now saves the next session an hour. |

### Red flags, STOP
- About to spawn 3+ agents on work that touches the same files? Don't; go Solo or Pair.
- Delegating without pasting in the relevant MEMORY/ERRORS/LEARNINGS? Stop, inject first.
- About to claim "done" without running the test/build/verify commands? Not done yet.
- A structure bigger than Pair with no observable trigger justifying it? Drop a tier.

## Reference map

| File | What it contains | Load when |
|---|---|---|
| `references/orchestration.md` | Efficiency governor, escalation triggers, delegation contract, model routing, degradation | Any work beyond Solo/Pair |
| `references/org-structures.md` | The 13-structure catalog with cost/quality profiles | Choosing or escalating a structure |
| `references/self-learning.md` | The inject-and-harvest protocol + file conventions | Delegating, or wiring up memory |
| `references/council.md` | The 5-advisor decision pressure-test | Before a consequential, hard-to-reverse decision |
