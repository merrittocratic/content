# Scottie Doesn't Know

Eric Cole was my number one pick at the John Deere Classic. The model had him at 5.8% to win. DataGolf had him at 2.17%. He finished 39th.

Here's the part that stings: that pick went out four days after I "fixed" the model, and I had the backtest to prove it. Five weeks separate the US Open from The Open Championship, and nearly everything I tried in between failed. This is the story of how the failures found the actual bug -- the one the wins kept hiding.

---

## 60% of the Time, It Works Every Time

At the US Open, the headline said the model had arrived: our win probabilities scored dead even with DataGolf. Frame it, hang it in the den.

Then you look one layer down. In the 1-3% win probability band -- the mid-tier, where most of a golf field actually lives -- the rankings were upside down. The players the model liked least in that tier kept finishing ahead of the players it liked most, and Wyndham Clark won the whole tournament from inside that band at 1.6%. The culprit looked obvious: players with years of elite history and cooling recent games -- the model's darlings -- kept outranking the guys playing well *right now*.

## Groundhog Day

So I built features. Form windows, putting streaks, trend slopes -- a full build cycle. Per-round accuracy before: 2.79 strokes. After: 2.79. Every variation I tried: 2.79. I could not move that number with a forklift.

That was the first real clue, even if I read it late. The model predicts individual rounds fine. The leak was downstream, in the part that turns "how good is this guy" into "what are his chances."

## Lucy and the Football

After the feature spree, I re-ran the US Open and the broken tier flipped to healthy. Fixed! I believed it for exactly four days, at which point the John Deere happened in real life instead of in a backtest, the tier went right back to broken, and Eric Cole finished 39th holding my number one pick.

Rule learned, hopefully permanently: a backtest of the same event that motivated your fix will tell you what you want to hear, every time. If the test isn't written down *before* the tournament, it isn't a test. It's a bedtime story.

## Two Models Enter

The next fix got real discipline. Challenger model on one machine, current model on the other, same tournament -- the Genesis Scottish Open -- expectations written down before the first tee. The challenger trusted recent form harder, and I wrote down in advance exactly how that would fail if it failed: it would fall in love with hot names. On cue, it had Tyrrell Hatton at 4.2% against DataGolf's 1.9%.

The incumbent won the head-to-head. Except when I decomposed the margin, the *entire* difference came down to one player. Scheffler: incumbent 10.1%, challenger 14.0%, DataGolf 14.8%. He missed the cut that week, so the lowest price "won." That's not a model evaluation. That's a coin flip with a leaderboard attached.

## Shocked to Find Gambling in This Establishment

Then my diagnostic got caught cheating. Chasing a discrepancy, I ran the *same* model through the evaluation twice -- nothing different but the random draws inside the simulation. The mid-tier health metric went from "genius" to "broken" between runs. The number I'd chased for five weeks moves nearly as much from dice as from decisions. It's fixed now -- 24,000 simulations instead of 2,000, with a locked seed -- but some of that mid-tier panic was never real.

Three misses survived every re-check, though. All pointing the same direction.

## Let Scottie Be Scottie

Across three straight events, the model underpriced its own best players. The group it priced around 2% to win was winning at about 3.5%. When it predicts a player is about to have an elite week, he outperforms even that call. And elite players are measurably steadier round to round -- but the simulation was handing everyone the same volatility, pricing Scheffler like a field-average golfer with a nicer resume.

And yes -- I'm telling you the model undervalues Scottie Scheffler the same week the man shot 78 and went home early. DataGolf had him at 15% that week too. But 15% was never a promise about the cut. He doesn't win six weeks out of seven, and the miss usually looks like a T12, not a Friday flight. Here's the fade's actual accounting: every week Scheffler doesn't win, pricing him at 10% instead of 15% pays the model a nickel. Every week he wins, it costs seven nickels -- and he does that four or five times a year. That's the whole business: picking up nickels in front of a steamroller. It feels like a paycheck right up until it's a tire track.

The Cole disaster and the Scheffler discount are the same bug. Probabilities have to add up to 100%. Every point the top of the board doesn't get has to land somewhere, and it was landing on the darlings.

## Now We Find Out

The fix going into The Open isn't a new feature. It's two changes to the probability layer: stop hedging the elite predictions, and give steady players credit for being steady. Both written down before the tournament, both running as a shadow model against production, scored against DataGolf and the betting market on the whole board -- not on whether one large Texan lifts a jug.

If it works, it won't be because a backtest smiled at me. Fool me once.

---

*Evaluation across the US Open, John Deere Classic, and Genesis Scottish Open; the John Deere and the Genesis were scored prospectively against expectations written down pre-tournament. DataGolf API for skill priors, field data, and market baselines. Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
