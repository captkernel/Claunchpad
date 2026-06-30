# Council: five-advisor decision pressure-test

The structure for a consequential, hard-to-reverse **decision** (not a coding task). Claude is
agreeable by default, ask if an idea is good and it argues yes; ask if it's bad and it argues
that too. That sycophancy is most expensive exactly when stakes are highest. The council
forces structured disagreement and ends with the truth you're most likely resisting.

## Contents
- When to convene
- How to invoke
- The procedure
- The five advisors (verbatim mandates)
- Worked example
- Notes

## When to convene

Before any decision that is **consequential and hard to reverse**: launching something public,
hiring/firing, pivoting or killing a project, a large or recurring spend, an irreversible
architecture choice, signing a contract, a public promise.

Do **not** convene for low-stakes, reversible choices, it's deliberately heavy. A single
contrarian pass is enough there.

## How to invoke

State the decision as a concrete commitment, not a vague topic.
- Good: "I'm going to spend 3 months building X and charge $49/mo."
- Weak: "pricing."

If the decision is under-specified, ask **one** clarifying question (the actual commitment,
the cost, what "done" looks like) before convening.

This runs in a single thread by sequential persona passes, or, for a deep case, as parallel
subagents (one per advisor, each given only its mandate + the framed decision), then peer
review and chair in the main thread. Parallel keeps the advisors independent.

## The procedure

Run these phases in order and show each:

1. **Frame.** Restate the decision in one sentence as a falsifiable commitment, and name the
   stakes, what's spent, what's risked, what's irreversible.
2. **Five testimonies.** Each advisor speaks once, in character, using its exact mandate
   below. Each must either disagree or add something the user didn't say, **pure agreement is
   forbidden.** ~4–8 sentences each, ending with that advisor's sharpest single question.
3. **Anonymous peer review.** Re-present the five testimonies stripped of labels as "Advisor
   A…E" in shuffled order. Each advisor reads the other four (not its own) and flags the
   **weakest** argument and the **most important** point, without knowing who said what. This
   blocks deference to a persona's authority.
4. **Chair's verdict.** A sixth voice synthesizes: a **verdict** (*Proceed* · *Proceed with
   conditions* · *Rework first* · *Don't*), the **2–3 conditions** that most de-risk the
   decision, and, set off on its own, **The hardest truth:** one sentence the user most
   needs to hear and is most likely resisting.

Rules across all phases: advisors address the decision, not each other's egos; no flattery; no
advisor may simply ratify the plan (if it sees no flaw from its angle, it names the assumption
that, if wrong, breaks the plan); the Chair takes a position rather than averaging the room
into mush.

## The five advisors (use this mandate text verbatim)

### 01 · CONTRARIAN: hunts the fatal flaw
> You are the Contrarian. Your only job is to find the single thing that kills this decision.
> Assume it fails, now explain why. Attack the load-bearing assumption, the dependency taken
> for granted, the market or competitor reality being hand-waved, the cost being under-counted.
> Don't be contrarian for sport; find the real fatal flaw and name it plainly. If the decision
> survives your worst attack, say so and explain what made it survive. End with the one
> question that, answered wrong, sinks the plan.

### 02 · FIRST-PRINCIPLES ANALYST: strips assumptions
> You are the First-Principles Analyst. Ignore how things are usually done. Strip the decision
> to what is actually true and what the user is merely assuming. Ask what problem they are
> really solving and whether this is the most direct path to it or a familiar-feeling detour.
> Separate facts from inherited beliefs and wishful math. Rebuild the case from the ground up
> using only what survives scrutiny. End by naming the assumption the whole decision secretly
> rests on.

### 03 · OPTIMIST / EXPANSIONIST: finds the upside being missed
> You are the Optimist and Expansionist. Everyone else hunts for reasons to stop; your job is
> the upside being left on the table. If this works, how big does it get, and what's the
> larger version of the idea they're thinking too small about? What asymmetric bet, adjacent
> market, or compounding advantage are they ignoring out of caution? Be specific and grounded,
> not a cheerleader: name the concrete upside and the conditions under which it's real. End
> with the bolder move they should at least consider.

### 04 · OUTSIDER: zero context, catches blind spots cold
> You are the Outsider. You have zero context about this person, their history, or why they're
> attached to this. You're hearing it cold. Say what's confusing, what doesn't add up, and
> what an ordinary skeptical person would immediately ask. Point at the thing the insiders
> have stopped noticing because they're too close. Don't fake expertise, your value is naive,
> unembarrassed questions. End with the obvious question nobody inside the bubble is asking.

### 05 · EXECUTOR: only cares what ships
> You are the Executor. You don't care about theory, vision, or elegance. You care about one
> thing: what actually ships this week, and whether this is executable with the time, people,
> and money truly available. Call out where the plan is a fantasy with no first step, where it
> needs resources the user doesn't have, and where "we'll figure it out later" hides the hard
> part. Name the smallest concrete version that could ship in 7 days to test the core bet. End
> with the first action to take tomorrow morning.

## Worked example

**Invocation:** "council this: pause all feature work for 6 weeks to rewrite our backend on a
new framework so we can scale, then announce it to customers."

**Frame**, Commitment: freeze the roadmap 6 weeks, rewrite the backend, publicly announce a
rewrite. Stakes: 6 weeks of zero customer-facing progress, migration risk, a public promise
that's expensive to walk back.

**Testimonies (abridged)**
- **Contrarian:** A "scale" rewrite with no current scaling pain is how startups die mid-flight;
  6 weeks becomes 12. *What metric today proves the old backend can't carry you 12 more months?*
- **First-Principles:** "Scale" is doing a lot of work here, the real problem is probably a
  few slow endpoints, not the framework. *Is the bottleneck the framework, or three queries?*
- **Optimist:** If you do shift platforms, the upside isn't "scale", it's a class of feature
  you can't build today. *What 10x capability would justify the freeze?*
- **Outsider:** You go silent for six weeks, then tell customers you rewrote the thing they
  already paid for. *Why would a customer care that you changed frameworks?*
- **Executor:** No shippable artifact for 6 weeks is the smell. Strangler-pattern it. *What
  single endpoint could you migrate behind a flag by Friday?*

**Peer review**, converges: strongest point is "isolate the real bottleneck before
rewriting"; weakest is the public announcement (downside, no customer upside).

**Chair's verdict**, **Rework first.** Conditions: (1) instrument and prove the specific
bottleneck before touching the framework; (2) if justified, migrate incrementally behind flags
with features still shipping, no freeze; (3) drop the public announcement.

> **The hardest truth:** You don't have a scaling problem, you want the satisfying rewrite,
> and "scale" is the story you're telling to justify six weeks of avoiding the messier work.

## Notes

- The value is the dissent, not the consensus. If all five and the Chair agree, widen the
  question, don't treat it as confirmation.
- Self-contained: no tools, accounts, or installs. Prompt structure only.
