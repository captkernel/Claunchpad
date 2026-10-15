# Anthropic directory submission sheet: Claunchpad

Prepared 2026-10-15 for a manual submission by the maintainer. Nothing has been submitted.
Portal facts were checked on 2026-10-14 against claude.com/docs/plugins/submit.

## Prerequisites

- [ ] Paid Claude plan
- [ ] GitHub account connected on claude.ai, with push access to `captkernel/Claunchpad`
- [ ] Repo is public (it is)
- [ ] Limits: 10 submissions per 24 h; one submission per repo and folder

## Portal steps

1. Open https://claude.ai/directory/manage
2. Submit new
3. Choose "Plugin bundle"
4. Repository: `captkernel/Claunchpad`
5. Plugin path: leave empty (the plugin is at the repo root, no subpath)
6. Branch or tag: `master`
7. Validate (expect a pass; see Checklist results)
8. Listing details (pre-filled from plugin.json and README, see below)
9. Data handling questions
10. Compliance acknowledgements
11. Submit for review

One listing reaches claude.ai, Cowork and Claude Code.

## Listing

| Field | Value |
|---|---|
| Name | `claunchpad` (display name: Claunchpad) |
| Version | 1.0.0 |
| Author | captKernel (https://github.com/captkernel) |
| License | MIT |
| Keywords | project-setup, claude-md, memory, agent-teams, orchestration |

**Short description** (plugin.json `description`, verbatim):

> Drop in one skill and Claude sets your project up properly: a solid CLAUDE.md, persistent memory that survives /clear, self-sizing agent teams, decision councils and curated ecosystem skills.

**Long description** (adapt from the README intro; suggested text):

> Claunchpad is one skill that sets a project up properly. On first run it interviews you, then writes a solid CLAUDE.md and a MEMORY.md, and registers two short local shell hooks. One reloads your project memory at the start of every session so decisions survive /clear and compaction. The other nudges Claude once per session to file new learnings. Work then runs as a team that sizes itself: a solo pass for small things, a builder plus reviewer for real changes, parallel agents for independent research. Optionally, at setup, it offers to install three third-party tools (Superpowers, Skills Curator, Agent Browser). Nothing is installed unless you accept.

**Category:** the portal's category list was not available when this sheet was written. Pick the closest of: Developer tools / Productivity / Project setup.

## Links

| Field | Value |
|---|---|
| Homepage | https://github.com/captkernel/Claunchpad |
| Repository | https://github.com/captkernel/Claunchpad |
| Support (repo issues) | https://github.com/captkernel/Claunchpad/issues |

### Optional listing fields (optional, recommended)

The directory reads these from plugin.json (Claude Code ignores them; the validator accepts them on v2.1.281+). They are NOT yet in plugin.json; add them in a later task or enter them in the portal.

| plugin.json field | Suggested value |
|---|---|
| `icon` | `assets/icon.svg` exists (also `assets/logo.svg`). No raster image exists in the repo, and the directory may want a PNG, so export `assets/icon.svg` to a square PNG (for example `assets/icon.png`, 512x512) first |
| `documentationUrl` | https://github.com/captkernel/Claunchpad#readme |
| `supportUrl` | https://github.com/captkernel/Claunchpad/issues |
| `privacyPolicyUrl` | https://github.com/captkernel/Claunchpad#what-it-runs-reads-and-sends |
| `termsOfServiceUrl` | https://github.com/captkernel/Claunchpad/blob/master/LICENSE (MIT; no separate terms exist) |

## Data handling answers

The exact questions were not known when this sheet was written. These are best pre-filled answers derived from the README section "What it runs, reads and sends". They are answers to adapt, not quotes of the portal. Read each question in the portal first.

- **Does the plugin send data off the user's machine?** No. Claunchpad itself sends nothing anywhere. Its two hooks make no network call.
- **Does it collect or transmit user, project or conversation data?** No. `load-memory` reads `MEMORY.md`, up to eight recent `memory/*.md` files and (after compaction) `.claunchpad/handoff.md` from the user's own project and hands them to Claude as session context. `harvest-nudge` only blocks once per session to remind Claude to file learnings.
- **What files does it write?** Into the user's project, after the first-run interview and without destructive overwrites: `CLAUDE.md`, `MEMORY.md`, `memory/` fact files and `.claunchpad/handoff.md` (higher tiers), `.claude/settings.json` (only registers hooks; edits to an existing file are additive), `.claude/hooks/load-memory`, `.claude/hooks/harvest-nudge`, and a flag file `.claunchpad/.harvest-nudged`.
- **Does it run code or install anything?** The hooks are short local POSIX shell scripts that can be read in full. At bootstrap it offers three optional third-party installs; nothing runs unless the user accepts (`[Y] all, [c] customise, [s] skip`): Superpowers (`claude plugin marketplace add obra/superpowers-marketplace` then `claude plugin install superpowers@superpowers-marketplace`), Skills Curator (`git clone` of captkernel/Skills_Curator, then its installer), Agent Browser (`npm install -g agent-browser`, then `agent-browser install`, which downloads a Chrome for Testing build; skipped if Node is missing). Declining installs no third-party code.
- **Does it change permissions or settings?** It registers two hooks in the project's `.claude/settings.json`. It does not change permission rules.
- **Credentials or secrets?** None requested, stored or transmitted.
- **Third-party services contacted?** Only if the user accepts an optional install (GitHub, npm and the Chrome for Testing download).

## Compliance acknowledgements

The portal shows 4 acknowledgements. Their wording is unknown here. Read each in the portal and tick it yourself.

- [ ] Acknowledgement 1 (read in the portal)
- [ ] Acknowledgement 2 (read in the portal)
- [ ] Acknowledgement 3 (read in the portal)
- [ ] Acknowledgement 4 (read in the portal)

## Held-for-review items

These do not cause rejection but a human reviewer will look at them.

| Item | Size | Justification |
|---|---|---|
| `docs/video/claunchpad-reel.mp4` | 3.3 MB | Launch reel (9:16) embedded in the README as a demo. Not loaded or executed by the plugin |
| `docs/video/claunchpad-reel-4x5.mp4` | 3.1 MB | Same reel in 4:5 feed format, linked from the README |
| `skills/dist/claunchpad.zip` | n/a | Upload-ready packaging of the skill for the claude.ai Skills upload flow. Same content as `skills/claunchpad/`. Not loaded by the plugin |

Also worth a mention if asked: the name "Claunchpad" is a deliberate pun on "launchpad" and contains "Claude" only as a fragment, not as a whole word. The brand look-alike check may flag it for review.

## Checklist results

Run on 2026-10-15 at HEAD of `master` before adding this file.

| Check | Result |
|---|---|
| `claude plugin validate --strict .` | `✔ Validation passed` |
| `.claude-plugin/plugin.json` present, distinctive name | Yes, `claunchpad` |
| README at least 40 words outside code blocks | Yes (about 1400 words in total) |
| LICENSE or plugin.json license | Both (MIT) |
| `.DS_Store` / `Thumbs.db` / `desktop.ini` | None |
| Symlinks (mode 120000) | None |
| Submodules / LFS | None |
| `git archive HEAD` size | 7,208,960 bytes (limit 52,428,800) |
| Non-image files over 256 KiB | 2 (the two mp4 files above) |
| `.zip` / `.pdf` / `.ico` / `.exe` | 1 (`skills/dist/claunchpad.zip`) |
| Tracked file count | 44 (limit 512) |
| Secrets in tracked files | None found (filename scan for secret/.env/.key/.pem) |
| Pinned npx/uvx executed by the plugin | The plugin runs no npx or uvx. Docs only: `npm install -g agent-browser` in the README and `templates/recommended-skills.md` is unpinned, and runs only after the user accepts the bootstrap offer. Consider pinning it (`agent-browser@<version>`) to be safe with the scanner |
| Security scan disclosure | README section "What it runs, reads and sends" covers writes, hooks, network and optional installs |
