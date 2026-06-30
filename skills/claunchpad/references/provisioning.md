# Provisioning reference

How Claunchpad profiles a user and project, selects a tier, deploys the right
infrastructure, and grows that infrastructure when the project outgrows its tier.
Read this when you need to understand what gets written, why a tier was chosen, or
how to run `claunchpad upgrade` non-destructively.

## Contents

- Signals gathered — expertise + project shape
- Tier table — Starter / Standard / Pro
- Deploy steps per tier — which files and hooks each writes
- Tier is a recommendation, not a constraint
- Recommended skills — offer to install high-value plugins/skills
- Re-provisioning (`claunchpad upgrade`)
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
| **Pro** (advanced / large / high-stakes / team) | per-fact `memory/` dir from day 1 | load + harvest-nudge | full contract + Explore/Plan context rules | 4-tier ladder + full 13-structure appendix | presets wired in |

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
| `.claunchpad/handoff.md` | Claude-maintained session-handoff buffer (see below); reloaded by `load-memory` on `compact` |
| Council presets | Claunchpad council configurations wired into `CLAUDE.md` |

Pro ships the graduated `memory/` shape immediately — no migration needed later.
The `load-memory` hook reads both `MEMORY.md` and up to eight of the most-recently-
modified `memory/*.md` files, so the hook works identically at all three tiers.

**The `.claunchpad/handoff.md` buffer** is a Claude-maintained file (not a separate hook script).
`CLAUDE.md` instructs Claude to keep it updated with current task state before long sessions or
context compaction. `load-memory` reloads it on a `compact` source so context survives
compaction. There is no separate "handoff hook" — only `load-memory` and `harvest-nudge` are
registered as hooks.

---

## Tier is a recommendation

Tier selection is a recommendation the user can override. An advanced user on a tiny
throwaway project may prefer Starter's minimal footprint. A beginner on a serious
production project may be steered toward Standard with extra guidance prose in
`CLAUDE.md`. Ask before writing if the recommended tier seems mismatched to what the
user just described.

---

## Re-provisioning (`claunchpad upgrade`)

Run `claunchpad upgrade` when a project has outgrown its current tier.

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
- Creates `.claunchpad/handoff.md` buffer
- Wires council presets

**Proactive suggestion.** Claude may proactively suggest upgrade when it detects the
graduation signal mid-session (the `MEMORY.md` index is too long to scan; the user is
regularly running three or more parallel agents). Execution always requires the user's
explicit go-ahead — `claunchpad upgrade` never runs automatically.

---

## Recommended skills

After the tier is deployed, offer to install a curated set of high-value Claude Code
plugins/skills. The list lives in `templates/recommended-skills.md` (editable; read it — do
not hard-code skill names). Each entry carries its own real install command(s) and prereqs;
the current set uses three different install mechanisms, so run each skill's own command, not a
uniform installer.

**Step 1 — detect surface.** Claude Code (filesystem + a `claude` / `npm` CLI on PATH) vs
claude.ai / the app (no plugin system).

**Step 2 — Claude Code path.** Present the bundle (each skill's name + one-line *why*), then
ask one question:

> Install the recommended skills? **[Y] all · [c] customise · [s] skip**

- **all** — install every entry. **customise** — list the entries and let the user pick a
  subset. **skip** — do nothing, continue.
- For each chosen skill, detect the OS (Windows vs POSIX) and run that skill's matching install
  command from the manifest. Default **user scope** (`~/.claude/`) so the tools are available
  across every project.
- **Check prereqs first.** Before running a skill's command, confirm its required tool exists
  (e.g. `claude`, `git`, `node`/`npm`). If a prereq is missing, **skip that one skill** and
  print its `manual install` line — do not abort the rest.
- Never overwrite existing config destructively; settings.json edits are additive. If a plugin
  is already enabled, report "already present" and skip it.

**Step 3 — activation (always tell the user to restart).** Installing is **never fully silent**:
a newly added plugin/skill does not take effect until Claude Code reloads. After the commands
run, summarize what was installed / skipped / why, then give the user an explicit, unmissable
restart instruction — do not leave it implied:

> ✅ Installed: <list>. **To activate, restart Claude Code now** — quit and reopen it (or run
> `/reload-plugins` if the new plugins are already cached). Accept the trust prompt if asked.

State it plainly every time; the skills will appear missing until the user restarts, so the
restart line is the most important part of the message, not a footnote.

**Step 4 — claude.ai / app path.** There is no plugin system, so **do not attempt to install**.
Instead print the **manual list** from the manifest: each skill's name, source, one-line *why*,
and the exact command to run later in Claude Code. (See also the claude.ai / API path below.)

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
