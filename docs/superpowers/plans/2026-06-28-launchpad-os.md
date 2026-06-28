# Launchpad Project-OS Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the `launchpad` skill into a project operating system for Claude Code — a provisioning layer that profiles the user/project and deploys tiered infrastructure (memory, delegation, orchestration, hooks), with councils repositioned as-is.

**Architecture:** A lean `SKILL.md` front door routes to on-demand references. A bootstrap "Provisioning Interview" picks a tier (Starter/Standard/Pro) and installs the matching subset: a hybrid memory store (single `MEMORY.md` → per-fact `memory/` dir), POSIX-sh hooks (`load-memory` on SessionStart, `harvest-nudge` on Stop), a 7-point delegation contract, and a 4-tier orchestration ladder with the 13-structure catalog as a Pro appendix.

**Tech Stack:** Markdown (skill + references + templates), POSIX sh (hook scripts + validation harness), JSON (Claude Code `settings.json`). No build system; the "test suite" is `tools/validate.sh`, which asserts structural invariants and runs behavioral tests on the hook scripts.

## Global Constraints

- **Target surface:** Claude Code first; claude.ai/API gets an instruction-only copy-paste fallback (no hooks, no files). (spec §2, §11)
- **Hook behavior:** load auto + harvest nudge only. **No surprise auto-writes to memory.** (spec §8)
- **Hook scripts:** POSIX sh, runnable under Git Bash / the Bash tool; **no python/node dependency** in hook scripts (escaping done in pure sh/awk/sed). (spec §16.4)
- **SKILL.md budget:** keep under ~500 lines; `description` frontmatter ≤ 1024 chars. (spec §12)
- **Memory frontmatter type vocabulary:** exactly `decision | learning | error | reference`. (spec §5.2)
- **Non-destructive:** provisioning and `launchpad upgrade` never clobber existing user files or memory. (spec §4.3)
- **Councils unchanged:** `references/council.md` and `references/feasibility-council.md` keep their current content; only positioning changes. (spec §9)
- **git:** the repo lives at `launchpad/.git`. All `git` commands in this plan run with that as the working directory. The outer `C:\Claude\Toolkits` is not a git repo.
- **Paths:** all paths below are relative to `C:\Claude\Toolkits\launchpad\` unless absolute.

---

## File Structure

**Create:**
- `skills/launchpad/tools/validate.sh` — structural + behavioral test harness (the test suite)
- `skills/launchpad/templates/hooks/load-memory` — SessionStart memory loader (POSIX sh)
- `skills/launchpad/templates/hooks/harvest-nudge` — Stop harvest reminder (POSIX sh)
- `skills/launchpad/templates/settings.starter.json` — SessionStart hook only
- `skills/launchpad/templates/settings.standard.json` — SessionStart + Stop hooks
- `skills/launchpad/templates/memory-fact.md` — per-fact memory file template (graduated)
- `skills/launchpad/references/provisioning.md` — the interview, signals, tiers, re-provision/graduation
- `skills/launchpad/references/memory.md` — hybrid model, frontmatter, graduation, hook wiring, subagent access
- `skills/launchpad/references/delegation.md` — 7-point contract, inheritance rules, model routing, harvest

**Modify:**
- `skills/launchpad/templates/MEMORY.md` — rewrite to 4-section Starter log + graduation note
- `skills/launchpad/templates/CLAUDE.md` — add subagent memory-pointer block; point at hybrid memory; tier note
- `skills/launchpad/references/orchestration.md` — 4-tier front door + governor + appendix pointer
- `skills/launchpad/references/self-learning.md` — hybrid memory + hook-aware inject/harvest
- `skills/launchpad/references/org-structures.md` — add "Pro appendix" header note
- `skills/launchpad/SKILL.md` — rewrite front door: provisioning + 3 pillars + routing + reference map

**Delete:**
- `skills/launchpad/templates/ERRORS.md` — unified into MEMORY.md sections / memory-fact files
- `skills/launchpad/templates/LEARNINGS.md` — unified into MEMORY.md sections / memory-fact files

**Keep untouched:**
- `skills/launchpad/references/council.md`, `skills/launchpad/references/feasibility-council.md` (content frozen)
- `skills/launchpad/templates/anti-style.md` (voice deprioritized, out of scope)

---

## Implementation Note on Markdown Tasks

Hook scripts, `settings.json`, `validate.sh`, and templated files with strict structure get **complete verbatim content** below. The large reference markdowns (`provisioning.md`, `memory.md`, `delegation.md`, etc.) get a **content specification**: the exact required sections, the must-include rules/tables (copied from the named spec section), and the exact `validate.sh` assertions that gate them. The implementer writes the prose to satisfy those assertions, expanding from the cited spec section. This avoids duplicating the entire spec as prose while leaving zero ambiguity about what each file must contain.

---

### Task 1: Validation harness

**Files:**
- Create: `skills/launchpad/tools/validate.sh`

**Interfaces:**
- Produces: a CLI `validate.sh [skill|refs|memory|hooks|all]` (default `all`). Exit 0 = all checks in the group pass; exit 1 = at least one failed. Prints `PASS`/`FAIL` per check. Later tasks invoke specific groups.

- [ ] **Step 1: Write the harness (this is the failing test suite)**

Create `skills/launchpad/tools/validate.sh`:

```sh
#!/bin/sh
# Launchpad structural + behavioral test harness.
# Usage: validate.sh [skill|refs|memory|hooks|all]
set -u
HERE="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"   # -> skills/launchpad
GROUP="${1:-all}"
FAILS=0

ok()   { printf 'PASS  %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n' "$1"; FAILS=$((FAILS+1)); }
have() { [ -f "$HERE/$1" ]; }

assert_file()      { if have "$1"; then ok "exists: $1"; else bad "missing: $1"; fi; }
assert_absent()    { if have "$1"; then bad "should be deleted: $1"; else ok "absent: $1"; fi; }
assert_contains()  { # file substring label
  if have "$1" && grep -qF -- "$2" "$HERE/$1"; then ok "$3"; else bad "$3"; fi; }
assert_maxlines()  { # file n label
  if have "$1"; then n=$(wc -l < "$HERE/$1"); if [ "$n" -le "$2" ]; then ok "$3 ($n<=$2)"; else bad "$3 ($n>$2)"; fi
  else bad "$3 (missing)"; fi; }

json_ok() { # stdin -> 0 if valid-ish JSON. Tries python3/node, falls back to brace+quote check.
  data="$(cat)"
  if command -v python3 >/dev/null 2>&1; then printf '%s' "$data" | python3 -c 'import json,sys;json.load(sys.stdin)' 2>/dev/null; return $?; fi
  if command -v node >/dev/null 2>&1; then printf '%s' "$data" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{JSON.parse(s)})' 2>/dev/null; return $?; fi
  printf '%s' "$data" | grep -q '{' && printf '%s' "$data" | grep -q '}'
}

check_skill() {
  assert_file SKILL.md
  # description frontmatter <= 1024 chars (extract between 'description:' and next top-level key)
  if have SKILL.md; then
    desc=$(awk '/^description:/{f=1} f{print} /^---/{if(f)exit}' "$HERE/SKILL.md" | wc -c)
    if [ "$desc" -le 1024 ]; then ok "SKILL.md description <=1024 ($desc)"; else bad "SKILL.md description >1024 ($desc)"; fi
  fi
  assert_maxlines SKILL.md 500 "SKILL.md <=500 lines"
  # every references/*.md named in SKILL.md must exist
  if have SKILL.md; then
    for r in $(grep -oE 'references/[a-z-]+\.md' "$HERE/SKILL.md" | sort -u); do
      if [ -f "$HERE/$r" ]; then ok "linked ref exists: $r"; else bad "linked ref missing: $r"; fi
    done
  fi
}

check_refs() {
  for f in provisioning memory delegation orchestration self-learning org-structures council feasibility-council; do
    assert_file "references/$f.md"
  done
  assert_contains references/provisioning.md "Starter" "provisioning.md has tier table (Starter)"
  assert_contains references/provisioning.md "Pro" "provisioning.md has tier table (Pro)"
  assert_contains references/delegation.md "Explore" "delegation.md covers Explore/Plan inheritance"
  assert_contains references/orchestration.md "Solo" "orchestration.md has 4-tier ladder (Solo)"
  assert_contains references/orchestration.md "org-structures.md" "orchestration.md points to appendix"
  assert_contains references/org-structures.md "appendix" "org-structures.md marked as appendix"
}

check_memory() {
  assert_file templates/MEMORY.md
  for s in "## Decisions" "## Learnings" "## Errors" "## References"; do
    assert_contains templates/MEMORY.md "$s" "MEMORY.md has section: $s"
  done
  assert_file templates/memory-fact.md
  for k in "name:" "description:" "metadata:" "type:"; do
    assert_contains templates/memory-fact.md "$k" "memory-fact.md frontmatter has: $k"
  done
  assert_contains templates/CLAUDE.md "LAUNCHPAD-MEMORY-POINTER" "CLAUDE.md has subagent memory-pointer block"
  assert_absent templates/ERRORS.md
  assert_absent templates/LEARNINGS.md
}

check_hooks() {
  assert_file templates/hooks/load-memory
  assert_file templates/hooks/harvest-nudge
  assert_file templates/settings.starter.json
  assert_file templates/settings.standard.json
  if have templates/settings.starter.json; then
    if json_ok < "$HERE/templates/settings.starter.json"; then ok "settings.starter.json valid JSON"; else bad "settings.starter.json invalid JSON"; fi
  fi
  if have templates/settings.standard.json; then
    if json_ok < "$HERE/templates/settings.standard.json"; then ok "settings.standard.json valid JSON"; else bad "settings.standard.json invalid JSON"; fi
    assert_contains templates/settings.standard.json "harvest-nudge" "standard settings registers harvest-nudge"
  fi
  # behavioral: load-memory emits additionalContext for a fixture MEMORY.md
  if have templates/hooks/load-memory; then
    tmp="$(mktemp -d)"; printf '# MEMORY\n- decision: use sqlite\n' > "$tmp/MEMORY.md"
    out="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/load-memory" </dev/null 2>/dev/null)"
    if printf '%s' "$out" | grep -q 'additionalContext' && printf '%s' "$out" | json_ok; then ok "load-memory emits valid additionalContext JSON"; else bad "load-memory output wrong: $out"; fi
    rm -rf "$tmp"
  fi
  # behavioral: harvest-nudge blocks once, then silent
  if have templates/hooks/harvest-nudge; then
    tmp="$(mktemp -d)"
    o1="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/harvest-nudge" </dev/null 2>/dev/null)"
    o2="$(CLAUDE_PROJECT_DIR="$tmp" sh "$HERE/templates/hooks/harvest-nudge" </dev/null 2>/dev/null)"
    if printf '%s' "$o1" | grep -q '"decision"[[:space:]]*:[[:space:]]*"block"'; then ok "harvest-nudge blocks on first run"; else bad "harvest-nudge first run not blocking: $o1"; fi
    if [ -z "$(printf '%s' "$o2" | tr -d '[:space:]')" ]; then ok "harvest-nudge silent on second run"; else bad "harvest-nudge second run not silent: $o2"; fi
    rm -rf "$tmp"
  fi
}

case "$GROUP" in
  skill)  check_skill ;;
  refs)   check_refs ;;
  memory) check_memory ;;
  hooks)  check_hooks ;;
  all)    check_skill; check_refs; check_memory; check_hooks ;;
  *) echo "unknown group: $GROUP"; exit 2 ;;
esac

echo "----"
if [ "$FAILS" -eq 0 ]; then echo "ALL PASS ($GROUP)"; exit 0; else echo "$FAILS FAILED ($GROUP)"; exit 1; fi
```

- [ ] **Step 2: Run it to verify it fails (nothing built yet)**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh all`
Expected: many `FAIL` lines and `N FAILED (all)`, exit 1. (The harness itself works; the artifacts don't exist yet.)

- [ ] **Step 3: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/tools/validate.sh
git commit -m "test: add launchpad validation harness"
```

---

### Task 2: load-memory hook

**Files:**
- Create: `skills/launchpad/templates/hooks/load-memory`
- Test: `skills/launchpad/tools/validate.sh hooks` (load-memory checks)

**Interfaces:**
- Consumes: stdin hook JSON (may contain `"source"`); env `CLAUDE_PROJECT_DIR` (defaults to `.`).
- Produces: on stdout, either nothing (no memory) or `{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"<escaped>"}}`. Side effect: clears `.launchpad/.harvest-nudged` on a new session source.

- [ ] **Step 1: Run the failing behavioral test**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh hooks`
Expected: `FAIL  missing: templates/hooks/load-memory` (among others).

- [ ] **Step 2: Write the script**

Create `skills/launchpad/templates/hooks/load-memory`:

```sh
#!/bin/sh
# SessionStart hook: load project memory and emit it as additionalContext.
# Pure POSIX sh; no python/node dependency.
set -u

ROOT="${CLAUDE_PROJECT_DIR:-.}"
MEM="$ROOT/MEMORY.md"
MEMDIR="$ROOT/memory"
HANDOFF="$ROOT/.launchpad/handoff.md"
NUDGE_FLAG="$ROOT/.launchpad/.harvest-nudged"

input="$(cat 2>/dev/null || true)"
source="$(printf '%s' "$input" | sed -n 's/.*"source"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')"

# New session: reset the per-session harvest-nudge flag.
case "$source" in
  startup|clear|resume|"") rm -f "$NUDGE_FLAG" 2>/dev/null || true ;;
esac

content=""
if [ -f "$MEM" ]; then
  content="$content
=== Project memory index (MEMORY.md) ===
$(cat "$MEM")"
fi

if [ -d "$MEMDIR" ]; then
  for f in $(ls -1t "$MEMDIR"/*.md 2>/dev/null | head -n 8); do
    content="$content

=== memory/$(basename "$f") ===
$(cat "$f")"
  done
fi

if [ "$source" = "compact" ] && [ -f "$HANDOFF" ]; then
  content="$content

=== Session handoff buffer (.launchpad/handoff.md) ===
$(cat "$HANDOFF")"
fi

# Nothing to load.
if [ -z "$(printf '%s' "$content" | tr -d '[:space:]')" ]; then
  exit 0
fi

# Pure-sh JSON string encoder: escape \ and ", strip CR, join lines with \n, wrap in quotes.
escaped="$(printf '%s' "$content" | tr -d '\r' \
  | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' -e 's/	/\\t/g' \
  | awk 'BEGIN{ORS="";print "\""} {print sep $0; sep="\\n"} END{print "\""}')"

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":%s}}\n' "$escaped"
exit 0
```

Note: the `sed` tab-escape uses a literal TAB character between the second `-e 's/` and `/\\t/'`. Ensure it is a real tab when typing.

- [ ] **Step 3: Run the test to verify it passes**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh hooks`
Expected: `PASS  load-memory emits valid additionalContext JSON`. (harvest-nudge checks still FAIL — built next.)

- [ ] **Step 4: Manual smoke test**

Run:
```bash
cd /c/Claude/Toolkits/launchpad/skills/launchpad
t=$(mktemp -d); printf '# MEM\n- decision: x\n' > "$t/MEMORY.md"
CLAUDE_PROJECT_DIR="$t" sh templates/hooks/load-memory </dev/null
```
Expected: one line of JSON starting `{"hookSpecificOutput"` containing `"additionalContext"` with the file text. Then `rm -rf "$t"`.

- [ ] **Step 5: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/templates/hooks/load-memory
git commit -m "feat: add load-memory SessionStart hook"
```

---

### Task 3: harvest-nudge hook

**Files:**
- Create: `skills/launchpad/templates/hooks/harvest-nudge`
- Test: `skills/launchpad/tools/validate.sh hooks` (harvest-nudge checks)

**Interfaces:**
- Consumes: env `CLAUDE_PROJECT_DIR`.
- Produces: first run per session → `{"decision":"block","reason":"..."}` on stdout + creates `.launchpad/.harvest-nudged`; subsequent runs → nothing, exit 0. (Flag is cleared by `load-memory` at next session start.)

- [ ] **Step 1: Run the failing test**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh hooks`
Expected: `FAIL  missing: templates/hooks/harvest-nudge`.

- [ ] **Step 2: Write the script**

Create `skills/launchpad/templates/hooks/harvest-nudge`:

```sh
#!/bin/sh
# Stop hook: once per session, remind Claude to harvest durable learnings.
# Never writes to memory itself (no surprise auto-writes).
set -u

ROOT="${CLAUDE_PROJECT_DIR:-.}"
FLAG="$ROOT/.launchpad/.harvest-nudged"

# Already nudged this session -> allow the stop silently.
if [ -f "$FLAG" ]; then
  exit 0
fi

mkdir -p "$ROOT/.launchpad" 2>/dev/null || true
: > "$FLAG" 2>/dev/null || true

cat <<'JSON'
{"decision":"block","reason":"Before finishing: if this turn produced a durable decision, a resolved failure, or a reusable technique, append it to MEMORY.md (or a memory/ fact file). If nothing is worth keeping, say so briefly and stop. This reminder fires once per session."}
JSON
exit 0
```

- [ ] **Step 3: Run the test to verify it passes**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh hooks`
Expected: all hooks checks `PASS`, including `harvest-nudge blocks on first run` and `harvest-nudge silent on second run`. `ALL PASS (hooks)`.

- [ ] **Step 4: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/templates/hooks/harvest-nudge
git commit -m "feat: add harvest-nudge Stop hook"
```

---

### Task 4: settings.json templates

**Files:**
- Create: `skills/launchpad/templates/settings.starter.json`
- Create: `skills/launchpad/templates/settings.standard.json`
- Test: `skills/launchpad/tools/validate.sh hooks`

**Interfaces:**
- Produces: two registerable hook config files. Starter = SessionStart only. Standard (also used by Pro) = SessionStart + Stop. Commands reference `$CLAUDE_PROJECT_DIR/.claude/hooks/<script>` (the install location, not the template location).

- [ ] **Step 1: Write `settings.starter.json`**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/load-memory", "timeout": 15 }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Write `settings.standard.json`**

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/load-memory", "timeout": 15 }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          { "type": "command", "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/harvest-nudge", "timeout": 10 }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: Run the test to verify it passes**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh hooks`
Expected: `PASS  settings.starter.json valid JSON`, `PASS  settings.standard.json valid JSON`, `PASS  standard settings registers harvest-nudge`. `ALL PASS (hooks)`.

- [ ] **Step 4: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/templates/settings.starter.json skills/launchpad/templates/settings.standard.json
git commit -m "feat: add tiered settings.json hook templates"
```

---

### Task 5: Memory templates (MEMORY.md, memory-fact.md; retire ERRORS/LEARNINGS)

**Files:**
- Modify: `skills/launchpad/templates/MEMORY.md`
- Create: `skills/launchpad/templates/memory-fact.md`
- Delete: `skills/launchpad/templates/ERRORS.md`, `skills/launchpad/templates/LEARNINGS.md`
- Test: `skills/launchpad/tools/validate.sh memory`

**Interfaces:**
- Produces: the Starter memory file (4 sections) and the graduated per-fact template. Consumed by `references/memory.md` (Task 7), `load-memory` (reads `MEMORY.md`/`memory/`), and CLAUDE.md (Task 6).

- [ ] **Step 1: Run the failing test**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh memory`
Expected: FAILs for missing sections / missing `memory-fact.md` / ERRORS.md & LEARNINGS.md still present.

- [ ] **Step 2: Rewrite `templates/MEMORY.md`** (Starter sectioned log + graduation note)

```markdown
# MEMORY.md — project memory (Starter)

<!-- READ this at session start. APPEND the moment you make a non-obvious decision, resolve a
real failure, or find a durable technique. One fact per bullet, newest first, absolute dates
(YYYY-MM-DD). Log the fact AND the why. Don't record what code or git history already shows.
GRADUATE: when this file gets hard to scan (~a screenful per section, or ~400 lines total),
migrate to a `memory/` directory of one-fact files — see references/memory.md. -->

## Decisions
<!-- a choice + why (+ rejected alternative). e.g. "2026-06-28 chose SQLite over Postgres: single-writer, zero ops." -->

## Learnings
<!-- a durable technique that works here. e.g. "2026-06-28 this API rate-limits at 50/s; batch in 40s windows." -->

## Errors
<!-- a failure + its fix, so it isn't retried. e.g. "2026-06-28 vitest hung on ESM; fix: pool:'forks'." -->

## References
<!-- external resources, commands, ports, gotchas. e.g. "2026-06-28 staging deploy: `make deploy-staging`." -->
```

- [ ] **Step 3: Create `templates/memory-fact.md`** (graduated per-fact template)

```markdown
---
name: <kebab-case-slug>
description: <one-line summary — used to judge relevance on recall>
metadata:
  type: decision | learning | error | reference
  date: YYYY-MM-DD
---

<The fact, stated once and tersely. For an error: the symptom, then **Fix:** what resolved it.
Link related facts with [[other-slug]]. Index line for MEMORY.md: `- [Title](memory/<slug>.md) — hook`.>
```

- [ ] **Step 4: Delete the retired flat logs**

```bash
cd /c/Claude/Toolkits/launchpad
git rm skills/launchpad/templates/ERRORS.md skills/launchpad/templates/LEARNINGS.md
```

- [ ] **Step 5: Run the test to verify it passes**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh memory`
Expected: all section checks PASS, `memory-fact.md` frontmatter checks PASS, `absent: templates/ERRORS.md`, `absent: templates/LEARNINGS.md`. (CLAUDE.md pointer check still FAILs — Task 6.)

- [ ] **Step 6: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/templates/MEMORY.md skills/launchpad/templates/memory-fact.md
git commit -m "feat: hybrid memory templates; retire ERRORS/LEARNINGS flat logs"
```

---

### Task 6: CLAUDE.md template (subagent memory-pointer block)

**Files:**
- Modify: `skills/launchpad/templates/CLAUDE.md`
- Test: `skills/launchpad/tools/validate.sh memory`

**Interfaces:**
- Produces: a CLAUDE.md template carrying a marked, inheritable memory-pointer block (subagents inherit CLAUDE.md → this reaches general-purpose subagents for free). Must contain the literal marker `LAUNCHPAD-MEMORY-POINTER` (asserted by validate.sh).

- [ ] **Step 1: Run the failing test**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh memory`
Expected: `FAIL  CLAUDE.md has subagent memory-pointer block`.

- [ ] **Step 2: Replace the "Self-learning" and "Orchestration" sections of `templates/CLAUDE.md`**

Replace the current lines 40–58 (the `## Self-learning`, `## Orchestration`, and `## Voice` sections) with:

```markdown
## Project memory (read at session start, update before session end)
<!-- LAUNCHPAD-MEMORY-POINTER: this block is inherited by general-purpose subagents. Keep it. -->
This project keeps a durable, shared memory. **Read `MEMORY.md` first thing each session**
(and the `memory/` directory if it exists); verify any named file/path/flag still exists
before trusting it. **Append** to the right place the moment you make a non-obvious decision,
resolve a real failure, or find a durable technique — one fact, newest first, absolute dates.

**If you are a subagent:** your task prompt should carry the 1–3 memory facts that matter most.
If you need more history, **read `MEMORY.md` (and `memory/`) yourself** before starting — you do
not inherit the parent's conversation or memory, only this file. (Explore/Plan agents do not even
get this file; they must be given everything in their prompt.)

## Orchestration (work as a team only when it pays off)
For substantial multi-step, multi-file, or high-stakes work, invoke the **launchpad** skill and
use its efficiency-gated ladder: Solo → Pair → parallel fan-out → Workflow. Default to the
smallest structure that clears the bar; escalate only on a real trigger. When you delegate,
inject the critical memory facts into the subagent's prompt (it can't read this project's
memory on its own beyond this file) and require a return-learnings slot you harvest back.
```

(Leave lines 1–39 — title, what-this-is, tech stack, run/test/build, working rules, conventions, hard-stops — unchanged. The `## Voice` reference to `anti-style.md` is removed here since voice is out of scope for this redesign; `anti-style.md` itself stays in templates for users who want it.)

- [ ] **Step 3: Run the test to verify it passes**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh memory`
Expected: `ALL PASS (memory)`.

- [ ] **Step 4: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/templates/CLAUDE.md
git commit -m "feat: CLAUDE.md subagent memory-pointer + hybrid memory wiring"
```

---

### Task 7: reference/memory.md

**Files:**
- Create: `skills/launchpad/references/memory.md`
- Test: `skills/launchpad/tools/validate.sh refs`

**Interfaces:**
- Produces: the authoritative memory reference. Consumed by SKILL.md reference map (Task 12) and provisioning.md (Task 9).

**Content specification** (write prose covering each; source: spec §5 and §8):
- **Hybrid model** — Starter single `MEMORY.md` (4 sections: Decisions/Learnings/Errors/References) vs. graduated `memory/` dir (one fact per file). When to be in each.
- **Per-fact file format** — reproduce the frontmatter block from `templates/memory-fact.md` (name, description, metadata.type ∈ `decision|learning|error|reference`, date) and the `MEMORY.md` index-line format `- [Title](memory/<slug>.md) — hook`, plus `[[wikilink]]` usage.
- **Graduation procedure** — the observable trigger (index hard to scan / ~400 lines), and the non-destructive migration: each section entry → a fact file with inferred frontmatter; `MEMORY.md` rewritten as the index. Nothing dropped.
- **Hook wiring** — `load-memory` injects the index (+ recent facts in Pro, + handoff buffer on `compact`) via `hookSpecificOutput.additionalContext`; matchers `startup|resume|clear|compact`. `harvest-nudge` reminds once per session and **never auto-writes**. Note the `.launchpad/.harvest-nudged` flag lifecycle (set by harvest-nudge, cleared by load-memory).
- **Subagent access** — "both, situationally": the inherited CLAUDE.md pointer (free) for general-purpose agents; inline injection of the critical 1–3 facts for must-haves; **Explore/Plan skip CLAUDE.md so must be fully injected**.
- **claude.ai/API degradation** — no files/hooks: maintain an in-context memory block, offer copy-paste blocks at session end.

**Gating assertions** (already in validate.sh `refs`): file exists. **Add** these two lines to `check_refs()` in `tools/validate.sh` before running:
```sh
  assert_contains references/memory.md "metadata" "memory.md documents fact frontmatter"
  assert_contains references/memory.md "additionalContext" "memory.md documents the load hook"
```

- [ ] **Step 1: Add the two assertions above to `tools/validate.sh` `check_refs()`.**
- [ ] **Step 2: Run `sh tools/validate.sh refs`** → expect FAIL for missing `references/memory.md`.
- [ ] **Step 3: Write `references/memory.md`** to satisfy every bullet in the content spec above.
- [ ] **Step 4: Run `sh tools/validate.sh refs`** → expect the two memory.md assertions PASS (other refs still FAIL).
- [ ] **Step 5: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/tools/validate.sh skills/launchpad/references/memory.md
git commit -m "docs: add memory pillar reference"
```

---

### Task 8: reference/delegation.md

**Files:**
- Create: `skills/launchpad/references/delegation.md`
- Test: `skills/launchpad/tools/validate.sh refs`

**Interfaces:**
- Produces: the delegation reference. Consumed by SKILL.md reference map and orchestration.md.

**Content specification** (source: spec §6; salvage usable material from the existing `references/orchestration.md` "delegation-prompt contract" and "CLAUDE.md / subagent gotcha" sections):
- **The 7-point contract** — Objective, Scope, Context (memory facts pasted in + paths + error text), Output format, Tool guidance, Stop criteria, Return-learnings slot. Reproduce the NEW-KNOWLEDGE return-block format from the existing self-learning.md.
- **Grounded inheritance rules** — general-purpose subagents inherit CLAUDE.md (don't re-explain the stack; inject only task specifics); **Explore/Plan skip CLAUDE.md** (cheap but context-blind → inject everything); no subagent inherits conversation/parent-memory.
- **Model routing** — Haiku (mechanical/high-volume), Sonnet (most implementation/search/review), Opus (hard reasoning/synthesis/judging). Cheap models on cheap roles = biggest saving.
- **Harvest** — the return-learnings slot feeds memory; the Stop-nudge backstops a forgotten harvest.

**Gating assertion:** `check_refs()` already asserts `delegation.md` contains "Explore". **Add**:
```sh
  assert_contains references/delegation.md "Return-learnings" "delegation.md has the 7-point contract"
```

- [ ] **Step 1: Add the assertion above to `check_refs()`.**
- [ ] **Step 2: Run `sh tools/validate.sh refs`** → expect FAIL for missing `references/delegation.md`.
- [ ] **Step 3: Write `references/delegation.md`** per the content spec.
- [ ] **Step 4: Run `sh tools/validate.sh refs`** → delegation.md assertions PASS.
- [ ] **Step 5: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/tools/validate.sh skills/launchpad/references/delegation.md
git commit -m "docs: add delegation pillar reference"
```

---

### Task 9: reference/provisioning.md

**Files:**
- Create: `skills/launchpad/references/provisioning.md`
- Test: `skills/launchpad/tools/validate.sh refs`

**Interfaces:**
- Produces: the provisioning reference — the bootstrap front door. Consumed by SKILL.md (the "First-run bootstrap" routes here).

**Content specification** (source: spec §4, §16):
- **Signals gathered** — Expertise (auto-detect: existing `.claude/`, `settings.json` with hooks, prior `CLAUDE.md`, git depth, CI/test config) + one confirming question (New / Comfortable / Advanced). Project shape (cheap Explore-agent inspect, then confirm: size, nature, stakes, solo/team, agent-need).
- **Tier table** — reproduce the spec §4.2 table verbatim (Starter / Standard / Pro × Memory / Hooks / Delegation / Orchestration / Councils). Must contain the literal words `Starter` and `Pro` (asserted).
- **Deploy steps per tier** — which files/hooks get written:
  - Starter: `CLAUDE.md`, `MEMORY.md` (4-section), `.claude/settings.json` ← `settings.starter.json`, `.claude/hooks/load-memory`.
  - Standard: the above + `.claude/hooks/harvest-nudge` + `.claude/settings.json` ← `settings.standard.json`.
  - Pro: the above + create `memory/` dir from day one + `.launchpad/handoff.md` buffer + wire council presets.
- **Tier is an overridable recommendation.**
- **Re-provisioning (`launchpad upgrade`)** — re-run profiling; **additively, non-destructively** add the next tier's infra (migrate `MEMORY.md`→`memory/`, add harvest hook, surface appendix). Per spec §16.2: Claude **may proactively suggest** upgrade on the graduation signal, but **execution needs user go-ahead**.
- **claude.ai/API** — skip writes; copy-paste blocks; behaviors in-session.

**Gating assertions:** `check_refs()` already asserts Starter/Pro present. **Add**:
```sh
  assert_contains references/provisioning.md "upgrade" "provisioning.md documents re-provisioning"
  assert_contains references/provisioning.md "settings.starter.json" "provisioning.md maps tier deploys"
```

- [ ] **Step 1: Add the two assertions to `check_refs()`.**
- [ ] **Step 2: Run `sh tools/validate.sh refs`** → FAIL for missing `references/provisioning.md`.
- [ ] **Step 3: Write `references/provisioning.md`** per the content spec.
- [ ] **Step 4: Run `sh tools/validate.sh refs`** → provisioning.md assertions PASS.
- [ ] **Step 5: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/tools/validate.sh skills/launchpad/references/provisioning.md
git commit -m "docs: add provisioning reference (interview + tiers + upgrade)"
```

---

### Task 10: orchestration.md — 4-tier front door

**Files:**
- Modify: `skills/launchpad/references/orchestration.md`
- Test: `skills/launchpad/tools/validate.sh refs`

**Interfaces:**
- Produces: the orchestration front door narrowed to a 4-tier ladder, pointing to `org-structures.md` as the Pro appendix. The "delegation-prompt contract" and "CLAUDE.md/subagent gotcha" detail moves to `delegation.md` (Task 8) — replace those sections here with a one-line pointer to `delegation.md` to avoid duplication.

**Content specification** (source: spec §7; preserve the existing "Why restraint / cost reality", "Escalation triggers", "De-escalation", "Synthesis", "Degradation" sections — they're good):
- Replace the "Selection decision tree" (current lines ~134–151) with the **4-tier front door**: 1) Solo (default; trivial or same-file), 2) Pair (build + independent review + verify; default for real changes), 3) Parallel fan-out (3+ independent angles), 4) Workflow (10+ uniform targets / multi-module). One observable trigger per step.
- Keep the **efficiency governor** ("one rule" + ~15x cost reality).
- Replace the "delegation-prompt contract" and "CLAUDE.md / subagent gotcha" bodies with: *"See `references/delegation.md` for the 7-point contract, inheritance rules, and model routing."*
- Add a closing line: *"The full 13-structure catalog is a power-user appendix: `references/org-structures.md`."* (must contain literal `org-structures.md` and `Solo` — already asserted).

- [ ] **Step 1: Run `sh tools/validate.sh refs`** → note current state (orchestration.md exists; new assertions on Solo / appendix pointer may already pass or fail depending on edits).
- [ ] **Step 2: Edit `references/orchestration.md`** per the content spec.
- [ ] **Step 3: Run `sh tools/validate.sh refs`** → `orchestration.md has 4-tier ladder (Solo)` and `orchestration.md points to appendix` PASS.
- [ ] **Step 4: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/references/orchestration.md
git commit -m "docs: narrow orchestration to 4-tier front door; point to delegation + appendix"
```

---

### Task 11: self-learning.md + org-structures.md appendix note

**Files:**
- Modify: `skills/launchpad/references/self-learning.md`
- Modify: `skills/launchpad/references/org-structures.md`
- Test: `skills/launchpad/tools/validate.sh refs`

**Interfaces:**
- Produces: self-learning.md updated to the hybrid memory model + hook awareness (was three flat stores); org-structures.md marked as the Pro appendix.

**Content specification:**
- `self-learning.md`: replace "The three stores" (MEMORY/ERRORS/LEARNINGS) with the **hybrid model** (single MEMORY.md sections → graduated `memory/` facts; type vocabulary `decision|learning|error|reference`). Keep the inject-and-harvest loop and the "core problem" (subagents inherit no memory). Add one paragraph: **hooks now automate the read side** (`load-memory` injects memory each session, including post-compaction) and **nudge the harvest side** (`harvest-nudge`), but the inject-into-subagents discipline is unchanged. Update the "What goes where" table to the four types. Cross-reference `references/memory.md` as the canonical detail.
- `org-structures.md`: add a header note at the top: *"Appendix (Pro tier): the full 13-structure catalog. The everyday front door is the 4-tier ladder in `references/orchestration.md`; reach here only when a structure beyond Pair/fan-out/Workflow is genuinely warranted."* (must contain literal `appendix` — asserted).

- [ ] **Step 1: Run `sh tools/validate.sh refs`** → `org-structures.md marked as appendix` currently FAIL.
- [ ] **Step 2: Edit `self-learning.md`** per the content spec.
- [ ] **Step 3: Add the appendix header note to `org-structures.md`.**
- [ ] **Step 4: Run `sh tools/validate.sh refs`** → `ALL PASS (refs)`.
- [ ] **Step 5: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/references/self-learning.md skills/launchpad/references/org-structures.md
git commit -m "docs: hybrid+hook-aware self-learning; mark org-structures as Pro appendix"
```

---

### Task 12: SKILL.md rewrite (front door)

**Files:**
- Modify: `skills/launchpad/SKILL.md`
- Test: `skills/launchpad/tools/validate.sh skill`

**Interfaces:**
- Consumes: all references created/modified in Tasks 7–11 plus the frozen council references.
- Produces: the lean front door. Must keep `description` ≤ 1024 chars, file ≤ 500 lines, and link only to references that exist.

**Content specification** (source: spec §3, §7, §9; keep the current frontmatter `name: launchpad` and trigger-phrase style):
- **Frontmatter** — keep `name: launchpad`; update `description` to cover: sets up a project so Claude works at its best, provisions tiered infra (memory + delegation + orchestration + hooks), and convenes councils. Keep trigger phrases. **Verify ≤ 1024 chars** (validate.sh checks).
- **Body sections:**
  - One-paragraph thesis: Launchpad is a project OS; cheapest structure that clears the bar.
  - **First-run bootstrap** → route to `references/provisioning.md` (profile → tier → deploy). Summarize the 3 tiers in 3 lines.
  - **The three pillars** — Memory (`references/memory.md`), Delegation (`references/delegation.md`), Orchestration (`references/orchestration.md`), one line each.
  - **Hooks** — load-auto + harvest-nudge, one line, pointer to memory.md.
  - **Councils (application)** — Decision (`references/council.md`) and Feasibility (`references/feasibility-council.md`), unchanged; one line each on when to convene.
  - **When NOT to use** — one-line fixes, quick questions, tightly-coupled single-file edits: stay solo.
  - **Reference map table** — rows for: provisioning, memory, delegation, orchestration, org-structures (Pro appendix), self-learning, council, feasibility-council. Every path must resolve (validate.sh checks each linked `references/*.md` exists).

- [ ] **Step 1: Run `sh tools/validate.sh skill`** → note current FAILs (old SKILL.md links `self-learning`, `council`, `feasibility-council`, `orchestration`, `org-structures`; new links must all resolve).
- [ ] **Step 2: Rewrite `SKILL.md`** per the content spec.
- [ ] **Step 3: Run `sh tools/validate.sh skill`** → `ALL PASS (skill)` (description ≤ 1024, ≤ 500 lines, every linked ref exists).
- [ ] **Step 4: Commit**
```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/SKILL.md
git commit -m "feat: rewrite SKILL.md as project-OS front door"
```

---

### Task 13: Full integration check + README sync

**Files:**
- Modify: `skills/launchpad/README.md` and/or `skills/README.md` (sync the file list if they enumerate templates/references)
- Test: `skills/launchpad/tools/validate.sh all`

**Interfaces:**
- Produces: a fully green validation run and docs that match the new structure.

- [ ] **Step 1: Run the full suite**

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh all`
Expected: `ALL PASS (all)`, exit 0.

- [ ] **Step 2: Sync READMEs**

Open `skills/launchpad/README.md` and `skills/README.md`. If either lists the template/reference files or describes the memory model (three stores / ERRORS.md / LEARNINGS.md), update to the new structure: hybrid memory, `memory-fact.md`, `provisioning.md`/`memory.md`/`delegation.md`, hooks, tiers. If they don't enumerate files, leave as-is.

- [ ] **Step 3: Re-run the full suite** to confirm no regressions.

Run: `cd /c/Claude/Toolkits/launchpad/skills/launchpad && sh tools/validate.sh all`
Expected: `ALL PASS (all)`.

- [ ] **Step 4: Commit**

```bash
cd /c/Claude/Toolkits/launchpad
git add skills/launchpad/README.md skills/README.md
git commit -m "docs: sync READMEs to project-OS structure"
```

---

## Out of Scope (explicitly deferred)

- **dist zip rebuild** (`skills/dist/launchpad.zip`): blocked on the unresolved skill name (top pick "Kestrava"). Regenerate after the rename, not in this plan.
- **v2 feasibility council redesign** (premortem, independent scoring, new lenses): parked; councils ship as-is per spec §9.
- **Voice / anti-style**: deprioritized; `anti-style.md` left in templates untouched.
- **A true `PreCompact` hook**: not load-bearing; handoff uses `Stop` + `SessionStart(compact)` only (spec §8.3). Revisit if a dedicated event is confirmed.

---

## Self-Review

**1. Spec coverage:**
- §4 provisioning → Task 9 ✓ | §5 memory → Tasks 5, 7 ✓ | §6 delegation → Task 8 ✓ | §7 orchestration → Tasks 10, 11 ✓ | §8 hooks → Tasks 2, 3, 4 ✓ | §9 councils as-is → kept untouched, referenced in Task 12 ✓ | §10 file hierarchy → File Structure + all tasks ✓ | §11 claude.ai degradation → documented in Tasks 7, 9 content specs ✓ | §12 mechanics/budgets → enforced by validate.sh (Task 1) ✓ | §13 what-changes → Tasks 5, 6, 10, 11 ✓ | §16 resolved decisions → Tasks 3 (one-nudge), 6 (POSIX), 9 (upgrade) ✓.
- CLAUDE.md template (§5.5 pointer) → Task 6 ✓.
- Gap check: handoff buffer — handled as `load-memory`'s `compact` behavior + Pro instruction (Task 2 + Task 9 content), not a separate script; this is the spec §8.3 interpretation (a script can't summarize a session). Recorded in Out of Scope / Task notes.

**2. Placeholder scan:** Scripts, JSON, and strict templates are given verbatim. Markdown reference tasks use content specifications with exact gating assertions rather than "TODO" — each bullet is a concrete requirement traceable to a spec section. No "TBD"/"handle edge cases"/"similar to Task N" present.

**3. Type/name consistency:** marker `LAUNCHPAD-MEMORY-POINTER` defined in Task 6, asserted in Task 1. Flag path `.launchpad/.harvest-nudged` written by `harvest-nudge` (Task 3), cleared by `load-memory` (Task 2) — consistent. Hook command paths `$CLAUDE_PROJECT_DIR/.claude/hooks/{load-memory,harvest-nudge}` consistent across Tasks 2/3/4. Frontmatter type vocabulary `decision|learning|error|reference` consistent across Tasks 5, 7, 11. validate.sh group names (`skill|refs|memory|hooks|all`) consistent across all task test steps.
