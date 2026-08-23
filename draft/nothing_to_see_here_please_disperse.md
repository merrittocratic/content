# Nothing to See Here, Please Disperse

Anybody can show you the thing that worked. The hard part, the part almost nobody does, is showing you what came back empty. A null result feels like a confession, so most shops bury theirs and let you assume everything they tried turned to gold.

Boxscore Prophet launches Week 1, frozen for the season, no midyear tweaks. So before it goes live, here's the other half of the discipline: three experiments from this summer that found nothing, published anyway. If you want to know whether a model shop is telling you the truth, watch what they do with a null.

## Do or Do Not, There Is No Try

Every experiment got a decision written down before we saw the data: what we expected, what size of miss would count as a finding, and the smallest sample we'd trust. Those numbers don't move once results are in. An effect bar of 0.8 EPA of prediction error, 2.0 for quarterbacks because they're noisier, on a cell of at least 300 player-weeks. A honesty bar of a stated probability landing 4 percentage points or more off from what actually happened, on a cell of at least 400 player-weeks.

Big enough but under the bar doesn't count. Over the bar but too small doesn't count either -- it gets parked in a watch registry with the year it becomes answerable. That second bucket is where the good stuff lives. One honest caveat: you can verify the bars were dated and published before results came in, but the code and results got saved together, so the ordering itself is something you're trusting us on, not something the repo proves by itself. Better to say that plainly than let you assume more rigor than we can show.

## Blame It on the Rain

The weather still hits the field. It just hits Vegas' line first. A windy or wet outdoor game gets marked down to a lower total before kickoff, and our model has been reading opening totals since the betting-lines rung shipped in July. So we went looking for whatever wind, cold, and rain still had left to say once that layer was already in place.

Five seasons of kickoff-hour forecasts, 2021 through 2025, outdoor games only, using the forecast as of Friday lock and never what actually happened -- Friday is all you have when you're setting a lineup. 929 games, 12,271 player-weeks. Eighteen effect cells were big enough to count. Zero cleared the bar. Thirty-two honesty cells were big enough. The worst missed by 2.75 points against a 4-point bar. Not much left to say, because Vegas said most of it first.

One cell got bookmarked instead of buried: receivers in 15-plus mph wind hit a startable week 6.6 percentage points less often than we said -- the gap between calling a guy 25 percent and watching him land at 18. Real, in the expected direction, sitting on 265 player-weeks against a 400 floor, drawn from just 52 windy games. The league adds about ten a year, so around 2027 or 2028 it becomes answerable. Everything else in the table was a temptation the floor saved us from: tight ends in rain off by 11.4 points on 68 player-weeks, quarterbacks in sub-25-degree games by 9.5 on 46, quarterbacks in high wind by 8.6 on 107. All would have looked shippable to somebody without a floor written down in advance.

Buffalo hosted New England in 2021 at 25.5 mph, and Emmanuel Sanders, Cole Beasley, Stefon Diggs, and Gabriel Davis all underperformed together. Elijah Moore and Jerry Jeudy lead the league in showing up windy, six such weeks each. Wind doesn't care about your depth chart.

## The Blind Side

Seven measurements of trench play, from your own line's sack and stuff rates allowed to the opponent's blitz rate. Eighty-four effect cells, all big enough, zero over the bar. Worst honesty cell missed by 3.1 against 4.

The pre-registered favorite going in was that stacked fronts smother running backs more than the model knows. It's not just absent, it's backwards. Across the three heavy-box groups, backs came in at plus-0.61, plus-0.17 and plus-0.41 relative to prediction -- positive means they beat the model.

The only lean anywhere lives on quarterbacks, in four places: behind a line missing starters, minus-1.37. Behind a line that allows sacks, minus-0.96. Against a front that generates sacks, minus-0.84. Behind a line that gets stuffed, minus-0.82. All overprojected, all short of the 2.0 bar. Worth being precise: this is four correlated readings of one mechanism, not four independent confirmations. Any two of those groups share only a tenth to a fifth of their players, and across a decade only 20 player-weeks land in all four at once. It stays parked for a second reason too -- the continuity measure uses who actually started, which you only know on Sunday, and a feature that grades beautifully in hindsight but can't be built on a Tuesday is a trap.

The quarterbacks who show up in that broken-line group most often: Matthew Stafford, 23 weeks. Aaron Rodgers, 18. Carson Wentz, 18. Ryan Tannehill, 16. Their single worst weeks in the sample belong to names like Deshaun Watson, Caleb Williams, and Bryce Young -- outliers out of nearly 600 player-weeks, not a pattern, so treat them as exactly that.

## Rookie of the Year

Tested rookies against veterans, by draft-capital tier, and by season phase. Nothing triggered. Worst honesty cell missed by 2.96 against 4.

The headline we wanted going in was that late-round rookies break out faster than draft-tier averages expect. Wrong direction at every position -- day-three and undrafted rookies came in below predicted volume across the board, running backs 0.53 fewer opportunities, receivers 0.15 fewer targets, tight ends 0.20 fewer, quarterbacks 1.88 fewer dropbacks. If anything the existing machinery is already a touch too generous to them. Dak Prescott and Brock Purdy both sit inside that exact population, which makes them the two most famous exceptions ever used to disprove the rule they're supposedly proof of.

The best temptation in the whole ladder showed up here: first-round rookie running backs beat their stated number by 10.6 percentage points, a finding that would have sold beautifully. It ran on 182 player-weeks against a 400 floor, and got thrown out anyway, because the bar doesn't know how good a story is.

## Two Out of Five Ain't Bad

Two experiments this summer did find something. When the back ahead of your guy gets ruled out by Friday, the rolling averages hadn't caught up and we were underprojecting the backup by 3.8 touches -- fixed now, error on those weeks down 14 percent. And the betting market knew things our own defensive adjustments didn't: adding the opening spread and implied total closed a gap where high-total games were understating a player's odds by up to 12 points. Opening lines, not closing, because openers are the only version knowable on a Friday.

The whole summer of testing cost zero dollars -- free weather archive, free opening lines, free public play-by-play. A $100 timestamped odds archive got evaluated and turned down. The one bill actually coming isn't for data we bought, it's a licensing wrinkle: the weather archive is free for non-commercial use, so once this newsletter makes money, we owe about 30 euros a month for the privilege of knowing it was windy.

Three nulls, two features, every bar written down before we looked. That's the whole trick, and it's also the whole pitch. Tuesday, the next piece in this series draws the actual line on what the model won't do for you either.

---

*Method: five pre-registered experiments (weather, offensive line/defensive front, rookie priors, injury state, betting lines) run against a decade of walk-forward-validated, Friday-lock-only data via nflverse/nflreadr. Weather via free archival forecast data; betting lines via free opening spreads and totals. Full ablation ladder and code at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
