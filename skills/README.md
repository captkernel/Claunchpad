# Skills (for Claude Code and claude.ai)

This project ships one skill, packaged the standard way so it runs on every surface.

- **launchpad** — `skills/launchpad/SKILL.md` · zip: `skills/dist/launchpad.zip`
  Sets a project up for Claude (bootstraps `CLAUDE.md` + a self-learning memory + a voice
  guide) and runs an efficiency-gated agent-team orchestration playbook with a 13-structure
  org catalog and a 5-advisor decision council.

The skill body stays lean; its depth lives in `skills/launchpad/references/`
(`orchestration.md`, `org-structures.md`, `self-learning.md`, `council.md`), which load only
when needed. The files written into a target project come from `skills/launchpad/templates/`.

**Claude Code:** copy `launchpad/` into `~/.claude/skills/` (global) or a repo's
`.claude/skills/`. **claude.ai:** upload `dist/launchpad.zip` (Settings → Capabilities →
Skills, or a Project).

> Name is provisional — see `../RENAME.md` before publishing.
