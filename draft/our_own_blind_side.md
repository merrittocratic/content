# Our Own Blind Side

---

Last week we published a stack of nulls -- weather, the trenches, rookie priors, three swings, three misses, receipts attached. That was the model being tested and passing. This week is different. This is the model working exactly as designed and still getting it wrong, because of things it has no way to see. Not a bug. A blind side.

Two examples. Same board, two different flavors of blind.

## Schrödinger's Bell Cow

Every rookie running back walks into Week 1 as the same player, statistically speaking. Not literally, obviously, but to the model. Our volume features are built from a back's own rolling average over recent games, and at Week 1 of a rookie season, that average doesn't exist yet. It's blank by construction. The only pre-season signal left standing is draft round, and draft round is identical for every back in the same tier of the same class. The model has no feature for "bell cow" or "committee." It finds out same as you do -- by watching him play.

We went back and found every first-round rookie back with enough sample to check, 13 backs, 182 player-weeks, and on average the model undersold this group by 10.6 percentage points per player-week. But "on average" is doing a lot of hiding here. Split it and it's not one trend, it's two, with a small honest smear in between. Seven backs got a real bell-cow role and beat their number by 13-36pp -- Fournette, Elliott, Barkley, Harris, Bijan Robinson, McCaffrey, Gibbs. Three landed in a committee and missed their number by 11-27pp the other direction -- Edwards-Helaire, Jeanty, Penny. The remaining three -- Jacobs, Hampton, Michel -- came in close enough to call it a wash. Same draft slot, same blank slate, wildly different outcomes, and nothing pre-season tells you which bucket you're getting.

Which brings us to Jeremiyah Love. Third overall, first back off the board, $53M guaranteed, and the Cardinals' first depth chart of the summer lists him RB2 behind Tyler Allgeier, with James Conner still on the roster. Preseason depth charts are not gospel and this one can move before kickoff. But right now, using the only information the model is allowed to use, Love is genuinely a coin flip between the Gibbs outcome and the Edwards-Helaire outcome. We don't know which bucket he's in. Neither does the model. Neither, probably, does Arizona.

## The Sunday Scaries

Different flavor of blind, same root cause: the data exists, it's just not born yet when we need it.

We looked at every QB week where the offensive line was missing two or more regular starters -- 592 player-weeks, 132 quarterbacks -- and the model overprojected the group by 1.37 EPA on average. That's real, it's a genuine miss, and it's structural for a boring reason: who actually started up front isn't official until Sunday, and the board ships Tuesday. By the time we'd know to dock a QB for his tackle being out, we've already told you what to do with him.

Here's where it gets more honest than a tidy headline would like. The four quarterbacks who show up most often in this bucket don't all show the effect. Stafford (23 weeks, +0.06) and Tannehill (16 weeks, +0.36) were basically fine behind banged-up lines. Rodgers (-1.25) and especially Wentz (-6.17) were the real drag. And the miss isn't hiding in the famous names anyway -- it's smeared across the full 132-QB tail, with real quarterbacks landing on the good side of the same bucket, Brees at +5.01, Josh Allen at +6.10. This isn't "bad offensive lines sink quarterbacks." It's noisier and less quotable than that, which is exactly why it's a blind side and not a feature waiting to be built.

## What this means for the board

Neither of these gets fixed by trying harder. The RB gap closes the moment a rookie plays two or three real games and the rolling features wake up -- Love's board number gets sharper fast, whichever direction it moves. The QB gap only closes if we're willing to publish Sunday-morning numbers instead of Tuesday ones, and we've already decided that trade isn't worth it -- a board that changes its mind after lock isn't a board you can trust. So both blind sides stay blind sides, on purpose, and we'd rather tell you where they are than pretend the frozen model doesn't have any.

---

*Data via nflverse/nflreadr, first-round rookie RB sample and O-line/QB null test both walk-forward, Friday-lock information only. Code and full receipts at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*