---
repo: boxscore-prophet
---

# Trust, But Verify

We told you earlier this week this post was coming. Before Boxscore Prophet starts grading itself in public, here's exactly what "grading" means, and why the number should be trusted at all.

Every Tuesday from here on, this newsletter tells you a number: the chance a running back, receiver, quarterback, or tight end gives you a startable week, and a smaller chance he goes full boom. Then the games happen, and a few days later we check. Not "I liked that pick" checking. Not vibes. The stated probability, against the box score that actually occurred.

That's the whole model, restated as a threat: if we say 60%, it needs to happen close to 60% of the time, or the number was never worth publishing in the first place. The Week 1 board goes live Tuesday. The first live grading column runs two Tuesdays after that. Before either one, here's the ruler.

## The Receipts

We ran the backtest the honest way: every probability the model would have published from 2016 through 2025, compared against what actually happened, using only what was knowable the Friday before kickoff. Two numbers per player per week, a startable line (15 PPR points for a back or receiver, 20 for a quarterback, 12 for a tight end) and a boom line (20/25/17, same order). 71,228 player-weeks, pooled across all four positions and both thresholds.

Averaged within each cell, the model and reality are barely distinguishable:

| Position | Line | Model said | Actually happened | Gap |
|----------|------|-----------:|-------------------:|----:|
| QB | start | 29.7% | 29.9% | +0.21pp |
| QB | boom | 13.9% | 13.9% | 0.00pp |
| RB | start | 27.5% | 27.7% | +0.21pp |
| RB | boom | 14.5% | 14.3% | -0.21pp |
| WR | start | 26.1% | 26.6% | +0.52pp |
| WR | boom | 12.9% | 13.2% | +0.24pp |
| TE | start | 29.0% | 28.3% | -0.74pp |
| TE | boom | 11.8% | 11.8% | -0.03pp |

Worst cell in the whole table is TE starts, off by three-quarters of a point. That's the honesty number for the entire operation, and it's a good one.

## The Fine Print

Averages forgive a lot, though. Slice those same probabilities into ten-point buckets instead, everything we ever called "40-50%" grouped together, and the worst bucket misses by 8.46 percentage points. A single bucket, a single week, a single player can get noisy even when the whole system is honest on average. That gap is real, it's in this post on purpose, and it's the reason the next section exists.

## The Bar We Set Before We Looked

An 8-point miss in one bucket doesn't automatically become next Tuesday's headline. Before a gap gets called a real finding instead of noise, it has to clear two bars at once: at least 4 percentage points off, on a sample of at least 400 player-weeks. Short on either one and it goes on a watch registry -- flagged, tracked, not reported as a conclusion.

That's not a bar being introduced for the first time here. The null-results run a few weeks back found five things that cleared the 4-point line and missed the 400-week floor: a windy-game receiver effect, a first-round rookie running back beating his number, three others that looked like stories and weren't. All five got parked. None got published as findings, because the bar doesn't know how good a story is, and it's not supposed to.

## Starting In Two Weeks

Every number in this post is the ruler everything else gets measured against. The Week 1 board goes live Tuesday, nothing to grade yet. Two Tuesdays after that, the first On the Record column runs: last week's published numbers, next to what actually happened, flattering or not. Now you know exactly what "flattering or not" means when we say it.

---

*Method: every probability the model would have published, 2016-2025, walk-forward validated against Friday-lock-only information, checked against actual box scores. 71,228 player-weeks across RB/WR/QB/TE and both thresholds. Data via nflverse/nflreadr. Full backtest and code at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
