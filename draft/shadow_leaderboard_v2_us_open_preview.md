# Shadow Leaderboard 2.0: Shinnecock Doesn't Care About Your Career Average

---

The PGA Championship post-cut piece ended with a promise: "Resolving all of this is exactly what's going into the Shinnecock roadmap."

Consider it resolved. Mostly.

The Shadow Leaderboard ran its first public tournament at Aronimink and came out of it with receipts — some good, some humbling. Aberg posted one of the best ball-striking weeks in the field and the model ranked him 17th. Hatton's form-only case evaporated the moment the course got hard, exactly as the prior said it would. Rory's Thursday looked like a blowup; his skill prior said it was noise; he shot 67 on Friday. Three weeks of surgery later, the version that scores Shinnecock is meaningfully different. Three changes. One piece of plumbing.

---

## Your 2022 Cam Smith Is Not Your 2026 Cam Smith

The old player skill prior was a flat multi-year mean of strokes-gained total. Feed it Cam Smith and it returns one number — a blend of his LIV defection prime and whatever he's shown us since, as if both seasons belong to the same golfer. They don't.

The new prior is exponentially decayed with a ~2.4-year half-life. The last two seasons carry about two-thirds of the weight; the long tail still anchors players to their career mean, but the model now knows what year it's in. A new `n_prior_rounds` feature also captures how much evidence sits behind each prior — Scottie Scheffler's 300-round signal and a Q-school graduate's 18-round whisper are no longer treated with equal confidence.

The Memorial after Round 1 is already showing what the fix looks like. Kristoffer Reitan — the player the old model ranked 97th at Truist while he was actively winning the tournament — is at Muirfield Village this week. In the old model, his career skill prior was -3.965. In the new model, with Euro data and prior decay: **-0.651**. Still slightly below average, but no longer an anchor. He had a rough opening round (-1.94 vs. the field) and sits 44th. That's a defensible result for a player who had a bad day. 97th while winning versus 44th after a bad round is the difference between a broken prior and a working one.

Aberg is the same correction, milder version. His prior moved from -0.270 to -0.096 — nearly at par for the field. He's 26th after a solid opening round, with a 30% top-10 probability. At Aronimink the model watched him post elite ball-striking and filed it under "probably an outlier." This week it has him at 3% to win. Still conservative, but in the right neighborhood.

The DP World Tour is also in the model now. Euro rounds enter the strokes-gained prior at a 0.5 weight from same-player cross-tour regression (empirical coefficient ≈ 0.51). It's a field-strength correction, not a course-difficulty one — SG is already computed relative to the field at each event, so course difficulty is differenced out by definition. What the 0.5 corrects for is that beating a DP World Tour field reflects less raw skill than beating a PGA Tour field by the same margin. Euro rounds also enter `n_prior_rounds` at half-weight, so the model knows a prior built mostly on DP World data is thinner evidence.

The Memorial is already showing the payoff. Fleetwood led the field with a +6.06 opening round and sits 6th with a 55% top-10 probability. His prior is 0.751, built on 168 events — a count that only gets that high when DP World rounds are in the ledger. He came into the week with slightly *negative* recent form (-0.10), not a hot-hand story at all. The model ranked him near the top on career credentials alone, and he backed it up. One caveat for the methodology-inclined: component priors (OTT, APP, ARG, PUTT) remain PGA-only, since Euro data feeds total-SG only. For players with thin PGA component samples, the course-fit score is still doing some estimation in the dark.

---

## Shinnecock Is Not Augusta Is Not Sawgrass

Course fit was hand-coded for Aronimink. For Shinnecock and every venue going forward, it's derived.

156 venues are now classified by architect school (Tillinghast, MacKenzie, Dye), course style (links, parkland, desert), and rough severity. Per-venue strokes-gained component weights are then calculated from relative variance across the historical field — which SG components actually separate skill from noise at this specific place — not from intuition about what a course rewards. 120 venues have empirical weights; Shinnecock is one of 36 that use group-level weights imputed from links-style, Tillinghast-design, high-rough-severity peers.

Each player enters the week with a course fit score: component weights applied against their own prior profile. The Memorial is a useful illustration of why the distinction matters. Muirfield Village weights approach play as the dominant discriminator: OTT 23%, **APP 31%**, ARG 23%, PUTT 23%. Shinnecock flips the profile: **OTT 30%**, APP 21%, **ARG 26%**, PUTT 23%. A player thriving at the Memorial on elite iron play is getting a course-fit boost this week that won't transfer at the same rate to a links layout where driving and scrambling carry more weight. The Memorial leaderboard is not a straight map to the U.S. Open field print.

---

## Same Tee Time Is Not Same Weather

This is the change that matters most for Shinnecock specifically, and it didn't exist at Aronimink at all.

ERA5 hourly weather — via Open-Meteo — is now joined to every player-round back to 2010, matched to the actual UTC tee hour for 2017+ data. Wind speed, wind direction, temperature, precipitation. Pre-2017 rows use daily averages, down-weighted via a `weather_precision` flag.

Why does it matter here? Because Shinnecock sits on the south shore of Long Island and its weather doesn't stay still. Anyone who watched 2018 knows: Brooks Koepka hoisted the trophy while the morning wave was grinding through 35 mph gusts that made par a winning score on some holes. A morning wave with calm air and an afternoon wave at 18 mph onshore is not one shared row of conditions — it's 156 different rows, and each player now gets their own forecasted weather matched to their actual tee time. When the coastal forecast splits, the leaderboard will show it. That's new.

---

## And the Plumbing: Now With Error Bars

Point predictions still come from the tuned gradient boosted tree — same workhorse as Aronimink. Residual uncertainty is now drawn from a Bayesian model fitted alongside it. The result: the leaderboard now publishes calibrated win probabilities, top-5 probabilities, and top-10 probabilities.

Yes, every commercial golf model in the world has these numbers. Ours are ours now.

---

## What to Watch For

Two patterns the old model couldn't catch are now live:

**Links-style fit.** Shinnecock will surface players the Euro-enriched prior combined with links course weights favor — open-stance bombers and DP World Tour grinders who were underweighted at Aronimink. Pay attention to anyone with a strong OTT prior on a course where driving variance is high.

**Wave-dependent predictions.** When the coastal forecast splits, morning and afternoon wave players print different probabilities. If Thursday has a genuine weather split — and Shinnecock in June has a real track record of providing one — the leaderboard will show it.

First field print runs Thursday morning. The picks are inside it.

---

*Shadow Leaderboard predictions derived from DataGolf API strokes-gained data, Open-Meteo ERA5 weather joined at hourly UTC tee times, and a two-stage model: tuned GBDT first stage + brms Bayesian posterior for uncertainty quantification. Course weights derived from relative SG variance methodology across 156 venues. Full model at [github.com/merrittocratic/shadow-leaderboard](https://github.com/merrittocratic/shadow-leaderboard).*
