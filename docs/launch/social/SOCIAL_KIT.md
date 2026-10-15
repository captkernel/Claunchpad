# Claunchpad, distribution kit

Copy-paste ready, posted from the captKernel accounts (handle `@captkernel`). Repo is public (MIT). Voice is founder-to-builders: direct, lowercase-leaning, honest about the rough edges, and it ends on a real question. No em dashes. When and where to post: [`../CHECKLIST.md`](../CHECKLIST.md) (Launch 2).

**The links**
```
Install:  /plugin marketplace add captkernel/plugins
          /plugin install claunchpad@captkernel
Repo:     https://github.com/captkernel/Claunchpad
Showcase: https://htmlpreview.github.io/?https://github.com/captkernel/Claunchpad/blob/master/showcase.html
Reel:     https://github.com/captkernel/Claunchpad/raw/master/docs/video/claunchpad-reel.mp4
          (4:5 feed cut: https://github.com/captkernel/Claunchpad/raw/master/docs/video/claunchpad-reel-4x5.mp4)
Other:    manual copy (cp -r skills/claunchpad ~/.claude/skills/) or claude.ai (upload skills/dist/claunchpad.zip)
```

**Headline facts:** a Claude Code skill that sets up a whole project "operating system" in one drop-in. Persistent memory that survives `/clear` and compaction (via a SessionStart hook). Agent teams that size themselves (solo, pair, fan-out, workflow). A one-tap install of the best ecosystem skills, with Skills Curator deeply integrated to rebuild each one for your project. Three tiers (Starter/Standard/Pro) chosen by a one-question interview. Built with its own discipline (a final review caught two real bugs the per-task reviews missed). Open source, MIT.

**Narrative beats to lean on:**
1. Your AI forgets everything the moment you type `/clear`. Memory should be the harness's job, not yours.
2. More agents is not more quality. A wide run costs ~15x the tokens and hurts on coupled work.
3. It meets you where you are: beginner gets a safe setup, expert gets the full machine.
4. Infuse, don't invoke: skills get rebuilt for your project, not bolted on with the author's accent.
5. Dogfooded: it was built the way it asks you to build.

**Assets in this folder:**
- `carousel.html` (10 slides, 1080x1350, Claunchpad design system). Export by screenshotting each slide at full size, or print-to-PDF (one slide per page).
- `reel-script.md` (Instagram Reel, ~22s, shot list + on-screen text + voiceover).
- The finished 37s launch reel is already rendered: `../../video/claunchpad-reel.mp4` (9:16) and `../../video/claunchpad-reel-4x5.mp4` (4:5). Use it as-is if you don't want to cut the ~22s version.

---

## 1. LinkedIn post

```
I kept noticing the same thing: every time I started a session with Claude, it had forgotten everything from the last one.

The decisions we made. The bug that took two hours to track down. The one weird thing about the codebase. Gone the moment I cleared the context. I wasn't building on yesterday, I was re-explaining yesterday.

What I eventually realised: the bottleneck was almost never the model. It was that nothing the model learned ever stuck, and that I had no rule for when to bring in help, and no record of what we'd already figured out.

So I built Claunchpad. It's one skill you drop into Claude Code, and it sets up the things a senior engineer would set up by reflex:

• Persistent memory that survives /clear and compaction. A hook reloads it at the start of every session, so Claude picks up mid-stride instead of starting from zero.
• Agent teams that size themselves. Solo for small fixes, a build-review-verify pair for real changes, parallel agents only when the work is genuinely independent. A wide multi-agent run costs roughly 15x the tokens, so restraint is the default.
• A one-tap install of the best ecosystem skills, rebuilt for your project rather than bolted on as-is.

It meets you where you are. A beginner gets a tiny, safe setup with nothing to break. An advanced user gets the full machine. Same skill, the right depth.

The detail I'm proudest of: it was built using its own discipline. Fresh agent per task, independent review, automated tests. A final whole-branch review caught two bugs every narrow review had missed. A tool that cuts corners building itself has no business asking you to trust its discipline.

It's open source (MIT). Repo and a one-page interactive walkthrough in the comments.

If you build with Claude Code: what's the first thing you wish it remembered between sessions?
```

First comment (drop the links here, not in the post body, for reach):
```
Install in Claude Code: /plugin marketplace add captkernel/plugins, then /plugin install claunchpad@captkernel
Repo: https://github.com/captkernel/Claunchpad
Interactive walkthrough: https://htmlpreview.github.io/?https://github.com/captkernel/Claunchpad/blob/master/showcase.html
```

---

## 2. Reddit, r/ClaudeAI

**Title:**
```
[Show] I built Claunchpad, a one-skill "project OS" for Claude Code (persistent memory, self-sizing agent teams, MIT)
```

**Body:**
```markdown
**Install:** `/plugin marketplace add captkernel/plugins` then `/plugin install claunchpad@captkernel`
**Repo:** https://github.com/captkernel/Claunchpad
**Walkthrough (one page):** https://htmlpreview.github.io/?https://github.com/captkernel/Claunchpad/blob/master/showcase.html

I kept hitting the same wall: every new session, Claude had forgotten the last one. The decisions, the bugs I'd already fixed, the gotchas in the codebase, all gone the second I cleared the context. The bottleneck was never the model. It was that nothing it learned ever stuck.

So I built Claunchpad. It's one skill you drop into Claude Code and it sets up the stuff an experienced user does by reflex. What it actually does:

**1. Persistent memory that survives /clear and compaction.** A SessionStart hook reloads your project's memory (decisions + why, failures + fixes, techniques that work here) at the start of every session, so you stop re-explaining yesterday. On a small project it's one MEMORY.md; as it grows it graduates to a per-fact memory/ directory, non-destructively.

**2. Agent teams that size themselves.** Solo for small fixes, a build > independent review > verify pair for real changes, parallel agents only for genuinely independent work, a scripted workflow for big migrations. You don't pick the structure. It escalates only on a real trigger and drops back down when a cheaper one would do, because a wide multi-agent run costs ~15x the tokens and actively hurts on tightly coupled work.

**3. A one-tap install of the best ecosystem skills.** At setup it offers Superpowers, Skills Curator, and Agent Browser, installed the right way for your machine. Skills Curator is deeply integrated as the curation layer: every other skill gets evaluated, security-scanned, and rebuilt for your project (keep what fits your stack, rewrite the rest in your voice, drop the noise). Infuse, don't invoke.

**4. It meets you where you are.** A short interview picks a tier. Beginner gets a tiny safe setup with nothing to break; an advanced user gets the per-fact memory, the full hook layer, the orchestration catalog, and council presets. Same skill, the right depth.

**5. Built with its own discipline.** Implemented via fresh-agent-per-task with an independent reviewer and an automated test gate. A final whole-branch review caught two bugs every per-task review had structurally missed (a feature the docs described but no code performed, and a brand-new file pointing at two files the same change had deleted). Both fixed before it shipped.

It's MIT, works on Claude Code (filesystem + hooks + subagents) and degrades to copy-paste behavior on claude.ai.

Genuinely curious about one thing: when should the harness proactively reload/suggest things vs stay quiet? Figuring out the line between "helpful" and "noisy" is the actual hard part. How do you handle memory across sessions today?
```

**Time to post:** mid-morning US weekday, the day after r/ClaudeCode. Reply to every comment.

---

## 3. Reddit, r/ClaudeCode

Different angle from the r/ClaudeAI post: this one is about what I learned making memory load reliably, not a feature tour. Don't cross-post the r/ClaudeAI text here.

**Title:**
```
What I learned trying to make Claude Code memory survive /clear: put the load in a hook, not in CLAUDE.md
```

**Body:**
```markdown
**Install:** `/plugin marketplace add captkernel/plugins` then `/plugin install claunchpad@captkernel`
**Repo:** https://github.com/captkernel/Claunchpad (disclosure: I built it, MIT)

My first attempts at cross-session memory were instructions in CLAUDE.md: "read MEMORY.md before you start." It worked until it didn't. After /clear or a compaction, whether the memory got read depended on whether the model remembered to do it, which is the exact thing that was failing in the first place.

What fixed it was moving the load out of the prompt and into the harness:

- **A SessionStart hook does the reading.** `load-memory` is a short POSIX sh script. It reads `MEMORY.md`, up to eight recent `memory/*.md` files, and (after compaction) a `.claunchpad/handoff.md` buffer, and hands them to Claude as session context via `additionalContext`. It runs on every session start, including after /clear and compaction, so loading memory stops being something the model can forget.
- **Writing stays with the model, with one nudge.** A second hook, `harvest-nudge` (Stop), blocks once per session to remind Claude to file any new decision, learning or error before stopping. It never writes to memory itself. I didn't want a hook silently editing what the project "knows".
- **Start with one file, graduate later.** Small projects get a single `MEMORY.md` with four sections (Decisions, Learnings, Errors, References). When it gets too big to scan, it moves to a per-fact `memory/` directory with `MEMORY.md` as a thin index, non-destructively.
- **No network, nothing hidden.** Neither hook makes a network call. Both are short enough to read in full before you trust them, and the settings change only registers the hooks, additively.

Claunchpad packages that plus the rest of the setup I kept rebuilding by hand (a CLAUDE.md, rules for when to bring in subagents, a couple of decision councils). A one-question interview picks Starter, Standard or Pro, so a beginner gets two files and the load-only hook.

Rough edges: the hooks are POSIX sh, and on claude.ai there are no hooks at all, so it falls back to applying the behavior in-session and handing you files to paste. The nudge is also a judgment call; once per session felt right, more felt like nagging.

If you've built your own memory setup for Claude Code: did you load it from a hook, from CLAUDE.md, or something else, and what broke first?
```

**Time to post:** the day before r/ClaudeAI (see the checklist). Reply to every comment.

---

## 4. X / Twitter thread

**1 (hook), attach slide 1 of the carousel:**
```
your AI forgets everything the moment you type /clear

i got tired of re-explaining yesterday's decisions every session, so i built Claunchpad: one skill that gives Claude Code a memory that survives /clear, agent teams that size themselves, and the best skills pre-wired

open source, MIT
```
**2 (the why):**
```
the thing i finally understood: the bottleneck was never the model

it was that nothing it learned ever stuck, and i had no rule for when to bring in help

fix the scaffolding and the same model behaves like a completely different, far better collaborator
```
**3 (memory):**
```
persistent memory is the centerpiece

a SessionStart hook reloads your decisions, your fixes, your gotchas at the start of every session, even after /clear and compaction

Claude can't forget to load it, because loading it isn't Claude's job anymore. it's the harness's
```
**4 (agents):**
```
more agents is not more quality

a wide multi-agent run costs ~15x the tokens and hurts on coupled work

so Claunchpad gives Claude a ladder, not a swarm: solo > pair > fan-out > workflow, escalating only when the task earns it
```
**5 (skills + Skills Curator):**
```
it installs the best ecosystem skills for you, then rebuilds each one for your project via Skills Curator

keep what fits your stack, rewrite the rest in your voice, drop the noise

infuse, don't invoke
```
**6 (close):**
```
/plugin marketplace add captkernel/plugins
/plugin install claunchpad@captkernel

github.com/captkernel/Claunchpad

built it using its own discipline. a final review caught two bugs every per-task review missed. open source, MIT

what's the first thing you wish Claude remembered between sessions?
```
Tag `@AnthropicAI` on tweet 1.

---

## 5. Hacker News, Show HN

**Title:**
```
Show HN: Claunchpad, one skill that gives Claude Code memory and agent teams
```
**URL:** `https://github.com/captkernel/Claunchpad`

**First comment** (post it right after submitting; with a URL set, HN shows no body text):
```
Every new Claude Code session started from zero for me: it had forgotten the prior session's decisions, the bugs I'd already fixed, the gotchas in the codebase. The bottleneck was never the model. It was that nothing it learned persisted, and I had no consistent rule for when to fan out to multiple agents vs stay solo.

Claunchpad is one skill you drop in that sets that scaffolding up. A SessionStart hook reloads project memory at the start of every session (surviving /clear and compaction). Work runs as a right-sized team (solo > pair > parallel fan-out > workflow), escalating only on a concrete trigger because a wide multi-agent run costs roughly 15x the tokens and hurts on coupled work. At setup it offers to install a few high-value skills, with one (Skills Curator) integrated as a curation layer that rebuilds each external skill for your project rather than installing it as-is.

It deploys in tiers via a one-question interview, so a beginner gets two files and a load-only hook while an advanced user gets the full machine. It was built using its own process (fresh agent per task, independent review, automated test gate), and a final whole-branch review caught two cross-file bugs the per-task reviews missed.

Install: /plugin marketplace add captkernel/plugins, then /plugin install claunchpad@captkernel. MIT. Works fully on Claude Code; degrades to in-session behavior on claude.ai.

Built it because I kept re-explaining context to my own assistant. Curious whether others have found a memory pattern that actually holds across sessions.
```

---

## 6. Instagram carousel caption

```
Your AI forgets everything the moment you type /clear.

I got tired of re-explaining yesterday to my own assistant, so I built Claunchpad: one skill you drop into Claude Code that turns on the stuff a senior engineer sets up by reflex.

→ Persistent memory that survives /clear and compaction
→ Agent teams that size themselves instead of swarming
→ The best skills, rebuilt for your project (infuse, don't invoke)
→ Beginner-safe or full-power, same skill, the right depth

It's free and open source (MIT). Built with its own discipline, a final review caught two real bugs along the way.

Link in bio, or search "Claunchpad" on GitHub.

Save this for your next project. What's the first thing you wish Claude remembered between sessions?

.
.
#claudecode #anthropic #claude #aitools #aiagents #buildinpublic #devtools #opensource #vibecoding #softwareengineering #promptengineering #indiehacker
```

---

## 7. Posting order

The order, timing and accounts live in [`../CHECKLIST.md`](../CHECKLIST.md) (Launch 2, one week after Skills Curator): X, then LinkedIn, then r/ClaudeCode, r/ClaudeAI the next day, Show HN Tue to Thu 8 to 10am US ET, Instagram the same day as HN. Tag @AnthropicAI on tweet 1, put LinkedIn links in the first comment, and stay around for the first 90 minutes of the HN post.

Stagger by a few hours, don't fire everything in one window. Lead with honesty about the rough edges, that's what reads as real.
