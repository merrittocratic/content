# ============================================================================
# build.R -- graphics for "There Can Be Only One. Right?"
# (cfb-season, 2026-10-18 week6_cfb_wrapup)
#
# repo: none in the draft's frontmatter. Steve supplied a verified data
# packet directly and authorized building graphics from it despite the
# repo:none tag (see graphics/logs/week6_cfb_wrapup.log). All numbers below
# are transcribed from that packet / the article's own tables, not
# recomputed.
#
# Four candidates:
#   1. candidate_1.png -- slope chart, blown-lead comparison (OSU-Texas vs.
#      Texas-Oklahoma), leader's EPA/play 1st half -> 2nd half.
#   2. candidate_2.png -- gt table, Big Ten three-season decline through
#      Week 6 (2024/2025/2026).
#   3. candidate_3.png -- faceted bar chart, "no elite team": #1's SD above
#      FBS average and #1's lead over #5, three seasons.
#   4. candidate_4.png (WILDCARD) -- patchwork 2-panel: five systems' five
#      different #1 picks, plus a polar rank chart of Indiana's profile
#      across all five systems + AP.
#
# Packages: ggplot2, dplyr, tibble, glue, scales, ggtext, ggrepel, gt,
#           gtExtras, patchwork
# Output: graphics/week6_cfb_wrapup/candidate_{1,2,3,4}.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(glue)
library(scales)
library(ggrepel)
library(gt)
library(gtExtras)
library(patchwork)

out_dir <- "graphics/week6_cfb_wrapup"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

# --- House palette & theme (copied from scripts/trust_but_verify_sample_size_funnel.R) ----
col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_blue    <- "#3A7CA5"   # steel blue
col_red     <- "#C0392B"   # red
col_gold    <- "#B8860B"   # dark goldenrod

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major   = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.title         = element_text(color = col_text, size = 10),
      plot.title         = element_text(color = col_text, face = "bold",
                                        size = 15, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 10,
                                        margin = margin(b = 10)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 10)),
      strip.text         = element_text(color = col_text, face = "bold", size = 10),
      legend.position    = "none",
      plot.margin        = margin(14, 20, 10, 14)
    )
}

save_plot <- function(p, filename, width = 1200, height = 800, dpi = 150) {
  ggsave(
    filename = file.path(out_dir, filename),
    plot     = p,
    width    = width / dpi,
    height   = height / dpi,
    dpi      = dpi,
    bg       = col_bg
  )
  cat("wrote", file.path(out_dir, filename), "\n")
}

# ============================================================================
# Candidate 1: slope chart -- the blown lead that wasn't
# Data: article / packet item 1 (blown-lead EPA/play splits)
# ============================================================================

blown <- tibble::tribble(
  ~game,                                ~half,       ~epa,   ~color_grp,
  "Ohio State vs. Texas (Wk 2)",         "1st half",  0.198,  "collapse",
  "Ohio State vs. Texas (Wk 2)",         "2nd half", -0.406,  "collapse",
  "Texas vs. Oklahoma (Wk 6)",          "1st half", -0.015,  "never_good",
  "Texas vs. Oklahoma (Wk 6)",          "2nd half", -0.280,  "never_good"
) |>
  mutate(half = factor(half, levels = c("1st half", "2nd half")))

end_labels <- blown |>
  group_by(game) |>
  filter(half == "2nd half") |>
  mutate(lab = glue("{game}\n{sprintf('%+.3f', epa)} EPA/play"))

p1 <- ggplot(blown, aes(x = half, y = epa, group = game, color = color_grp)) +
  geom_hline(yintercept = 0, color = col_text, linewidth = 0.8) +
  geom_line(linewidth = 1.4) +
  geom_point(size = 3.6) +
  geom_text_repel(
    data = end_labels, aes(label = lab),
    seed = 42, size = 3.1, fontface = "bold", lineheight = 0.95,
    nudge_x = 0.38, hjust = 0, direction = "y",
    segment.color = col_subtext, segment.size = 0.3,
    box.padding = 0.5
  ) +
  scale_color_manual(values = c(collapse = col_blue, never_good = col_red)) +
  scale_x_discrete(expand = expansion(mult = c(0.15, 0.55))) +
  scale_y_continuous(breaks = seq(-0.4, 0.2, 0.1), limits = c(-0.45, 0.24)) +
  labs(
    title = "One Lead Was Real. The Other Wasn't.",
    subtitle = paste0(
      "Leader's EPA per play, 1st half vs. 2nd half -- Ohio State led 23-3 on a\n",
      "good half before fading; Texas never cleared zero before fading further"
    ),
    x = NULL, y = "Leader's EPA/play",
    caption = paste0(
      "Ohio State led Texas 23-3, Wk 2 (Texas won 24-23, scoring 21 straight in Q4); ",
      "Texas led Oklahoma 17-7, Wk 6 (Oklahoma won 27-24)\n",
      "TheMerrittocracy  \u00b7  EPA excludes garbage time; corrected 2026 play order. Data via cfbfastR / CFBD."
    )
  ) +
  theme_merrittocracy_light()

save_plot(p1, "candidate_1.png")

# ============================================================================
# Candidate 2: gt table -- Big Ten three-season decline through Week 6
# Data: packet item 2
# ============================================================================

bigten <- tibble::tribble(
  ~metric,                                  ~y2024,              ~y2025,           ~y2026,
  "Best team (net EPA rank)",                "1st (Ohio State)",  "2nd (Oregon)",   "4th (Indiana)",
  "Teams in FBS top 10 (net EPA)",           "4",                 "4",              "3",
  "Teams in FBS top 25 (net EPA)",           "7",                 "7",              "7",
  "Non-con record vs. Power 4",              "6-8",               "5-6",            "4-10"
)

tbl2 <- bigten |>
  gt() |>
  cols_label(
    metric = "Big Ten through Week 6",
    y2024  = "2024",
    y2025  = "2025",
    y2026  = "2026"
  ) |>
  tab_header(
    title    = md("**Deep, But No Juggernaut**"),
    subtitle = md("Big Ten three-season trend, measured through Week 6 each year")
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** &middot; Net EPA ranks out of 138 FBS teams, not opponent-adjusted &middot; Data via cfbfastR / CFBD")
  ) |>
  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(9),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_column_labels()
  ) |>
  # 2026 cells that slipped (top of the conference, non-con record) in red;
  # depth (top-25 count) held steady, so it gets a neutral highlight
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(weight = "bold", color = "#C62828")),
    locations = cells_body(columns = y2026, rows = c(1, 2, 4))
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#F5F5F5"), cell_text(weight = "bold")),
    locations = cells_body(columns = y2026, rows = 3)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = metric)
  ) |>
  cols_align(align = "center", columns = c(y2024, y2025, y2026)) |>
  cols_align(align = "left",   columns = metric) |>
  cols_width(
    metric ~ px(240),
    y2024  ~ px(160),
    y2025  ~ px(160),
    y2026  ~ px(160)
  )

gtsave(tbl2, filename = file.path(out_dir, "candidate_2.png"), vwidth = 760)
cat("wrote", file.path(out_dir, "candidate_2.png"), "\n")

# ============================================================================
# Candidate 3: faceted bar chart -- "no elite team" over three seasons
# Data: packet item 3 (top-of-field spread)
# ============================================================================

spread <- tibble::tribble(
  ~year, ~team,          ~metric,                              ~value,
  "2024", "Ohio State",  "Above the FBS average",              2.90,
  "2025", "Texas Tech",  "Above the FBS average",              2.96,
  "2026", "Georgia",     "Above the FBS average",              2.76,
  "2024", "Ohio State",  "Lead over the #5 team",              0.85,
  "2025", "Texas Tech",  "Lead over the #5 team",              1.15,
  "2026", "Georgia",     "Lead over the #5 team",              0.81
) |>
  mutate(
    metric = factor(metric, levels = c("Above the FBS average", "Lead over the #5 team")),
    is_now = year == "2026",
    lab = sprintf("%.2f", value)
  )

p3 <- ggplot(spread, aes(x = year, y = value, fill = is_now)) +
  geom_col(width = 0.62) +
  geom_text(aes(label = glue("{team}\n{lab}")), vjust = -0.35, size = 3.3,
            color = col_text, fontface = "bold", lineheight = 1.05) +
  facet_wrap(~metric, scales = "free_y") +
  scale_fill_manual(values = c(`FALSE` = col_blue, `TRUE` = col_gold)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.32))) +
  labs(
    title = "Georgia Stands Out Like Recent #1s",
    subtitle = paste0(
      "The net EPA #1 through Week 6 each season, measured in standard deviations\n",
      "of net EPA per play -- Georgia is in the same range as 2024 Ohio State"
    ),
    x = NULL, y = NULL,
    caption = paste0(
      "Georgia is 4th in both offensive and defensive EPA, the most balanced team in the net EPA top five.\n",
      "TheMerrittocracy  \u00b7  Net EPA is not opponent-adjusted; corrected 2026 play order. Data via cfbfastR / CFBD."
    )
  ) +
  theme_merrittocracy_light()

save_plot(p3, "candidate_3.png")

# ============================================================================
# Candidate 4 (WILDCARD): patchwork -- Indiana's resume case
#   Panel A: best win by opponent's net EPA rank, unbeaten contenders
#   Panel B: quarterbacks by season EPA per dropback rank (of 223)
# Data: rerun packet items 1-3 (all numbers appear in the article)
# ============================================================================

# --- Panel A: best win -------------------------------------------------------

best_wins <- tibble::tribble(
  ~team,         ~ap, ~opp,          ~rank, ~top25,
  "Indiana",      7,  "Nebraska",     6,    2,
  "Georgia",      2,  "Alabama",     11,    1,
  "Miami",        4,  "Wake Forest", 16,    1,
  "Notre Dame",   3,  "Wisconsin",   25,    1,
  "Ohio State",   5,  "Iowa",        42,    0
) |>
  mutate(
    row     = glue("{team} (AP {ap})"),
    row     = factor(row, levels = rev(row)),
    is_iu   = team == "Indiana",
    ord     = ifelse(rank %% 10 == 1 & rank != 11, "st", ifelse(rank %% 10 == 2 & rank != 12, "nd", "th")),
    lab     = glue("{opp} ({rank}{ord}) \u00b7 {top25} top-25 win{ifelse(top25 == 1, '', 's')}")
  )

panelA <- ggplot(best_wins, aes(x = rank, y = row)) +
  geom_segment(aes(x = 0, xend = rank, yend = row), color = col_grid, linewidth = 1.2) +
  geom_point(aes(color = is_iu), size = 5) +
  geom_text(aes(label = lab, color = is_iu), nudge_x = 6, hjust = 0,
            size = 3.1, fontface = "bold") +
  scale_color_manual(values = c(`FALSE` = col_blue, `TRUE` = col_gold)) +
  scale_x_continuous(limits = c(0, 100), breaks = c(1, 20, 40),
                     labels = c("1st", "20th", "40th")) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Best Win Among the Contenders",
    subtitle = "Opponent's net EPA rank (1 = best), AP rank pre-Week 6"
  ) +
  theme_merrittocracy_light() +
  theme(
    plot.title  = element_text(size = 13),
    axis.text.y = element_text(size = 10, face = "bold", color = col_text),
    axis.title  = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.margin = margin(10, 30, 8, 12)
  )

# --- Panel B: quarterbacks -------------------------------------------------

qbs <- tibble::tribble(
  ~qb,                ~team,        ~rank,
  "Darian Mensah",    "Miami",       1,
  "Gunner Stockton",  "Georgia",     2,
  "Josh Hoover",      "Indiana",     3,
  "Julian Sayin",     "Ohio State",  5,
  "Dante Moore",      "Oregon",     43,
  "Arch Manning",     "Texas",     118,
  "Nico Iamaleava",   "UCLA",      170
) |>
  mutate(
    qb    = factor(qb, levels = rev(qb)),
    is_iu = team == "Indiana",
    lab   = glue("{rank}{ifelse(rank == 1, 'st', ifelse(rank == 2, 'nd', ifelse(rank == 3, 'rd', 'th')))} ({team})")
  )

panelB <- ggplot(qbs, aes(x = rank, y = qb)) +
  geom_segment(aes(x = 0, xend = rank, yend = qb), color = col_grid, linewidth = 1.2) +
  geom_point(aes(color = is_iu), size = 4.5) +
  geom_text(aes(label = lab, color = is_iu), nudge_x = 14, hjust = 0,
            size = 3.4, fontface = "bold") +
  scale_color_manual(values = c(`FALSE` = col_blue, `TRUE` = col_gold)) +
  scale_x_continuous(limits = c(0, 270), breaks = c(1, 100, 200),
                     labels = c("1st", "100th", "200th")) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Indiana's QB Is Top 3",
    subtitle = "Season EPA/dropback rank, of 223"
  ) +
  theme_merrittocracy_light() +
  theme(
    plot.title  = element_text(size = 13),
    axis.text.y = element_text(size = 10, face = "bold", color = col_text),
    axis.title  = element_blank(),
    panel.grid.major.y = element_blank(),
    plot.margin = margin(10, 40, 8, 12)
  )

combined <- panelA + plot_spacer() + panelB +
  plot_layout(widths = c(1, 0.06, 1.15)) +
  plot_annotation(
    title = "Ranked 7th in the AP, Built Like a Contender",
    caption = paste0(
      "Indiana: 22-game win streak, 4th in net EPA, 7th in the AP poll entering Week 6. Top-25 wins are by opponent's net EPA rank.\n",
      "QB ranks are season EPA per dropback (100+ dropbacks).\n",
      "TheMerrittocracy  \u00b7  EPA excludes garbage time; corrected 2026 play order. Ranks out of 138 FBS teams. Data via cfbfastR / CFBD."
    ),
    theme = theme(
      plot.title   = element_text(color = col_text, face = "bold", size = 17, margin = margin(b = 6)),
      plot.caption = element_text(color = col_subtext, size = 8, hjust = 0, margin = margin(t = 10))
    )
  ) &
  theme(plot.background = element_rect(fill = col_bg, color = NA))

save_plot(combined, "candidate_4.png")
