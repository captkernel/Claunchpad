# Recommended-Skills Bootstrap Offer — Design Specification

**Date:** 2026-06-30
**Status:** Approved — building
**Feature:** At Launchpad bootstrap, offer to install a curated set of high-value Claude Code plugins/skills.

---

## 1. Problem & Goal

Launchpad bootstraps a project's own scaffold but says nothing about the broader ecosystem. A new user doesn't know which external skills are worth having. Goal: during first-run, offer a curated, verified set of "important skills" — the user says yes / customise / skip, and Launchpad installs (Claude Code) or prints a manual list (claude.ai). Curated by us, confirmed by the user; manifest-driven so the set is editable.

---

## 2. Locked Decisions (from brainstorming)

- **Selection UX:** tiered — recommended **bundle (one yes/no)** + **customise** (pick a subset).
- **claude.ai / app:** no plugin system → **skip auto-install, print a manual list** (names, sources, what each does, commands to run later).
- **Curation:** we propose the list; user confirmed it. Lives in an editable **manifest**.
- **Install mechanism:** **Approach C (hybrid)** — manifest-driven; record durable config where applicable, apply via each skill's real install command, fall back to manual list. Install is **never fully silent** (always a trust prompt and/or restart).
- **Scope:** default **user-level** (`~/.claude/`) so the tools are available across all projects; project-level is possible but not the default.

---

## 3. The Curated List (verified sources + real install commands)

Each entry is a real Claude Code plugin/skill with a confirmed source. **The three use three different install mechanisms** — the manifest carries each skill's real command(s) per OS; there is no uniform installer.

### 3.1 Superpowers — skill-engineering backbone
- **Source:** `obra/superpowers-marketplace` (plugin marketplace; plugin `superpowers@superpowers-marketplace`)
- **Why:** brainstorming, writing-plans, TDD, systematic-debugging, subagent-driven-development — the disciplined workflow engine.
- **Install (Claude Code):**
  - CLI: `claude plugin marketplace add obra/superpowers-marketplace` then `claude plugin install superpowers@superpowers-marketplace`
  - Declarative (settings.json): add `extraKnownMarketplaces."superpowers-marketplace" = { source: { source: "github", repo: "obra/superpowers-marketplace" } }` and `enabledPlugins."superpowers@superpowers-marketplace" = true`
- **Activate:** accept the trust prompt / restart Claude Code.

### 3.2 Skills Curator — evaluate-before-you-install
- **Source:** `captkernel/Skills_Curator` (plugin `skills-curator`, v4.5.0; single-plugin repo, install-script canonical)
- **Why:** scores a candidate skill before install and persists every decision ("decide once, re-decide never") — the natural gatekeeper for everything else this feature installs.
- **Install (Claude Code):** clone the repo, then run its installer (per its README):
  - macOS/Linux/Git Bash: `git clone https://github.com/captkernel/Skills_Curator && cd Skills_Curator && bash install.sh`
  - Windows PowerShell: `git clone https://github.com/captkernel/Skills_Curator; cd Skills_Curator; powershell -ExecutionPolicy Bypass -File install.ps1`
  - `install.sh` defaults to Lite (no Python) and adds the Python tier if Python 3.10+ is present (`--with-python` / `--lite-only` to force).
- **Activate:** next session (skill auto-discovered from `~/.claude/skills/`).

### 3.3 Agent Browser — browser automation for agents
- **Source:** `vercel-labs/agent-browser` (npm package `agent-browser`; also ships a `.claude-plugin` marketplace)
- **Why:** lets agents drive a real browser (tab scan/switch, JS eval, screenshots, uploads).
- **Install (Claude Code):** `npm install -g agent-browser` then `agent-browser install` (downloads Chrome for Testing on first run).
- **Caveats (manifest must surface):** requires Node/npm; downloads a Chrome build (network + disk); heaviest of the three. If Node is absent, this entry degrades to a manual-list note.
- **Activate:** CLI available immediately; the bundled Claude skills load next session.

---

## 4. Architecture

A manifest (data) + bootstrap instructions (process) + validation (tests). No installer script of our own — Launchpad runs each skill's real command via the Bash tool, consistent with its "Claude does it via tools" ethos.

### 4.1 Manifest — `templates/recommended-skills.md`
A human- and Claude-readable table/list. One block per skill with fields:
`id · name · one-line why · source (owner/repo or npm pkg) · type (marketplace-plugin | install-script | npm-cli) · install: { posix, windows } · activate note · caveats · manual-install (for app)`.
Editable: a maintainer changes the set here without touching flow logic.

### 4.2 Bootstrap flow — additions to `references/provisioning.md`
A new **"Recommended skills"** step, run after the tier is deployed:

1. **Detect surface.** Claude Code (filesystem + `claude`/`npm` CLIs) vs claude.ai/app.
2. **Claude Code path:**
   - Present the bundle: the three names + one-liners, then ask **`[Y] install all · [c] customise · [s] skip`**.
   - `Y` → install all selected; `c` → list the three, user picks a subset, install those; `s` → nothing.
   - For each chosen skill, run its **OS-appropriate** install command from the manifest (detect Windows vs POSIX). Default **user scope** (`~/.claude/`).
   - Before running `npm`/`bash`/`claude` commands, confirm the tool exists; if missing (e.g. no Node for Agent Browser), skip that entry and print its manual instructions instead.
   - After installs, state the **one human step left**: accept the trust prompt and/or **restart Claude Code** to activate. List what was installed and what was skipped + why.
3. **App path (claude.ai):** skip auto-install; **print the manual list** from the manifest (name, source, why, the exact command to run later in Claude Code).
4. **Idempotence/safety:** never overwrite existing user config destructively; if a plugin is already enabled, report "already present" and skip. Settings.json edits are additive.

### 4.3 SKILL.md
One line under the bootstrap section pointing to the recommended-skills step + manifest.

---

## 5. Per-surface / per-OS behavior summary

| Surface | Behavior |
|---|---|
| Claude Code (Windows) | offer → install via `install.ps1` / `npm` / `claude plugin`; user-scope; restart to activate |
| Claude Code (POSIX) | offer → install via `install.sh` / `npm` / `claude plugin`; user-scope; restart to activate |
| claude.ai / app | skip auto-install; print manual list with commands |
| Tool missing (e.g. no Node) | skip that skill; print its manual instructions; continue with the rest |

---

## 6. Components / Files

- **Create:** `skills/launchpad/templates/recommended-skills.md` (the manifest)
- **Modify:** `skills/launchpad/references/provisioning.md` (the offer flow + per-surface/per-OS + activation note)
- **Modify:** `skills/launchpad/SKILL.md` (one-line pointer)
- **Modify:** `skills/launchpad/tools/validate.sh` (new checks, below)
- **Optional:** a line in `showcase.html` / `skills/README.md` noting the recommended-skills step

---

## 7. Testing (validate.sh — structural only)

We cannot trigger real plugin installs in CI, so assertions are structural:
1. `templates/recommended-skills.md` exists and names all three sources verbatim: `obra/superpowers-marketplace`, `captkernel/Skills_Curator`, `vercel-labs/agent-browser`.
2. The manifest documents both a POSIX and a Windows install path (literal `install.sh` and `install.ps1` present; `npm install -g agent-browser` present; `claude plugin marketplace add` present).
3. `provisioning.md` documents the offer (`customise`, `skip`), the per-surface split (a manual-list path for the app), and the "restart to activate" note.
4. `SKILL.md` links/points to the recommended-skills step (and still passes its existing budget checks: description ≤1024, ≤500 lines).
5. Existing `validate.sh all` continues to pass (no regressions).

---

## 8. Out of Scope

- Auto-restarting Claude Code (impossible/unsafe; we instruct the user).
- Verifying the install actually succeeded end-to-end (needs a live restart).
- Managing plugin *updates* or uninstalls (separate concern).
- Adding skills beyond the confirmed three (manifest is editable for later).

---

## 9. Success Criteria

- On Claude Code, a user finishing bootstrap is offered the three skills, can take all / pick / skip, and gets correct OS-appropriate install commands run, with a clear "restart to activate" + a summary of installed/skipped.
- On claude.ai, the user gets an accurate manual list instead.
- A missing prerequisite (e.g. Node) degrades that one skill to manual instructions without aborting the rest.
- `validate.sh all` passes; the manifest is the single editable source of the list.
