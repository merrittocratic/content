# Predicting the Majors Has Been a Major Challenge

*(Pun absolutely intended.)*

---

Four majors, four winners: Rory McIlroy at Augusta, Aaron Rai at the PGA, Wyndham Clark at Shinnecock, and now Ryan Fox lifting the Claret Jug at Royal Birkdale.

Same story every time: the market's shortest number went home empty. Scottie Scheffler carried the best odds in the field at all four majors this year — same guy, four different sportsbook boards, four different weeks — and won none of them. Fox went off 48th in my pre-tournament rankings with a 0.4% win probability. The entire Birkdale podium — Fox, Cameron Young, Sam Burns — came from ranks 48, 30, and 22. Meanwhile the guy every model on earth had on top finished T4.

Again.

---

## Cinderella Story, Outta Nowhere

Here's the thing nobody wants to hear about golf prediction: "favorite" is a weaker word than it sounds like in a major championship.

Going into the Open, my model gave Scheffler the highest win probability in the field: 7.3%. That's what "favorite" means in a 156-man major — the shortest number on the board, not an expected winner. Flip it around, and the best golfer on the planet, in peak form, was a 13-to-1 shot. Run that same math across all four majors this year — Scheffler carried win probabilities somewhere in the 7–17% range at each one — and the odds he wins zero of the four come out to roughly 55%. Better than a coin flip.

So no, this isn't a stunning collapse. It's the base rate. A golf tournament is one four-day sample drawn from a sport with enormous week-to-week variance, and the deepest fields of the year compress everyone's chances toward the middle. The interesting part was never that the favorite lost four straight — that's what's supposed to happen more often than not. The interesting part is what those four losses looked like up close.

---

## If You're Not First, You're Last

Which brings me to the most interesting player of the 2026 major season: the guy who didn't win any of them.

Scheffler's finishes at the four majors: 2nd, T14, T4, T4. Never outside the top 14. Zero trophies.

Here's the stat that jumped out when I pulled his strokes-gained data. Through the first three majors — the Open's detailed numbers aren't archived yet — Scheffler hit the ball better at the majors than he did the rest of the year. His total strokes gained per round was +2.60 at the majors versus +2.21 everywhere else. The separation came on the greens:

| | SG Putting / Round |
|---|---|
| Majors (Masters, PGA, U.S. Open) | +0.07 |
| Everything else in 2026 | +0.59 |

At regular tour stops, Scheffler picked up more than half a stroke per round with the putter. At the majors, he putted like an average tour pro — dead neutral. At the PGA Championship it went genuinely cold: he lost 0.42 strokes per round on the greens and finished T14 in a week where his ball-striking was good enough to contend.

The honest fine print: twelve rounds of putting data is a small sample, and putting is the noisiest stat in golf. His U.S. Open week on the greens was actually fine. I'm not declaring a curse. But the shape of the season is hard to ignore — the best tee-to-green player alive showed up to the four biggest weeks of the year with his A-game ball-striking and a putter that went quiet, and the difference between that and four wins instead of four top-5s is about half a stroke a round.

---

## What I'm Taking Into Next Season

If you build prediction models, major season is a humility machine. My model's headline calibration numbers held up fine against the big public projection systems this year, and it still put the Open champion 48th on the sheet. The lesson isn't to chase the Ryan Foxes — a model that had Fox winning would be a worse model, not a better one. The lesson is that in golf, "favorite" is a statement about probability, not destiny.

Four different sportsbooks, four different weeks, one guy at the top of the board every time — and by the math, missing all four wasn't even the upset. It was the coin flip. For the best player alive — and every model tracking him, mine included — the majors stayed exactly what they've always been: a major challenge.

---

*Scheffler strokes-gained data via DataGolf, scoped to the Masters, PGA Championship, and U.S. Open — Open Championship splits not yet archived. Pre-tournament odds via FanDuel, DraftKings, and CBS Sports. Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
