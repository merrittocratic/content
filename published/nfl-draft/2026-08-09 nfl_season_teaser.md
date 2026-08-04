# Your Fantasy Projections Are Lying to You. Ours Aren't Allowed To.

Every fantasy site will hand you the same thing this September: a
decimal. "Jahmyr Gibbs, 17.3 points." That number is a costume.
Nobody knows whether Gibbs scores 8 or 28 on Sunday, and the decimal
point is there to make a guess look like a measurement.

So Boxscore Prophet, launching Week 1, doesn't do decimals. It
answers the two questions you're actually asking at your kitchen
table on Sunday morning: what's the chance this guy gives me a week
I'd start him for, and what's the chance he goes full league-winner?

## The Tuesday Board

Every Tuesday, a fresh board for all four skill positions -- RBs,
WRs, QBs, and tight ends, who get their own model because we learned
that a tight end is not a small wide receiver. A receiver on the
field is running a route; a tight end might be a sixth offensive
lineman. Different job, different model.

Here's what a board looks like, from our dress rehearsal on 2025's
Week 15:

![The Tuesday board: RB sample, 2025 Week 15](img/teaser_board_rb_w15.png)

Two numbers per player. The full bar is the chance of a startable
week; the dark bar is the chance of a boom. Notice what the board is
telling you that a decimal can't: Bijan Robinson and James Cook
project as near-identical starts, but neither is a sure thing --
because nobody is. The board also won't pretend Saquon at 67% is a
lock. He isn't. He's a two-out-of-three, and knowing that is the
whole game.

Alongside the board: a streamer view for the waiver-wire crowd and a
rookie tracker that separates "this kid is earning real opportunity"
from "this kid got lucky twice" -- very different things to trust
your FLEX spot to. Deep dives land on Substack; the boards and alerts hit
X during the week.

## The Part Where We Prove It

When our model says 60%, it needs to happen about 60% of the time,
or the number is just vibes with a percent sign. So we made it prove
itself across a decade of NFL seasons, week by week, using only what
was knowable the Friday before kickoff. No peeking at Sunday.

![Calibration: predicted vs. actual](img/teaser_calibration.png)

That's every probability the system published in the backtest,
grouped by what it said, plotted against what actually happened. The
dots sit on the line. (The top-right dot drifts -- the model runs a
touch confident on its rare 70%+ calls, and we're telling you that
now rather than hoping you don't notice in December.)

And it stays honest in public: every week we grade the previous
week's board against the actual box scores and post the scorecard,
flattering or not. The model is frozen for the season -- no quiet
mid-year tweaks, no "we've adjusted the formula" after a rough
Sunday. What ships in Week 1 is what gets graded in Week 18.

## Earnest Runs the Show

Longtime readers know Earnest, the automation agent living on the
Mac Mini in the corner of my office -- the one who once confused an
NBA rookie with a Pirates prospect. He's been promoted anyway.

Earnest is the operations department this season. He runs the
pipeline that builds the Tuesday boards, re-scores them as the week's
injury reports land -- Tuesday's board assumes everyone plays; the
Sunday morning board knows who's out -- and runs the weekly
self-grading. When news breaks that moves a player, he flags it to my
phone. Nothing publishes without a human yes; Earnest proposes, I
approve. He handles the scaffolding so the analysis can be the job.

## Week 1

Chances, not decimals. Four positions every Tuesday, re-scored as
news breaks, graded in public all season, run by a guy and his
slightly overconfident robot.

Bring your league's know-it-all. We brought receipts.

---

*Models trained on 2014-2025 data via nflverse/nflreadr. Backtest
walk-forward, Friday-lock information only. Code at
[github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
