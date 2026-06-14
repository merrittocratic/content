# Who the F* is Private Santiago?

Colonel Jessep said it, and sometimes I feel it when reviewing the results from a model trying to predict the winner of a golf tournament.  Predicting golf is already a humbling enterprise. Predicting it at a US Open is several rungs harder.  So, when your model predicts Jimmy Stanger has a high probability of winning the tournament the week before the U.S. Open, you can't help but think: "Who the F is Jimmy Stanger?"

Then Stanger goes out and shoots 5-under in Round 1, 3-under in Round 2 (-8 overall) T7, and suddenly you think, maybe just maybe, this might all work out after all.

## A Mighty Wind

My pre-PGA Championship model had a few holes in it, with the most urgent fix being weather.  During the last U.S. Open at Shinnecock, there was close to a 7-stroke difference between the morning and afternoon rounds on Saturday.  This makes not having weather in the model feel a bit like being a time-traveling placekick holder for Scott Norwood.  You just know the result is going to be a little "wide right".  So, the model now integrates ERA5 reanalysis data: hourly weather at exact course coordinates for every round dating back to 2010. Wind speed, wind direction, temperature, and precipitation, matched to each player's tee time window. Not a daily average, but the actual conditions that every player experienced.

Shinnecock sits exposed on eastern Long Island with nothing between it and the Atlantic.  So the morning and afternoon waves often won't even play the same golf course.  The improvement in prediction accuracy gained is real but modest in the training data because weather isn't the most important lever at most venues.  At Shinnecock though, it's probably the most meaningful course-specific signal we could add.

## Stacking Wins

The fix is in.  No, not for gambling, but a fix for taking a point prediction for strokes gained, and then applying that to determining who has a real chance to win the tournament.

The first try at the stacking layer, the piece that converts strokes gained predictions into win probabilities, was wrong in a specific and fixable way. It included random effects for player-season and course. This means that the model is effectively always scoring a new season and a new tournament that it has never seen before. So, those effects have no anchor. They just add noise.

Dropping those effects from the win probability stack fixed the calibration. The prediction coefficient on the strokes gained output nearly doubled after the change.  The win probability is now anchored where it belongs, on a player's talent and recent form, instead of getting redistributed into variance the model was accidentally calling signal. The win probability leaderboard now has real separation between the good bets and the rest of the field.

This was the most meaningful improvement of the offseason. The practical result is a model that is no longer working against itself.  Sorry, that was a lot of nerd-ery!

## Knowing is half the battle

Two related improvements, both about strokes gained components.

The first is pre-tournament.  Instead of just a single number, our rolling 8-event form now runs by component: off-the-tee, approach, around-the-green, and putting. A player who has been an elite putter over his last eight events now gets that credit going in. A player whose approach play has been quietly excellent for two months gets that credit too.

The second is in-tournament. Component strokes gained from each completed round now also feed back into the round-by-round prediction. If a player drove it well in round 1 but lost shots everywhere from 100 yards and in, the model going into round 2 sees the component breakdown, not just the total. A player who drove it beautifully but couldn't make a putt is a better round 2 bet than his overall number suggests. The model now knows that going in rather than finding out after the fact.

At Shinnecock, tee-to-green actually carries more weight than putting, so the distinction matters.

## Always Watching

Earnest is finally starting to earn his keep in this process.  A reminder, Earnest is the OpenClaw AI agent who lives on a Mac Mini who used to be my Social Media coordinator.  Well, he's received a small promotion and now every round of every tournament runs live through Earnest.  His core jobs: detect when a round closes, trigger the model to re-score based on the previous round, push the updated leaderboard to Telegram with enough context for me to decide whether there's content worth writing. That's it. The piece that doesn't scale for a one-person operation is sitting down every 30 minutes to check whether anything interesting happened. Earnest does it automatically and tells me when there is something worth paying attention to.

During every live round, Earnest is on the lookout for players on a heater who are outperforming their model projection or a player who is crashing back down to earth after two amazing rounds.  He handles rain delays and suspensions, and detects when API feeds freeze and he suppresses alerts until the data moves again.

Now, I get updates like this: Tommy Fleetwood is +2.4 SG through 11 — 100th percentile per our model. Pre-round win prob was 5%; top-10 was 5%.

## Now We Find Out

Here's where the model stands going into Thursday's opening round at Shinnecock.



This is the first genuine stress test: four days, USGA setup, exposed course, weather as a primary variable, and a field that includes a meaningful contingent of European Tour and LIV Tour players who need PGA tour approximations that may not be perfect, but are principled.  

The model will be wrong about some things. The wind will do something nobody modeled. A player with 11 events of Tour history will lead through 36 holes and break every prior we have. That's fine. The goal is not to nail the winner. The goal is to produce a leaderboard where the good bets are where they should be, and where Earnest can surface the things worth paying attention to as they happen.

The model found Stanger before the opening round at the RBC, so bring on Shinnecock!

---

*Model runs on PGA Tour 2010-2025 and DP World Tour historical strokes gained data. Weather features via ERA5 reanalysis at tee-time UTC resolution. Skill priors anchored to DataGolf rolling history with exponential decay. Course component weights derived from venue taxonomy. Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
