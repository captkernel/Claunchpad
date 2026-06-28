# Launchpad as a Project Operating System — Design Specification

**Date:** 2026-06-27
**Status:** Design (awaiting user review)
**Supersedes:** `2026-06-27-adaptive-onboarding-harness-design.md` (the "phase-unlock" draft — abandoned; see Design Principles for why)

---

## 1. Problem Statement

Launchpad should make a new-to-Claude-Code user's project run the way an expert's does: durable memory that survives `/clear` and compaction and reaches subagents, disciplined delegation, and orchestration that scales only as far as the task earns. The same skill must also serve advanced users without dumbing things down.

The hard part is the spread of users. A beginner drowns in a five-file scaffold and a thirteen-structure catalog; an advanced user is insulted by training wheels. The skill must **gather the infrastructure a given user and project actually need and deploy exactly that** — no more, no less — and let a project add infrastructure as it grows.

This spec defines Launchpad as a **project operating system for Claude Code**: a provisioning layer that profiles the user and project, three pillars (Memory, Delegation, Orchestration) deployed in tiers, a hook layer that automates what otherwise relies on discipline, and councils repositioned as one application on top.

---

## 2. Design Principles

1. **Honest mechanisms only.** The earlier draft invented "phases" the user progresses through — but there is no runtime that tracks a user's phase. Tiers are chosen at **install time** by an explicit provisioning step, and changed by an explicit **re-provision** action. No hidden state machine.
2. **Deploy what the work earns.** The cheapest structure, the fewest files, the lightest automation that clears the quality bar. Power is spent on purpose.
3. **Memory is the centerpiece.** Everything else exists to capture, preserve, and route what the project learns.
4. **Grounded in verified Claude Code mechanics** (Section 12), not assumptions.
5. **Progressive disclosure is free and already exists.** A skill's reference files load only when Claude opens them. Structure the skill so the right reference opens at the right moment; don't reinvent the mechanism.

---

## 3. Architecture Overview

```
                    ┌─────────────────────────────┐
                    │   PROVISIONING INTERVIEW     │  (bootstrap front door)
                    │  profile user + project  →   │
                    │  pick tier  →  deploy infra  │
                    └──────────────┬──────────────┘
                                   │ deploys a subset of:
        ┌──────────────┬──────────┴───────┬──────────────┐
        ▼              ▼                   ▼              ▼
   ┌─────────┐   ┌───────────┐      ┌────────────┐  ┌─────────┐
   │ MEMORY  │   │DELEGATION │      │ORCHESTRATE │  │  HOOKS  │
   │(pillar1)│   │ (pillar2) │      │ (pillar3)  │  │ (layer) │
   └─────────┘   └───────────┘      └────────────┘  └─────────┘
        └───────────────── COUNCILS (application, as-is) ──────┘
```

Build scope (confirmed): **the full OS in one pass, councils included but kept in current v1 form** (repositioned, not internally redesigned). The v2 feasibility-council redesign stays parked.

---

## 4. The Provisioning Layer

The bootstrap's job changes from "write five files" to "profile, then provision."

### 4.1 Signals gathered

**Expertise** — auto-detect what is cheap, then confirm with one question:
- Auto signals: presence of `.claude/`, an existing `settings.json` with hooks, a prior `CLAUDE.md`, git history depth, presence of CI/test config.
- Confirming question: *New to Claude Code · Comfortable · Advanced.*

**Project shape** — inspect the repo with a cheap Explore agent (it skips CLAUDE.md, so it's cost-neutral), then confirm:
- Size: one script/file vs. multi-module.
- Nature: app · library · research-heavy · ops/infra.
- Stakes: throwaway/experiment vs. production.
- Collaboration: solo vs. team.
- Agent need: will this plausibly need parallel research/review/migration?

### 4.2 Tiers (what gets deployed)

| Tier | Memory | Hooks | Delegation | Orchestration | Councils |
|---|---|---|---|---|---|
| **Starter** (beginner / tiny / throwaway) | single `MEMORY.md` (sectioned log) | `SessionStart` **load only** | Solo + a one-paragraph Pair note | Solo ↔ Pair | hidden (mention only if asked) |
| **Standard** (real project / comfortable) | `MEMORY.md`, structured to graduate | load **+ harvest-nudge** | full 7-point contract + model routing | 4-tier ladder | mentioned; loaded on request |
| **Pro** (advanced / large / high-stakes / team) | per-fact `memory/` dir from day 1 | load + nudge + handoff | full contract + Explore/Plan context rules | 4-tier ladder + full 13-structure appendix | presets wired in |

Tier selection is a **recommendation the user can override** — an advanced user on a tiny project may want Starter; a beginner on a serious project may be steered to Standard with extra guidance.

### 4.3 Re-provisioning (the honest "grows with you")

A `launchpad upgrade` flow re-runs profiling and **adds** the next tier's infrastructure when a project outgrows its tier:
- Migrate `MEMORY.md` → `memory/` per-fact dir (Section 5.3).
- Add the harvest-nudge hook; add the handoff hook.
- Surface the orchestration appendix.

Upgrade is **additive and non-destructive** — it never clobbers existing memory or user edits. Triggers are observable (the index is too long to scan; the user starts running 3+ agents regularly) and surfaced as a suggestion, never forced.

---

## 5. Pillar 1 — Memory

### 5.1 Hybrid model

- **Tiny (Starter):** one `MEMORY.md` with four sections — **Decisions / Learnings / Errors / References.**
- **Graduated (Standard→Pro):** a `memory/` directory, **one fact per file** with frontmatter; `MEMORY.md` becomes a thin one-line-per-fact index with `[[wikilinks]]`. This mirrors the model this very workspace runs.

### 5.2 Per-fact file format (graduated)

```markdown
---
name: <kebab-case-slug>
description: <one-line summary — used to judge relevance on recall>
metadata:
  type: decision | learning | error | reference
  date: YYYY-MM-DD
---

<the fact. For errors: the failure, then **Fix:**. Link related facts with [[slug]].>
```

`MEMORY.md` index line: `- [Title](memory/<slug>.md) — one-line hook`.

### 5.3 Graduation procedure

When the single-file index gets hard to scan, Claude (on `launchpad upgrade`, or when it notices the signal) migrates: each existing section entry becomes a per-fact file with inferred frontmatter; `MEMORY.md` is rewritten as the index. Non-destructive: the old content is preserved as files, nothing is dropped.

### 5.4 Automation via hooks (see Section 8)

- **`SessionStart` (matchers: `startup`, `resume`, `clear`, `compact`)** reads the index (and, in Pro, the most-recently-touched fact files) and injects them via `hookSpecificOutput.additionalContext`. **This is the reliability win:** memory loads every session — including after compaction — without depending on Claude remembering to read it.
- **`Stop` / `SubagentStop`** (Standard+) nudges: reminds Claude to harvest any new decision/learning/error before the turn ends. **It does not auto-write** (user choice: "load auto, harvest nudge" — no surprise writes).

### 5.5 Subagent memory access ("both, situationally")

Subagents inherit the project `CLAUDE.md` and can use `Read` (verified, Section 12). So:
- **Standing pointer (free):** `CLAUDE.md` carries a block — *"Project memory lives in `MEMORY.md` / `memory/`. If your task needs prior decisions, learnings, or known errors, read the index first."* Inherited by every general-purpose subagent at no token cost.
- **Inline injection (guaranteed):** the parent pastes the critical 1–3 facts directly into the delegation prompt for must-haves.
- **Caveat:** Explore/Plan subagents skip CLAUDE.md, so the pointer does **not** reach them — they require full inline injection (Section 6.2).

---

## 6. Pillar 2 — Delegation

### 6.1 The 7-point contract

Every non-trivial delegation states: (1) **Objective** — one concrete outcome; (2) **Scope** — in/out/do-not-touch; (3) **Context** — the relevant memory facts pasted in, plus file paths and error text; (4) **Output format** — exactly what to return; (5) **Tool guidance** — preferred tools, parallel calls where independent; (6) **Stop criteria**; (7) **Return-learnings slot** — end with any new failure+fix or durable learning to harvest.

### 6.2 Grounded inheritance rules (the sharp part)

- **General-purpose subagents inherit CLAUDE.md** → do **not** re-explain the stack/conventions; inject only task-specific scope + memory.
- **Explore/Plan agents skip CLAUDE.md** → they are cheap *because* they are context-blind. Use them for research/scans, but **inject everything they need**; never assume they know the stack.
- **No subagent inherits conversation history or parent memory** beyond CLAUDE.md → context injection is non-negotiable for must-haves.

### 6.3 Model routing

Haiku for mechanical/high-volume/classification; Sonnet for most implementation, search, review; Opus for hard reasoning, synthesis, adversarial judging, the trickiest bugs. Cheap models on cheap roles is the single biggest multi-agent saving.

### 6.4 Harvest

The agent's return-learnings slot feeds back into memory: the parent files each item into the right section/fact-file. The Stop-nudge hook backstops a forgotten harvest.

---

## 7. Pillar 3 — Orchestration

### 7.1 The 4-tier front door

1. **Solo** (default) — trivial, or tightly-coupled/same-file work.
2. **Pair** — build + independent review + verify. The default for any change worth reviewing.
3. **Parallel fan-out** — 3+ genuinely independent angles that don't share state or edit the same files (research pod / review board / best-of-N).
4. **Workflow** — 10+ uniform targets or a multi-module program; hand to a deterministic script.

One observable escalation trigger per step; de-escalate the moment a cheaper structure would finish correctly.

### 7.2 The efficiency governor

Multi-agent multiplies token cost (~15x for large fan-outs); it helps on breadth-first independent work and hurts on coupled work (shared context, same-file edits → lost work). The governor: pick the cheapest structure that clears the bar; escalate only on a fired trigger; record de-escalations as learnings.

### 7.3 The appendix (Pro)

The full 13-structure catalog (Strike Team, Debug Task Force, Red/Blue, Assembly Line, Program, etc.) survives as a reference loaded **only** when an advanced user wants it. It is not part of the beginner/Standard front door.

---

## 8. The Hook Layer

Behavior level (confirmed): **load auto + harvest nudge.** No surprise writes.

### 8.1 Hooks deployed

| Hook | Event | Tier | Responsibility | Mechanism |
|---|---|---|---|---|
| `load-memory` | `SessionStart` (`startup`, `resume`, `clear`, `compact`) | all | Read `MEMORY.md` index (+ recent facts in Pro), emit as context | `hookSpecificOutput.additionalContext` |
| `harvest-nudge` | `Stop` / `SubagentStop` | Standard, Pro | Remind Claude to file new decisions/learnings/errors before ending | nudge text; **never auto-writes** |
| `handoff` | Stop + `SessionStart(compact)` fallback | Pro | Persist a short session-handoff buffer so context survives compaction | writes a `.launchpad/handoff.md` buffer; reloaded by `load-memory` on `compact` |

### 8.2 settings.json shape (verified)

```json
{
  "hooks": {
    "SessionStart": [
      { "matcher": "startup|resume|clear|compact",
        "hooks": [{ "type": "command", "command": ".claude/hooks/load-memory", "timeout": 15 }] }
    ],
    "Stop": [
      { "matcher": "*",
        "hooks": [{ "type": "command", "command": ".claude/hooks/harvest-nudge", "timeout": 10 }] }
    ]
  }
}
```

Hooks live in `.claude/settings.json` (project) with scripts under `.claude/hooks/`. Precedence: Managed > Local > Project > User.

### 8.3 PreCompact caveat

A dedicated `PreCompact` event could not be confirmed during grounding. The handoff design therefore relies on **`Stop` (to write the buffer) + `SessionStart(compact)` (to reload it after compaction)** — both verified. If a true `PreCompact` hook is confirmed at implementation time, it becomes a cleaner write trigger; until then it is not load-bearing.

### 8.4 Portability

Hooks are Claude Code only. On claude.ai/API the bootstrap skips hook installation and falls back to instruction-only memory (Claude is told to read/write the index in-session), plus copy-paste template blocks.

---

## 9. Councils (application, repositioned as-is)

Councils are reframed as one **application** built on the OS (memory for the framing + findings, orchestration for parallel lenses), not a co-headline. Their internals are **unchanged** in this build:
- **Decision Council** (`references/council.md`) — adversarial pressure-test of one irreversible choice.
- **Feasibility Council** (`references/feasibility-council.md`) — four-lens project-viability review.

Only their **positioning** changes: they are surfaced through the orchestration front door (Pro tier wires presets in; Standard mentions them on request; Starter hides them). The v2 feasibility redesign (premortem, independent scoring, new lenses) remains parked for a later effort and is explicitly out of scope here.

---

## 10. File Hierarchy

### 10.1 Skill (shipped)

```
skills/launchpad/
  SKILL.md                         # lean front door: provisioning + 3 pillars overview + routing
  references/
    provisioning.md                # the interview, signals, tier table, re-provision/graduation
    memory.md                      # hybrid model, frontmatter, graduation, hook wiring, subagent access
    delegation.md                  # 7-point contract, inheritance rules, model routing, harvest
    orchestration.md               # 4-tier ladder + efficiency governor (front door)
    org-structures.md              # full 13-structure catalog (Pro appendix)
    self-learning.md               # inject/harvest protocol detail
    council.md                     # decision council (as-is)
    feasibility-council.md         # feasibility council (as-is)
  templates/
    CLAUDE.md                      # includes the subagent memory-pointer block
    MEMORY.md                      # sectioned log (Starter) / index (graduated)
    memory-fact.md                 # per-fact file template (graduated)
    settings.json                  # hook registrations per tier
    hooks/
      load-memory                  # SessionStart loader
      harvest-nudge                # Stop/SubagentStop nudge
      handoff                      # session buffer
```

### 10.2 Project artifacts (deployed by tier)

```
project/
  CLAUDE.md                        # all tiers
  MEMORY.md                        # all tiers (log → index on graduation)
  memory/                          # Pro from day 1; others after graduation
  .launchpad/handoff.md            # Pro (handoff buffer)
  .claude/
    settings.json                  # tier-appropriate hooks
    hooks/                         # the deployed hook scripts
```

---

## 11. claude.ai / API Degradation

No filesystem, no hooks, no subagents. The skill: skips all writes; applies the behaviors in-session; offers `CLAUDE.md` / `MEMORY.md` as copy-paste blocks; replaces hook-loaded memory with an instruction to maintain an in-context memory block; replaces subagent delegation with sequential in-thread "role passes." Councils run as sequential lens passes in one thread.

---

## 12. Verified Claude Code Mechanics (grounding)

| Claim | Verdict | Key field / note |
|---|---|---|
| Subagents inherit project `CLAUDE.md` | TRUE | except Explore/Plan |
| Subagents can `Read` arbitrary project files if instructed | TRUE | default tool access |
| Subagents inherit conversation history / parent system prompt | FALSE | fresh context; own prompt |
| Explore/Plan skip CLAUDE.md | TRUE | for cheap research |
| `SessionStart` can inject context | TRUE | `hookSpecificOutput.additionalContext`; matchers `startup\|resume\|clear\|compact` |
| `Stop`/`SubagentStop` can run a script | TRUE | can nudge or block |
| `PreCompact` dedicated event | UNCONFIRMED | use `Stop` + `SessionStart(compact)` fallback |
| `PostToolUse`/`PreToolUse` matchers + block/modify | TRUE | not used in core scope |
| Skills load reference files on-demand | TRUE | plain markdown links; free until opened |
| SKILL.md `description` length | ~1024–1536 chars | keep tight; current is 543 |
| Per-skill token budget | ~5k/skill, ~25k combined | keep SKILL.md < ~500 lines |

---

## 13. What Changes From v1

- **Add** the provisioning layer (interview → tier → deploy; re-provision/graduate).
- **Add** the hook layer (load-memory, harvest-nudge, handoff) + `settings.json` templates.
- **Change** memory from three flat logs → hybrid (sectioned log → per-fact files + index + wikilinks).
- **Add** mechanics-grounded delegation rules (CLAUDE.md inheritance lets you stop re-explaining the stack; Explore/Plan context-blindness requires full injection).
- **Shrink** the orchestration front door from 13 structures → 4-tier ladder; 13-catalog becomes a Pro appendix.
- **Reposition** councils as an application (internals unchanged).
- **Delete** the abandoned phase-unlock draft.

---

## 14. Success Criteria

- A beginner runs Launchpad and gets two files, one load-only hook, and a clear next step — no catalog, no ceremony.
- An advanced user on a serious project gets per-fact memory, the full hook layer, the orchestration catalog, and council presets — without being asked beginner questions.
- Memory survives `/clear` and compaction and reaches general-purpose subagents (via pointer) and Explore/Plan agents (via injection).
- A project can run `launchpad upgrade` and gain the next tier's infra non-destructively.
- The same delegation contract a user writes for their first Pair review works unchanged for a 5-agent fan-out.

---

## 15. Risks & Mitigations

- **Provisioning misjudges the user/project** → tier is always an overridable recommendation; re-provision is cheap and additive.
- **`PreCompact` assumption wrong** → already mitigated; handoff uses only verified events.
- **Harvest-nudge ignored** → it is a backstop, not the primary path; the contract's return-learnings slot is the primary harvest.
- **SKILL.md bloat** → enforce the < ~500-line budget; push detail into on-demand references.
- **Hook scripts fail on Windows shells** → ship POSIX-sh scripts runnable under the Bash tool / Git Bash, and document the dependency; keep instruction-only fallback.

---

## 16. Resolved Decisions (approved 2026-06-28)

1. **Provisioning interaction:** auto-detect what's cheap + **one** confirming expertise question + a short project-shape confirmation. Kept as designed.
2. **`launchpad upgrade` surface:** Claude **may proactively suggest** re-provisioning when it detects the graduation signal mid-session, but **execution requires the user's go-ahead** — never auto-migrates.
3. **Starter hooks:** Starter ships the **single load-only `SessionStart` hook** (it is the headline benefit — memory surviving `/clear` and compaction — and is read-only/safe; setup is one file). Pure instruction-only remains the claude.ai/API fallback only.
4. **Windows shells:** hook scripts target **POSIX sh** (runnable via the Bash tool / Git Bash), with the instruction-only path as fallback where sh is unavailable.
