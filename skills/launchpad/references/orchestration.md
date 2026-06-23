# Orchestration: the efficiency governor

How to run work as a team without burning tokens. Read this before any work beyond Solo or
Pair. Pair it with `org-structures.md` (the catalog of structures) and `self-learning.md`
(what to inject into each delegated agent).

## Contents
- The one rule
- Why restraint (the cost reality)
- Escalation triggers (when to go up a tier)
- De-escalation (when to come back down)
- The delegation-prompt contract
- Model routing
- Concurrency and scale limits
- Synthesis (combining results)
- The CLAUDE.md / subagent gotcha
- Degradation: orchestration without subagents
- Selection decision tree

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

## The delegation-prompt contract

A subagent inherits the project `CLAUDE.md`, your prompt, a git-status snapshot, and any
skills named in its definition. It does **not** inherit the parent's conversation, memory, or
system prompt. Vague delegation is the top cause of duplicated work, gaps, and wrong-tool use.
Every delegation states, explicitly:

1. **Objective:** the one concrete outcome, in a sentence.
2. **Scope / boundaries:** what's in, what's out, what not to touch.
3. **Known context:** the relevant `MEMORY.md` / `ERRORS.md` / `LEARNINGS.md` entries, pasted
   in (the agent can't read them itself), plus file paths and any error text.
4. **Output format:** exactly what to return (a list, a diff, a verdict, a structured object),
   so results compose without rework.
5. **Tool guidance:** which tools/searches to prefer, and to make independent calls in
   parallel where possible.
6. **Stop criteria:** when to consider the task finished, so it doesn't run away.
7. **Return-learnings slot:** require the agent to end with any new failure+fix or durable
   learning it found, so you can harvest it (see `self-learning.md`).

## Model routing (a cost lever, not an afterthought)

Match the model to the role:
- **Haiku:** mechanical, high-volume, or classification work (formatting, log triage, simple
  lookups).
- **Sonnet:** most implementation, search, and review.
- **Opus:** hard reasoning: architecture, synthesis of many results, adversarial judging, the
  trickiest bugs.

Cheaper models on the cheap roles is often the single biggest saving in a multi-agent run.

## Concurrency and scale limits

- Run **3-5 agents in parallel** for most fan-out. More than that rarely improves results and
  multiplies cost.
- Concurrency caps vary by plan/tier and can queue sustained fan-outs; a rough ceiling is **a
  dozen or so** concurrent agents. Don't design for more by hand.
- At **10+ targets** (files to migrate, endpoints to audit, items to transform), stop
  hand-spawning. Hand the work to a **Workflow** (a script that orchestrates many agents
  deterministically). See the Assembly Line / Program entries in `org-structures.md`.

## Synthesis (combining results)

When agents return:
- **Cross-check** claims that should agree; flag conflicts rather than averaging them away.
- **Preserve sources:** keep the evidence/citations, not just the rolled-up conclusion.
- **Attribute** which agent found what, so a wrong finding can be traced.
- A synthesis step is itself a role (often Opus). Don't let the orchestrator silently blur
  five strong findings into mush. Take a position.

## The CLAUDE.md / subagent gotcha

- A subagent inherits the project `CLAUDE.md`, your spawn prompt, a git-status snapshot, and
  any skills named in its definition. It does **not** inherit the parent's conversation,
  memory, or system prompt.
- The built-in **Explore** and **Plan** agents **skip** `CLAUDE.md` and git status to stay
  cheap. If a load-bearing rule must hold inside one of those, restate it in the spawn prompt;
  don't assume it carried over. They are also one-shot: they return no agent id and can't be
  resumed.
- No subagent inherits skills unless they're named in its definition. If a subagent needs the
  self-learning protocol, put the relevant slice in its prompt.
- Nesting is bounded: a subagent about five levels deep loses the Agent tool and can't spawn
  further. In practice, keep orchestration to one or two levels.

## Degradation: orchestration without subagents

On claude.ai and other surfaces with no subagent tool, run the same structures as **sequential
persona passes** in one thread:

- Do one role at a time: implement, then (as a fresh-eyed reviewer) critique, then reconcile.
  Council runs the same way: five advisors in turn, then the chair.
- Clear or summarize context between heavy passes to avoid bloat.
- Tradeoff: cheaper (no duplicated context) but slower and with no true isolation; the later
  passes have seen the earlier ones. Name the lens explicitly each pass to fight priming.

## Selection decision tree

1. Is this a consequential, hard-to-reverse **decision** (not a coding task)? Convene the
   **Council**.
2. Is the task trivial, or tightly coupled / same-file? **Solo**.
3. A normal change worth a second pair of eyes? **Pair** (build + independent review +
   verify). This is the default for real changes.
4. A focused multi-step feature? **Strike Team**. A stubborn bug with rival theories?
   **Debug Task Force**.
5. 3+ independent angles?
   - Investigation/research: **Research Pod**.
   - Multi-lens review of a risky change: **Review Board**.
   - Wide solution space: **Best-of-N / Tournament**.
   - Correctness/security-critical: **Red / Blue**.
6. 10+ targets or a multi-module program? **Assembly Line / Program**, handed to a Workflow.

Full definitions and cost/quality profiles: `org-structures.md`.
