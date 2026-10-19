# ============================================================================
# build.R -- graphics for "Hold Onto Your Butts"
# (cfb-season, 2026-10-25 week7_cfb_wrapup)
#
# repo: none in the article's frontmatter. Steve supplied a data packet
# directly and asked for a Rembrandt packet built from it (see
# graphics/logs/week7_cfb_wrapup.log). All numbers below are transcribed
# from that packet and cross-checked against the article, not recomputed.
#
# Four candidates:
#   1. candidate_1.png -- bar chart, top-8 losses per AP poll week since
#      1936 (1,173 weeks), the two 5-loss weeks highlighted.
#   2. candidate_2.png -- gt table, Notre Dame's resume: six wins, none
#      over a team ranked at the time; BYU loss; ranked teams remaining.
#   3. candidate_3.png -- faceted lollipop, Notre Dame vs. Texas remaining
#      opponents by net EPA rank.
#   4. candidate_4.png (WILDCARD) -- tile grid of the AP top 8, Week 7 2026
#      vs. Oct. 4, 2014, losers filled, top-8-vs-top-8 losses drawn as arcs.
#
# Packages: ggplot2, dplyr, tibble, glue, scales, gt, gtExtras
# Output: graphics/week7_cfb_wrapup/candidate_{1,2,3,4}.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(glue)
library(scales)
library(gt)
library(gtExtras)

out_dir <- "graphics/week7_cfb_wrapup"
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
  theme_minimal(base_size = base_size, base_family = "Arial") +
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
      strip.text         = element_text(color = col_text, face = "bold", size = 11),
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
    bg       = col_bg,
    device   = ragg::agg_png
  )
  cat("wrote", file.path(out_dir, filename), "\n")
}

ordinal <- function(n) {
  suf <- ifelse(n %% 100 %in% 11:13, "th",
         ifelse(n %% 10 == 1, "st",
         ifelse(n %% 10 == 2, "nd",
         ifelse(n %% 10 == 3, "rd", "th"))))
  paste0(n, suf)
}

# ============================================================================
# Candidate 1: bar chart -- how rare is a five-loss week?
# Data: packet item 1, historical context table
# ============================================================================

hist_weeks <- tibble::tribble(
  ~losses, ~weeks,
  0,       569,
  1,       352,
  2,       181,
  3,        54,
  4,        15,
  5,         2
) |>
  mutate(
    is_five = losses == 5,
    pct     = weeks / sum(weeks),
    lab     = ifelse(is_five, "2 weeks", comma(weeks))
  )

stopifnot(sum(hist_weeks$weeks) == 1173)

p1 <- ggplot(hist_weeks, aes(x = factor(losses), y = weeks, fill = is_five)) +
  geom_col(width = 0.68) +
  geom_text(aes(label = lab, color = is_five), vjust = -0.5, size = 3.8,
            fontface = "bold") +
  annotate(
    "text", x = 5.15, y = 175, hjust = 0.5, vjust = 0, size = 3.2,
    color = col_red, fontface = "bold", lineheight = 1.05,
    label = "Oct. 4, 2014 and\nWeek 7, 2026. Only\n2026 included\n#1 and #2."
  ) +
  annotate(
    "segment", x = 5.6, xend = 5.95, y = 170, yend = 40,
    color = col_red, linewidth = 0.5
  ) +
  scale_fill_manual(values = c(`FALSE` = col_blue, `TRUE` = col_red)) +
  scale_color_manual(values = c(`FALSE` = col_text, `TRUE` = col_red)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)), labels = comma) +
  labs(
    title = "Five Top-8 Losses Has Happened Twice",
    subtitle = paste0(
      "Number of AP poll weeks by how many of the top eight teams lost,\n",
      "every week since 1936 with a full top eight (1,173 weeks)"
    ),
    x = "Top-8 teams that lost that week", y = "Weeks",
    caption = paste0(
      "AP ranks entering each week. Early poll data in CFBD is less complete.\n",
      "TheMerrittocracy  \u00b7  Data via cfbfastR / College Football Data API."
    )
  ) +
  theme_merrittocracy_light() +
  theme(panel.grid.major.x = element_blank())

save_plot(p1, "candidate_1.png")

# ============================================================================
# Candidate 2: gt table -- Notre Dame's resume has no ranked wins
# Data: Steve's Notre Dame follow-up packet (wins table + remaining ranked)
# ============================================================================

nd <- tibble::tribble(
  ~section,                      ~opp,             ~rec,   ~ap,
  "Wins",                        "Wisconsin",      "4-2",  "No",
  "Wins",                        "North Carolina", "4-2",  "No",
  "Wins",                        "Purdue",         "3-4",  "No",
  "Wins",                        "Stanford",       "3-4",  "No",
  "Wins",                        "Michigan State", "2-5",  "No",
  "Wins",                        "Rice",           "1-6",  "No",
  "Loss",                        "BYU",            "--",   "Yes (#8)",
  "Ranked teams still to play",  "Miami",          "6-0",  "#3 now",
  "Ranked teams still to play",  "SMU",            "5-1",  "#24 now"
)

tbl2 <- nd |>
  gt(groupname_col = "section") |>
  cols_label(
    opp = "Opponent",
    rec = "Opponent's record now",
    ap  = "AP-ranked at the time?"
  ) |>
  tab_header(
    title    = md("**Six Wins, Zero Ranked**"),
    subtitle = md("Notre Dame (6-1) has not beaten a team that was in the AP poll when they played")
  ) |>
  tab_source_note(
    source_note = md(paste0(
      "Remaining ranks are from the AP poll entering Week 7. The committee uses its own rankings, ",
      "first released in early November.<br>",
      "**TheMerrittocracy** &middot; Data via cfbfastR / CFBD"
    ))
  ) |>
  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    row_group.font.size                = px(12),
    row_group.font.weight              = "bold",
    row_group.background.color         = "#F5F5F5",
    table.width                        = pct(100),
    data_row.padding                   = px(6),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_column_labels()
  ) |>
  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = opp)
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(weight = "bold", color = "#C62828")),
    locations = cells_body(columns = ap, rows = section == "Wins")
  ) |>
  tab_style(
    style     = list(cell_fill(color = "#FFF8E1"), cell_text(weight = "bold", color = "#8D6E00")),
    locations = cells_body(columns = ap, rows = section == "Ranked teams still to play")
  ) |>
  cols_align(align = "center", columns = c(rec, ap)) |>
  cols_align(align = "left",   columns = opp) |>
  cols_width(
    opp ~ px(220),
    rec ~ px(220),
    ap  ~ px(220)
  )

gtsave(tbl2, filename = file.path(out_dir, "candidate_2.png"), vwidth = 760)
cat("wrote", file.path(out_dir, "candidate_2.png"), "\n")

# ============================================================================
# Candidate 3: faceted lollipop -- what's left for Notre Dame and Texas
# Data: packet item 2, remaining schedules by opponents' net EPA rank
# ============================================================================

remaining <- tibble::tribble(
  ~team,         ~opp,                 ~rank, ~flag,
  "Notre Dame",  "Navy",                72,   "",
  "Notre Dame",  "Miami",                3,   "AP #3",
  "Notre Dame",  "Boston College",      96,   "",
  "Notre Dame",  "SMU",                 25,   "AP #24",
  "Notre Dame",  "Syracuse",            81,   "",
  "Texas",       "Ole Miss",            59,   "",
  "Texas",       "Mississippi State",   68,   "",
  "Texas",       "at Missouri",         29,   "",
  "Texas",       "at LSU",               1,   "",
  "Texas",       "Arkansas",           125,   "",
  "Texas",       "at Texas A&M",        55,   ""
) |>
  mutate(
    facet = ifelse(team == "Notre Dame",
                   "Notre Dame (6-1)",
                   "Texas (4-2)"),
    top30 = rank <= 30,
    lab   = ifelse(flag == "", ordinal(rank), glue("{ordinal(rank)} \u00b7 {flag}"))
  ) |>
  group_by(team) |>
  arrange(desc(rank), .by_group = TRUE) |>
  mutate(y = factor(paste(team, opp), levels = paste(team, opp))) |>
  ungroup()

p3 <- ggplot(remaining, aes(y = y)) +
  geom_segment(aes(x = 138, xend = rank, yend = y), color = col_grid, linewidth = 1.6) +
  geom_point(aes(x = rank, color = top30), size = 4.2) +
  geom_text(aes(x = rank, label = lab, color = top30), nudge_y = 0.38,
            size = 3.0, fontface = "bold") +
  facet_wrap(~facet, scales = "free_y", ncol = 2) +
  scale_y_discrete(labels = function(x) sub("^(Notre Dame|Texas) ", "", x)) +
  scale_x_reverse(limits = c(138, -6), breaks = c(138, 100, 50, 1),
                  labels = c("138th", "100th", "50th", "1st")) +
  scale_color_manual(values = c(`FALSE` = col_blue, `TRUE` = col_red)) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Texas Has the Harder Road",
    subtitle = paste0(
      "Remaining opponents by net EPA rank (of 138 FBS teams). Longer bar = tougher opponent;\n",
      "red = top 30 in net EPA. FPI rates Texas's remaining schedule the 14th-hardest."
    ),
    x = "Opponent's net EPA rank", y = NULL,
    caption = paste0(
      "2025: Notre Dame went 10-2 and finished 11th in the final CFP rankings (in under the 2026 top-12 rule);\n",
      "Texas went 9-3 and finished 13th, first team out.\n",
      "TheMerrittocracy  \u00b7  EPA excludes garbage time; corrected 2026 play order. AP ranks entering Week 7.\n",
      "Data via cfbfastR / CFBD; schedule strength via FPI."
    )
  ) +
  theme_merrittocracy_light() +
  theme(
    axis.text.y        = element_text(size = 10, face = "bold", color = col_text),
    panel.grid.major.y = element_blank(),
    panel.spacing.x    = unit(2.2, "lines")
  )

save_plot(p3, "candidate_3.png")

# ============================================================================
# Candidate 4 (WILDCARD): the AP top 8, two chaos weeks side by side
# Data: packet item 1 (Week 7 results; Oct. 4, 2014 losers)
#   2014: losers #2 Oregon, #3 Alabama, #4 Oklahoma, #6 Texas A&M, #8 UCLA;
#   #1 Florida State won. Packet does not name #5 or #7, only that exactly
#   five lost, so they are shown unnamed as "did not lose".
# ============================================================================

grid <- tibble::tribble(
  ~week,          ~rank, ~team,          ~lost, ~note,
  "Week 7, 2026",  1,    "Georgia",      TRUE,  "lost to\nunranked\nAuburn",
  "Week 7, 2026",  2,    "Notre Dame",   TRUE,  "lost to\n#8 BYU",
  "Week 7, 2026",  3,    "Miami",        FALSE, "won",
  "Week 7, 2026",  4,    "Ohio State",   FALSE, "won",
  "Week 7, 2026",  5,    "Indiana",      TRUE,  "lost to\n#4\nOhio State",
  "Week 7, 2026",  6,    "Alabama",      TRUE,  "lost to\n#14\nTennessee",
  "Week 7, 2026",  7,    "Texas",        TRUE,  "lost to\nunranked\nFlorida",
  "Week 7, 2026",  8,    "BYU",          FALSE, "won",
  "Oct. 4, 2014",  1,    "Florida State", FALSE, "won",
  "Oct. 4, 2014",  2,    "Oregon",       TRUE,  "lost to\nlower-ranked\nteam",
  "Oct. 4, 2014",  3,    "Alabama",      TRUE,  "lost to\nlower-ranked\nteam",
  "Oct. 4, 2014",  4,    "Oklahoma",     TRUE,  "lost to\nlower-ranked\nteam",
  "Oct. 4, 2014",  5,    "",             FALSE, "did not lose",
  "Oct. 4, 2014",  6,    "Texas A&M",    TRUE,  "lost to\nlower-ranked\nteam",
  "Oct. 4, 2014",  7,    "",             FALSE, "did not lose",
  "Oct. 4, 2014",  8,    "UCLA",         TRUE,  "lost to\nlower-ranked\nteam"
) |>
  mutate(
    yrow  = ifelse(week == "Week 7, 2026", 2, 1),
    fill  = ifelse(lost, col_red, "#F2F2F2"),
    txt   = ifelse(lost, "#FFFFFF", col_text),
    name  = ifelse(team == "", glue("#{rank}"), glue("#{rank}\n{team}"))
  )

# Top-8-vs-top-8 games in 2026: #2 Notre Dame lost to #8 BYU; #5 Indiana
# lost to #4 Ohio State. Drawn as arcs above the 2026 row.
arcs <- tibble::tribble(
  ~x,  ~xend,
  2,   8,
  4,   5
)

p4 <- ggplot(grid) +
  geom_tile(aes(x = rank, y = yrow, fill = fill), width = 0.94, height = 0.9,
            color = col_bg, linewidth = 1) +
  geom_text(aes(x = rank, y = yrow + 0.22, label = name, color = txt),
            size = 3.0, fontface = "bold", lineheight = 0.9) +
  geom_text(aes(x = rank, y = yrow - 0.2, label = note, color = txt),
            size = 2.5, lineheight = 0.9) +
  geom_curve(data = arcs, aes(x = x, xend = xend, y = 2.47, yend = 2.47),
             curvature = -0.35, color = col_gold, linewidth = 0.9) +
  annotate("text", x = 5, y = 2.95, label = "Top 8 vs. top 8:\ntwo guaranteed losses", lineheight = 0.95,
           color = col_gold, size = 3.1, fontface = "bold") +
  annotate("text", x = 0.42, y = 2, label = "Week 7, 2026", hjust = 1,
           color = col_text, size = 3.6, fontface = "bold") +
  annotate("text", x = 0.42, y = 1, label = "Oct. 4, 2014", hjust = 1,
           color = col_text, size = 3.6, fontface = "bold") +
  scale_fill_identity() +
  scale_color_identity() +
  scale_x_continuous(limits = c(-0.9, 8.6), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0.5, 3.4), expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  labs(
    title = "The Only Two Five-Loss Weeks in the AP Top 8",
    subtitle = paste0(
      "AP top eight entering the week; red = lost. This week took out #1 and #2.\n",
      "2014 was wilder: all five losses came against lower-ranked teams."
    ),
    caption = paste0(
      "Every AP poll week since 1936 with a full top eight in CFBD's records (1,173 weeks).\n",
      "2014's #5 and #7 are not named in the source data, only that they did not lose.\n",
      "TheMerrittocracy  \u00b7  Data via cfbfastR / College Football Data API."
    )
  ) +
  theme_void(base_size = 12) +
  theme(
    plot.background = element_rect(fill = col_bg, color = NA),
    plot.title      = element_text(color = col_text, face = "bold", size = 15,
                                   margin = margin(b = 4)),
    plot.subtitle   = element_text(color = col_subtext, size = 9.5,
                                   margin = margin(b = 6)),
    plot.caption    = element_text(color = col_subtext, size = 8, hjust = 0,
                                   margin = margin(t = 10)),
    plot.margin     = margin(14, 20, 10, 14)
  )

save_plot(p4, "candidate_4.png", height = 600)
