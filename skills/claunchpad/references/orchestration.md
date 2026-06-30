# Orchestration: the efficiency governor

How to run work as a team without burning tokens. Read this before any work beyond Solo or
Pair. Pair it with `org-structures.md` (the Pro catalog of structures) and `self-learning.md`
(what to inject into each delegated agent).

## Contents
- The one rule
- Why restraint (the cost reality)
- The 4-tier front door
- Escalation triggers (when to go up a tier)
- De-escalation (when to come back down)
- Delegation &amp; subagent inheritance
- Synthesis (combining results)
- Degradation: orchestration without subagents

## The one rule

**Pick the cheapest structure that clears the quality bar.** Start small. Escalate one tier
only when a concrete trigger fires. Drop a tier the moment a cheaper one would do. The org
catalog is power you spend deliberately, never the default.

## Why restraint (the cost reality)

- Multi-agent work multiplies token cost. Anthropic's multi-agent research system measured
  roughly **15x the tokens** of a single chat; a small 3-5 agent fan-out costs less, but it
  still multiplies. Token usage alone explains most of the variance in multi-agent cost.
- Multi-agent **helps** on breadth-first, independent, parallelizable work (research, wide
  review, exploring a large surface).
- Multi-agent **hurts** on tightly-coupled work: shared context, many dependencies between
  steps, or several agents editing the same files (last write wins, so work is lost).
- So the question is never "how many agents can I throw at this." It's "what is the smallest
  formation that produces a correct, verified result."

## The 4-tier front door

Start here every time. One observable trigger per step.

**Tier 1 — Solo** (default)
Trigger: the task is trivial, sequential, or tightly-coupled / same-file. Parallelism would
cause conflicts or add no speed. Most tasks live here.

**Tier 2 — Pair** (default for real changes)
Trigger: the change is worth a second pair of eyes — a fix, a feature, anything that touches
shared logic. One agent builds; a separate fresh-context agent reviews; the orchestrator
verifies and merges. This is where real-project work should land by default.

**Tier 3 — Parallel fan-out**
Trigger: 3 or more genuinely independent angles exist — subtasks that don't share state and
won't edit the same files (research pod, review board, best-of-N). Run them in parallel and
synthesize results. Do not use if agents would touch the same files; last write wins.

**Tier 4 — Workflow**
Trigger: 10 or more uniform targets (files to migrate, endpoints to audit, items to
transform), or a multi-module program where hand-spawning every agent is impractical. Hand
the work to a deterministic script that orchestrates many agents. See `org-structures.md`.

If none of the triggers above fire, stay at the tier you're on. Escalating without a fired
trigger is waste.

## Escalation triggers (go up a tier only if one is true)

- **Parallelism:** there are **3 or more independent** subtasks that don't share
  state and won't edit the same files.
- **Context pollution:** the task will flood the main context with output you won't reuse
  (large logs, many files, deep research). Isolate it in a subagent that returns only the
  conclusion.
- **Independent verification needed:** the change is risky enough that a fresh-context
  reviewer (who didn't write it) materially lowers the chance of a bad merge.
- **High stakes:** the cost of being wrong is large or hard to reverse.
- **Wide solution space:** several plausible approaches exist and one attempt is likely to be
  mediocre (design, algorithm, naming). Generate competing attempts and judge them.

If none fire, you're done escalating. Most tasks live at Solo or Pair.

## De-escalation (come back down)

After each phase, ask: would a cheaper structure now finish this correctly? If yes, drop to
it. Common cases: a Research Pod's findings turn out narrow (finish Solo); a Review Board
finds nothing in two lenses (one reviewer would have sufficed next time). Record that as a
learning.

## Delegation &amp; subagent inheritance

See `references/delegation.md` for the 7-point contract, inheritance rules, and model routing.

## Synthesis (combining results)

When agents return:
- **Cross-check** claims that should agree; flag conflicts rather than averaging them away.
- **Preserve sources:** keep the evidence/citations, not just the rolled-up conclusion.
- **Attribute** which agent found what, so a wrong finding can be traced.
- A synthesis step is itself a role (often Opus). Don't let the orchestrator silently blur
  five strong findings into mush. Take a position.

## Degradation: orchestration without subagents

On claude.ai and other surfaces with no subagent tool, run the same structures as **sequential
persona passes** in one thread:

- Do one role at a time: implement, then (as a fresh-eyed reviewer) critique, then reconcile.
  Council runs the same way: five advisors in turn, then the chair.
- Clear or summarize context between heavy passes to avoid bloat.
- Tradeoff: cheaper (no duplicated context) but slower and with no true isolation; the later
  passes have seen the earlier ones. Name the lens explicitly each pass to fight priming.

The full 13-structure catalog is a power-user appendix: `references/org-structures.md`.
