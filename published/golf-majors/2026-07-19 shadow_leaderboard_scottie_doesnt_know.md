# Scottie Doesn't Know

Eric Cole was my number one pick at the John Deere Classic. The model had him at 5.8% to win. DataGolf had him at 2.17%. He finished 39th.

Here's the part that stings: that pick went out four days after I "fixed" the model, and I had the backtest to prove it. Five weeks separate the US Open from The Open Championship, and nearly everything I tried in between failed. This is the story of how the failures found the actual bug, the one the wins kept hiding.

---

## 60% of the Time, It Works Every Time

At the US Open, the headline said the model had arrived: our win probabilities scored dead even with DataGolf. Frame it, I'm the Champion Golf Modeler of the World.

Then you look one layer down. In the 1-3% win probability band, the mid-tier, where most of the field actually lives, the rankings were upside down. The players the model liked least in that tier kept finishing ahead of the players it liked most, and Wyndham Clark won the whole tournament from inside that band at 1.6%. The culprit looked obvious: players with years of elite history and cooling recent games, the model's darlings, kept outranking the guys playing well *right now*.

## Groundhog Day

So I built features. Form windows, putting streaks, trend slopes, a full build cycle. Per-round accuracy before: 2.79 strokes. After: 2.79. Every variation I tried: 2.79. The number was effectively Thor's hammer. I was clearly not worthy!  But, it turns out there's a reason I couldn't budge that number, and it's pretty thoroughly researched. Even if you knew every player's true ability exactly, individual rounds bounce about 2.8 strokes (2.757 to be precise) around that ability on average. 

That was the first real clue, even if I read it late. The model predicts individual rounds fine and well in-line with the industry. The leak was downstream, in the part where we turn "how good is this guy" into "what are his chances".

## Lucy and the Football

After the feature spree, I re-ran the US Open and the broken tier flipped to healthy. Fixed! I believed it for exactly four days, at which point the John Deere happened in real life instead of in a backtest, the tier went right back to broken, and Eric Cole finished 39th while holding my number one pick.

Rule learned, hopefully permanently: a backtest on the same event that motivated your fix will tell you what you want to hear, every time. If the test isn't written down *before* the tournament, it isn't a test. It's a fairy tale.

## Eagle Fang vs. Myagi-Do

The next fix got real discipline. The challenger model on one machine, the incumbent model on another with both scoring the same tournament. For the Genesis Scottish Open, the expectations written down before the first tee time. The challenger trusted recent form harder, and I wrote down in advance exactly how that would fail if it failed: it would fall in love with hot names. On cue, it had Tyrrell Hatton at 4.2% against DataGolf's 1.9%.

The incumbent model won the head-to-head. Except when I decomposed the margin, the *entire* difference came down to one player. Scheffler: incumbent 10.1%, challenger 14.0%, DataGolf 14.8%. He missed the cut that week, so the lowest price "won." That's not a model evaluation. That's a coin flip with a leaderboard attached.

## Scottie Scheffler not doing Scottie Scheffler Things

Across three straight events, the model underpriced its own best players. The group it priced around 2% to win was winning at about 3.5%. When it predicts a player is about to have an elite week, the player outperforms even that call. And elite players are measurably steadier round-to-round, but the simulation was handing everyone the same volatility, pricing Scheffler like a field-average golfer with a sightly better resume.

Ah the irony, I'm telling you the model undervalues Scottie Scheffler the same week he shot 78 and went home early. Channeling my inner 7 year old, I point out that DataGolf had him at 15% to win too!  Scottie typically wins about one start in seven,  and in the other six, the miss usually looks like a T5, not a Friday flight back to Texas. The fade is a nickel business. Every week Scheffler doesn't win, pricing him at 10% instead of 15% picks up a nickel. The week he does win, it hands back 35 cents, and he wins four or five times a year. 

The Cole disaster and the Scheffler discount are the same bug. Probabilities have to add up to 100%. Every point the top of the board doesn't get has to land somewhere, and it was landing on the darlings.

## Next Stop, The Claret Jug!

The fix going into The Open isn't a new feature. It's two changes to the probability layer: stop hedging the elite predictions, and give steady players credit for being steady. Both written down before the tournament, both running as a shadow model against production, scored against DataGolf and the betting market on the whole board.

It's not built on whether one large Texan lifts a jug, but I do like his chances.

---

*Evaluation across the US Open, John Deere Classic, and Genesis Scottish Open; the John Deere and the Genesis were scored prospectively against expectations written down pre-tournament. DataGolf API for skill priors, field data, and market baselines. DataGolf: Golf is really, really random Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
