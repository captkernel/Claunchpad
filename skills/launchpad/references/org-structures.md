# Org-structure catalog

> **appendix (Pro tier):** This is the full 13-structure catalog. The everyday front door is
> the 4-tier ladder in `references/orchestration.md`; reach here only when a structure beyond
> Pair, fan-out, or Workflow is genuinely warranted.

Thirteen team structures, smallest to largest. Pick the **cheapest one that clears the
quality bar** (see `orchestration.md` for the governor and triggers). Each entry: what it's
for, when to activate, the roles, its cost tier, and the output lift it buys.

Cost tiers: **¢** no fan-out · **$** small team · **$$** parallel formation · **$$$** program
(hand to a Workflow).

## Contents
- Tier 0, Solo
- Tier 1, Pair · Generator–Critic
- Tier 2, Scout-then-Build · Strike Team · Debug Task Force
- Tier 3, Research Pod · Review Board · Best-of-N · Red/Blue
- Tier 4, Council
- Tier 5, Assembly Line · Program
- Selection table

---

## Tier 0: no fan-out (¢)

### Solo
- **For:** trivial work, or tightly-coupled / same-file edits where parallelism causes
  conflicts.
- **Activate when:** the task is small, sequential, or all in one place.
- **Roles:** main thread only.
- **Output lift:** none needed; speed and simplicity are the win. Most tasks live here.
- **De-escalate to:** n/a (this is the floor).

## Tier 1: sequential quality loops (¢, best quality per token)

### Pair  *(default for any real change)*
- **For:** normal changes worth a second pair of eyes.
- **Activate when:** you're modifying real code or content and want it verified.
- **Roles:** Implementer → independent **Reviewer** (fresh context) → **Verify** gate (run
  test/build/lint and confirm output before claiming done).
- **Output lift:** catches the bugs the author can't see, at minimal cost. The cheapest
  quality you can buy.
- **De-escalate to:** Solo (trivial). **Escalate to:** Strike Team / a parallel formation.

### Generator–Critic
- **For:** tricky logic or important prose where one pass is mediocre, but a full team is
  overkill.
- **Activate when:** quality matters and the work is single-threaded.
- **Roles:** Generator produces → Critic attacks it adversarially → Generator revises (1–2
  rounds). Can be one agent switching lenses, or two.
- **Output lift:** large quality gain on a single artifact for a small, sequential cost.

## Tier 2: small focused teams ($)

### Scout-then-Build
- **For:** work in an unfamiliar codebase or problem area.
- **Activate when:** you'd otherwise pollute the main context with exploration before you can
  even start.
- **Roles:** a cheap **Scout** (Explore-style, read-only) maps the area and returns only the
  map → the builder proceeds informed.
- **Output lift:** keeps the main thread clean and the build well-targeted.

### Strike Team
- **For:** a focused, multi-step feature.
- **Activate when:** the change spans several steps or files but is one coherent piece of work.
- **Roles:** **Architect** (plan) → **Implementer(s)** → **Reviewer** → **Verifier**.
- **Output lift:** structure and a verification gate on a real feature, still cheap.
- **Note:** implementers run in parallel only when they touch different files; split by
  file/module, and never put two agents on one file. If the steps are coupled, keep it serial.

### Debug Task Force
- **For:** a stubborn bug with more than one plausible cause.
- **Activate when:** the cause isn't obvious and rival theories exist.
- **Roles:** parallel **hypothesis-testers** (one theory each) + **adversarial cross-check**
  (each tries to disprove the others) → root-cause synthesis.
- **Output lift:** converges on the real cause instead of fixing a symptom.

## Tier 3: parallel formations ($$, gated on triggers)

### Research Pod
- **For:** breadth-first investigation across independent angles.
- **Activate when:** there are 3+ distinct angles and the output would otherwise flood context.
- **Roles:** **Lead** decomposes → **3–5 Researchers** (one explicit angle each, distinct
  objectives) → **Synthesizer** cross-checks and reconciles.
- **Output lift:** wide, fast coverage; large time saving via parallel search.
- **Cost note:** ~15× a single pass, justify it with the breadth.

### Review Board
- **For:** a high-risk change that needs more than one lens.
- **Activate when:** the blast radius of a bug is large (security-sensitive, data, money).
- **Roles:** parallel reviewers, one **lens each** (correctness · security · performance ·
  tests/edge cases) → synthesis that prioritizes by severity.
- **Output lift:** catches failure modes a single reviewer misses.
- **De-escalate:** if two lenses repeatedly find nothing, drop to a single reviewer (Pair).

### Best-of-N / Tournament
- **For:** wide-solution-space problems where one attempt is likely mediocre.
- **Activate when:** design, algorithm, API shape, or naming with several viable directions.
- **Roles:** **N independent attempts** from different starting angles → **judge panel**
  scores them → **synthesis** takes the winner and grafts the best of the runners-up.
- **Output lift:** materially better artifact than one-attempt-iterated.

### Red / Blue
- **For:** correctness- or security-critical work.
- **Activate when:** being wrong is expensive and adversarial pressure would expose it.
- **Roles:** **Blue** builds/defends → **Red** independently attacks (edge cases, exploits,
  broken assumptions) → fixes → repeat until Red is out of attacks.
- **Output lift:** hardened result; finds what friendly review won't.

## Tier 4: judgment ($$)

### Council
- **For:** a consequential, hard-to-reverse **decision** (not a coding task), launch, hire,
  pivot, architecture, large spend, public commitment.
- **Activate when:** the call is expensive to undo and you want real dissent, not validation.
- **Roles:** five adversarial advisors (contrarian · first-principles · optimist · outsider ·
  executor) → anonymous peer review → **Chair** delivers a verdict + the hardest truth.
- **Output lift:** counters Claude's agreeableness exactly when stakes are highest.
- **Full play:** `council.md`.

## Tier 5: large programs → hand to a Workflow ($$$)

### Assembly Line
- **For:** the same transformation across many items (migration, codemod, batch audit).
- **Activate when:** there are 10+ targets that each flow through the same stages.
- **Roles:** each item runs **stage 1 → stage 2 → …** (e.g. transform → verify) independently,
  with no barrier between items.
- **Output lift:** scale with bounded wall-clock; deterministic coverage.
- **How:** stop hand-spawning, express it as a **Workflow `pipeline()`**.

### Program / Division
- **For:** a large build or migration spanning multiple modules.
- **Activate when:** the work needs several Strike Teams plus integration and QA.
- **Roles:** an **Orchestrator** over multiple sub-teams → **integration** → **QA/verify**.
- **Output lift:** coordinated delivery of work too big for one context.
- **How:** drive it with a **Workflow** (resumable, scriptable) rather than ad-hoc subagents;
  keep a human in the loop between phases.

---

## Selection table (cheapest first)

| Signal in the task | Structure | Tier |
|---|---|---|
| Trivial, or one coupled file | Solo | ¢ |
| A normal change worth reviewing | **Pair** *(default)* | ¢ |
| One important artifact, single-threaded | Generator–Critic | ¢ |
| Unfamiliar code to map first | Scout-then-Build | $ |
| A focused multi-step feature | Strike Team | $ |
| A bug with rival theories | Debug Task Force | $ |
| 3+ independent research angles | Research Pod | $$ |
| High-risk change, multiple lenses | Review Board | $$ |
| Wide solution space (design/algorithm) | Best-of-N / Tournament | $$ |
| Correctness/security-critical | Red / Blue | $$ |
| A hard-to-reverse decision | Council | $$ |
| 10+ uniform targets | Assembly Line (Workflow) | $$$ |
| Multi-module build/migration | Program (Workflow) | $$$ |
