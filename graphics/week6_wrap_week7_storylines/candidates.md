# Candidates: week6_wrap_week7_storylines (repo: boxscore-prophet)

- candidate_1.png -- table (gt). Week 7 board for the seven fantasy names in the draft (Goff, Gibbs, St. Brown, Jameson Williams, Prescott, Tanner McKee, George Pickens): model rank, ECR rank, gap and exact start chance, grouped by game.
- candidate_2.png -- chart (dumbbell). Model rank vs. ECR rank for the same seven; Jameson Williams (WR41 vs. WR30) is the one big red fade, Pickens (WR10 vs. WR18) the biggest blue lift.
- candidate_3.png -- chart (jittered dot strip). Where the seven sit among every QB and WR on the Week 7 board by start chance, Williams in red (29%), Pickens 51%, St. Brown 60%, McKee 28%.
- candidate_4.png -- WILDCARD, chart (patchwork, two stacked game panels). Green Bay at Detroit vs. Dallas at Philadelphia: start-chance bars with boom-chance diamonds and model-vs-ECR rank tags, so the shootout and the slog read side by side.

## Data sources
`boxscore-prophet/output/10d_start_board_2026_w07.csv` (start_pct, boom_pct) and `10d_ecr_gap_2026_w07.csv` (model_rank, ecr_rank, rank_gap). Every fantasy figure in the draft (McKee 28% QB16/QB20, Pickens 51% WR10/WR18, Prescott 35% QB10/QB8, Gibbs 71% RB1, St. Brown 60% WR2/WR4, Goff 46% QB4, Williams 29% WR41/WR30) matches.

## Reuse check
week5_wrap_week6_storylines candidate_1 had a Week 6 Prescott row and candidate_3 charted his weekly points; these are Week 7 values and a different framing. No prior slug charted McKee, Pickens, or the Detroit skill players.

## Notes
- ggbeeswarm is not installed, so candidate_3 uses seeded-free jitter (geom_jitter) instead; the vertical stack of QBs near 10% is real data (many QBs tied at 10%). Jitter is vertical only, so x positions are exact.
- Market lines (Cowboys -4.5, totals 44.5 and 53.5) were left off the graphics; see unverified list.

## Unverified claims (not charted): no matching artifact found
- All NFC East claims: 0-6 in Weeks 5-6, outscored by 44, 5-11 outside division, 31% win rate, outscored by 83, 25th-worst of 200 division-seasons, 2020 NFC East comparison, 51 all-lose weeks, 10 worst divisions bounce-back (46%, 32%-58%).
- Team EPA ranks (Philadelphia 31st, Dallas 25th, Washington 24th, Giants 22nd, defense/offense ranks), points per game, schedule-strength ranks, Hurts blood clot.
- Lions/Bills claims: 32.8 points per game, EPA ranks, points allowed, game totals (62.4, 61.3), Week 2 41-31 result.
- Super Bowl history: 75-point record, 74 in LII, 52.6 pair average, five-pair under results (40, 16, 51, 38, 62), 24-game +3 average, 127 of 6,223 games at 76+ points.
- Week 7 market lines: Cowboys -4.5, totals 44.5 and 53.5, implied 24.5/20; Buffalo Week 7 bye.
- boxscore-prophet has no team-level EPA, division, or Super Bowl history artifacts, so none of these can be built from this repo.
