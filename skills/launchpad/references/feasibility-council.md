# Feasibility Council: four-lens project viability review

The structure for evaluating whether a whole **project, product, or venture can actually work**,
across the dimensions that decide its fate in the real world. Where the decision council
([[council]]) pressure-tests a single irreversible *choice* with adversarial reasoning roles,
this council pressure-tests an *initiative's viability* with functional domain roles, each
asking "can this work from where I sit?" The output is a feasibility read per dimension and an
overall verdict gated by the weakest link.

## Contents
- When to convene
- How to invoke
- The weakest-link principle
- The procedure
- The four lenses (verbatim mandates)
- The Chair
- Worked example
- Optional lenses
- Council vs. Council: which to run
- Notes

## When to convene

When you're deciding whether to **commit real resources to a project**: greenlighting a new
product or feature line, before sinking weeks of build time into a bet, evaluating a venture or
side-project for go/no-go, or a periodic health check on something already in flight ("is this
still viable?"). It answers *can this work, and where will it break?* — not the narrower *should
I commit to this one decision?* that the decision council handles.

Do **not** convene for a single reversible call, a coding task, or a project so early it's still
just a sentence. Frame it first.

## How to invoke

State the project as a concrete thing being built and sold, not a theme.
- Good: "Build a Claude-skill marketplace, charge creators 10%, launch to the Claude Discord in 8 weeks."
- Weak: "a skills marketplace."

If the project is under-specified, ask **one** clarifying question (what's being built, who pays,
what "launched" means) before convening.

Runs as sequential lens passes in one thread, or — for a deep case — as parallel subagents (one
per lens, each given only its mandate + the framed project), then cross-examination and Chair in
the main thread. Parallel keeps the lenses honest and independent.

## The weakest-link principle

A project's feasibility is set by its **worst dimension, not its average.** Green on tech,
finance, and marketing but Red on distribution is a **Red project** — you will build a thing that
works, costs out, and that nobody can reach. The Chair's job is to find the binding constraint,
not to average four scores into a comfortable amber. Resist the urge to feel good because three
of four lenses are happy.

## The procedure

Run these phases in order and show each:

1. **Frame.** Restate the project in one sentence as a concrete build-and-sell commitment, and
   name the core bet, what's being spent, what success looks like, and the deadline.
2. **Four assessments.** Each lens speaks once, in character, using its exact mandate below.
   Each gives a **feasibility read (Green / Amber / Red)** for its dimension, its top 1–3 risks,
   what would have to be true for it to go Green, and ends with that lens's sharpest single
   question. Pure optimism is forbidden: if a lens sees no problem, it names the assumption that,
   if wrong, turns its dimension Red.
3. **Cross-examination (dependency clash).** Each lens names where **another lens's plan breaks
   its own** — the contradictions between functions that sink projects. (Marketing's growth curve
   blows up Finance's CAC; Tech's timeline misses GTM's launch window; GTM's enterprise motion
   can't carry Finance's $20/mo price.) Surface every clash; these inter-dependencies are where
   feasibility actually dies.
4. **Chair's verdict.** A fifth voice synthesizes: an **overall feasibility verdict**
   (*Feasible* · *Feasible with conditions* · *Not yet — validate first* · *Infeasible as
   framed*), the **binding constraint** (the single weakest link that gates the whole project),
   the **2–3 validation steps** that would most cheaply de-risk it before committing, and, set off
   on its own, **The thing that has to be true:** the one load-bearing assumption the entire
   project rests on across all four lenses.

Rules across all phases: lenses assess the project, not each other; no lens may rate its
dimension Green without naming what would flip it Red; the Chair takes a position on the binding
constraint rather than hedging; an honest Red is more valuable than a hopeful Amber.

## The four lenses (use this mandate text verbatim)

### 01 · TECHNOLOGY / BUILD: can it be built and operated
> You are the Head of Technology. Judge whether this can actually be built *and operated* with
> the team, stack, and timeline truly available — not in theory, in practice. Name the hardest
> technical unknown, the part everyone assumes is easy but isn't, the scaling or reliability
> cliff, the day-2 maintenance and on-call cost nobody priced in, and any dependency on a
> vendor, API, or model that could change under you. Don't hide behind "it's all doable with
> enough time" — say what it costs in real weeks and people. Give a feasibility read (Green /
> Amber / Red) on the build and state what would flip it to Green. End with the single technical
> unknown that, if it goes wrong, blows the timeline or forces an architecture rewrite.

### 02 · FINANCE / ECONOMICS: does the money work
> You are the Head of Finance. Ignore the vision; interrogate the money. Does a single unit make
> money — what does it cost to acquire a customer, what do they pay, what's the gross margin,
> when does it break even, and how much capital does it burn to get there? Separate real numbers
> from hopeful ones and name where the model rests on a figure nobody has earned yet. Stress the
> runway: if it takes twice as long and costs twice as much — it will — does the business still
> survive? Give a feasibility read (Green / Amber / Red) on the economics and state what would
> flip it to Green. End with the one financial assumption that, if it's off by 2x, breaks the
> model.

### 03 · GO-TO-MARKET / DISTRIBUTION: can it reach and convert buyers
> You are the Head of Go-to-Market. Product and vision don't matter if no one can reach the
> buyer. Pin down the actual motion: who exactly buys this, through what channel, with what sales
> cycle, and at what cost to get in front of them. Is there a repeatable, affordable path from
> stranger to paying customer — or is the plan "we'll figure out distribution later"? Name the
> channel being assumed without evidence, and whether the price point fits the channel (a $20/mo
> product can't carry a field-sales motion; an enterprise deal can't run on a tweet). Give a
> feasibility read (Green / Amber / Red) on distribution and state what would flip it to Green.
> End with the question: what is the first repeatable channel, and has anyone proven it converts?

### 04 · MARKETING / POSITIONING & DEMAND: does anyone want it, can they be made to care
> You are the Head of Marketing. Your concern is demand and perception: does anyone actually want
> this, and can you make them care enough to switch? Nail the positioning in one line — who it's
> for, what it replaces, and why it's obviously better *for them*, not merely different. Name the
> competitor or status-quo behavior you're really fighting (often "they do nothing"), and whether
> the differentiation is real or a minor feature being inflated into a story. Say plainly whether
> this is a vitamin (nice to have) or a painkiller (urgent). Give a feasibility read (Green /
> Amber / Red) on demand and positioning and state what would flip it to Green. End with the
> question: in the customer's own words, why would they switch — and have you actually heard them
> say it?

## The Chair

> You are the Chair. You do not have a functional axe to grind; your job is judgment. Read the
> four assessments and the cross-examination. Identify the **binding constraint** — the single
> weakest dimension that gates the whole project, because feasibility is set by the worst lens,
> not the average. Do not average four reads into a comfortable amber. Deliver a verdict
> (*Feasible* · *Feasible with conditions* · *Not yet — validate first* · *Infeasible as
> framed*), the 2–3 cheapest validation steps that would most reduce the biggest uncertainty
> before any real commitment, and end — set off on its own — with **The thing that has to be
> true:** the one load-bearing assumption the entire project rests on. Take a position; a chair
> who hedges is useless.

## Worked example

**Invocation:** "council this project: build a Claude-skill marketplace, take 10% of creator
sales, launch to the Claude community in 8 weeks."

**Frame**, Commitment: build a two-sided marketplace (creators list skills, buyers purchase),
take a 10% cut, launch in 8 weeks. Bet: there's enough paid demand for skills to support a
marketplace. Spent: 8 weeks of build + ongoing ops. Success: live storefront with paying
transactions. Deadline: 8 weeks.

**Assessments (abridged)**
- **Technology — Amber:** Listing and checkout are easy; trust and safety isn't — you're hosting
  third-party code that runs in users' agents, so sandboxing, review, and abuse handling are the
  real build, and they're not in the 8 weeks. *Who reviews submitted skills for malicious code,
  and is that manual forever?*
- **Finance — Red:** 10% of low-priced skills is pennies per sale; at any plausible volume the
  take-rate doesn't cover review/ops cost. The model needs either high prices or huge volume,
  and you have neither yet. *How many transactions a month at what average price clears your costs?*
- **GTM — Amber:** You have a warm channel (the community), but that's a one-time launch spike,
  not a repeatable acquisition engine. After launch week, where do new buyers come from? *What's
  the channel for buyer #1,000, not buyer #10?*
- **Marketing — Amber:** Creators want this (supply is easy to recruit); the open question is
  *buyer* demand — most people expect skills free. You're fighting "they'll just grab it off
  GitHub." *Have you heard a single buyer say they'd pay rather than copy it free?*

**Cross-examination** — Finance vs. Marketing: free-on-GitHub kills the price point Finance needs.
Tech vs. Finance: the trust-and-safety cost Tech named is exactly the fixed cost Finance can't
cover at a 10% take. GTM vs. Marketing: the launch spike masks that there's no proven repeat-buyer
demand. The clashes converge on one thing: **paid demand is unproven and the economics only work
if it's strong.**

**Chair's verdict**, **Not yet — validate first.** Binding constraint: **buyer willingness to pay**
(Finance Red, driven by the Marketing question). Validation steps: (1) pre-sell — get 20 people to
actually pay for 3 existing skills before building anything; (2) price-test to find a point where
10% covers per-transaction review cost; (3) scope a manual, non-marketplace trust process so safety
cost is known before automating.

> **The thing that has to be true:** people will pay for skills they could copy for free — and you
> have zero evidence of that yet, which makes the marketplace a bet on demand you haven't tested,
> dressed up as a build problem.

## Optional lenses

Add a lens when a project's risk concentrates there; keep the core four otherwise.
- **Operations & Risk** — legal, regulatory, compliance, support load, day-2 running cost. Convene
  for anything touching payments, health, finance, minors, or user data.
- **Customer / Product** — depth of the user need and retention, beyond first purchase. Convene
  when the worry is "will they keep using it," not "will they buy it."
- **Team / Org** — do we have, or can we hire and keep, the people this requires? Convene when the
  plan depends on talent you don't yet have.

## Council vs. Council: which to run

- **Feasibility Council (this file):** *Can this project work, and where does it break?* Functional
  lenses, a whole initiative, a per-dimension viability read. Run it to **evaluate** a project.
- **Decision Council ([[council]]):** *Should I commit to this one irreversible choice?* Adversarial
  reasoning roles, a single decision, a verdict on the hardest truth. Run it to **decide**.

They compose: run the Feasibility Council to find whether and how a project can work, then — once
you know the shape — the Decision Council on the specific go/no-go commitment.

## Notes

- The value is the binding constraint, not the average score. Four greens that hide one
  fatal red is the failure mode this exists to catch.
- An honest Red now is cheaper than a hopeful Amber that costs you eight weeks.
- Self-contained: no tools, accounts, or installs. Prompt structure only.
