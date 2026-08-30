# Nothing to See Here.  Please...

Anybody can show you the thing that worked. The hard part, the part almost nobody does, is showing you what came back empty. A null result feels like a confession of something that failed, so they're often buried.  Typically, all the audience gets to see is the final product that makes them assume everything you attempted turned to gold.

Boxscore Prophet launches Week 1, frozen for the season, no midyear tweaks. So, before it goes live in all its amazing glory, here's where we show a few warts: three experiments from this summer that found nothing, published anyway. If you want to build trust with your audience, sometimes showing what didn't work makes for the best story to tell.  No matter what people tell you, all of your ideas are not the greatest ever.  Here's some proof.

## Thank You For Your Honesty

Before running any of these experiments, we set our decision rules in advance: what we expected to see, how big a miss would need to be to count as a finding, and the smallest sample size we'd trust.  Those numbers don't move once the results are in, and that's the discipline. First the effect-size, which we did vary based on position.  For running backs, wide receivers, and tight ends, it was 0.8 EPA of prediction error; for quarterbacks, who are noisier, it was 2.0 EPA. We also set a secondary honesty bar: a stated probability landing 4 percentage points or more off from what actually happened, measured on a cell of at least 400 player-weeks.  Umm, what is EPA again?  EPA (Expected Points Added) measures a play against expectation: not yards or touchdowns, but how many points that specific play was worth compared to the league-average outcome from that down, distance, and field position.

A miss big enough to matter but built on too small a sample doesn't count. One backed by enough data but too small to matter doesn't count either.  All of these misses get parked in a continue to monitor bucket, tagged with the year it becomes answerable. That second bucket is where the interesting results live. 

## You Can't Change The Weather

One of our initial experiments was to add specific weather features to the training set.  Five seasons of kickoff-hour forecasts, 2021 through 2025, outdoor games only, using the forecast as of Friday evening.  Never what actually happened on gameday.  Friday evening is all you might have when you're setting a lineup. 929 games, 12,271 player-weeks. Eighteen cells had enough data to test for an effect and none cleared the bar. Thirty-two had enough data to test for honesty, and the worst missed by 2.75 points, short of the 4-point bar.  

Here's the interesting part.  The weather still hits the field. It just hits Vegas' line first and the Vegas odds were already baked into the model.  A windy or wet outdoor game gets adjusted down to a lower total before kickoff, and our model has been reading opening totals since the betting-lines updated shipped in July. So we went looking for whatever wind, cold, and rain still had left to say once that layer was already in place.  What we found, Vegas said most of it first, so *"That's all I got to say about thaaat.."*

One cell did get bookmarked instead of fully buried: receivers in 15-plus mph wind hit a startable week 6.6 percentage points less often than we said.  Real effect, in the expected direction, but with only 265 player-weeks, short of the 400 floor.  This whole effect is just 52 *"windy"* games, and the league adds about ten a year, so whether to add it as a feature should become answerable by 2027.  You'll still be reading, right?  Everything else in the table was a temptation the floor saved us from: tight ends in rain off by 11.4 points on just 68 player-weeks, quarterbacks in sub-25-degree games by 9.5 on 46, quarterbacks in high wind by 8.6 on 107. All would have looked shippable to somebody without a floor written down in advance.  

Buffalo hosted New England in 2021 at 25.5 mph, and Emmanuel Sanders, Cole Beasley, Stefon Diggs, and Gabe Davis all underperformed together. Elijah Moore, Jerry Jeudy, and Gabe Davis lead the league in showing up windy, six such weeks each. Maybe we strongly reconsider the player weeks floor in future years, but for now *I'll stay*.

## The Big Uglies

Seven measurements of trench play, from your own line's sack and stuff rates allowed to the opponent's blitz rate. Eighty-four cells had enough data to test for an effect, and none cleared the bar. Worst honesty cell missed by 3.1 points, short of the 4-point bar. The pre-registered favorite going in was that stacked fronts smother running backs more than the model knows. It's not just absent, it's backwards. Across the three heavy-box groups, backs came in at plus-0.61, plus-0.17 and plus-0.41 relative to prediction. Yes, positive means they beat the model.

The only lean anywhere lives on quarterbacks, in four places: behind a line missing starters, minus-1.37. Behind a line that allows sacks, minus-0.96. Against a front that generates sacks, minus-0.84. Behind a line that gets stuffed, minus-0.82. All overprojected, all still short of the 2.0 bar. 

Worth being precise: these aren't four independent confirmations, they're four ways of measuring the same thing. A line missing starters is also the line that allows sacks, faces sack-heavy fronts, and gets stuffed, different symptoms of one bad day up front. The four groups barely overlap in which players and weeks they flag (a tenth to a fifth of players shared between any two, just 20 player-weeks across a decade landing in all four at once), but that's the noise in how you measure a shaky line, not four separate effects agreeing with each other.

It stays parked for a second, unrelated reason too: the measure depends on knowing who actually started, and that's not known until Sunday, and a signal that only grades out in hindsight isn't one we can use.

The quarterbacks who show up in that broken-line group most often: Matthew Stafford, 23 weeks. Aaron Rodgers, 18. Carson Wentz, 18. Ryan Tannehill, 16. Their single worst weeks in the sample belong to names like Deshaun Watson, Caleb Williams, and Bryce Young.  They're outliers out of nearly 600 player-weeks, not a pattern.

## Rookie Mistake

We tested rookies against veterans, by draft-capital tier, and by season phase. Nothing triggered. Worst honesty cell missed by 2.96 points, short of the 4-point bar.

The headline we wanted going in was that late-round rookies break out faster than draft-tier averages expect. Wrong direction at every position: day-three and undrafted rookies came in below predicted volume across the board, running backs 0.53 fewer opportunities, receivers 0.15 fewer targets, tight ends 0.20 fewer, quarterbacks 1.88 fewer dropbacks. If anything the existing machinery is already too generous to them. Dak Prescott and Brock Purdy both sit inside this exact population, which makes them the two most famous exceptions ever used to disprove the rule they're supposedly proof of.

The best temptation in the whole ladder showed up here: first-round rookie running backs beat their stated number by 10.6 percentage points, a finding that would have sold beautifully. It ran on 182 player-weeks, short of the 400 floor, and got thrown out anyway, because the bar doesn't know how good a story is. Zoom in and the floor earns its keep: those 182 player-weeks come from just thirteen backs, and not a league-wide trend.  Hard to generalize to elite talent like Christian McCaffrey, Saquon Barkley, and Bijan Robinson. Whether that's about who they are or the role they walked into is a question for a different piece.

## .400 Would Normally Get You Into the HOF

Two experiments this summer did find something. When the back ahead of your guy gets ruled out by Friday, the rolling averages hadn't caught up and we were underprojecting the backup by 3.8 touches.  The fix is in, and the error on those weeks are now down 14 percent. And the betting market knew things our own defensive adjustments didn't: adding the opening spread and implied total closed a gap where high-total games were understating a player's odds by up to 12 points. 

The whole summer of testing cost zero dollars: free weather archive, free opening lines, free public play-by-play. A $100 timestamped odds archive got evaluated and turned down.  Three nulls, two features, every bar written down before we looked. That's the whole trick, and it's also the whole pitch. The next piece in this series draws the actual line on what the model will and won't do for you.

---

*Method: five pre-registered experiments (weather, offensive line/defensive front, rookie priors, injury state, betting lines) run against a decade of walk-forward-validated, Friday-lock-only data via nflverse/nflreadr. Weather via free archival forecast data; betting lines via free opening spreads and totals. Full ablation ladder and code at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
