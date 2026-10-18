# Candidates: week5_wrap_week6_storylines (repo: boxscore-prophet)

- candidate_1.png -- table (gt). Week 6 board for Jeremiyah Love (RB24 vs. ECR RB19, 25%), Marvin Harrison Jr. (WR77 vs. WR52, 17%), C.J. Stroud (QB19 vs. QB15, 24%), Dak Prescott (QB8 vs. QB6, 44%) and Jayden Daniels (QB5 vs. QB7, 45%); exact start chances and spots-vs-ECR are the point.
- candidate_2.png -- chart (faceted bars). Love vs. Harrison actual PPR points Weeks 1-5 against the 15-point startable line: Love cleared once (21.9 in Week 3), Harrison never, DNP in Week 5.
- candidate_3.png -- chart (line, Stroud highlighted in red). Stroud, Prescott and Daniels weekly PPR points vs. the 20-point QB line, point size = pre-kickoff start chance; Stroud cleared in Weeks 4 (23.1) and 5 (20.9), Daniels' Week 3-4 DNPs break his line.
- candidate_4.png -- WILDCARD, chart (patchwork: heat-tile grid + rank dumbbell). All five players' start chance and actual PPR points for Weeks 1-5 plus the Week 6 projection, gold outline on cleared weeks, next to a model-vs-ECR dumbbell where Harrison's 25-spot gap dwarfs the rest.

## Data sources
- `boxscore-prophet/output/10d_receipts_2026_w01.csv` through `w05.csv` (start_pct, fp_actual, dnp, thresh_start).
- `10d_start_board_2026_w06.csv` (start chance, model rank) and `10d_ecr_gap_2026_w06.csv` (ECR rank, rank gap).
- Draft figures (25% RB24 vs. RB19; WR77, 25 below consensus; 24% QB19 vs. QB15; 45% QB5 vs. QB7) all match these files.

## Reuse check
Prior drafts (week3/week4 storylines, week1_narrative_receipts, somethings_gotta_give) charted Stroud and Love in model-rank-vs-ECR tables and Weeks 1-3/1-4 start-line receipts for other player sets. These candidates cover Week 6 and Weeks 1-5 for this draft's players, and Harrison, Daniels and Prescott are new. Underlying data reused, charts not.

## Unverified claims (not charted)
- Snap share 74%, 13 targets, 8.3% and 22.6% target share, Mike LaFleur decision.
- Separation (2.05 yards, 95th of 96), FTN catchable rates (68%/65% vs. 74%), EPA per target (13th of 78).
- Contested-target rate 18.9% to 30.4%, Detroit forcing contested catches.
- Love 3.66 YPC (24th of 35), -0.39 rush yards over expected, 56.2 scrimmage yards per game, top-10 backs since 2015 comparison; snap-share claims.
- Arizona's 19.5-point market line.
- Houston 1-4, 110 points scored vs. 112 allowed, 2.5 expected wins, one-score record; Stroud CPOE 3rd, EPA per play by quarter (0.164 / 0.031), red-zone TD rank 22nd.
- Prescott 7th in EPA per play, 0.447 late, third-down and red-zone ranks, defense last in EPA per play, Cowboys 2-3.
- Jacksonville defensive ranks (1st YPC, 23rd YPA allowed); San Francisco 6.25 yards per attempt allowed.
- Daniels: 0.137 EPA per play, -0.018 in 2025, CPOE -0.2 (24th of 30), success rate 42.9%, designed runs, 2.97 seconds to throw.
- Overtime clock sequence (0:55 to 0:12, 43 seconds, 63 comparable situations, median 16).
- Note: the receipts show Daniels as DNP in Weeks 3 and 4; the draft doesn't mention that, so check it against the draft's narrative.

## Added in second pass (candidate_2 caption fix + candidates 5-7)

- candidate_2.png caption fixed to begin "TheMerrittocracy  ·  " (house credit was missing). Re-rendered; content/numbers unchanged. Built via `build.R` (unchanged code otherwise).
- candidate_5.png -- chart (two-panel bar, patchwork). Marvin Harrison Jr.'s target share by season (22.6% to 18.1% to 8.3%) next to his catchable-target rate by season (68% to 65% to 46%) against the ~74% league catchable rate; 2026 bars in red. Section: "Raising Arizona."
- candidate_6.png -- chart (single-row horizontal bar). Washington's 43 seconds between snaps in OT vs. the Giants, against the league median (16s) and 90th percentile (25s) across 63 comparable late-game situations since 2024, Washington's bar in red as the longest of all 63. Section: "I Can't Unsee That."
- candidate_7.png -- chart (two-panel bar, patchwork). Left: actual vs. Pythagorean-expected wins for Houston (1 vs. 2.45, the NFL's biggest shortfall) and Arizona (1 vs. 1.4) for context; right: C.J. Stroud's EPA per play in the first three quarters (0.164) vs. 4th quarter/OT (0.031). Section: "Deserve Has Got Nothin' To Do With It."

## Data sources (candidates 5-7)
All three use numbers from Steve's data packet (public nflverse/nflreadr, NGS, and FTN charting figures), supplied directly for this run and vouched for by Steve -- not pulled from a boxscore-prophet artifact file, since boxscore-prophet has no team-level EPA/CPOE/target-share/play-clock data (confirmed in prior passes on this and related week-storylines slugs). No PFF numbers used anywhere.

## Reuse check (candidates 5-7)
Checked `graphics/week3_wrap_week4_storylines/`, `graphics/week4_wrap_week5_storylines/`, and `graphics/somethings_gotta_give/` (same repo/series). None chart Harrison's target share/catchable-rate trend, the Washington overtime clock sequence, or Houston's Pythagorean win gap alongside Stroud's late-game EPA drop -- these are new angles, distinct from candidates 1-4's fantasy-points framing and from prior drafts' coaching-path and offense/defense EPA angles.

## Unverified claims, still not charted
- Separation (2.05 yards, 95th of 96; 72nd of 85 in 2025) and Harrison's 13th of 78 in EPA per target -- not in the supplied packet's chartable set for this pass (left out; packet covered target share, catchable rate, and contested-target context instead).
- Arizona contested-target rate (18.9% to 30.4%) and McBride's 26%-to-40% jump vs. Detroit -- in the packet but not charted this pass (already a dense section via candidate_4's wildcard; avoided a fifth Arizona-skill-position chart to keep variety).
- Love's rushing efficiency (3.66 YPC, rush yards over expected, top-10-RB comparison) and the Jacksonville/San Francisco defensive ranks -- in the packet/draft but not charted this pass; no distinct angle left that wouldn't restate candidate_2 or crowd the four non-fantasy charts already built.
- Daniels' three-season efficiency/accuracy/success-rate/time-to-throw slope -- in the packet but not charted this pass; candidate_6 already uses the Daniels/Washington section for the clock sequence.
