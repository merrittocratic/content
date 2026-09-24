# Candidates: trust_but_verify (repo: boxscore-prophet)

- candidate_1.png -- table (gt). The core 8-cell calibration ledger (Position x Startable/Boom, model-said vs. actually-happened, gap in pp), color-coded by gap direction; TE-start bolded as the worst cell. Exact numbers are the point.
- candidate_2.png -- chart (bar/leaderboard). All 8 cells ranked by |gap|, diverging color for over- vs under-called, TE start on top annotated as the worst miss in the table.
- candidate_3.png -- chart (dumbbell, faceted by position). Model-said vs. actually-happened plotted as connected dot pairs for start/boom per position, with ggrepel callouts on TE start (biggest miss) and QB boom (dead-on match).
- candidate_4.png -- WILDCARD, chart (patchwork, 3 panels). Top: heatmap tile grid of the same 8-cell ledger. Bottom: two log-scaled dot plots of every cell currently sitting on the live watch registry (data/10f_watch_registry.csv), normalized to each cell's own effect bar and sample floor -- shows the WR windy-game cell clearing its effect bar but not its sample floor, and the QB trench-residual cells clearing their sample floor easily but not their effect bar.

