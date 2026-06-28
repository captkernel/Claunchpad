# Skills (for Claude Code and claude.ai)

This project ships one skill, packaged the standard way so it runs on every surface.

- **launchpad**, `skills/launchpad/SKILL.md` · zip: `skills/dist/launchpad.zip`
  Provisions a project-OS for Claude in one of three tiers (Starter / Standard / Pro):
  writes `CLAUDE.md`, hybrid memory (`MEMORY.md` + per-fact `memory/` dir), delegation
  contract, and hooks (`load-memory` SessionStart, `harvest-nudge` Stop), then positions
  councils (5-advisor decision council, 4-lens feasibility council) and a 4-tier
  orchestration ladder with a 13-structure org catalog on top.

The skill body stays lean; its depth lives in `skills/launchpad/references/`
(`provisioning.md`, `memory.md`, `delegation.md`, `orchestration.md`, `org-structures.md`,
`self-learning.md`, `council.md`, `feasibility-council.md`), which load only when needed.
The files written into a target project come from `skills/launchpad/templates/`.

**Claude Code:** copy `launchpad/` into `~/.claude/skills/` (global) or a repo's
`.claude/skills/`. **claude.ai:** upload `dist/launchpad.zip` (Settings → Capabilities →
Skills, or a Project).

> Name is provisional, see `../RENAME.md` before publishing.
