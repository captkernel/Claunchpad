# Delegation: the 7-point contract

How to hand off work to a subagent correctly. A vague delegation is the top cause of
duplicated work, gaps, and wrong-tool use. This reference covers the full contract, the
inheritance rules that change what you must inject, model routing, and the harvest loop
that feeds learnings back into memory.

Pair with `memory.md` (what to inject) and `self-learning.md` (inject/harvest detail).

## Contents

- The 7-point contract
- Grounded inheritance rules
- Model routing
- Harvest loop
- claude.ai / API degradation

---

## The 7-point contract

Every non-trivial delegation must state all seven points explicitly. Subagents do not
inherit the parent's conversation, memory, or system prompt — if it isn't in the
prompt, the agent doesn't know it.

### 1. Objective

One concrete outcome, in one sentence. Not a list of steps — the thing that must be
true when the agent stops.

> _"Return a JSON array of every API endpoint in `src/routes/` that lacks an auth
> middleware, with file path and line number."_

### 2. Scope

What's in, what's out, what not to touch. Prevent accidental scope creep and file
edits the orchestrator didn't authorize.

> _"Read `src/routes/` only. Do not edit files. Do not open test files."_

### 3. Context

The relevant memory facts pasted in directly, plus file paths and any error text the
agent needs. **Memory is not injected automatically** — inject what matters. A
general-purpose subagent can `Read` `MEMORY.md` or `memory/` fact files if you direct it
to, but it will not do so unprompted. Explore/Plan agents skip `CLAUDE.md` entirely and
cannot be relied on to read any memory files; give them everything in the spawn prompt.

Pull the 1–3 most relevant entries from `MEMORY.md` / `memory/` and paste them under
a heading like:

```
## What we already know (obey this)
- ERROR: <symptom> -> <fix/rule>
- DECISION: <constraint that bounds your work>
- LEARNING: <technique stated as a rule>
```

Include: the paths the agent must open, the exact error text if debugging, the
decision that ruled out an approach the agent might otherwise try.

### 4. Output format

Exactly what to return — a JSON object, a bullet list, a diff, a verdict — so the
result composes without rework. Unspecified format → the agent invents one and the
orchestrator has to parse it.

### 5. Tool guidance

Which tools to prefer and which to avoid. Remind the agent to fire independent calls
in parallel (the Agent tool, multiple Reads, multiple searches) rather than
sequentially when the sub-tasks don't share state.

### 6. Stop criteria

When the task is done. Prevents runaway work and unnecessary continuation past the
objective.

> _"Stop as soon as you have read every file in `src/routes/` once. Do not iterate."_

### 7. Return-learnings slot

End every delegation prompt with a required return slot so you can harvest durable
knowledge back into memory:

```
Finish your response with a NEW-KNOWLEDGE block (or "none"):
- FAILURE: <symptom> | CAUSE: <root cause> | FIX: <what worked>
- LEARNING: <durable technique or finding, as a reusable rule>
```

This is the **Return-learnings** anchor: learnings from delegation are filed into
`MEMORY.md` (or a `memory/` fact file) under the matching type — `error`, `learning`,
`decision`, or `reference` — and never discarded. See `self-learning.md` for the full
inject-and-harvest loop.

---

## Grounded inheritance rules

What a subagent inherits determines what you must inject. Getting this wrong is the
most common delegation mistake.

### General-purpose subagents (most delegations)

A general-purpose subagent inherits:
- The project `CLAUDE.md` (including the `LAUNCHPAD-MEMORY-POINTER` block and working
  rules)
- Your spawn prompt
- A git-status snapshot
- Any skills named in its definition

**Consequence: do not re-explain the stack, conventions, or general working rules.**
They are already in `CLAUDE.md`. Inject only the task-specific objective, scope,
context (memory facts + paths), output format, tool guidance, stop criteria, and the
Return-learnings slot.

### Explore and Plan agents — the critical exception

**Explore** and **Plan** agents skip `CLAUDE.md` entirely. They are cheap precisely
because they are context-blind, and the standing memory pointer never reaches them.

This means:
- They do not know the project's stack, conventions, or working rules.
- They do not know what already failed (they will happily repeat it).
- They do not see the `LAUNCHPAD-MEMORY-POINTER` instruction to read memory files.

**Rule:** if any project constraint, known error, or architectural decision must hold
inside an Explore or Plan agent, restate it in the spawn prompt. Never assume it
carried over from `CLAUDE.md`.

Explore and Plan are best for lightweight research scans where context-blindness is
acceptable. If the task is context-sensitive, use a general-purpose subagent instead.

### No subagent inherits conversation or parent memory

No subagent — general-purpose or Explore/Plan — inherits the parent's conversation
history, memory stores, or system prompt beyond `CLAUDE.md`. Context injection is
non-optional for must-haves.

### Nesting limit

Nesting is bounded: a subagent roughly five levels deep loses the Agent tool and
cannot spawn further. Keep orchestration to one or two levels in practice.

---

## Model routing

Match the model to the role. This is the single biggest cost lever in a multi-agent
run.

| Role | Model | Characteristic work |
|---|---|---|
| Mechanical / high-volume | **Haiku** | Formatting, log triage, simple lookups, classification |
| Implementation / search / review | **Sonnet** | Writing code, searching a codebase, reviewing a change |
| Hard reasoning / synthesis / judging | **Opus** | Architecture decisions, combining many results, adversarial review, the trickiest bugs |

Cheap models on cheap roles is the single biggest saving in a multi-agent run.
Defaulting everything to Opus or Sonnet when Haiku would suffice multiplies cost for
no quality gain.

---

## Harvest loop

The Return-learnings slot is not courtesy — it closes the learning loop:

1. **Agent returns** its result plus a NEW-KNOWLEDGE block.
2. **Orchestrator harvests**: each item is filed into `MEMORY.md` (or a `memory/` fact
   file) under the matching type —
   - `FAILURE` / `CAUSE` / `FIX` → `error`-type entry
   - `LEARNING` → `learning`-type entry
   - Architectural choices → `decision`-type entry
3. **Next delegation selects** those entries and injects them; see `self-learning.md`.

The `harvest-nudge` Stop hook backstops a forgotten harvest: it blocks once per
session to prompt you to write any durable learning before stopping. It never writes
to memory itself — that is always a deliberate decision.

For parallel fan-outs, harvest from every agent before appending; several agents often
rediscover the same fact and deduplication happens at this step.

---

## claude.ai / API degradation

No subagents, no filesystem, no hooks. Delegation collapses to sequential role passes
in a single thread:

- Do one role at a time in the main thread: implement, then (as a fresh-eyed reviewer)
  critique, then reconcile.
- Maintain an in-context knowledge block between passes — the same NEW-KNOWLEDGE
  format — and update it incrementally.
- The harvest step becomes: at the end of the session, offer the updated memory stores
  as copy-paste blocks so the user can persist them.

The 7-point contract still applies to each role pass: state the objective, scope, and
stop criteria explicitly before switching roles, so the later pass doesn't drift into
the earlier one's assumptions.
