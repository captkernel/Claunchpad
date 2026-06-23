# RENAME: swap the working name for the final name

This project was built under the **provisional working name `launchpad`**. The final
name is being chosen separately (originality-validated against GitHub / npm / PyPI / the
Claude skill ecosystem). Once chosen, renaming is a mechanical find-replace + two folder
renames. Nothing in the design depends on the name.

## What to change

1. **Folder names** (two):
   - `launchpad/`  →  `<final-name>/`            (project root)
   - `launchpad/skills/launchpad/`  →  `launchpad/skills/<final-name>/`  (skill folder, in
     Claude Code the skill's invoked name equals this directory name)

2. **In-file occurrences** of the working name. Replace whole-word, case-aware:
   - `launchpad`  →  `<final-name>`        (lowercase: frontmatter `name:`, paths, prose)
   - `Launchpad`  →  `<Final-Name>`        (Title case: headings, README)
   - `LAUNCHPAD`  →  `<FINAL-NAME>`        (if any all-caps usage)

   Files that mention it: `README.md`, `.pcc.json`, `skills/README.md`,
   `skills/launchpad/SKILL.md` (frontmatter `name:` + body), the four `references/*.md`,
   and `templates/CLAUDE.md` (the "invoke the <name> skill" pointer).

3. **The dist zip**: rebuild after renaming, with forward-slash paths (build via Python's
   `zipfile`, not PowerShell `Compress-Archive`, which writes backslash paths that break
   extraction on Linux/macOS and claude.ai). The repo's existing build does this.

## Constraints on the final name (already enforced when shortlisting)

- Lowercase letters, numbers, hyphens only; ≤ 64 chars.
- MUST NOT contain the reserved words **"claude"** or **"anthropic"** (skill-name rule).
- Should be original, no notable collision with an existing skill / tool / package / repo.

## Quick check after rename

- `skills/<final-name>/SKILL.md` frontmatter `name:` matches the folder name.
- No stray "launchpad" remains: search the tree for it and confirm only intended hits.
