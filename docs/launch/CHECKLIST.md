# captKernel launch checklist

Two launches, about a week apart: **Skills Curator first, Claunchpad second.** Everything goes out under the captKernel brand. The copy is ready to paste:

- Skills Curator: [`docs/launch/social/SOCIAL_KIT.md`](https://github.com/captkernel/Skills_Curator/blob/main/docs/launch/social/SOCIAL_KIT.md) in the Skills_Curator repo
- Claunchpad: [`social/SOCIAL_KIT.md`](social/SOCIAL_KIT.md), plus [`social/carousel.html`](social/carousel.html) and [`social/reel-script.md`](social/reel-script.md)

Install line used everywhere (plugin first):
```
/plugin marketplace add captkernel/plugins
/plugin install <name>@captkernel        # skills-curator or claunchpad
```

`@captkernel` is the handle placeholder in every file. **If the handle is taken on a platform, find-replace `@captkernel`** in both kits and in `social/carousel.html` (the brand mark on every slide) and `social/reel-script.md` before posting.

---

## 1. Accounts to create

Use the same handle everywhere if you can. Each bio is under 160 characters.

| Platform | Handle | Bio | Link |
|---|---|---|---|
| X | `@captkernel` | `open-source plugins for Claude Code: Skills Curator, Claunchpad and more. built in public, honest about the rough edges.` | https://github.com/captkernel |
| Reddit | `u/captkernel` | `I build open-source Claude Code plugins (Skills Curator, Claunchpad). Here to compare notes on skills, memory and agents.` | https://github.com/captkernel |
| LinkedIn (company page) | `captKernel` | `captKernel builds open-source plugins for Claude Code: Skills Curator, Claunchpad and small focused toolkits. MIT licensed.` | https://captkernel.com |
| Instagram | `@captkernel` | `open-source Claude Code plugins. short reels on skills, memory and agent teams. free, MIT.` | https://github.com/captkernel |
| Hacker News | `captkernel` | (the "about" field) `Open-source Claude Code plugins: Skills Curator, Claunchpad. https://github.com/captkernel` | https://github.com/captkernel |

- [ ] X account created, bio + link set
- [ ] Reddit account created, bio + link set
- [ ] LinkedIn company page created, tagline + website set
- [ ] Instagram account created (professional/creator), bio + link set
- [ ] HN account created, about field set
- [ ] Profile image on all five: the captKernel mark (or the Claunchpad launch-arrow from `assets/logo.svg` until there is one)

## 2. Warm-up (2 to 3 weeks before Launch 1)

New Reddit and HN accounts get filtered: low-karma posts on r/ClaudeAI and r/ClaudeCode are often held or removed, and a brand-new HN account's Show HN tends to sink unseen. Earn some history first.

- [ ] Spend 2 to 3 weeks commenting genuinely in r/ClaudeAI, r/ClaudeCode and on HN. Answer questions, share what worked, no links to our repos.
- [ ] Read each subreddit's rules on self-promotion right before posting; they change.
- [ ] On X and LinkedIn, post a few small build notes so the accounts aren't empty on launch day.
- [ ] Do a dry run of the install line in a clean Claude Code session the day before each launch.

## 3. Launch 1: Skills Curator

Proposed: **Tue 3 Nov 2026 (day 1) and Wed 4 Nov 2026 (day 2).** Shift both by a week if the warm-up isn't done. US clocks change on 1 Nov 2026, so 8 to 10am ET is 13:00 to 15:00 UTC (6:30 to 8:30pm IST).

Copy: `docs/launch/social/SOCIAL_KIT.md` in the Skills_Curator repo.

Day 1:
- [ ] X thread (kit section 4), reel on tweet 1, tag @AnthropicAI
- [ ] LinkedIn post (kit section 5), links in the first comment
- [ ] Reddit r/ClaudeCode (kit section 2)

Day 2:
- [ ] Reddit r/ClaudeAI (kit section 1), the day after r/ClaudeCode
- [ ] Show HN (kit section 3), Tue to Thu between 8 and 10am US ET, post the first comment straight away and stay for the first 90 minutes
- [ ] Instagram Reel + caption (kit section 6), the same day as Show HN

Stagger posts by a few hours. Don't post the same text in two places.

## 4. Launch 2: Claunchpad (one week later)

Proposed: **Tue 10 Nov 2026 (day 1) and Wed 11 Nov 2026 (day 2).** Same order.

Copy: [`social/SOCIAL_KIT.md`](social/SOCIAL_KIT.md).

Day 1:
- [ ] X thread (kit section 4), carousel slide 1 on tweet 1, tag @AnthropicAI
- [ ] LinkedIn post (kit section 1), links in the first comment
- [ ] Reddit r/ClaudeCode (kit section 3)

Day 2:
- [ ] Reddit r/ClaudeAI (kit section 2)
- [ ] Show HN (kit section 5), Tue to Thu between 8 and 10am US ET, first comment straight away
- [ ] Instagram carousel (export `social/carousel.html`, 10 slides at 1080x1350) + reel, caption from kit section 6, the same day as Show HN

## 5. Fallback

If the new Reddit or HN accounts are still filtered on launch day, post from the maintainer's own aged personal accounts, presented as "built by captKernel". No copy changes: the posts already say "I built it", which stays true.

- [ ] Decide per platform on the morning of day 1 (check whether a test comment from the new account shows up logged out)

## 6. After launch

- [ ] Watch traffic for 14 days (GitHub keeps 14 days of views):
  ```
  gh api repos/captkernel/Skills_Curator/traffic/views
  gh api repos/captkernel/Skills_Curator/traffic/popular/referrers
  gh api repos/captkernel/Claunchpad/traffic/views
  gh api repos/captkernel/Claunchpad/traffic/popular/referrers
  ```
  Baseline before launch (checked 15 Oct 2026): Skills_Curator 3 stars, about 20 installs on skills.sh; Claunchpad 0 stars.
- [ ] Answer every comment within 24 hours, on every platform. Fix what people report and say so in the thread.
- [ ] Then the awesome-list listings. The entries and the submission order are in `docs/launch/awesome-lists.md` in each repo: awesome-claude-code after Launch 1, Skills Curator first and Claunchpad once that one is accepted or declined; VoltAgent held until there is visible usage.
