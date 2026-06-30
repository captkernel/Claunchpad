# Your AI Forgets Everything the Moment You Type `/clear`. Karan Built the Fix.

*Most people drive Claude on hard mode — no memory, no discipline, a blank slate every session. Claunchpad is the scaffolding that turns it into your best engineer instead of a clever intern. Built in the open by captKernel.*

> The thing nobody warns you about is the forgetting. You spend an afternoon teaching Claude how your project works — the decisions, the dead ends, the one weird gotcha that cost you two hours — and then you clear the context, or it compacts, and it's a stranger again. You're not building on yesterday. You're re-explaining yesterday. Every session starts at zero, and you slowly realise the bottleneck was never the model. It was that nothing it learned ever stuck.
> — Karan Parmar, in his words

That frustration is the whole idea behind **Claunchpad**. Karan — better known online as captKernel — kept noticing that the gap between a mediocre Claude session and a genuinely great one had almost nothing to do with which model you picked. It was everything *around* the model: whether it remembered, whether it stayed disciplined, whether it knew when to call for backup and when to just do the work. Most of us rebuild that scaffolding by hand on every project, badly, and then wonder why the magic doesn't hold. Claunchpad builds it for you, once, in about a minute — and it's open source.

Think of it less as a skill and more as a **project operating system for Claude Code**. Here's what that actually means.

## Memory that survives the reset

This is the heart of it. Everyone's advice about giving your AI "memory" amounts to *remember to keep good notes* — a discipline you abandon by Wednesday. Claunchpad makes forgetting structurally impossible instead.

It wires a hook into Claude Code that fires at the start of every single session — including the ones after you type `/clear`, and the ones after the context silently compacts itself. Before Claude says a word, that hook reads your project's memory back into the conversation. Decisions and why you made them. Failures and the fix that finally worked. The techniques and gotchas specific to *this* codebase. Claude can't forget to load it, because loading it isn't Claude's job anymore — it's the harness's.

On a small project that memory is a single tidy file. As the project grows, Claunchpad graduates it into a proper library — one fact per file, linked together, indexed — without you lifting a finger. And the one habit that usually rots, *writing things down*, gets a gentle nudge at the end of a session so the next one starts even smarter. Nothing is written behind your back; you stay the author of your own record.

> The notes you take are only as good as your discipline. The notes a hook takes are as good as the hook.

## Spend agents on purpose

The other place people go wrong is the opposite of forgetting — it's *flailing*. The instinct, the moment a task looks big, is to fan out a swarm of sub-agents and let the cavalry sort it out. Claunchpad is built on the opposite conviction, and it's blunt about it: more agents is not more quality. A wide multi-agent run can cost roughly fifteen times the tokens of a single chat, and on tightly-coupled work — agents editing the same files, depending on each other's half-finished output — it actively makes things *worse*.

So Claunchpad gives Claude a ladder instead of a swarm. Most work stays solo. A change worth reviewing gets a pair: one builds, a second set of fresh eyes reviews, and nothing counts as done until it's verified. Only genuinely independent work — three different research angles that don't touch — earns a parallel team. And a real fleet of agents is reserved for the rare job that actually needs a deterministic, scripted assembly line. One rule governs all of it: **the cheapest structure that clears the quality bar wins.** Power you spend on purpose, never by reflex.

## It meets you where you are

Here's the quietly clever part. Claunchpad doesn't hand everyone the same intimidating machine. When it sets up, it takes a quick read of who you are and what you're building, then deploys exactly the tier that fits.

A newcomer on a throwaway project gets two files and a single, safe, read-only memory hook — nothing to learn, nothing to break. A real working project gets the full delegation contract and the harvest nudge. And an advanced user on something large and high-stakes gets the whole apparatus from minute one: the per-fact memory library, the complete hook layer, a session-handoff buffer that survives compaction, and the decision frameworks wired in. You can always level up later with one command, and it adds the next tier's machinery without ever clobbering what you've already built. Beginners aren't drowned; experts aren't patronised.

## And it brings friends

The newest piece is the one I'd have wanted on day one. When Claunchpad finishes setting up your project, it offers — your choice, take all of them, pick a few, or skip — to install the small handful of tools that genuinely punch above their weight:

- **Superpowers**, the disciplined-workflow engine (brainstorming, planning, test-first development, the whole methodical spine).
- **Skills Curator**, captKernel's own gatekeeper that evaluates a skill *before* you install it and remembers the verdict so you never re-decide.
- **Agent Browser**, which lets your agent actually drive a real browser.

Each one installs the way it's genuinely meant to — there's no pretending three different tools share one magic command — and on the surfaces where automatic installs aren't possible, Claunchpad just prints you the exact steps instead. It even tells you the one thing humans always forget: *restart Claude Code, or the new skills will look like they never installed.* It's the difference between being handed a project and being handed a project that already knows where the good tools live.

## Built the way it preaches

The detail I find most telling: Claunchpad was built using the exact discipline it ships. Every piece was implemented by a fresh agent, reviewed by a second one for correctness and for doing *only* what was asked, and verified against an automated test suite before it counted as done. At the very end, a single broad review read the whole thing at once — and earned its keep immediately, catching two bugs that every narrow per-task review had structurally missed: a feature the docs proudly described but no code actually performed, and a brand-new file quietly pointing at two other files the same change had just deleted. Both were fixed before anything shipped.

That's the same loop Claunchpad sets up for you. A tool that cuts corners in its own construction has no business asking you to trust its discipline. This one doesn't cut them.

## The point

> What I finally understood building this is that I'd been blaming the wrong thing. When a session went sideways it was never that the model wasn't smart enough — it was that I'd given it no memory to stand on, no rule for when to bring in help, and no record of everything we'd already figured out together. Fix the scaffolding and the same model behaves like a completely different, far better collaborator. The intelligence was always there. It just had nothing to hold onto.
> — Karan, in his words

Claunchpad is the thing that gives it something to hold onto. It's open source under MIT, built in the open by captKernel, and it sets your next project up in about the time it takes to read this far.

▶ **See it at a glance** (interactive, single page): {{SHOWCASE_URL}}
▶ **Get it on GitHub:** https://github.com/captkernel/Claunchpad

—Nishant

---
---

## Appendix for Nishant — facts, angles & assets (not for publication)

Everything below is source material so you can pull what fits your voice. The article above is a finished draft; rewrite freely.

### The one-line version
Claunchpad is a Claude Code skill that bootstraps a project "operating system": durable memory that survives `/clear` and compaction (via a SessionStart hook), a disciplined delegation contract, a right-sized orchestration ladder, and an opt-in offer to install the high-value ecosystem skills — all deployed in the tier (Starter / Standard / Pro) that fits the user.

### The three structural ideas (the article's spine — features are downstream)
1. **Memory as infrastructure, not a habit.** Hooks reload memory every session, including post-compaction. The user can't forget because remembering isn't a human task anymore. Pull-quote: *"The notes a hook takes are as good as the hook."*
2. **Spend agents on purpose.** Restraint is the default; the "more agents = better" instinct is wrong (~15× token cost; hurts coupled work). The 4-tier ladder (Solo → Pair → parallel fan-out → Workflow). Pull-quote: *"Power you spend on purpose, never by reflex."*
3. **Provision to the person.** Tiered deploy (Starter/Standard/Pro) read from user expertise + project shape; non-destructive `launchpad upgrade`. Beginners get 2 files; pros get the whole machine.

### The dogfooding beat (most credible detail — like the Skills Curator "scanner flagged itself" story)
Built via subagent-driven development: fresh implementer per task → independent spec+quality review → automated test gate. A final whole-branch review caught two cross-file bugs the per-task reviews structurally could not see: (1) a "handoff hook" the docs advertised but no code/instruction actually wrote the buffer for; (2) a newly-authored reference file routing harvested learnings into two memory stores that the *same* change had just deleted. Both fixed pre-merge.

### Hard facts
| | |
|---|---|
| **Product** | Claunchpad (a "project OS" for Claude Code; internal skill name: `launchpad`) |
| **Repo** | https://github.com/captkernel/Claunchpad |
| **License** | MIT |
| **Author** | @captkernel (Karan Parmar) |
| **Pillars** | Memory · Delegation · Orchestration, + a hook layer, + councils |
| **Hooks** | `load-memory` (SessionStart → injects memory, incl. post-compaction); `harvest-nudge` (Stop → reminds once, never auto-writes) |
| **Tiers** | Starter / Standard / Pro (deployed by a bootstrap interview) |
| **Recommended-skills offer** | Superpowers (`obra/superpowers-marketplace`), Skills Curator (`captkernel/Skills_Curator`), Agent Browser (`vercel-labs/agent-browser`) |
| **Councils** | Decision Council (5-advisor pressure-test) + Feasibility Council (4-lens viability) |
| **Showcase** | self-contained `showcase.html` in the repo (live URL once GitHub Pages is on) |

### Pull-quotes you can lift
> "The bottleneck was never the model. It was that nothing it learned ever stuck."
> "More agents is not more quality."
> "The cheapest structure that clears the quality bar wins."
> "A tool that cuts corners in its own construction has no business asking you to trust its discipline."

### Things to do before publishing (primary source > summary)
1. Open the showcase page (single self-contained HTML) and screenshot the tiers + pillars sections — most photogenic single artifact.
2. Skim the repo README and SKILL.md for any numbers that moved.
3. Confirm the live showcase/Pages URL and swap it into the `{{SHOWCASE_URL}}` placeholder above.
