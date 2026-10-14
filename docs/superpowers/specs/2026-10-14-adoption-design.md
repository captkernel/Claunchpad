# Adoption & discoverability — captKernel public skills

> Spec date: 2026-10-14 · Status: approved · Phase 2 of 4 (hygiene → **adoption** → new capabilities → skill quality)

Flagships: `captkernel/Skills_Curator` (branch `main`) and `captkernel/Claunchpad` (branch `master`).
Also covered for installability: `captkernel/claude-thinking-tools`, `claude-writing-tools`,
`claude-everyday-tools` (all branch `main`).

**Identity:** everything public goes out under the **captKernel** brand. No captKernel social
accounts exist yet; Karan creates them and does all posting and portal submissions. Claude prepares;
nothing is posted or submitted on Karan's behalf.

**Strategy (staged funnel):** installable → findable → launch to get users → awesome-lists once there
is traction. Rationale: both active awesome-lists gate on adoption (hesreallyhim: "build, get users,
then submit"; VoltAgent: "real community usage", which closed PR #548 in May 2026).

## Baseline (2026-10-14)

- Skills Curator: 3 stars, 12 views / 9 uniques in 14 days, `plugin.json` v4.6.0, no `marketplace.json`, README 516 lines.
- Claunchpad: 0 stars, 7 views / 5 uniques, no plugin manifest, README 131 lines.
- Toolkits: no plugin manifests. All 5 repos have a LICENSE.
- GitHub profile `captkernel`: no name, bio, website or profile README; 2 followers.

## Stage 1 — Installable

1. **Hub marketplace repo `captkernel/plugins`** (new, public, MIT). Contents: `.claude-plugin/marketplace.json`, `README.md`, `LICENSE`.
   - Marketplace `name: "captkernel"`, `owner: {name: "captKernel", url: "https://github.com/captkernel"}`, `description` set.
   - One entry per plugin with `{"source": "github", "repo": "captkernel/<repo>"}`; entry `name` must equal that repo's `plugin.json` `name`.
   - User install: `/plugin marketplace add captkernel/plugins` → `/plugin install <name>@captkernel`.
2. **`plugin.json` in each repo** (`.claude-plugin/plugin.json`), with `name`, `version`, `description`, `author`, `homepage`, `repository`, `license`, `keywords`, `skills`. Plugin names avoid the restricted word "claude":

   | Repo | Plugin name | Version |
   |---|---|---|
   | Skills_Curator | `skills-curator` (exists) | 4.6.1 (content change, see below) |
   | Claunchpad | `claunchpad` | 1.0.0 |
   | claude-thinking-tools | `thinking-tools` | 1.0.0 |
   | claude-writing-tools | `writing-tools` | 1.0.0 |
   | claude-everyday-tools | `everyday-tools` | 1.0.0 |

   Each repo's README/CONTRIBUTING notes: bump `version` on every release or users never get updates.
3. **Self-marketplace per repo**: `.claude-plugin/marketplace.json` with one entry `{"name": "<plugin>", "source": "./"}`, so each README can offer `/plugin marketplace add captkernel/<repo>`.
4. **Bug fixes found while validating (2026-10-14), in scope because they block installs:**
   - 12 toolkit skills (all but `council`) and their `commands/*.md` have unparseable YAML frontmatter (unquoted `Triggers: "..."` in `description`), so Claude Code loads them with empty metadata and they never auto-trigger. Quote the descriptions; rebuild `skills/dist` zips.
   - `plugin.json` `skills` adds to the default `skills/` scan, so Skills Curator's plugin also loads the claude.ai edition. Move it to `editions/`; move root `CLAUDE.md` to `.claude/CLAUDE.md` (root one fails `--strict`). Release as 4.6.1.
   - Toolkit plugins set `"commands": []` so the duplicate `commands/` copies don't load beside the skills.
5. **Gate:** `claude plugin validate --strict` passes for all 5 repos and the hub; then a scratch install test (fresh dir, add hub marketplace, install all 5, confirm each skill is listed/loadable). Failures are fixed before Stage 2.

## Stage 2 — Findable

1. **README rework (both flagships).** First screen, in order: one-line pitch, launch reel, **plugin install** (fallbacks: manual copy into `~/.claude/skills/`, claude.ai zip), three proof bullets.
   - Skills Curator README cut from 516 to ~200 lines. Reference sections (command reference, architecture, FAQ, token cost, platforms, repository layout) move to `docs/` files and are linked; no content is deleted.
   - Both READMEs gain a short **"What it runs, reads and sends"** section (required by Anthropic's security scan).
   - Existing voice rules hold: no em dashes, descriptive not salesy.
2. **captKernel GitHub profile.** Set display name "captKernel", bio, website `https://captkernel.com`. New public repo `captkernel/captkernel` with a profile README that showcases the 5 tools, each with its install line and one-sentence description.
3. **Anthropic directory prep (Claunchpad + Skills Curator).** Run the pre-submission checklist: `plugin.json` present; valid name; README ≥ 40 words; LICENSE; no `.DS_Store`/`Thumbs.db`/`desktop.ini`; no symlinks/submodules/LFS; repo < 50 MiB; valid SKILL.md frontmatter (description a single string); no secrets; no non-image file > 256 KiB or binaries that would hold review, or a documented reason for each. Fix failures. Produce `docs/launch/directory-submission.md` per flagship with every portal field pre-filled (listing copy, data-handling answers, compliance acknowledgements). Karan submits at claude.ai/directory/manage.
4. **Registries.** Add topics `agent-skills`, `claude-code-plugin`, `claude-skills` to all 5 repos (keeping existing ones). Check whether skills.sh already indexes the flagships; record the result.

## Stage 3 — Launch kit (prepared, not posted)

- **Two launches ~1 week apart:** Skills Curator first, Claunchpad second (it references Skills Curator as its curation layer).
- **Per launch**, in `docs/launch/social/` of that repo: Reddit (r/ClaudeAI, r/ClaudeCode), Show HN title + first comment, X thread, LinkedIn post, IG carousel + caption. Plugin install line first. No em dashes, ends on a real question. All `@kayparmar` placeholders replaced with the captKernel brand; DRAFT banner removed from Claunchpad's existing kit once rebranded.
- **Skills Curator gets its own social kit** modelled on Claunchpad's `social/`.
- **`docs/launch/CHECKLIST.md`** (Claunchpad repo, covering both launches): create accounts, set bios/links, warm-up guidance (new Reddit/HN accounts are filtered; weeks of genuine participation first), posting order and timing, and the fallback of posting Reddit/HN from Karan's personal aged accounts as "built by captKernel" with no copy changes.

## Stage 4 — Listings (drafted, held)

- **hesreallyhim/awesome-claude-code:** both repos already meet rule (i) (≥14 days old with ongoing commits). Draft the web-form entry for Skills Curator (one line, descriptive, no emojis). Karan submits via the web UI form after the Skills Curator launch. Claunchpad's entry is drafted but goes in only after Skills Curator's is resolved (one at a time).
- **VoltAgent/awesome-agent-skills:** draft entries for both (`Add skill: captkernel/<name>`, description ≤ 10 words). Hold until real usage; suggested bar ~25 stars or visible installs, Karan decides.
- On acceptance, add the "Mentioned in Awesome Claude Code" badge to the README.
- Drafts live in `docs/launch/awesome-lists.md` per flagship.

## Out of scope

Skill content changes (phase 4), new features (phase 3), creating social accounts, posting, portal submission, paid promotion.

## Done when

- `claude plugin validate --strict` passes on all 5 repos and `captkernel/plugins`; scratch install of all 5 plugins succeeds.
- Both flagship READMEs show the plugin install command on the first screen; Skills Curator README ≤ ~200 lines with reference content preserved in `docs/`.
- GitHub profile has name, bio, website and a live profile README.
- Directory submission sheets, both launch kits, the checklist and awesome-list drafts exist and are committed.
- Existing gates still pass: Skills Curator `pytest`, Claunchpad `tools/validate.sh`.
- Nothing posted or submitted on Karan's behalf.
