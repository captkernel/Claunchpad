# Recommended skills (manifest)

The curated set Launchpad offers to install at bootstrap. **Editable** — change this list to
change what's offered; the bootstrap flow (`references/provisioning.md`) reads it, it has no
hard-coded skill names. Each entry carries its own real install command(s); the three below use
three different mechanisms, so do not assume a uniform installer.

Install is **never fully silent** on Claude Code — there is always a trust prompt and/or a
**restart** before a newly added plugin/skill activates. Default scope is **user-level**
(`~/.claude/`) so the tools work across all projects. None of this exists on claude.ai / the app
(no plugin system) — there, print the **Manual install** lines instead.

---

## superpowers
- **id:** `superpowers`
- **why:** Skill-engineering backbone — brainstorming, writing-plans, TDD, systematic-debugging,
  subagent-driven-development. The disciplined workflow engine.
- **source:** `obra/superpowers-marketplace` (marketplace; plugin `superpowers@superpowers-marketplace`)
- **type:** marketplace-plugin
- **install (posix & windows, same):**
  - `claude plugin marketplace add obra/superpowers-marketplace`
  - `claude plugin install superpowers@superpowers-marketplace`
- **declarative alternative (settings.json):** add
  `extraKnownMarketplaces."superpowers-marketplace" = { "source": { "source": "github", "repo": "obra/superpowers-marketplace" } }`
  and `enabledPlugins."superpowers@superpowers-marketplace" = true`.
- **activate:** accept the trust prompt / restart Claude Code.
- **prereqs:** the `claude` CLI on PATH.
- **manual install (app):** "In Claude Code, run `claude plugin marketplace add obra/superpowers-marketplace` then `claude plugin install superpowers@superpowers-marketplace` (or the interactive `/plugin` equivalents)."

## skills-curator
- **id:** `skills-curator`
- **why:** Evaluates a candidate skill before you install it and persists every decision
  ("decide once, re-decide never"). The natural gatekeeper for everything else you add.
- **source:** `captkernel/Skills_Curator` (plugin `skills-curator`; install-script canonical)
- **type:** install-script
- **install (posix / Git Bash):**
  - `git clone https://github.com/captkernel/Skills_Curator`
  - `cd Skills_Curator && bash install.sh`
- **install (windows / PowerShell):**
  - `git clone https://github.com/captkernel/Skills_Curator`
  - `cd Skills_Curator; powershell -ExecutionPolicy Bypass -File install.ps1`
- **notes:** `install.sh` defaults to the Lite tier (no Python); adds the Python tier if Python
  3.10+ is present. Use `--lite-only` or `--with-python` to force.
- **activate:** next session (auto-discovered from `~/.claude/skills/`).
- **prereqs:** `git`; optional Python 3.10+ for the full tier.
- **manual install (app):** "Clone `github.com/captkernel/Skills_Curator` and run `bash install.sh` (or `install.ps1` on Windows), then reopen Claude Code."

## agent-browser
- **id:** `agent-browser`
- **why:** Lets agents drive a real browser — tab scan/switch, JS eval, screenshots, uploads.
- **source:** `vercel-labs/agent-browser` (npm package `agent-browser`; also ships a `.claude-plugin`)
- **type:** npm-cli
- **install (posix & windows, same):**
  - `npm install -g agent-browser`
  - `agent-browser install`  (downloads Chrome for Testing on first run)
- **caveats:** requires Node/npm; downloads a Chrome build (network + disk); heaviest of the
  three. If Node is absent, **skip and print this entry's manual install** rather than failing.
- **activate:** CLI available immediately; bundled Claude skills load next session.
- **prereqs:** Node.js + npm.
- **manual install (app):** "Install Node, then `npm install -g agent-browser` and `agent-browser install`."

---

## Field reference (for maintainers editing this manifest)
- **id** — short slug. **why** — one line. **source** — `owner/repo` or npm package.
- **type** — `marketplace-plugin` | `install-script` | `npm-cli` (determines which command runs).
- **install (posix / windows)** — the real command(s); the flow picks by detected OS.
- **prereqs** — tools that must exist first; if missing, the flow skips and prints manual install.
- **activate** — what the user must do for it to take effect (trust prompt / restart / next session).
- **manual install (app)** — the line printed on claude.ai / the app, where auto-install is impossible.
