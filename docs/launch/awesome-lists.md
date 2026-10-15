# Awesome-list entries for Claunchpad (HELD)

Drafts only. Nothing here has been submitted. A human submits each one, later, after launch traction.
Install line for reference: `/plugin marketplace add captkernel/plugins` then `/plugin install claunchpad@captkernel`.

Baseline signals recorded 2026-10-15: Claunchpad 0 stars, not on skills.sh. Skills Curator 3 stars, about 20 installs on skills.sh.

## 1. hesreallyhim/awesome-claude-code

Submit only after the Skills Curator recommendation is resolved (accepted or declined).

Rules (verified 2026-10-14 from CONTRIBUTING.md and the issue template):
- Submit through the web UI issue form only, by a human: https://github.com/hesreallyhim/awesome-claude-code/issues/new?template=recommend-resource.yml . Not a PR. The `gh` CLI cannot be used.
- One resource at a time.
- Resource must be at least 14 days old with ongoing commits, or have 100+ stars. Claunchpad qualifies on age and activity (first commit 2026-06-24).
- Description: descriptive, not a sales pitch, not addressed to the reader, no emojis. 10 to 500 characters.
- The bot discovers the license.

Form fields (template ids in parentheses):
- Display Name (`display_name`): Claunchpad
- Category (`category`, dropdown): Configuration
- Link (`link`): https://github.com/captkernel/Claunchpad
- Author Name (`author_name`): captKernel
- Author Link (`author_link`): https://github.com/captkernel
- Description (`description`): One-skill project setup for Claude Code. It writes a CLAUDE.md, turns on persistent memory shared across agents that survives /clear, sets rules for sizing agent teams, adds decision frameworks, and installs curated ecosystem skills.
- Checklist (`checklist`): tick every required box after actually doing each step. Leave the optional trap box unchecked.

Other category options in the template, if needed: Memory & Context Persistence, Multi-Purpose.

### On acceptance

Add this badge to the README:

```
[![Mentioned in Awesome Claude Code](https://awesome.re/mentioned-badge.svg)](https://github.com/hesreallyhim/awesome-claude-code)
```

## 2. VoltAgent/awesome-agent-skills

README line (add at the end of the subcategory):

```
- **[captkernel/claunchpad](https://github.com/captkernel/Claunchpad)** - One-skill project setup: CLAUDE.md, memory, agent teams
```

(8 words in the description.)

- Subcategory: Community Skills > Context Engineering (README checked 2026-10-15; the subcategories are now Vector Databases, Marketing, Productivity and Collaboration, Development and Testing, Context Engineering, Specialized Domains, n8n Automation). Alternative: Productivity and Collaboration.
- PR title: `Add skill: captkernel/claunchpad`
- Hold condition: about 25 stars or visible installs. The maintainers decline brand-new skills and say they focus on community-adopted ones. The decision to submit is the owner's.
- History: the earlier Skills Curator PR (#548) was closed on 2026-05-08 for lack of usage. Expect the same outcome without visible usage.
