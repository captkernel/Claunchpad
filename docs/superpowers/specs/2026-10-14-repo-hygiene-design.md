# Repo hygiene — Claunchpad + Skills Curator

> Spec date: 2026-10-14 · Status: approved · Phase 1 of 4 (hygiene → adoption → new capabilities → skill quality)

Covers both public repos: `captkernel/Claunchpad` (branch `master`) and
`captkernel/Skills_Curator` (branch `main`). No skill content changes in this phase.

## 1. Move render clutter out of the repos

Every untracked item at the time of writing is promo-production output (IG cuts, drafts,
superseded reels, reel composition pieces, Playwright screenshots, campaign brief). Move all of
it, unchanged, to a sibling media folder:

| Repo | Destination |
|---|---|
| `C:\Claude\Toolkits\launchpad` | `C:\Claude\Toolkits\_media\claunchpad\` |
| `C:\Claude\Skills\Skills_Curator` | `C:\Claude\Skills\_media\skills-curator\` |

Verify file count and total bytes match before and after each move. Nothing is deleted.
Finished reels already tracked under `docs/video/` stay where they are.

## 2. Prevent recurrence (`.gitignore`, both repos)

Add:

```
# Render / promo production output — lives in ../_media/
*-output-*/
ratio-*/
.playwright-mcp/
*-preview.html
/*.png
# Local dashboard status file
.pcc.json
```

Skills Curator also gains `node_modules/`, `*.log`, `.remember/` (parity with Claunchpad).

## 3. Remove stale and private content

- **Claunchpad `.pcc.json`**: tracked publicly but holds internal workspace notes. Untrack with
  `git rm --cached` (file stays on disk for the local dashboard) and refresh its stale content
  (name is final: "Claunchpad").
- **Claunchpad `RENAME.md`**: delete — the name is final.
- **`skills/README.md`**: remove the "Name is provisional, see `../RENAME.md`" line.
- **`docs/design.md`**: historical spec; add one line under the header noting it shipped as
  Claunchpad. Do not rewrite the body.
- `.superpowers/sdd/*` mentions are untracked working files; leave them.

## 4. Claunchpad GitHub metadata

Mirror the Skills Curator pattern via `gh repo edit`:

- **Description:** "Drop in one skill and Claude starts working like someone who knows what
  they're doing: persistent memory, self-sizing agent teams, curated skills, zero setup."
- **Topics:** `claude-code`, `claude-skills`, `agent-skills`, `anthropic`, `ai-agents`,
  `project-setup`, `memory`, `claude-md`
- **Homepage:** the interactive showcase URL from the README.

## 5. Commit and push

One `chore: repo hygiene` commit per repo, pushed to its default branch. This spec is
committed with the Claunchpad change.

## Done when

- `git status` is clean in both repos.
- Skills Curator: `pytest` passes (37 tests).
- Claunchpad: `skills/claunchpad/tools/validate.sh` passes.
- The Claunchpad GitHub page shows the description, topics and homepage.
