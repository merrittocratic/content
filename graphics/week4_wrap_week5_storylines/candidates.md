# Candidates: week4_wrap_week5_storylines (repo: boxscore-prophet)

- candidate_1.png -- table (gt). "Start Chance vs. Actual, Weeks 1-4": Trevor Lawrence, Bijan Robinson, Drake London, Cooper Rush and Michael Penix Jr., Boxscore Prophet's pre-kickoff start chance next to each one's actual PPR points every week, with Rush's benching and Penix's Week 3 debut footnoted; exact numbers are the point. Section: "Duuuuval!" / Atlanta section.
- candidate_2.png -- chart (ranked leaderboard bar). "Bijan Took Off Right Alongside Him": Boxscore Prophet's pre-kickoff flex board for the Week 4 Falcons-Saints game, all 24 flex-eligible players ranked by boom chance -- Bijan Robinson 2nd (32%), Drake London 3rd (29%), both called out against the field. Section: Atlanta.
- candidate_3.png -- chart (line/dot, narrative-anchored). "Atlanta's Quarterback Carousel": actual PPR points for every week Cooper Rush, Jack Strand and Michael Penix Jr. actually played (DNP weeks dropped, not shown as zero) -- visualizes the Week 3 QB change the article leads with. Section: Atlanta.
- candidate_4.png -- WILDCARD, chart (patchwork, 2-panel heat-tile grid). "Offense Sells Tickets": Jacksonville's six core skill players (Lawrence, Thomas Jr., Washington, Meyers, Strange, Tuten) vs. Atlanta's six (Rush, Penix, Bijan Robinson, Brian Robinson, London, Pitts), each cell actual PPR points by week, DNP weeks tiled grey -- Jacksonville hums steadily, Atlanta is dead until Penix takes over in Week 3. Sections: both.

## Data sources
- All four candidates: `boxscore-prophet/output/10d_receipts_2026_w01.csv` through `w04.csv` (start_pct, boom_pct, fp_actual, dnp, hit_start -- Boxscore Prophet's pre-kickoff start/boom chances and post-game actual PPR points).
- candidate_2 additionally: `boxscore-prophet/output/10d_boom_board_2026_w04.csv`, filtered to `board == "flex"` (pre-kickoff flex-ranked boom chances for the Week 4 ATL-NO game specifically).
- Atlanta's Week 4 game (vs. New Orleans) is now graded in these files -- fp_actual is populated for Week 4, unlike the prior run's note that it wasn't yet available.

## Repo note
Boxscore Prophet is a fantasy player-props model (start/boom chance and post-game PPR scoring). It has no team-level EPA, CPOE, red-zone, defensive-ranking, rushing-yards, or coaching-history data anywhere in `output/` -- confirmed again on this pull. That limits what's chartable to player start chances and actual fantasy points.

## Unverified claims (no matching artifact in boxscore-prophet; not charted)
- Jacksonville 2nd in net EPA, 14th-to-4th in EPA/play, 51% scoring drives (3rd), 86% red-zone TD rate (2nd).
- Trevor Lawrence's CPOE rank (30th of 42 last year to 5th of 35 this year) -- CPOE is sourced from NGS per the article's own methods note, not from this repo.
- Jacksonville defense: 64 rush yds/g allowed (2nd), 8.5 YPA allowed (30th), 292 pass yds/g allowed (31st), league-leading 6 INTs, defense 7th-to-21st EPA after stripping turnovers.
- Philadelphia: 31st net EPA, 4 sacks (28th), Jalen Hurts 28th of 35 in CPOE, 10 completions of 20+ yards (22nd); the Week 5 market line (JAX -7).
- Atlanta's 0-2 start and the 34-3 loss to Carolina with five turnovers; the 35-0/45-0 margins against Green Bay and New Orleans.
- Offensive EPA per play by week (-0.32, -0.47, +0.33, +0.42) and Michael Penix Jr. ranking 2nd of 32 QBs in EPA per dropback in Week 4.
- Bijan Robinson's 194 and 145 rushing yards, and his 1.49 rush yards over expected per carry (2nd of 51 backs) -- no rushing-yards or NGS-style artifact exists in this repo for Weeks 3-4 (a one-off pilot file covering Week 1 skill-position rushing exists but doesn't cover these players/weeks).
- Atlanta's defense: 1st in rush yards/YPC allowed, 4th in EPA after stripping turnovers.
- Carolina and New Orleans ranked 26th/30th in net EPA; Baltimore 3rd in offensive EPA, Lamar Jackson's 10.0 YPA, opponents averaging 28th in EPA, the halftime sack/injury detail, Tyler Huntley's 8-of-9 relief outing, the 24-7-to-24-18 margin, Baltimore's run defense ranks (22nd EPA, 11th YPC), and the Week 5 market line (ATL -3.5).
- The entire "A Beautiful Mind" section: coach win rates by career path (53% vs. 47%), playoff rates (49% vs. 35%), top-10 defense/offense hit rates (29%/33%, 44%/15%), average defensive rank (16.4), first-year-hire prior win pct (.340), the 21-6 head-to-head record and the "biggest gap in six seasons" claim, and the Penix/Cousins under-Morris-vs-under-Stefanski/Kubiak EPA-per-dropback comparisons. None of this -- coaching career paths, team-level EPA by coach, or market-adjusted margins -- exists anywhere in boxscore-prophet's output.

## Reuse check
Checked `graphics/week3_wrap_week4_storylines/`, `graphics/somethings_gotta_give/`, and `graphics/trust_but_verify/` (all same repo). Those covered different players/teams (Mahomes/Allen/Cook/Stroud era players; Saints/Raiders/Texans/Chargers) and different angles (model-vs-ECR rank, calibration ledger, cleared/missed start lines). None restate the Jacksonville/Atlanta Week 1-4 start-chance-vs-actual or QB-carousel angles used here.

candidate_5.png -- table (gt, light). Section: "A Beautiful Mind." Offensive-path vs. defensive-path head coaches, 2021-2025: win % 53/47, playoffs 49/35, top-10 offense 44/15, top-10 defense 33/29, avg defense rank 16.4/16.4; footnote on the 2026 21-6 head-to-head. Numbers as stated in the article (Steve's nflverse/nflreadr analysis), not from boxscore-prophet. Built by Manfred.
