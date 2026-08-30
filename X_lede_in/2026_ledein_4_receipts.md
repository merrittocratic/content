# Jonathan Taylor Was a 62%, and He Scored 13.1

## STATUS: DRAFT -- lede-in post 4 of 5, target Fri 2026-09-04

That is a real line from our board. Last season, Week 15, our dress
rehearsal. Jonathan Taylor was the second-most-confident running back
call we had, one spot behind Saquon. He got 13.1 PPR points, which is
a bad night for a guy you started without thinking about it.

Ashton Jeanty, 60 percent. 8.2 points. Breece Hall, 55 percent. 5.7.

Those three lines are the top of a file we published, and starting in
Week 2 a file exactly like it goes out every single Tuesday, for
eighteen weeks, whether it flatters us or not.

## Grading Our Own Homework, With Somebody Watching

Here is the format. Every week we take the probabilities we published
before kickoff, group them by what we said, and check what actually
happened.

| Stated band | Players | We said | It happened |
|---|---|---|---|
| under 10% | 20 | 9% | 0% |
| 10-25% | 80 | 18% | 18% |
| 25-50% | 90 | 36% | 44% |
| 50%+ | 10 | 58% | 70% |

That is one week and about two hundred players, which means it is
mostly noise, and I want to be upfront that a single week of this
table proves nothing in either direction. The 50-percent-plus row is
ten players. If two of them had gone the other way it would read as a
miss instead of a win.

That is exactly why we do it eighteen times in a row where you can
see it.

The other half of the scorecard is the half I actually enjoy: the
misses and the longshots, by name.

**Worst misses -- highest odds that did not hit**

| Player | We said | He scored |
|---|---|---|
| Jonathan Taylor, IND | 62% | 13.1 |
| Ashton Jeanty, LV | 60% | 8.2 |
| Breece Hall, NYJ | 55% | 5.7 |

**Longshots that hit -- lowest odds that cleared the bar**

| Player | We said | He scored |
|---|---|---|
| Jalen Nailor, MIN | 11% | 19.5 |
| Kenneth Gainwell, PIT | 15% | 19.6 |
| DJ Moore, CHI | 16% | 22.9 |

Read the second table the right way, because it is the one people get
backwards. Jalen Nailor at 11 percent is not the model saying no. It
is the model saying one in nine, and one in nine happens all the time.
If the 11-percent guys never hit, our 11 percent would be a lie.

A model that is never embarrassed is not being honest, it is being
vague.

## The Ten-Year Version, Including the Ugly Bin

One week is a story. Here is the actual evidence.

Before we let this thing near your lineup we ran it across a decade of
seasons, week by week, using only information that existed on the
Friday before kickoff. No peeking at Sunday. That produced 71,228
published probabilities across four positions, and the question for
all of them is the only question that matters: when it says 60
percent, does it happen 60 percent of the time?

![Calibration, 2016-2025](img/teaser_calibration.png)

Mostly, yes -- within about a point, bin after bin, from the 6 percent
guys to the 64 percent guys.

Except the last one.

In the 70-to-80 percent bin, the model said 73.5 percent and it
happened 65 percent of the time. That is off by more than eight
points and it is the worst number on this page. Two things about it:
it is the smallest bin on the board, 120 player-weeks out of 71,228,
so it is the least stable number we have. And it sits exactly where we
already know we have a problem. That bin is the superstars, the
handful of guys who are supposed to be near-locks, and our model
currently shrinks them toward the crowd more than it should. It is
written up as a known limitation with the fix identified and
deliberately deferred, because the fix was not ready to be trusted
this season.

We could have cropped that bin. It is 120 rows and the chart looks
better without it.

But if I hide the one bad number on the calibration plot, you have no
reason to believe the fourteen good ones, and then the entire product
is just a nicer-looking version of the decimal point I keep
complaining about.

## Risen to His Level of Incompetence

Running all of this is Earnest, the automation agent on the Mac Mini
in the corner of my office, who once confused an NBA rookie with a
Pirates pitching prospect and has been promoted anyway.

Earnest is operations this season. He builds the Tuesday board,
re-scores it as the week's injury reports land -- Tuesday's board
assumes everybody plays, and the Sunday morning board knows who is
out -- and he assembles the grading file above, including the parts
about how his own board did. When news breaks that moves somebody
meaningfully, he flags it to my phone.

Nothing publishes without a human yes. Earnest proposes, I approve.

## No Takebacks

Last thing, and it is the one that makes the rest of it mean
anything: the model is frozen for the season.

No quiet midyear tweaks. No "we have refined our methodology" three
weeks after a rough Sunday. What ships in Week 1 is the thing that
gets graded in Week 18, and if it has a bad October you will watch it
have a bad October in this exact table.

We did test whether the model should keep learning during the season.
It was better seven times out of eight -- and it still lost, because
it missed the improvement bar we had set before running it, and the
bar does not move after the data arrives. Frozen it is. We will
revisit it next offseason with a real season of live results, which is
the only honest way to answer it.

First board goes up Tuesday.

---

*Boxscore Prophet. Chances, not decimals. Backtest is walk-forward on
Friday-lock information only; code at [github].*
