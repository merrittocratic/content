# The Leaderboard That Didn't Know What Round It Was In

---

Kristoffer Reitan did something to our model at Aronimink. He finished in contention from a 97th-place pre-tournament projection and forced an honest question: not "why was the model wrong" but "what specifically broke and how do you fix it?"

The answer was the prior problem. Reitan came in with a catastrophically negative career baseline and a form mean that was the highest in the field. The model averaged them and the prior won. He outperformed anyway. The form rocket problem piece was the honest accounting of that miss. What it didn't answer was what happened when that problem scaled across an entire field.

The RBC Canadian Open was the answer nobody wanted to see.

---

## When the Whole Field Was Reitan

The model's actual top-10 finishers at the RBC had an average pre-tournament rank of 51.3. Suber. Stanger. Garnett. Potgieter. All top-10 finishers. All came in with career priors the model didn't trust. We had found Stanger -- the Private Santiago piece flagged his form and he finished T7 -- but Stanger was the one the model happened to surface. The logic that worked for him didn't extend to the rest of the hot-but-low-prior group.

What the model didn't account for: the RBC is a different kind of event. Weaker field. Lower scoring average. On a course set up to give birdies to everyone who shows up, the gap between the world's 20th-best player and the 60th-best narrows. The model applied major-championship confidence to a birdie-fest. Top-10 Brier skill: +0.3%. Essentially nothing.

---

## What Shinnecock Confirmed

The US Open cleaned up the accounting. The actual top-10 finishers at Shinnecock had an average model rank of 32.4. Top-10 Brier skill was +10.2%. The model still didn't call the winner -- Wyndham Clark was 19th pre-tournament -- but the players it liked were meaningfully better positioned than a random draw would produce.

The live stack is where Clark showed up. After Round 2, his win probability jumped from 2.6% to 33.4%. A +30.8 point swing anchored to one round of scoring at one of the hardest setups in golf. The stacking layer rewrite -- dropping the random effects that were adding noise instead of signal -- showed up in a single number.

Two events. Same structural miss on the winner. Completely different calibration quality underneath. The signal is real. The model just doesn't know what event it's at.

---

## What the System Looks Like Now

Tournament preview goes out before the first round. Earnest monitors live scoring, fires heater and crasher alerts during the event, and re-scores the leaderboard after each round closes. After the tournament, the post-mortem pipeline runs -- pre-tournament probability estimates joined back to actual outcomes, decomposed by tier, surfacing where the rank ordering held and where it broke. The wrap-up piece writes from that diagnostic output. Not memory. Not feel. The evaluation.

---

## What Still Needs Fixing

Event-type awareness. The RBC and the US Open are not the same exercise, and the model needs to know that before it assigns probabilities.

Hot-but-low-prior players in volatile events. At Aronimink, Reitan was one player. At the RBC, he had company across the whole top 10. When the field is chaotic, form should lead. In majors, the prior discipline is appropriate -- Shinnecock validated it. The fix is conditional.

The 1--3% win probability range. Rank inversions in that tier are happening at a rate that isn't noise. The probability layer is too compressed in the middle of the field.

The core signal is real. The confidence is applied in the wrong places. That's what the next build cycle fixes -- and the post-mortem pipeline is what will show whether it worked.

---

*Model evaluation via Brier score decomposition across RBC Canadian Open and US Open outcomes. DataGolf API for skill priors and field data. Code at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
