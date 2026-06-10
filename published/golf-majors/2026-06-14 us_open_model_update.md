# Instrument Check Before Shinnecock

Predicting golf is already a humbling enterprise. Predicting golf at a US Open set up by the USGA is several rungs worse. Predicting golf at Shinnecock Hills, where the wind comes off the Atlantic with opinions about your model, is the tier above that.

## It Was Always About the Wind

The model now integrates ERA5 reanalysis data -- hourly weather at exact course coordinates for every round back to 2010. Wind speed, wind direction, temperature, and precipitation, matched to each player's tee time UTC window. Not a daily average. The actual conditions that player played in.

Shinnecock sits exposed on eastern Long Island with nothing between it and the Atlantic. In 1995, 2004, and 2018, the scoring average differential between calm and windy rounds was [verify: approximately 3-5 strokes per side?]. Morning and afternoon waves in those conditions aren't the same golf course.

The improvement in prediction accuracy on held-out rounds is real but modest [insert RMSE delta here]. Weather isn't the lever at most venues. At Shinnecock, it's probably the most meaningful course-specific signal we have outside of the strokes gained component weights the course taxonomy provides.

## The Confession Booth

This is the part I should have written when the Reitan miss happened, but the brms fix wasn't in yet. So here we are.

The stacking layer -- the piece that converts LightGBM point predictions into win probabilities -- was wrong in a specific and fixable way. It included random effects for player-season and course. The problem is that in production the model is always scoring a new season and a new tournament it has never seen before. Those effects have no anchor. They just add noise.

Dropping them fixed the calibration. The model's prediction coefficient [insert before/after value here] jumped meaningfully after the change. Probability mass now lands where it belongs -- on player talent and recent form -- instead of getting redistributed into variance the model was accidentally calling signal. The win probability leaderboard now has real separation between the good bets and the rest of the field.

This was the most meaningful improvement of the offseason. The practical result is a model that is no longer working against itself.

## Now the Model Knows Why

Two related improvements, both about strokes gained components.

The first is pre-tournament. Rolling 8-event form now runs by component: off-the-tee, approach, around-the-green, putting. A player who has been an elite putter over his last eight events gets that credit going in. A player whose approach play has been quietly excellent for two months gets that credit too.

The second is in-tournament. Component strokes gained from each completed round now feed back into the round-by-round prediction. If a player drove it well in round 1 but lost shots everywhere from 100 yards and in, the model going into round 2 sees the component breakdown, not just the total. A player who drove it beautifully but couldn't make a putt is a better round 2 bet than his overall number suggests. The model now knows that going in rather than finding out after the fact.

At Shinnecock, where off-the-tee and approach carry meaningfully more weight than at a putting-premium course, the distinction matters.

## Earnest on Watch

All of this runs live through Earnest -- the OpenClaw agent on the Mac Mini, connected to the DataGolf API during tournament week.

His core job: detect when a round closes, trigger the model rerun, push the updated leaderboard to Telegram with enough context to decide whether there's content worth writing. That's it. The piece that doesn't scale for a one-person operation is sitting down every 30 minutes to check whether anything interesting happened. Earnest does it automatically and tells me what to pay attention to.

During active play, he runs a lighter check on that 30-minute clock. No full re-score. Just a gap analysis: where is each player against their pre-round prediction, and who is moving fast enough in either direction to be worth flagging? "Player is playing well" is not a Telegram alert. "Player is massively outperforming their round 2 model projection through eight holes" gets a message.

He also handles rain delays and suspensions -- detects when the DataGolf feed freezes and suppresses alerts until data moves again. [Name the event this burned us on if you want to call it out.]

What Earnest still can't do: re-score mid-round. The model trained on completed round data. Feeding it partial strokes gained from an active round is an out-of-distribution problem that produces confident-looking garbage. Not fixed by Thursday. The US Open will run on full completed-round re-scores only, which means the model goes quiet during active play and speaks after the round closes. That's a real limitation. Calling it something else would be the thing this brand exists to call out.

## Now We Find Out

Shinnecock is the first genuine stress test: five days, USGA setup, exposed course, weather as a primary variable, and a field that includes a meaningful contingent of European Tour players whose DataGolf histories carry a cross-tour correction [~0.51 coefficient from OLS on historical SG differentials] that approximates PGA Tour equivalence without perfectly replicating it. That correction is principled. It's also still an approximation.

The model will be wrong about some things. The wind will do something nobody modeled. A player with 11 events of Tour history will lead through 36 holes and break every prior we have. That's fine. The goal is not to nail the winner. The goal is to produce a leaderboard where the good bets are where they should be, and where Earnest can surface the things worth paying attention to as they happen.

If something breaks, we'll write about that too. That's what this is.

---

*Model runs on PGA Tour 2010-2025 and DP World Tour historical strokes gained data. Weather features via ERA5 reanalysis at tee-time UTC resolution. Skill priors anchored to DataGolf rolling history with exponential decay. Course component weights derived from venue taxonomy. Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
