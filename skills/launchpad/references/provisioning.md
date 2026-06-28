# Provisioning reference

How Launchpad profiles a user and project, selects a tier, deploys the right
infrastructure, and grows that infrastructure when the project outgrows its tier.
Read this when you need to understand what gets written, why a tier was chosen, or
how to run `launchpad upgrade` non-destructively.

## Contents

- Signals gathered — expertise + project shape
- Tier table — Starter / Standard / Pro
- Deploy steps per tier — which files and hooks each writes
- Tier is a recommendation, not a constraint
- Re-provisioning (`launchpad upgrade`)
- claude.ai / API path — skip writes, copy-paste, in-session

---

## Signals gathered

Provisioning collects two kinds of signal before selecting a tier.

### Expertise

Auto-detect first, then confirm with one question.

**Auto signals** (read from the repo, no cost):

- Presence of `.claude/` directory
- Existing `settings.json` with hooks already registered
- A prior `CLAUDE.md` in the project root
- Git history depth (shallow clone vs. long history)
- Presence of CI/test config files (`.github/workflows/`, `pytest.ini`, `vitest.config.*`, etc.)

**Confirming question** (one only):

> How familiar are you with Claude Code?
> **New** · **Comfortable** · **Advanced**

### Project shape

A cheap Explore-agent inspect followed by a short confirmation. Explore agents skip
`CLAUDE.md`, so the inspect is context-neutral and low-cost. Confirm:

- **Size** — one script or file vs. multi-module codebase
- **Nature** — app · library · research-heavy · ops/infra
- **Stakes** — throwaway/experiment vs. production
- **Collaboration** — solo vs. team
- **Agent need** — will this plausibly require parallel research, review, or migration runs?

---

## Tier table

| Tier | Memory | Hooks | Delegation | Orchestration | Councils |
|---|---|---|---|---|---|
| **Starter** (beginner / tiny / throwaway) | single `MEMORY.md` (sectioned log) | `SessionStart` load only | Solo + a one-paragraph Pair note | Solo ↔ Pair | hidden (mention only if asked) |
| **Standard** (real project / comfortable) | `MEMORY.md`, structured to graduate | load + harvest-nudge | full 7-point contract + model routing | 4-tier ladder | mentioned; loaded on request |
| **Pro** (advanced / large / high-stakes / team) | per-fact `memory/` dir from day 1 | load + nudge + handoff | full contract + Explore/Plan context rules | 4-tier ladder + full 13-structure appendix | presets wired in |

---

## Deploy steps per tier

### Starter

Writes four artifacts:

| Artifact | Source |
|---|---|
| `CLAUDE.md` | `templates/CLAUDE.md` |
| `MEMORY.md` | `templates/MEMORY.md` (4-section log) |
| `.claude/settings.json` | `templates/settings.starter.json` |
| `.claude/hooks/load-memory` | `templates/hooks/load-memory` |

`settings.starter.json` registers a single `SessionStart` hook with matcher
`startup|resume|clear|compact` pointing to `.claude/hooks/load-memory`. The
load-memory hook is read-only and safe: it only reads memory and emits
`additionalContext`. No write hooks at Starter — harvest is manual.

### Standard

Everything Starter deploys, plus:

| Artifact | Source |
|---|---|
| `.claude/hooks/harvest-nudge` | `templates/hooks/harvest-nudge` |
| `.claude/settings.json` | `templates/settings.standard.json` |

`settings.standard.json` extends the Starter config by adding a `Stop` hook that
registers `harvest-nudge`. The harvest-nudge hook blocks once per session to remind
Claude to file any new decision/learning/error before stopping; it never writes to
memory itself (user choice, not automation).

### Pro

Everything Standard deploys, plus:

| Artifact | Notes |
|---|---|
| `memory/` directory | Created from day one; `MEMORY.md` is the thin index, not the facts |
| `.launchpad/handoff.md` | Session-handoff buffer; reloaded by `load-memory` on `compact` |
| Council presets | Launchpad council configurations wired into `CLAUDE.md` |

Pro ships the graduated `memory/` shape immediately — no migration needed later.
The `load-memory` hook reads both `MEMORY.md` and up to eight of the most-recently-
modified `memory/*.md` files, so the hook works identically at all three tiers.

---

## Tier is a recommendation

Tier selection is a recommendation the user can override. An advanced user on a tiny
throwaway project may prefer Starter's minimal footprint. A beginner on a serious
production project may be steered toward Standard with extra guidance prose in
`CLAUDE.md`. Ask before writing if the recommended tier seems mismatched to what the
user just described.

---

## Re-provisioning (`launchpad upgrade`)

Run `launchpad upgrade` when a project has outgrown its current tier.

**What upgrade does:**

1. Re-runs the profiling interview (expertise + project shape) against the current state
   of the repo.
2. Identifies which next-tier artifacts are missing.
3. Adds them **additively and non-destructively** — it never clobbers existing memory,
   edits the user has made to `CLAUDE.md`, or overwrites hooks that are already present.

**Starter → Standard** adds:
- `.claude/hooks/harvest-nudge`
- Updates `.claude/settings.json` to register the `Stop` hook (preserves existing
  `SessionStart` config)

**Standard → Pro** adds:
- Migrates `MEMORY.md` → `memory/` per-fact directory (see `references/memory.md` for
  the full graduation procedure — no entries are dropped)
- Creates `.launchpad/handoff.md` buffer
- Wires council presets

**Proactive suggestion.** Claude may proactively suggest upgrade when it detects the
graduation signal mid-session (the `MEMORY.md` index is too long to scan; the user is
regularly running three or more parallel agents). Execution always requires the user's
explicit go-ahead — `launchpad upgrade` never runs automatically.

---

## claude.ai / API path

When running on claude.ai or directly via the Anthropic API there is no filesystem,
no hook infrastructure, and no subagent delegation. Skip all file writes.

**Adapted behavior:**

- Maintain a running in-context memory block organized by the same four categories
  (Decisions / Learnings / Errors / References).
- Update it incrementally as decisions are made or failures resolved.
- At session end, offer the full `MEMORY.md` content (and any new fact files, for
  graduated projects) as copy-paste blocks so the user can persist them to their repo.

The provisioning interview and tier selection still apply in-session — they determine
which guidance and orchestration patterns Claude uses — but no files are written.
