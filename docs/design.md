# Design — `<NAME-TBD>`: an importable skill that makes Claude operate at its best on any project

> Spec date: 2026-06-24 · Status: approved design, pre-implementation
> Working name: **`<NAME-TBD>`** (project folder + skill share the name; final name chosen
> before ship — must be lowercase-hyphen, ≤64 chars, and must NOT contain "claude" or
> "anthropic", which are reserved skill-name words).

## 1. Purpose

One importable Claude skill that anyone can drop into a new or existing project to get the
most out of Claude immediately: disciplined working rules, a persistent **self-learning**
knowledge base shared across agents, a distinctive voice, and an **efficiency-gated agent
team / org-structure orchestration playbook** — including a high-stakes **decision council**.

It packages, generalised for anyone, the self-learning + memory pattern this workspace
already runs (`C:\Claude\CLAUDE.md`).

Non-goals: it is not an installer framework, not a CI tool, not provider-specific. It ships
no runtime dependency — it is prompt + templates only.

## 2. Design principles (from research — see §11 for sources)

1. **Match how Claude actually loads context.** `CLAUDE.md` loads every session (keep it
   cheap, < ~200 lines); skills load on demand (body < 500 lines / < 5k tokens); reference
   files load only when pointed to (richer). This dictates the two-layer architecture.
2. **Efficiency is a first-class constraint, not an afterthought.** Multi-agent work costs
   ~15× tokens and *hurts* on tightly-coupled work. The playbook defaults to the smallest
   structure and escalates only on observable triggers.
3. **Smallest set of high-signal tokens.** Every file justifies its token cost; assume the
   agent is already smart; add only what it doesn't know.
4. **Self-sufficient on re-read.** Memory/learning files must make sense to a fresh agent
   after a context reset; they carry their own protocol.
5. **Form matches failure.** Discipline failures → prohibition + rationalization table +
   red-flags. Output-shape failures → positive recipe/template. (Skills-authoring research.)
6. **Graceful degradation.** Full power in Claude Code (subagents, filesystem); on claude.ai
   (no subagents, no filesystem) the same plays run as sequential persona passes, behaviour
   only.

## 3. Architecture — two layers

- **Always-on layer = bootstrapped files** written into the target repo on first run. Read
  every session automatically. Must stay cheap and specific.
- **On-demand layer = the skill body + references.** Loaded only when triggered. Carries the
  heavier orchestration, org catalog, self-learning protocol, and council.

You import **one skill**. Part of what it does on first run is write the always-on files.

### 3.1 Project tree

```
<NAME-TBD>/                              # standalone project (sibling to other C:\Claude\Toolkits projects)
├─ README.md            # what it is + install for Claude Code / claude.ai / API
├─ LICENSE
├─ .pcc.json            # dashboard integration (category "Toolkits (Public)")
└─ skills/
   ├─ README.md
   ├─ <NAME-TBD>/                        # the skill (name == directory name in Claude Code)
   │  ├─ SKILL.md                        # lean hub: triggering + bootstrap steps + playbook overview + pointers
   │  ├─ references/
   │  │  ├─ orchestration.md              # efficiency governor + escalation + cost model + delegation rules + degradation
   │  │  ├─ org-structures.md             # the 13-structure catalog
   │  │  ├─ self-learning.md              # the shared inject-and-harvest learning protocol
   │  │  └─ council.md                    # 5-advisor high-stakes-decision play
   │  └─ templates/                       # written into the TARGET project on bootstrap
   │     ├─ CLAUDE.md                     # < 200 lines, specific, hard-rules-first, points back at the skill
   │     ├─ MEMORY.md                     # self-maintaining decision log
   │     ├─ ERRORS.md                     # self-maintaining failure+resolution log
   │     ├─ LEARNINGS.md                  # self-maintaining techniques/research store
   │     └─ anti-style.md                 # voice guide
   └─ dist/
      └─ <NAME-TBD>.zip                   # ready-to-upload for claude.ai
```

All reference files are **exactly one level deep** from SKILL.md (deeper nesting causes
partial reads). Any reference > 100 lines opens with a table of contents.

## 4. The skill: `SKILL.md`

Lean hub (< 500 lines, target < 5k tokens). Responsibilities:

### 4.1 Frontmatter

- `name: <NAME-TBD>` — lowercase-hyphen, ≤64, no "claude"/"anthropic".
- `description` — third person; **what + when + trigger phrases only; NO workflow recap**
  (the #1 documented trigger failure is summarising the procedure in the description, which
  makes agents follow the description and skip the body). Draft:

  > "Sets up a project so Claude performs at its best and orchestrates work as an
  > efficiency-gated team of subagents with a shared self-learning memory. Use when starting
  > or initializing a project, when configuring a repo for Claude, when planning or executing
  > substantial multi-step or multi-file work that benefits from delegation or parallel
  > agents, or before a consequential, hard-to-reverse decision. Trigger phrases: 'set up
  > this project', 'initialize <NAME-TBD>', 'run this as a team', 'orchestrate this', 'spin
  > up agents', 'review board', 'council this', 'pressure-test this decision'."

  (≤ 1024 chars; final string trimmed during implementation.)

### 4.2 Body sections

1. **What this does / when to use** — bullets of triggers + an explicit *when NOT to use*
   (trivial one-off edits, tightly-coupled work → stay solo).
2. **First-run bootstrap** — numbered steps (see §8). Plan-then-write; skip existing files.
3. **Orchestration overview** — the efficiency governor in brief + a selection flowchart
   (graphviz `dot`), then "load `references/orchestration.md` and `references/org-structures.md`
   when escalating beyond Solo/Pair."
4. **Self-learning in one paragraph** + "load `references/self-learning.md`."
5. **High-stakes decisions** → "load `references/council.md`."
6. **Pointers table** — each reference with a one-line "what it contains + when to load it."

Discipline-skill house style throughout: "violating the letter is violating the spirit," a
rationalization table, and a red-flags STOP list for the efficiency rules (so the agent
doesn't talk itself into over-orchestrating or skipping verification).

## 5. Reference: `orchestration.md` — the efficiency governor

Opens with a TOC. Leads with the **non-negotiable governor**, because efficiency is the
critical constraint:

- **Default to the smallest structure.** Start Solo or Pair. Most tasks never escalate.
- **Escalate one tier only on an observable trigger:** ≥3 independent parallelizable
  subtasks · high context-pollution risk · need for independent verification · high stakes ·
  wide solution space.
- **De-escalate** the moment a cheaper structure would do.
- **Cap concurrency at 3–5**; at 10+ targets hand off to a Workflow (don't hand-spawn).
- **Never parallelize tightly-coupled or same-file work** (last-write-wins data loss).
- **Route models per role** as a cost lever: Haiku for mechanical/classification, Sonnet for
  build, Opus for hard reasoning/synthesis.
- **One reviewer by default**; escalate to a panel only when risk is high.
- **Cost-vs-value gate** before any escalation: multi-agent ≈15× tokens; only justified for
  high-value, breadth-first, independent work.

Then:

- **Delegation-prompt contract** (subagents inherit no parent context/memory — only CLAUDE.md
  + the spawn prompt): every delegation states objective, scope/boundaries, **the relevant
  learnings injected** (see §7), output format, tool guidance, and stop criteria. Vague
  delegation causes duplicate work and gaps.
- **CLAUDE.md ↔ subagent gotcha:** custom subagents inherit CLAUDE.md, but built-in
  Explore/Plan agents skip it — so restate load-bearing rules in the spawn prompt for those.
- **Synthesis rules:** cross-check findings across agents, flag conflicts, preserve sources.
- **Graceful degradation:** on platforms without subagents, run the same roles as sequential
  persona passes (clear context between passes); cheaper but slower, no isolation.
- **Selection decision tree** (work-shape → smallest fitting structure).

## 6. Reference: `org-structures.md` — the catalog (13 structures)

Opens with a TOC. Each entry is terse: **purpose · activate-when · roles · cost tier ·
output lift · de-escalate-when.** Cost tiers: ¢ (no fan-out) · $ (small team) · $$ (parallel)
· $$$ (program → Workflow).

Tier 0 — no fan-out (¢):
- **Solo** — main thread only. Trivial, or tightly-coupled/same-file work.

Tier 1 — sequential quality loops (¢; best quality-per-token):
- **Pair** *(default for real changes)* — Implementer + independent Reviewer + Verify gate.
- **Generator–Critic** — produce → adversarial critique → revise (1–2 rounds). Tricky logic
  or prose, no fleet.

Tier 2 — small focused teams ($):
- **Scout-then-Build** — cheap Explore agent maps unknowns first (context isolation), then
  build proceeds informed. Unfamiliar code.
- **Strike Team** — Architect → Implementer(s) → Reviewer → Verifier. Focused feature.
- **Debug Task Force** — parallel competing-hypothesis testers + adversarial cross-check →
  root cause.

Tier 3 — parallel formations ($$; gated on triggers):
- **Research Pod** — Lead → 3–5 parallel researchers (distinct angles) → Synthesizer.
- **Review Board** — parallel multi-lens reviewers (security/perf/correctness/tests) →
  synthesis. High-risk changes.
- **Best-of-N / Tournament** — N independent attempts from different angles → judge panel →
  synthesize winner, grafting best of runners-up. Wide solution space (design, algorithm).
- **Red / Blue** — one side builds, an independent side attacks. Correctness/security-critical.

Tier 4 — judgment ($$):
- **Council** — 5 advisors + Chair (full play in `council.md`). Consequential, hard-to-reverse
  decisions.

Tier 5 — large programs → hand to a Workflow ($$$):
- **Assembly Line** — fixed stages per item (transform → verify), no barrier between items;
  migrations/batch over many files. Maps to a Workflow `pipeline()`.
- **Program / Division** — orchestrator over several Strike Teams + integration/QA. 10+
  targets → hand off to a Workflow rather than ad-hoc subagents.

A summary selection table at the end maps task signal → recommended structure, ordered cheapest
first.

## 7. Reference: `self-learning.md` — the shared agent brain

The protocol that lets every agent learn from experience + research and not repeat mistakes.

- **Three on-disk stores** (bootstrapped templates; self-maintaining; newest-first; capped
  ~20 entries / ~400 lines then compacted into a rolled-up summary):
  - `MEMORY.md` — decisions & why (+ rejected alternatives).
  - `ERRORS.md` — **failures + resolutions** (symptom · cause · fix/rule · status).
  - `LEARNINGS.md` — durable techniques & research findings ("how to do X well here").
- **The inject-and-harvest loop** (because subagents can't read these files themselves):
  1. Orchestrator reads the entries relevant to the task.
  2. **Injects** them into each subagent's delegation prompt (a "What we already know" block).
  3. Subagent does the work and returns, in a **required result slot**, any new
     failure+fix or learning it discovered.
  4. Orchestrator **harvests** that and appends it to the right store (deduping / curating).
  5. The next relevant task gets it for free.
- **Single-agent / main-thread variant:** read at session start, append before session end —
  the classic ritual; no injection needed since it's all one context.
- **Maintenance rules embedded in each file:** read-first, one-fact-per-entry, absolute
  dates, log verified outcomes not intentions, don't duplicate code/git, curate + hard cap.
- **claude.ai degradation:** no filesystem → the loop is in-session only; the stores can be
  pasted in / exported manually.

## 8. Bootstrap flow (done by Claude via the Write tool — no installer script)

On first invocation in Claude Code:

1. Detect project context (language, framework, package manager, test/build commands) by
   inspecting the repo.
2. Present a short plan of which files will be created (plan-then-write).
3. Write `CLAUDE.md`, `MEMORY.md`, `ERRORS.md`, `LEARNINGS.md`, `anti-style.md`, filling
   `CLAUDE.md` placeholders from what was detected. **Skip any file that already exists**
   unless the user says to overwrite.
4. Tell the user what was created and what to fill in.

On claude.ai (no filesystem): skip file writes; apply the behaviours in-session and offer the
templates as copy-paste blocks.

### 8.1 `CLAUDE.md` template (always-on, < 200 lines)

- One-line "what this is."
- **Tech stack (locked)** — language/framework/package-manager/tests/lint, version-pinned.
- **Run / test / build** — exact commands.
- **Working rules (the four):** ask-don't-assume · simplest-first · don't-touch-unrelated ·
  flag-uncertainty.
- **Conventions** — follow existing patterns; project-specific notes.
- **Hard stops** — deletes/overwrites, schema changes, migrations, deploys, external calls.
- **Self-learning pointer:** read `MEMORY.md` / `ERRORS.md` / `LEARNINGS.md` at start; append
  per their embedded protocols.
- **Orchestration pointer:** for substantial multi-step / multi-file / high-stakes work,
  invoke the `<NAME-TBD>` skill and use the efficiency-gated playbook.
- **Voice pointer:** see `anti-style.md`.

### 8.2 `MEMORY.md`, `ERRORS.md`, `LEARNINGS.md`

Each carries an embedded self-maintenance comment block (protocol + entry template), a `## Log`
/ `## Failures` / `## Learnings` section (newest first), and a `## Rolled-up summary` /
`## Known gotchas` compaction section. Formats per §11 research.

### 8.3 `anti-style.md`

Honesty-over-agreeableness preamble; **Never use these words** list; **Never use these
structures** list (rule-of-three, "not just X but Y", em-dash overuse, hedging stacks, empty
openers, hollow intensifiers, bold overuse, placeholder leakage); **Always do this** list
(lead with the point, precision verbs, one idea per sentence, vary rhythm, concrete over
vague, first person allowed); a **self-check before sending**.

## 9. Packaging & distribution

- **Claude Code:** copy the skill folder to `~/.claude/skills/<NAME-TBD>/` (global) or a
  repo's `.claude/skills/<NAME-TBD>/`.
- **claude.ai:** upload `dist/<NAME-TBD>.zip` via Settings → Skills (or to a Project).
- **API:** uploadable via the skills endpoint (note beta headers); conform to strictest
  constraints (no network, no runtime installs) so one folder runs everywhere.
- Project ships README (3-surface install instructions), LICENSE, `.pcc.json`. The new
  project gets its own git repo (`git init`) since `C:\Claude\Toolkits` is not itself a repo;
  the design doc + initial scaffold are the first commits.

## 10. Testing & validation (RED-GREEN-REFACTOR)

- **Baseline (RED):** give a fresh subagent a representative task *without* the skill; capture
  the failure (over-orchestrates, or skips verification, or repeats a known error, or writes
  AI-slop voice).
- **With skill (GREEN):** same task with the skill loaded; confirm the behaviour changes
  correctly (picks the smallest fitting structure, injects learnings, verifies before
  claiming done, clean voice).
- **Structural validation:** frontmatter valid (name rules, description ≤1024, third person,
  no workflow recap); SKILL.md < 500 lines; references one level deep; >100-line refs have a
  TOC; all bundled files referenced from SKILL.md.
- **Packaging check:** `dist/<NAME-TBD>.zip` builds and contains the full skill folder.
- Test on the model tiers the skill routes to (Haiku/Sonnet/Opus differ in adherence).

## 11. Research basis (sources)

CLAUDE.md / memory: https://code.claude.com/docs/en/memory · skills:
https://code.claude.com/docs/en/skills · subagents: https://code.claude.com/docs/en/sub-agents ·
workflows: https://code.claude.com/docs/en/workflows · multi-agent research system:
https://www.anthropic.com/engineering/multi-agent-research-system · context engineering:
https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents ·
long-running agents: https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents ·
memory tool: https://platform.claude.com/docs/en/agents-and-tools/tool-use/memory-tool ·
skills best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices ·
local authority: superpowers `writing-skills` skill. Anti-sycophancy/voice: Anthropic persona
vectors + community avoid-ai-writing consensus.

Key constraints captured: skill names cannot contain "claude"/"anthropic"; description must
not recap the workflow; CLAUDE.md < ~200 lines and Explore/Plan subagents skip it; SKILL.md
< 500 lines / refs one level deep with TOC > 100 lines; multi-agent ≈15× tokens (efficiency
gate); subagents inherit only CLAUDE.md + spawn prompt (hence inject-and-harvest);
memory files self-maintaining with hard caps + compaction.

## 12. Open items (resolved before ship, not blocking the plan)

- **Final name** — chosen with socialisation in mind; find-replace `<NAME-TBD>`.
- Exact `description` string (≤1024) finalised during implementation.
- Whether to also ship an optional `.claude/rules/` path-scoped example (deferred unless
  wanted — keep YAGNI).
