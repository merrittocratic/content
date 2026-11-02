# Candidates: week7_wrap_week8_storylines (repo: boxscore-prophet)

- candidate_1.png -- table (gt). Week 7 North QB board: Goff 49%, Love 46%, Burrow 34%, Murray 33%, Rodgers 24%, Watson 24%, plus J.J. McCarthy 21%, with start/boom chance, model QB rank, ECR QB rank and gap.
- candidate_2.png -- chart (ranked lollipop). All 22 QBs at 20%+ Week 7 start chance, NFC North in red and AFC North in gold; Goff, Love, Burrow and Murray are the four North QBs in the model's top 10.
- candidate_3.png -- chart (grouped bars). Kyler Murray (33% start, 19% boom, model QB10) vs J.J. McCarthy (21% start, 12% boom, model QB19), the "quarterback Minnesota moved on from" angle.
- candidate_4.png -- WILDCARD, chart (patchwork, mirrored three-panel). Each North starter against the QB across the field (Goff 49% vs. Love 46%, Burrow 34% vs. Huntley 9%, Murray 33% vs. Daniel Jones 18%, Rodgers 24% vs. Tyler Shough 23%, Watson 24% vs. Cam Ward 10%), bars for start chance, diamonds for boom, model/ECR ranks in the middle.

## Data sources
`boxscore-prophet/output/10d_ecr_gap_2026_w07.csv` (model_rank, ecr_rank, rank_gap, start_pct) joined to `10d_start_board_2026_w07.csv` (boom_pct, defteam). Division tags are from team abbreviations, not an artifact.

## Reuse check
week6_wrap_week7_storylines already used the Week 7 board for Goff, so Goff's row repeats, but the angle (all North QBs, QB-only ladder, Murray vs. McCarthy, QB vs. opposing QB) is new. Its candidate_3 was a QB+WR jitter strip; candidate_2 here is a QB-only ranked ladder, a different view.

## Notes
- Goff's current Week 7 start chance in the file is 49% (QB1 model, QB4 ECR); the earlier week6 candidates.md recorded 46%, so the board was re-run since then. The draft's 49% matches the current file.
- Lamar Jackson and Caleb Williams are not on the final Week 7 start board (Jackson was flagged Out/Questionable in the ledger runs), so they are left off.
- The 22-QB ladder cutoff (20%) is mine, not the draft's.

## Unverified claims (not charted): no matching artifact found
- Goff Week 8 "29% chance of a startable week" and "market has him at QB12": the repo has no Week 8 output (latest is 2026_w07). "Down from 49% in his games so far": 49% matches the Week 7 value only, no season-average artifact.
- All team and division claims: 29-8 record, 15-3 and 14-5 non-division records, NFC West .556, opponent net EPA ranks (about 20th, 14th-16th), 1-4 against top-12 net EPA, NFC West ranks (1st, 6th, 7th, 28th), Minnesota 6-0 and 4-0 in one-score games, strength of schedule 30th, Cleveland 5-2 with -13 point differential, 5-1 in one-score games, 18th net EPA, Detroit 4-2 and 21st net EPA, Cincinnati 3rd net EPA (up from 28th) and +41 point differential, Chicago 8th, Pittsburgh 16th, Green Bay 12th, Baltimore 10th net EPA and 3-1 / 1-2 with Jackson / Huntley. No team-level EPA, record or schedule artifacts in boxscore-prophet.
- Vikings defense/offense ranks (1st in EPA per play allowed, 1st in sack rate 9.9%, 23% red-zone touchdown rate, 30th EPA per play, 32nd success rate), Detroit 3rd offense and 31st defense, 4.8 completions of 20-plus yards allowed, Browns 8th EPA allowed, Steelers 6th EPA allowed, Packers worst run game and most takeaways.
- QB stats: Murray 85.8 passer rating (22nd of 32) and 6.5 yards per attempt and -8.4 passing EPA; McCarthy 10.1 yards per attempt, 95.2 passer rating, +10.6 passing EPA in Weeks 6-7; Watson CPOE -4.5 (31st); Goff 112.4 passer rating; Burrow 15 TD, 3 INT, 110.0 rating; Williams 106.5 rating (6th) and +5.8 CPOE (3rd); Rodgers; Chicago losses (9-3 at Minnesota, 31-7 to Green Bay). No passer rating, CPOE or passing EPA artifacts.
- "Week 8: Minnesota at Detroit, Lions by 3": no Week 8 spread artifact.
- Candidate 3 shows only the model's Week 7 pregame view of Murray vs. McCarthy; it does not verify or contradict the draft's claim that McCarthy has been better in Weeks 6-7.
