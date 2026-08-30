# Fact sheet: the three published nulls (ablation ladder rungs 3, 4, 5)

For "Nothing to See Here, Please Disperse" -- Substack, Fri 2026-08-28.
Compiled 2026-08-23. Data pull only: no experiment rerun, no model fit.

**How to read the citations.** `file:line` points at the exact line.
Table rows are cited as `file [axis/position/bucket]` so you can grep
them. Anything I derived today by filtering a stored artifact is
labeled **DERIVED TODAY** and is not a published number.

**Sign convention** (applies throughout): residual = observed minus
predicted. **Negative = the model OVER-predicted.** Positive = the
model under-predicted. Verified against README:673 (D21 describes the
negative QB cells as "overpredicted").

---

## 0. READ THIS BEFORE YOU WRITE THE PIECE

Four things that change sentences already in the Aug 28 draft.

**0.1 -- The ladder cost $0. The draft says otherwise and is wrong.**
The current draft of the post says weather cost "real money" and
refers to "one we paid for." No money was spent on any rung. Weather
came from the Open-Meteo free historical-forecast archive
(`R/14a0_weather_fetch.R:16`, CC-BY 4.0). Vegas came from free opening
lines; README:555 states "NO ODDS PURCHASE. Recurring line-data cost:
$0." See section 8.3 for the one forward-looking cost that is a
licensing obligation, not a spend. **Cut the money line.**

**0.2 -- "One cell wearing four hats" overstates the overlap.**
The four QB trench cells are far more disjoint than that phrase
implies: pairwise Jaccard 0.075 to 0.208, and only 20 player-weeks sit
in all four (section 3.4). They tell the same story; they are not
mostly the same rows. Suggested replacement framing: *four correlated
axes, one mechanism* -- defensible against the numbers. The current
draft's "Drawn from the same player-weeks four different ways" is not.

**0.3 -- The pre-registration gap is days, not weeks, and rung-level
bars were locked same-day.** The ladder (order, families, the
Friday-reconstructable rule) was pre-registered 2026-07-18. Each
rung's specific numeric bars were locked in the script header on the
day that rung ran. For rungs 4 and 5 the pre-registration date and the
closure date are the same date. Section 1 gives both columns.

Same-day is not a weakness and the piece should not apologize for it.
What matters is that the rule preceded the run, and it did -- writing
the bar in the morning and getting the answer that afternoon is how a
one-day diagnostic is supposed to go. The only claim to avoid is that
a reader can verify the ordering themselves; see 0.4.

**0.4 -- Git does not independently prove the bars predate the run.**
For all three nulls, the diagnostic script and its output CSVs were
committed in the same commit (14a: `b23a9eb` 2026-07-26 10:22; 15a:
`84a9bcd` 2026-08-01 07:49; 16a: `6ac5666` 2026-08-01 09:24). The
evidence that bars were locked first is the dated header text and the
recorded Steve sign-off, not a timestamp separation. That is normal
practice and I am not calling it a problem; I am flagging that a
hostile reader cannot verify ordering from the repo, so the piece
should not claim they can.

---

## 1. LADDER SUMMARY TABLE

The pre-registration listed **six** families (`building_in_public_log.md:171-187`).
It is described as a five-rung ladder because #6 (rest/travel) was
declared batched into rung 2. See the gap at 1.3.

| Rung | Family | Pre-stated expectation | Pre-committed bar | Observed | Verdict | Pre-reg date | Closed |
|---|---|---|---|---|---|---|---|
| 1 | Injury practice-report state machine | Fresh-shock vol residual moves from +3.8 toward 0; return-week from -1.0 toward 0; pooled rubric unchanged | Ship only if transition-state RMSE improves AND no rubric regression; flat = publish null (`R/11c_rb_injury_ab.R:16-25`) | RB fresh-shock bias +3.83 -> +0.96; vol RMSE on those weeks -14%; WR flat | **SHIP** (RB) + published null (WR) | 2026-07-18 | 2026-07-18 |
| 2 | Vegas lines (spread, total, implied) | "the cheap control. Expect flat RMSE on the solved component" (`building_in_public_log.md:176-178`); volume flat, honesty within +-2pp | Advance only if a cell n>=300 has \|mean vol resid\| >= 1.0 opp (QB >= 2.0 dropbacks), OR a cell n>=500 has \|stated-emp\| >= 3pp (`R/13a_vegas_diagnostic.R:34-42`) | Expectation FAILED. Volume flat as predicted, but total-EPA gradient at all four positions; 32 dishonest cells; QB high-implied understated 11.6pp | **SHIP** (3 layers) | 2026-07-19 | ablation 2026-07-19, shipped 2026-07-26 |
| 3 | Weather (Open-Meteo forecast archive) | "MOSTLY ABSORBED"; one live candidate = 15+ mph wind; "Prior verdict: NULL or a thin wind-only adjustment" (`R/14a_weather_diagnostic.R:20-26`) | Resid >= 0.8 EPA (QB >= 2.0) at n>=300, OR calibration >= 4pp at n>=400 (`R/14a_weather_diagnostic.R:27-35`) | NO TRIGGER. 0 of 18 eligible residual cells over bar; worst eligible calibration cell 2.75pp | **NULL** | 2026-07-26 | 2026-07-26 |
| 4 | Opponent front / OL context | Levels flat; live candidates = continuity breaks and heavy-box vs RB; "Prior verdict: NULL, or a thin RB/QB-side addition" (`R/15a_ol_front_diagnostic.R:26-33`) | Same as rung 3 (`R/15a_ol_front_diagnostic.R:34-40`) | NO TRIGGER. 0 of 84 residual cells over bar; worst calibration cell 3.10pp | **NULL** | 2026-08-01 | 2026-08-01 |
| 5 | Rookie prior enrichment | Aggregate near-flat; live candidates = rookie w1-4, R1 rookie QBs, day-3/UDFA volume positive (`R/16a_rookie_prior_diagnostic.R:17-25`) | Same as rung 3 (`R/16a_rookie_prior_diagnostic.R:27-33`) | NO TRIGGER. 0 of 20 eligible residual cells over bar; worst calibration cell 2.96pp | **NULL** | 2026-08-01 | 2026-08-01 |
| (6) | Rest / travel / short week | "real, tiny, cheap -- batched with 2" (`building_in_public_log.md:187`) | none recorded | none recorded | **NO RECORD** | 2026-07-18 | -- |

**1.1 Bar metric changed between rung 2 and rung 3.** Rung 2's proceed
rule (a) was on the VOLUME residual in opportunities. Rungs 3-5 use a
TOTAL-EPA residual in EPA. These are different metrics and are not
directly comparable. Only the calibration limb (b) is comparable
across rungs: 3pp at n>=500 (rung 2) versus 4pp at n>=400 (rungs 3-5).

**1.2 "Wider than rung 2's" is half-true and worth stating precisely.**
The effect-size bar got wider (4pp vs 3pp, +33%) while the sample
floor got LOWER (400 vs 500), which cuts the other way -- a lower floor
lets more cells qualify. Stated rationale, verbatim:
`R/14a_weather_diagnostic.R:27-28` -- "bars wider than rung 2's -- half
the seasons, outdoor-only, extreme buckets are thin; locked before the
run".

**1.3 GAP -- rest/travel has no artifact.** `grep` over `R/13*.R` finds
no rest, travel, short-week, or days-rest term anywhere in the rung-2
code. The only record that family was handled is the parenthetical at
README:710. **Do not write that six families were tested.** Either say
five, or say the sixth was folded in without a separate receipt.

---

## 2. RUNG 3 -- WEATHER

**Window and why.** 2021-2025, five seasons, outdoor games only. The
constraint is the archive: `R/14a0_weather_fetch.R:8-9` -- "the
Open-Meteo historical FORECAST archive starts 2021 -- the
pre-registered constraint; 5 seasons, not 12." Forecasts as of lock,
never observed weather (`R/14a0_weather_fetch.R:4-5`).

**Volume.** 1,359 of 1,359 games fetched, 0 failures (README:631-634).
Outdoor games in the analysis frame: **929** (DERIVED TODAY by
re-applying the 14a filter; the 1,359 figure includes indoor games
fetched "for the record").

Player-weeks per position (`output/14a_weather_residuals.csv`, wb axis,
summing buckets): QB 1,883 | RB 3,422 | TE 1,969 | WR 4,997.
Total **12,271** outdoor player-weeks.

**Bucket cut points** (`R/14a_weather_diagnostic.R:66-72`): wind calm
<=10 mph, breezy 10-15, windy15 >15. Temp frigid <=25F, cold 25-40,
mild >40. Precip wet = any forecast precipitation.

Game counts (DERIVED TODAY): calm 703, breezy 174, **windy15 52**.

### 2.1 Every residual cell (`output/14a_weather_residuals.csv`, 32 rows)

Bar: \|resid\| >= 0.8 EPA, QB >= 2.0, at n >= 300. **Eligible cells: 18.
Over bar: 0.**

| Axis | Pos | Bucket | n | mean tot resid | se | eligible? |
|---|---|---|---|---|---|---|
| wind | QB | calm | 1426 | +0.391 | 0.271 | yes |
| wind | QB | breezy | 350 | -1.451 | 0.535 | yes |
| wind | QB | windy15 | 107 | **-2.354** | 0.994 | NO (n<300) |
| wind | RB | calm | 2608 | +0.586 | 0.073 | yes |
| wind | RB | breezy | 617 | +0.115 | 0.159 | yes |
| wind | RB | windy15 | 197 | +0.363 | 0.244 | NO |
| wind | TE | calm | 1502 | +0.170 | 0.089 | yes |
| wind | TE | breezy | 365 | +0.125 | 0.185 | yes |
| wind | TE | windy15 | 102 | -0.238 | 0.269 | NO |
| wind | WR | calm | 3803 | +0.240 | 0.069 | yes |
| wind | WR | breezy | 929 | -0.241 | 0.140 | yes |
| wind | WR | windy15 | 265 | -0.742 | 0.267 | NO |
| temp | QB | frigid | 46 | **-2.219** | 1.237 | NO |
| temp | QB | cold | 245 | -0.042 | 0.664 | NO |
| temp | QB | mild | 1592 | -0.056 | 0.257 | yes |
| temp | RB | frigid | 84 | +0.147 | 0.423 | NO |
| temp | RB | cold | 457 | +0.491 | 0.187 | yes |
| temp | RB | mild | 2881 | +0.497 | 0.069 | yes |
| temp | TE | frigid | 49 | -0.460 | 0.551 | NO |
| temp | TE | cold | 255 | -0.366 | 0.201 | NO |
| temp | TE | mild | 1665 | +0.236 | 0.084 | yes |
| temp | WR | frigid | 104 | +0.122 | 0.358 | NO |
| temp | WR | cold | 669 | +0.017 | 0.164 | yes |
| temp | WR | mild | 4224 | +0.110 | 0.066 | yes |
| precip | QB | dry | 1815 | -0.028 | 0.240 | yes |
| precip | QB | wet | 68 | **-2.223** | 1.330 | NO |
| precip | RB | dry | 3294 | +0.530 | 0.066 | yes |
| precip | RB | wet | 128 | -0.600 | 0.305 | NO |
| precip | TE | dry | 1901 | +0.162 | 0.079 | yes |
| precip | TE | wet | 68 | -0.449 | 0.368 | NO |
| precip | WR | dry | 4819 | +0.117 | 0.062 | yes |
| precip | WR | wet | 178 | -0.399 | 0.285 | NO |

Bolded rows are below the sample floor but exceed the bar MAGNITUDE.
Three of them, all QB, all with standard errors around 1.0-1.3.

### 2.2 Calibration cells (`output/14a_weather_calibration.csv`, 64 rows)

Bar: \|stated - empirical\| >= 4pp at n >= 400. **Eligible: 32. Over bar: 0.**

Worst ELIGIBLE cells:

| Axis | Pos | Bucket | n | Threshold | delta pp |
|---|---|---|---|---|---|
| wind | RB | breezy | 617 | start | -2.75 |
| temp | WR | cold | 669 | start | -2.41 |
| wind | RB | breezy | 617 | boom | -2.11 |
| temp | QB | mild | 1592 | start | -1.93 |
| precip | QB | dry | 1815 | start | -1.82 |

Largest INELIGIBLE cells -- the temptations the floor blocked:
TE wet start -11.39pp (n=68); QB frigid start -9.51pp (n=46); QB breezy
start -9.47pp (n=350); QB windy15 start -8.61pp (n=107).

The full 64-row table is the artifact; nothing is omitted above except
rows I did not rank.

### 2.3 The bookmarked cell

WR starts in 15+ mph wind: stated 25.1%, empirical 18.5%, **delta
-6.63pp at n = 265** (`output/14a_weather_calibration.csv` [wb/WR/windy15/start]).
Registry row: `data/10f_watch_registry.csv` [windy15_wr_start], which
records effect -6.60, bar 4.0, n_floor 400, n_reg 265, registered
2026-07-26.

- Sample floor it fell under: **400** player-weeks. It has 265.
- Underlying games: **52** windy games, 2021-2025 (DERIVED TODAY,
  reproduces the registry note exactly).
- Accrual: about 10 windy games a year (registry note). At ~5.1 WR
  player-weeks per windy game, 265 -> 400 needs roughly 135 more
  player-weeks, about 26 more windy games, about **2.6 seasons**.
  Registry projects the floor is reached **2027-2028**. Both README:644-647
  and the registry say 2027-2028; my arithmetic agrees.

**Note the number is -6.6 percentage POINTS, not "6.6 points cold."**
The draft currently says "came back 6.6 points cold," which a reader
will hear as fantasy points. It is 6.6 percentage points of start
probability. Fix that.

### 2.4 GAP -- three QB weather cells exceed their bar magnitude and are not registered

QB windy15 residual -2.35 EPA (n=107), QB frigid -2.22 (n=46), QB wet
-2.22 (n=68) all exceed the 2.0 QB bar magnitude while failing the 300
floor. Only the WR calibration cell was entered in
`data/10f_watch_registry.csv`. The registry has 7 rows total and none
of these three are among them.

I am **not** calling this an error -- the pre-committed rule is that
below-floor cells do not trigger, and 16a's header explicitly
formalizes that ("Below-floor cells are reported, non-triggering
(windy15 precedent)", `R/16a_rookie_prior_diagnostic.R:31-32`). But if
the piece says "every cell still leaning is on the watch list," that
sentence is not supported. Your call whether to register them or soften
the claim.

---

## 3. RUNG 4 -- TRENCHES

Seven axes, `R/15a_ol_front_diagnostic.R:10-21`. Coverage gates 97-99%,
FTN join 96.6% (`output/15a0_coverage.csv`: coverage 0.972, ftn_join
0.966).

**3.1 Axis-level result** (`output/15a_olfront_residuals.csv`, 84 rows;
bar 0.8 EPA / QB 2.0 at n>=300; **eligible 84, over bar 0**):

| Axis | What it measures | Era | Result |
|---|---|---|---|
| own_sack | own-OL sack rate allowed | 2014-2025 | Flat except QB hi **-0.959** (n=2040) |
| own_stuff | own-OL rush stuff rate allowed | 2014-2025 | Flat except QB hi **-0.818** (n=2056) |
| cont | observed starting-5 continuity | 2014-2025 | Flat except QB broken **-1.370** (n=592, se 0.446) |
| opp_sack | opponent front sack rate generated | 2014-2025 | Flat except QB hi **-0.837** (n=1981) |
| opp_stuff | opponent front stuff rate generated | 2014-2025 | Flat everywhere; QB hi -0.645 |
| box | opponent heavy-box rate | 2022-2025 (FTN) | Flat; RB terciles all POSITIVE |
| blitz | opponent blitz rate | 2022-2025 (FTN) | Flat; RB hi +0.352 |

Non-QB positions: every RB, WR and TE cell across all seven axes falls
between -0.09 and +0.61 EPA, against a 0.8 bar.

**3.2 The pre-registered favorite is dead, and the direction is
confirmed positive.** Heavy-box vs RB
(`output/15a_olfront_residuals.csv` [box/RB/*]): lo **+0.611**
(n=1301), mid **+0.171** (n=1290), hi **+0.409** (n=1301). Positive =
under-prediction, so RBs facing the heaviest boxes slightly
OUT-performed the model. README:668-669 states "+0.2..+0.6 across
terciles"; the artifact gives +0.17 to +0.61. Reproduced independently
today at identical values.

The hypothesis was that heavy boxes suffocate RBs beyond what the
adjustments know. Not only absent -- wrong sign.

**3.3 The four QB cells**

| Cell | Registry id | Resid (EPA) | n | se | Bar |
|---|---|---|---|---|---|
| Continuity broken (<=3 of 5 returning starters) | cont_broken_qb | -1.37 | 592 | 0.446 | 2.0 |
| Own-OL sack rate allowed, high tercile | own_sack_hi_qb | -0.96 | 2040 | 0.231 | 2.0 |
| Opponent front sack rate, high tercile | opp_sack_hi_qb | -0.84 | 1981 | 0.234 | 2.0 |
| Own-OL stuff rate allowed, high tercile | own_stuff_hi_qb | -0.82 | 2056 | 0.235 | 2.0 |

Range **-0.82 to -1.37**, all below the 2.0 QB bar. README:670-674
quotes the range as "-0.8 to -1.4"; artifact values above.
Registry: `data/10f_watch_registry.csv` rows 2-5, all registered
2026-08-01.

**3.4 The overlap figure -- DERIVED TODAY, does not exist as an artifact**

`R/15a_ol_front_diagnostic.R` computes no overlap statistic. The only
record is the prose note "shares population with other trench cells --
one lean" (`data/10f_watch_registry.csv`, note column). I computed it
by re-deriving cell membership; all four cell sizes reproduce the
published n exactly (592 / 2040 / 1981 / 2056), so the membership is
right.

- Sum of the four cell sizes: 6,669 memberships
- Union: **4,447 distinct QB player-weeks** (33% redundancy)
- In exactly one cell: 2,596 | two: 1,500 | three: 331 | **all four: 20**

Pairwise Jaccard:

| Pair | Both | Jaccard |
|---|---|---|
| own_stuff_hi x opp_sack_hi | 694 | 0.208 |
| own_sack_hi x own_stuff_hi | 681 | 0.199 |
| own_sack_hi x opp_sack_hi | 640 | 0.189 |
| cont_broken x own_sack_hi | 226 | 0.094 |
| cont_broken x own_stuff_hi | 192 | 0.078 |
| cont_broken x opp_sack_hi | 180 | 0.075 |

Read this honestly: the three rate axes overlap about 20% pairwise;
continuity overlaps the others under 10%. They lean the same direction
and plausibly share a mechanism, but they are mostly different rows.
See 0.2.

**3.5 Worst calibration cell**: RB starts vs blitz-hi **-3.10pp**
(n=1262), under the 4pp bar
(`output/15a_olfront_calibration.csv` [blitz/RB/hi/start]) --
matches README:676. All 168 calibration cells cleared the n>=400
floor, so there are no below-floor temptations in this rung.

**3.6 Constraint on any future use.** The continuity axis is
OBSERVED-state, not Friday-reconstructable. README:677-681 and
`R/15a_ol_front_diagnostic.R:13-16`: any future QB rung "must first be
rebuilt EX-ANTE (Friday-lock reconstruction from injury designations +
prior-week line)". Worth a sentence in the piece -- it is the same
discipline that killed closing lines in rung 2.

---

## 4. RUNG 5 -- ROOKIES

Cells: cohort (veteran / rookie_all), tier (r1 / day2 = R2-3 /
day3_udfa = R4-7 + undrafted), phase (w1-4 / w5plus).
`R/16a_rookie_prior_diagnostic.R:11-15`. Rookie flag from
`load_players()`, is_rookie = season == rookie_season.

**4.1 Pre-stated candidates, each resolved**
(`R/16a_rookie_prior_diagnostic.R:17-25` for the candidates;
`output/16a_rookie_residuals.csv` for results):

| Candidate | Pre-stated | Observed | Verdict |
|---|---|---|---|
| Rookie weeks 1-4 ("prior does all the work; tier medians coarse") | live | RB +0.310 (n=381), WR -0.058 (n=415), TE -0.032 (n=113), QB -1.336 (n=104) | Flat. Dead. |
| R1 rookie QBs (star-shrinkage + rushing-tier axis) | live | QB r1 **-0.337** (n=417) | "Unremarkable" (README:696). Dead. |
| Day-3/UDFA VOLUME residual POSITIVE ("breakout class arrives faster than tier medians expect") | live | **Wrong sign** -- see 4.2 | Dead, backwards. |

**4.2 The day-3 candidate, with sign and magnitude**

Pre-registered text, verbatim (`R/16a_rookie_prior_diagnostic.R:21-23`):
"day-3/UDFA VOLUME residual positive (breakout class arrives faster
than tier medians expect)".

Observed volume residual, day3_udfa tier
(`output/16a_rookie_residuals.csv` [tier/*/day3_udfa], mean_vol_resid):

| Pos | mean vol resid | n | Units |
|---|---|---|---|
| QB | **-1.879** | 130 | dropbacks |
| RB | **-0.529** | 1102 | opportunities |
| TE | **-0.201** | 261 | opportunities |
| WR | **-0.151** | 804 | opportunities |

Every one negative. Negative = observed volume BELOW predicted = the
tier medians **over-credit** the day-3 class. The hypothesis predicted
positive. README:694-695: "the day-3/UDFA volume hypothesis was
wrong in DIRECTION (vol residual mildly negative -- tier medians
slightly over-credit the breakout class)."

Magnitude for the piece: about **half an opportunity a game** for
running backs, a sixth of a target for receivers. Small, but pointed
the wrong way.

**4.3 What the existing machinery already handles, and where**

Two pieces (`R/16a_rookie_prior_diagnostic.R:5-9`): (a) `is_cold_start
= TRUE` plus a draft_tier-median `baseline_epa_per_opp` in the feature
layer; (b) the volume-conditional walk-forward recal maps from 6c,
which "already own the low-usage strata where rookies live."

Cells where that is demonstrated -- the aggregate rookie cohort comes
back flat at every position (`output/16a_rookie_residuals.csv`
[cohort/*/rookie_all]): RB +0.264 (n=1891), WR +0.217 (n=2217), TE
+0.017 (n=673), QB -1.031 (n=642). Compare veterans: RB +0.300, WR
+0.163, TE +0.074, QB -0.265. Rookie and veteran cells sit on top of
each other at three of four positions.

**4.4 Worst calibration cell**: RB day3_udfa boom **-2.96pp** (n=945),
under the 4pp bar (`output/16a_rookie_calibration.csv`
[tier/RB/day3_udfa/boom]) -- README:700 rounds it to -3.0.

Largest ineligible cell, and the best "temptation" example in the whole
ladder: **R1 rookie RBs, start threshold, +10.61pp at n=182**
(`output/16a_rookie_calibration.csv` [tier/RB/r1/start]). Positive =
empirical above stated = the model UNDER-states first-round rookie RBs
by ten points. That is a shippable-looking finding on a sample less
than half the floor. Nobody registered it and the rule says it does not
count. Consider using it in section 7c -- it is more vivid than the
weather cell because it would have made the product look better.

---

## 5. WATCH-LIST REGISTRY

`data/10f_watch_registry.csv`, 7 rows, committed `2a78bab` 2026-08-01 11:49.

| Cell id | Src | Pos | Axis / bucket | Metric | Effect | Bar | n floor | n now | Testable |
|---|---|---|---|---|---|---|---|---|---|
| windy15_wr_start | D20 | WR | wind / windy15 | calibration, start | -6.60pp | 4.0pp | 400 | 265 | ~2027-2028 |
| cont_broken_qb | D21 | QB | cont / broken | residual | -1.37 EPA | 2.0 | 300 | 592 | needs ex-ante rebuild |
| own_sack_hi_qb | D21 | QB | own_sack / hi | residual | -0.96 | 2.0 | 300 | 2040 | -- |
| opp_sack_hi_qb | D21 | QB | opp_sack / hi | residual | -0.84 | 2.0 | 300 | 1981 | -- |
| own_stuff_hi_qb | D21 | QB | own_stuff / hi | residual | -0.82 | 2.0 | 300 | 2056 | -- |
| rookie_day2_qb | D22 | QB | tier / day2 | residual | -1.86 | 2.0 | 300 | 95 | ~2028-2029 |
| rookie_day3_qb | D22 | QB | tier / day3_udfa | residual | -2.65 | 2.0 | 300 | 130 | ~2028-2029 |

**5.1 "All QB-context cells" -- CORRECTED.** README:702-705 says "the
chain's softest cells are QB-context cells". Six of the seven registry
rows are QB. **The seventh is not**: windy15_wr_start is a wide
receiver cell. The claim is true of rungs 4 and 5 (the cross-rung note
at README:702 is scoped to those two rungs and is accurate); it is
NOT true of the registry as a whole. If the piece says every remaining
lean is a quarterback cell, it contradicts the registry's first row --
which is also the cell the piece spends the most time on.

**5.2 Note on the four trench cells' testability.** Three of them
already clear their n floor (2040, 1981, 2056 vs a 300 floor). They are
on the watch list because the EFFECT is under the bar, not because the
sample is short. Only the continuity cell carries a build precondition.
Do not write "we need more data" about these three; more data will not
change the effect size.

**5.3 rookie_all QB is described but not registered.** README:697
names "rookie_all QB -1.03 EPA (n=642 vs 2.0 bar)" as part of the
rookie-QB watch family. There is no `rookie_all` row in the registry --
only the two tier rows. Minor, but if you cite a "rookie-QB family" of
three cells, the registry shows two.

---

## 6. GRAPHIC CANDIDATE (sketch only, not built)

One `gt` table, the whole ladder, built so "three of five came back
empty" is visible before any number is read.

Columns:

| Col | Content | Treatment |
|---|---|---|
| 1 | Rung number + family name | Bold family; small-caps rung |
| 2 | What we expected | One clipped phrase from the pre-registration, quoted |
| 3 | The bar | Metric + threshold + n floor, monospace (e.g. `0.8 EPA @ n>=300`) |
| 4 | What we found | **Horizontal bar, the load-bearing column.** Bar length = observed effect as a FRACTION OF ITS OWN BAR, so all five rungs share one 0-1 scale despite different metrics. Vertical rule at 1.0 = the bar. |
| 5 | Verdict | SHIPPED (filled) / NULL (hollow) chip |
| 6 | Closed | Date |

The design decision that makes it work: **normalize every effect to its
own pre-committed threshold.** Rung 3's biggest eligible effect is
2.75pp against a 4pp bar = 0.69. Rung 4's is 3.10/4.0 = 0.78. Rung 5's
is 2.96/4.0 = 0.74. Rungs 1 and 2 blow through 1.0. The reader sees
three short bars stopping well short of the line and two long ones
crossing it, and the argument lands without arithmetic.

Two cautions. (a) Mixing metrics on one axis is a real liberty; the
column header must say "share of its own pre-committed bar" and the
footnote must name each rung's metric. (b) Pick ONE representative
effect per rung and say which -- I would use the largest ELIGIBLE
effect (the strongest thing that actually counted), never the largest
below-floor effect, or the graphic makes the opposite argument. Values
for column 4 if you use that rule: rung 3 = 0.69, rung 4 = 0.78, rung 5
= 0.74.

Optional second panel: a "temptations" strip showing the below-floor
cells (TE wet -11.4pp, RB r1 start +10.6pp, QB windy15 -8.6pp) greyed
out behind their n floors. That is the more honest and more
interesting graphic, and it is the one a hostile reader would ask for.

---

## 7. DRAFTING LAYER

### 7.1 WEATHER

**a. Named anchors.** DERIVED TODAY by re-applying the 14a bucket rule
to `data/weather_forecast_hist.rds` and joining
`output/13e_wr_fold_predictions.csv` to `data/wr_feature_table.rds`.
Reproduction check: 265 WR player-weeks across 52 games, matching the
published n exactly.

The single best anchor is **Buffalo vs New England, 2021 Week 13** --
the highest-wind game in the frame at **25.5 mph**. WRs in that game
and their EPA residuals: Emmanuel Sanders (BUF) -3.27, Cole Beasley
(BUF) -2.30, Stefon Diggs (BUF) -0.72, Gabriel Davis (BUF) -0.67. This
is the game most readers already remember.

Second: **Cleveland vs Denver, 2021 Week 7, 25.2 mph** -- Odell Beckham
-1.72, Jarvis Landry -1.01, Tim Patrick -1.17, and Courtland Sutton
**+3.50** (the model UNDER-shot him in a gale, which is the useful
detail).

Third, if a recent one helps: **San Francisco at Cleveland, 2025 Week
13, 22.9 mph** -- Jauan Jennings +4.69, Jerry Jeudy -0.07.

Most-exposed WRs across the whole cell: Elijah Moore and Jerry Jeudy
(6 windy weeks each), then Amari Cooper, Chase Claypool, Diontae
Johnson, Garrett Wilson, Khalil Shakir, Stefon Diggs, Wan'Dale Robinson
(5 each). Note the Cleveland/Buffalo/New York concentration -- that IS
the story of which players a wind feature would have moved.

**b. Bar in board terms.** If the wind cell had fired at its bar, a
wide receiver in a 15-plus mph game would have moved roughly **4
percentage points** on his published start probability -- the 4pp
calibration bar. The observed read was 6.6pp on a sample too small to
count. Concretely: a 25% start probability would have become about 21%.

**c. Counterfactual.** A shop without a pre-committed floor looks at
-6.6pp on 265 player-weeks, calls it "wind kills receivers," and ships
a wind adjustment. The cost is not that wind is fake -- it is that they
would ALSO have shipped, from the same table, TE-in-rain at -11.4pp
(n=68) and QB-in-frigid at -9.5pp (n=46), because those look even
bigger. Three adjustments, two of them fit to fewer than seventy
player-weeks, all landing in your December lineup advice. That is the
concrete cost.

**d. Pre-registration text, verbatim** (`R/14a_weather_diagnostic.R:20-26`,
dated 2026-07-26 in the header, PRE-RUN TEXT, not a paraphrase):

> PRE-STATED EXPECTATIONS (2026-07-26, before first run):
>   - MOSTLY ABSORBED: temp and precip cells flat; wind under 15 mph flat.
>   - The one live candidate: 15+ mph wind degrading passing beyond market
>     pricing -- if present, a small negative pass-side residual (QB order
>     1-2 EPA, WR/TE < 0.5) and a few pp of boom overstatement in wind.
>   - Prior verdict: NULL or a thin wind-only adjustment.

Bar, verbatim (`R/14a_weather_diagnostic.R:27-35`):

> PRE-COMMITTED PROCEED RULE (bars wider than rung 2's -- half the seasons,
> outdoor-only, extreme buckets are thin; locked before the run):
>   Rung 3 advances to 14b (a thin POST-PREDICTION adjustment per the
>   pre-registration -- explicitly NOT feature-table surgery) only if
>     (a) any position x bucket with n >= 300 has |mean tot resid| >= 0.8
>         EPA (QB >= 2.0), or
>     (b) any position x threshold x bucket with n >= 400 has
>         |stated - empirical| >= 4pp.
>   Otherwise the null is PUBLISHED and the ladder moves on.

Worth noting for the piece: the pre-stated expectation predicted a
WR/TE effect under 0.5 EPA. Observed WR windy15: -0.742. The
expectation was slightly too optimistic in magnitude and still landed
nowhere near a trigger.

### 7.2 TRENCHES

**a. Named anchors.** DERIVED TODAY from
`data/15a0_ol_front_tables.rds` joined to
`output/13e_qb_fold_predictions.csv`. Reproduction check: cont=broken
n=592, own_sack hi n=2040, opp_sack hi n=1981, own_stuff hi n=2056 --
all four match published exactly.

Recent, recognizable broken-line QB weeks (ol_overlap = returning
starters out of 5):

| QB | Team | Opp | Season | Wk | Returning starters | New starters | Resid |
|---|---|---|---|---|---|---|---|
| Deshaun Watson | CLE | NYG | 2024 | 3 | 3 | 2 | -24.61 |
| Caleb Williams | CHI | NE | 2024 | 10 | 3 | 2 | -24.00 |
| Jalen Hurts | PHI | NYG | 2023 | 18 | 2 | 3 | -22.44 |
| Cam Ward | TEN | JAX | 2025 | 13 | 3 | 2 | -20.17 |
| Aaron Rodgers | PIT | LAC | 2025 | 10 | 3 | 2 | -19.86 |
| Shedeur Sanders | CLE | CHI | 2025 | 15 | 3 | 2 | -19.12 |
| Bryce Young | CAR | NO | 2025 | 10 | 3 | 2 | -18.30 |

Most-exposed QBs 2021-2025: Matthew Stafford (10 broken-line weeks),
Bryce Young (9), Geno Smith (9), Jared Goff (9), Aaron Rodgers (8),
Carson Wentz (8), Dak Prescott (8), Justin Herbert (8). Full era:
Stafford 23, Rodgers 18, Wentz 18, Tannehill 16.

Caution on the individual rows above: these are the WORST residuals in
the cell, so they are the tail, not the average. The cell average is
-1.37 EPA. If you print Watson at -24.6, say plainly that it is the
worst week in 592, or you have accidentally made the null look like a
finding.

**b. Bar in board terms.** The QB residual bar is 2.0 EPA. Using the
rung-2 published mapping -- a 5.09 EPA gradient produced 4-12pp of
conditional dishonesty (README:507-512) -- 2.0 EPA lands roughly in the
**2-5 percentage point** range on a published QB start probability. The
observed worst cell (-1.37) is about two-thirds of that. Phrase it as
"under half a percentage point to about three" and you are safe; do not
give a single hard number, because the EPA-to-pp mapping is not linear
and is not published per-cell.

**c. Counterfactual.** Four axes, all leaning the same direction, all
statistically distinguishable from zero at face value (own_sack hi:
-0.96 with se 0.231 is four standard errors). A shop without a bar
ships "QB behind a bad line" as a feature and gets to announce four
independent confirmations of it. The overlap numbers in 3.4 show they
are not four independent confirmations -- but they are also not one
cell, so the honest version is that a real, small, correlated effect
exists and was declared too small to act on. The cost of shipping it:
a feature built on OBSERVED continuity, which is not knowable on
Friday -- so it would have graded beautifully in backtest and been
unbuildable on a Tuesday. That is the sharper point, and it is the
same trap closing lines set in rung 2.

**d. Pre-registration text, verbatim** (`R/15a_ol_front_diagnostic.R:26-40`,
dated 2026-08-01, PRE-RUN TEXT):

> PRE-STATED EXPECTATIONS (2026-08-01, locked before first run):
>   - Aggregate own-OL and opponent-front LEVELS flat -- priced by the
>     def adjustments and the lines.
>   - Live candidates: continuity BREAKS (this-week starter losses the
>     Tuesday market underprices; rung-1 transition-week precedent), and
>     heavy-box opponents vs RB efficiency beyond the aggregate adjustment.
>   - Prior verdict: NULL, or a thin RB/QB-side addition decided at 15b.

> PRE-COMMITTED PROCEED RULE (Steve sign-off 2026-08-01; rung-3 bars):
>   Advance to 15b only if
>     (a) any position x bucket with n >= 300 has |mean tot resid| >= 0.8
>         EPA (QB >= 2.0), or
>     (b) any position x threshold x bucket with n >= 400 has
>         |stated - empirical| >= 4pp.
>   Otherwise the null is PUBLISHED and the ladder moves to rung 5.

### 7.3 ROOKIES

**a. Named anchors.** DERIVED TODAY from
`output/13e_qb_fold_predictions.csv` joined to `load_players()` rookie
seasons. Reproduction check: r1=417, day2=95, day3_udfa=130 -- all
three match published exactly.

Day-3/UDFA rookie QBs, by player-weeks in the cell: Dak Prescott (15 --
a fourth-rounder, and the single best argument FOR the hypothesis that
the data then refutes), Gardner Minshew (14), Aidan O'Connell (10),
Shedeur Sanders (8), Spencer Rattler (7), Tommy DeVito (7), Brock Purdy
(6), Devlin Hodges (6), Tyson Bagent (5).

Day-2 rookie QBs: DeShone Kizer (15), Davis Mills (13), Derek Carr
(12), Tyler Shough (10), Will Levis (8).

The anchor I would build the section on: **Prescott and Purdy are both
in this cell.** The two most famous late-round rookie successes of the
decade are inside the exact population where the model was tested for
"day-three breakouts arrive early" -- and the population still came
back over-credited, not under-credited. That is the paragraph.

Shedeur Sanders is a useful double: he appears in both the day-3
rookie-QB cell (8 weeks) and the broken-line QB cell (CLE 2025 W15).

**b. Bar in board terms.** Same 4pp calibration bar. If the rookie cell
had fired, a rookie in the relevant tier would have moved about **4
percentage points** on his published start probability. The largest
eligible rookie effect was 2.96pp (RB day3_udfa boom) -- three quarters
of the way there and still short.

**c. Counterfactual.** This is the cheapest null to have gotten wrong,
because the available finding flattered everyone: **R1 rookie RBs
under-stated by +10.6pp on 182 player-weeks.** A shop without a floor
ships a first-round-rookie-RB bump, and it is a fantastic product
story -- the model "sees" rookie bell-cows early, it agrees with what
draft capital already told everybody, and it sells. It is 182 rows.
Note the direction: refusing this finding made the product look WORSE
in the short run, which is the strongest version of the argument the
whole piece is making.

**d. Pre-registration text, verbatim** (`R/16a_rookie_prior_diagnostic.R:17-33`,
dated 2026-08-01, PRE-RUN TEXT):

> PRE-STATED EXPECTATIONS (2026-08-01, locked before first run):
>   - Aggregate rookie cells near-flat (recal owns low-usage).
>   - Live candidates: rookie weeks 1-4 (prior does all the work; tier
>     medians coarse), R1 rookie QBs (star-shrinkage limitation +
>     rushing-tier axis), day-3/UDFA VOLUME residual positive (breakout
>     class arrives faster than tier medians expect).
>   - Prior verdict: NULL or thin; 16b decides any richer prior (college
>     production percentiles buildable; draft-model .pred needs historical
>     fold backfill -- separate cross-repo project).

> PRE-COMMITTED PROCEED RULE (Steve sign-off 2026-08-01; ladder bars):
>   Advance to 16b only if
>     (a) any cell with n >= 300 has |mean tot resid| >= 0.8 EPA (QB >= 2.0), or
>     (b) any cell x threshold with n >= 400 has |stated - empirical| >= 4pp.
>   Below-floor cells are reported, non-triggering (windy15 precedent).
>   Otherwise the null is PUBLISHED and the pre-registered ladder is
>   COMPLETE (rest/travel was batched with rung 2).

### 7.4 Provenance of the quoted pre-registrations

All three quotes above are **pre-run text in the script header**, not
log paraphrase -- that is the strong form. Two caveats already stated:
the rung-4 and rung-5 headers are dated the same day the rung closed
(0.3), and script and output were committed together (0.4).

By contrast, the LADDER-level pre-registration (family ordering, the
Friday-reconstructable rule, the text-data boundary) exists only as log
prose at `building_in_public_log.md:140-212`, dated 2026-07-18. It is
contemporaneous and dated but it is a log entry, not a locked artifact.
If the piece quotes the ladder ordering, that is the weaker record of
the two.

---

## 8. PUBLICATION SAFETY

**8.1 Everything in this fact sheet is already public or safe to
publish.** All figures come from files tracked in the public repo
(`output/14a_*`, `output/15a_*`, `output/16a_*`,
`data/10f_watch_registry.csv`, `README.md`,
`building_in_public_log.md`) or from filters over tracked model
artifacts. Nothing here touches `data/ecr/` or `data/vegas/`, both of
which are gitignored and licensed.

**8.2 Third-party attribution required if the weather section runs.**
Open-Meteo, CC-BY 4.0 (`R/14a0_weather_fetch.R:16`). The piece must
carry the attribution. FTN is the source for the box/blitz axes
(`R/15a_ol_front_diagnostic.R:19-20`) via nflverse -- if you name box
counts or blitz rates in print, attribute FTN. nflverse/nflreadr is
already in your standard footer.

**8.3 The dollar figure -- CONFIRMED $0 across the whole ladder.**
- Rung 1 injury: nflreadr `load_injuries`, free.
- Rung 2 Vegas: "NO ODDS PURCHASE. Recurring line-data cost: $0."
  (README:555). The ~$100 timestamped-odds archive was explicitly
  declined (README:547-554).
- Rung 3 weather: Open-Meteo free archive.
- Rungs 4 and 5: nflverse tables and `load_players()`, free.

**One forward-looking obligation, which is NOT a ladder cost.** The
Open-Meteo free tier is non-commercial. Per the paid-data notes, once
Substack monetizes, a commercial license (about EUR 29/month) becomes a
terms-of-service requirement. That is a future publishing cost, not
money spent on the ablation, and it attaches to the weather data
whether or not the rung had fired. If the piece wants a money line at
all, this is the only true one -- and it argues the opposite of what
the current draft says.

**8.4 Named players.** All player names in section 7 are public
performance records from public play-by-play. No injury detail beyond
official public designations is used. The residuals attached to
individual player-weeks are model outputs on public outcomes.

**8.5 One judgment call for you.** Section 7.2's anchor table prints
named QBs against their worst modeled weeks. It is accurate and
public, but it reads as a list of quarterbacks the model liked least
behind bad lines. If that lands harsher than you want in a piece whose
subject is our own nulls, the recurring-exposure list (Stafford,
Rodgers, Wentz, Tannehill) makes the same point without ranking anyone
by failure.

---

## 9. WOULD ANY OF THIS CHANGE IF RERUN TODAY?

**9.1 Weather -- LOW RISK, one caveat.** The archive window is fixed at
2021-2025 by the pre-registration; 2026 preseason games are not REG and
do not enter. `data/weather_forecast_hist.rds` is cached and resumable
(`R/14a0_weather_fetch.R:12-14`), so a rerun refetches nothing. The
caveat: Open-Meteo revises its historical forecast archive
occasionally; a full refetch could shift a game or two across the 10 or
15 mph cut points. Small, but the 52-game count is not guaranteed
byte-stable forever.

**9.2 Trenches -- MEDIUM RISK on two axes.** The `cont` axis is built
from snap counts, and README:663-665 records that 2020 and 2025
needed OL label variants because of "generic-label drift" upstream. If
nflverse re-releases 2025 snap counts with different position labels,
continuity states move. The FTN box/blitz axes have a 2022 floor and a
96.6% join rate; an FTN backfill would change n. Terciles are cut
within season, so any change to the underlying rate tables reshuffles
bucket membership.

**9.3 Rookies -- MEDIUM RISK, and this one is live right now.** The
rookie flag comes from `load_players()`, which is a mutable upstream
release. Rookie-season and draft-round fields get corrected. Related
and current: the 2026 rookie crosswalk still has about 12 pending gsis
ids awaiting the September re-run (per the tracker's `id_pending`
rows). That affects the 2026 tracker, not the 2014-2025 backtest cells
quoted here, but it is the same upstream dependency.

**9.4 Nothing here depends on 2026 preseason.** All three rungs are
2014-2025 (weather 2021-2025) regular-season backtest cells. Preseason
games do not enter any of these tables.

**9.5 The safest framing for print.** Every number in this fact sheet
is a statement about a frozen backtest, and the model is frozen for
2026. None of these figures will move during the season. Say that
plainly and none of 9.1-9.3 can embarrass you mid-October.

---

## 10. ASKED FOR BUT NOT IN THE WORK

None of these are holes in the ladder. They are things the request
asked for that we either never set out to produce or deliberately
scoped out. Listed so nobody goes hunting for them later.

1. **The overlap figure for the four QB trench cells.** Never
   computed -- 15a was a sizing diagnostic, and an overlap statistic
   would not have changed the verdict, since all four cells were under
   the bar either way. Out of scope at the time, reasonably. I derived
   it today (3.4) because the DRAFT makes a claim that depends on it.
   Labeled as new.
2. **Rest/travel.** Not a missing receipt -- a design decision. The
   pre-registration called it "real, tiny, cheap" and folded it into
   rung 2 rather than standing it up as its own rung
   (`building_in_public_log.md:187`). It was never going to produce a
   separate artifact. The only practical consequence: the ladder is
   five rungs, so the piece should say five.
3. **A per-cell EPA-to-percentage-points conversion.** Never built,
   and it would be a modeling exercise, not a lookup -- the mapping is
   not linear and varies by position and threshold. Out of scope for a
   data pull. Use the rung-2 range (README:507-512) as a loose anchor
   and do not print a precise pp figure for the QB trench cells.
4. **Weather's effect on 2026.** The window ends at 2025 by
   construction, and the model is frozen. Nothing to say here, and
   nothing that will change mid-season.

The one item on this list that genuinely needs a decision is in 2.4 --
three below-floor QB weather cells that were never entered in the
watch registry. Consistent with the rule as written; only matters if
the piece claims the registry is exhaustive.
