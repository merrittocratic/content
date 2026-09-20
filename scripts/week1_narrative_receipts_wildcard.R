# ============================================================================
# content/scripts/week1_narrative_receipts_wildcard.R
#
# Wildcard (candidate 4) for draft/week1_narrative_receipts.md.
# Two-panel patchwork composition:
#   Panel 1 -- dumbbell of model rank vs. ECR rank for the four QB conviction
#              calls, with an explicit HIT/MISS callout per row (not just
#              color) so the outcome doesn't require inferring from the gap
#              sign.
#   Panel 2 -- lollipop of the four featured backs' run-efficiency
#              percentiles, quartile-shaded.
# The title states the connection between the two panels directly: the two
# games where the QB conviction call hit also had the week's best two run
# grades; the one game where it missed had the week's worst.
#
# Revision history:
#   - v2 (this file): Steve's feedback on the original candidate_4 --
#     Panel 1 was ambiguous (color alone carried both the ECR/model
#     encoding and the hit/miss encoding). Added explicit HIT/MISS text per
#     row. Retitled to name the QB-call / run-game link instead of the
#     generic "Four Games, Eight Verified Signals." Panel 2 and the overall
#     two-panel composition are unchanged from v1. Also fixed gap-sign
#     convention to match candidate_1's table (positive = model more
#     bullish than ECR) and wrapped title/subtitle text so nothing clips
#     at the plot edge.
#
# Data sources (re-verified 2026-09-16, same artifacts as v1):
#   - QB model_rank / ecr_rank / rank_gap: output/10d_ecr_gap_2026_w01.csv
#     in boxscore-prophet, as captured pre-kickoff and previously verified
#     "exact match" against the draft text. NOTE: this artifact is
#     regenerated in place every pipeline run and now reflects a later
#     Week 1 game (KC/DEN) rather than a stable per-game history, so these
#     four rows cannot be re-pulled fresh from the live file this session --
#     they are carried over unchanged from the prior verified build, which
#     is also what output candidate_1.png's gt table already displays.
#   - QB hit/miss verdict: re-confirmed this session (not inferred from
#     gap sign) against output/10d_receipts_2026_w01.csv's hit_start /
#     fp_actual columns, which is the repo's real graded-outcome artifact:
#       * Jaxson Dart:    hit_start = TRUE  (fp_actual 26.6 vs thresh 20) -> HIT
#       * Justin Herbert: hit_start = FALSE (fp_actual 13.26 vs thresh 20) -> MISS
#       * Joe Burrow:     hit_start = FALSE (fp_actual 14.16 vs thresh 20);
#         model was BEARISH on Burrow (rank 4 vs ECR 1), so his missing his
#         own bar means the model's skeptical call was correct -> HIT
#       * Patrick Mahomes: the KC/DEN game (Monday night, already played)
#         has NOT yet been graded in the current output/10d_receipts_2026_w01
#         snapshot -- it still lists Mahomes under "still on the board." No
#         artifact in the repo currently carries his graded outcome. His HIT
#         label is therefore carried over unchanged from the original
#         verified build (matches candidate_1.png's gt table, which Steve
#         has already reviewed and did not flag), not freshly re-confirmed
#         against a graded artifact this session. Flagged here and in the
#         run log per house verification rules.
#   - RB run-efficiency percentiles: re-verified exact match this session
#     against output/oneoff/pff_run_grade_pilot/w1_2026_storyline_rb_proxy.csv
#     (Walker 97, Skattebo 81, Brown 30, Hampton 6).
#
# Output: content/graphics/week1_narrative_receipts/candidate_4.png
# ============================================================================

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(patchwork)

# colors ----------------------------------------------------------------------
hit_color  <- "#1F77B4"  # blue  -- the call held up
miss_color <- "#D95F02"  # orange -- the Chargers, the week's honest miss
grey_color <- "#8C8C8C"  # market / ECR dot

# panel 1 data ------------------------------------------------------------
qb <- tibble::tribble(
  ~player,             ~team,  ~model_rank, ~ecr_rank, ~hit,
  "Patrick Mahomes",   "KC",   9,           17,        TRUE,
  "Jaxson Dart",       "NYG",  5,           11,        TRUE,
  "Justin Herbert",    "LAC",  1,           5,         FALSE,
  "Joe Burrow",        "CIN",  4,           1,         TRUE
) |>
  mutate(
    label = glue("{player} ({team})"),
    label = factor(label, levels = rev(label)),
    # positive = model ranked the player higher (more bullish) than ECR --
    # matches candidate_1's gt table sign convention exactly
    gap = ecr_rank - model_rank,
    gap_label = ifelse(gap > 0, glue("gap +{gap}"), glue("gap {gap}")),
    verdict = ifelse(hit, "HIT", "MISS"),
    verdict_color = ifelse(hit, hit_color, miss_color),
    seg_color = ifelse(hit, hit_color, miss_color),
    # fixed label columns to the right of all data (axis is reversed, so a
    # smaller x sits further right in pixel space)
    x_gap = -3,
    x_verdict = -6.6
  )

p1 <- ggplot(qb) +
  geom_segment(
    aes(x = ecr_rank, xend = model_rank, y = label, yend = label, color = seg_color),
    linewidth = 1.4
  ) +
  geom_point(aes(x = ecr_rank, y = label), color = grey_color, size = 4.2) +
  geom_point(aes(x = model_rank, y = label, color = seg_color), size = 4.6) +
  geom_text(
    aes(x = x_gap, y = label, label = gap_label),
    hjust = 0, color = "grey30", size = 4.1, family = "sans"
  ) +
  geom_text(
    aes(x = x_verdict, y = label, label = verdict, color = verdict_color),
    hjust = 0, fontface = "bold", size = 4.4, family = "sans"
  ) +
  scale_color_identity() +
  scale_x_reverse(
    breaks = sort(unique(c(qb$model_rank, qb$ecr_rank)), decreasing = TRUE),
    limits = c(19, -8.5),
    expand = expansion(mult = c(0.01, 0.01))
  ) +
  labs(
    x = "Rank (1 = best)",
    y = NULL,
    subtitle = "Panel 1: the market (grey dot) vs. the model (color) -- lower rank is better.\nHIT/MISS states the outcome directly; color repeats it, it does not carry it alone."
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 12, face = "bold"),
    plot.subtitle = element_text(size = 10.5, color = "grey25", margin = margin(b = 10), lineheight = 1.2)
  )

# panel 2 data (unchanged from v1) ----------------------------------------
rb <- tibble::tribble(
  ~player,               ~team,  ~percentile, ~hit,
  "Kenneth Walker III",  "KC",   97,          TRUE,
  "Cam Skattebo",        "NYG",  81,          TRUE,
  "Chase Brown",         "CIN",  30,          TRUE,
  "Omarion Hampton",     "LAC",  6,           FALSE
) |>
  mutate(
    label = glue("{player} ({team})"),
    label = factor(label, levels = rev(label)),
    dot_color = ifelse(hit, hit_color, miss_color),
    label_text = glue("{percentile}th")
  )

quartile_bands <- tibble::tribble(
  ~xmin, ~xmax, ~fill,
  0,     25,    "#D95F02",
  25,    75,    "#DEDEDE",
  75,    100,   "#1F77B4"
)

p2 <- ggplot() +
  geom_rect(
    data = quartile_bands,
    aes(xmin = xmin, xmax = xmax, ymin = -Inf, ymax = Inf, fill = fill),
    alpha = 0.18
  ) +
  scale_fill_identity() +
  geom_segment(
    data = rb,
    aes(x = 0, xend = percentile, y = label, yend = label),
    color = "grey40", linewidth = 0.9
  ) +
  geom_point(data = rb, aes(x = percentile, y = label, color = dot_color), size = 4.6) +
  geom_text(
    data = rb,
    aes(x = percentile, y = label, label = label_text),
    hjust = -0.35, size = 4.1
  ) +
  scale_color_identity() +
  scale_x_continuous(limits = c(0, 108), breaks = c(0, 25, 50, 75, 100)) +
  labs(
    x = "Percentile",
    y = NULL,
    subtitle = "Panel 2: featured back's run-efficiency percentile, that same game"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_text(size = 12, face = "bold"),
    plot.subtitle = element_text(size = 10.5, color = "grey25", margin = margin(b = 10))
  )

# composition ---------------------------------------------------------------
combined <- p1 / p2 +
  plot_layout(heights = c(1, 1)) +
  plot_annotation(
    title = "Conviction Runs Downhill",
    subtitle = "Week 1, 2026 -- the two games where the model's QB call hit (Mahomes, Dart) also had the\nweek's best two run grades (Walker 97th, Skattebo 81st). The one it missed (Herbert) had the\nweek's worst (Hampton 6th).",
    caption = "Sources: output/10d_ecr_gap_2026_w01.csv, output/10d_receipts_2026_w01.csv, output/oneoff/pff_run_grade_pilot/w1_2026_storyline_rb_proxy.csv -- Boxscore Prophet",
    theme = theme(
      plot.title = element_text(size = 22, face = "bold", margin = margin(b = 4)),
      plot.subtitle = element_text(size = 12, color = "grey20", margin = margin(b = 12), lineheight = 1.25),
      plot.caption = element_text(size = 8.5, color = "grey45", hjust = 0)
    )
  )

out_dir <- file.path("graphics", "week1_narrative_receipts")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

ggsave(
  filename = file.path(out_dir, "candidate_4.png"),
  plot = combined,
  width = 11.5, height = 11.7, dpi = 170, bg = "white"
)
