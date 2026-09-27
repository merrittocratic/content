# ============================================================================
# content/scripts/somethings_gotta_give_wildcard.R
#
# Wildcard (candidate 4) for draft/somethings_gotta_give.md.
# Slope panels (one per team) tracking each named player's model start %
# W1 -> W3, with cleared/missed/DNP dots, over a tile strip of start lines
# cleared in Weeks 1-2.
#
# Rebuild of Rembrandt's original candidate_4 (its build script wasn't
# saved). Change from that version: Nico Collins (hamstring) is reported as
# not expected to play Week 3 vs. IND, and the W3 board was built before
# injury reports (report_status = NA). His W3 point is replaced by a gray
# "X" held at his last value with a dashed connector, labeled "not expected
# to play" rather than showing the stale 56%. Swap the label to OUT once the
# Friday injury report makes it official.
#
# Data (boxscore-prophet, read directly):
#   output/10d_receipts_2026_w01.csv, output/10d_receipts_2026_w02.csv
#   output/10d_start_board_2026_w03.csv
#
# Output: graphics/somethings_gotta_give/candidate_4.png
# ============================================================================

library(ggplot2)
library(dplyr)
library(patchwork)

bp <- file.path("..", "boxscore-prophet", "output")

players <- tibble::tribble(
  ~player_name,      ~team,
  "Chris Olave",     "SAINTS",
  "Tyler Shough",    "SAINTS",
  "Ashton Jeanty",   "RAIDERS",
  "Kirk Cousins",    "RAIDERS",
  "Nico Collins",    "TEXANS",
  "Dalton Schultz",  "TEXANS",
  "C.J. Stroud",     "TEXANS",
  "Justin Herbert",  "CHARGERS",
  "Tre Harris",      "CHARGERS",
  "Ladd McConkey",   "CHARGERS"
)
team_levels <- c("SAINTS", "RAIDERS", "TEXANS", "CHARGERS")

# W3 status overrides (not in the model's board) -----------------------------
not_expected <- c("Nico Collins")

# colors -----------------------------------------------------------------
hit_color  <- "#1E8060"
miss_color <- "#C0392B"
dnp_color  <- "#8C8C8C"
line_color <- "#9AA5B1"
mid_color  <- "#B8860B"

read_receipts <- function(wk) {
  read.csv(file.path(bp, sprintf("10d_receipts_2026_w%02d.csv", wk))) |>
    filter(player_name %in% players$player_name) |>
    transmute(
      player_name, week = wk, start_pct,
      status = case_when(
        dnp ~ "dnp",
        hit_start ~ "hit",
        TRUE ~ "miss"
      )
    )
}

w3 <- read.csv(file.path(bp, "10d_start_board_2026_w03.csv")) |>
  filter(player_name %in% players$player_name) |>
  transmute(player_name, week = 3, start_pct, status = "pending")

pts <- bind_rows(read_receipts(1), read_receipts(2), w3) |>
  left_join(players, by = "player_name") |>
  mutate(team = factor(team, levels = team_levels))

stopifnot(nrow(pts) == 3 * nrow(players))

# For "not expected to play" players, hold the W3 marker at the W2 value so
# the stale model number isn't plotted.
w2_vals <- pts |> filter(week == 2) |> select(player_name, w2_pct = start_pct)
pts <- pts |>
  left_join(w2_vals, by = "player_name") |>
  mutate(
    status = ifelse(week == 3 & player_name %in% not_expected, "out", status),
    start_pct = ifelse(status == "out", w2_pct, start_pct)
  ) |>
  select(-w2_pct)

solid <- pts |> filter(!(player_name %in% not_expected & week == 3))
dashed <- pts |> filter(player_name %in% not_expected, week >= 2)

# W3 labels, with manual nudges where two players share a point ------------
lab <- pts |>
  filter(week == 3) |>
  mutate(
    label = ifelse(status == "out",
                   paste0(player_name, "\nnot expected to\nplay (hamstring)"),
                   player_name),
    y = start_pct + case_when(
      player_name == "Tre Harris" ~ 1.2,
      player_name == "Ladd McConkey" ~ -2.0,
      TRUE ~ 0
    )
  )

p_slope <- ggplot() +
  geom_line(data = solid, aes(week, start_pct, group = player_name),
            color = line_color, linewidth = 1.1) +
  geom_line(data = dashed, aes(week, start_pct, group = player_name),
            color = dnp_color, linewidth = 1.1, linetype = "22") +
  geom_point(data = filter(pts, status %in% c("hit", "miss", "dnp")),
             aes(week, start_pct, color = status), size = 5) +
  geom_point(data = filter(pts, status == "pending"),
             aes(week, start_pct), shape = 21, fill = "white",
             color = "grey10", size = 4.6, stroke = 1.6) +
  geom_point(data = filter(pts, status == "out"),
             aes(week, start_pct), shape = 4, color = dnp_color,
             size = 4.6, stroke = 2) +
  geom_text(data = lab, aes(3.25, y, label = label),
            hjust = 0, size = 3.9, lineheight = 0.95) +
  facet_wrap(~team, nrow = 1) +
  scale_color_manual(values = c(hit = hit_color, miss = miss_color,
                                dnp = dnp_color), guide = "none") +
  scale_x_continuous(breaks = 1:3, labels = c("W1", "W2", "W3"),
                     limits = c(0.8, 5.3), expand = c(0, 0)) +
  scale_y_continuous(labels = function(x) paste0(x, "%"),
                     breaks = c(20, 40, 60), limits = c(5, 65)) +
  labs(x = NULL, y = "Model start %") +
  theme_minimal(base_size = 13) +
  theme(
    panel.grid.minor = element_blank(),
    panel.spacing.x = unit(1.4, "lines"),
    strip.text = element_text(face = "bold", size = 11),
    axis.text.x = element_text(size = 11)
  )

# tile strip -----------------------------------------------------------------
tiles <- pts |>
  filter(week %in% 1:2, status != "dnp") |>
  group_by(team) |>
  summarise(cleared = sum(status == "hit"), n = n(), .groups = "drop") |>
  mutate(
    rate = cleared / n,
    fill = case_when(rate == 1 ~ hit_color, rate < 0.25 ~ miss_color,
                     TRUE ~ mid_color),
    label = paste(cleared, "of", n)
  )

p_tiles <- ggplot(tiles, aes(team, 1)) +
  geom_tile(aes(fill = fill), width = 0.98, height = 1) +
  geom_text(aes(label = label), color = "white", fontface = "bold", size = 9) +
  scale_fill_identity() +
  scale_x_discrete(limits = team_levels) +
  labs(x = NULL, y = NULL,
       subtitle = "Start lines cleared, Weeks 1-2, for the players charted above (DNPs excluded)") +
  theme_void(base_size = 13) +
  theme(
    axis.text.x = element_text(face = "bold", size = 13, margin = margin(t = 6)),
    plot.subtitle = element_text(size = 13, margin = margin(b = 8)),
    plot.margin = margin(10, 40, 0, 40)
  )

combined <- p_slope / p_tiles +
  plot_layout(heights = c(3, 1)) +
  plot_annotation(
    title = "Four narratives, one model line each",
    subtitle = "Model start probability by week. Green = cleared the start line, red = missed, gray = DNP, open = Week 3 pending, X = not expected to play",
    caption = "Source: boxscore-prophet 10d_receipts_2026_w01/w02, 10d_start_board_2026_w03. Ten players named in the draft; not a full-slate hit rate.",
    theme = theme(
      plot.title = element_text(size = 18, face = "bold"),
      plot.subtitle = element_text(size = 12.5, margin = margin(b = 10)),
      plot.caption = element_text(size = 10)
    )
  )

out_dir <- file.path("graphics", "somethings_gotta_give")
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

ggsave(file.path(out_dir, "candidate_4.png"), combined,
       width = 16, height = 9.87, dpi = 150, bg = "white")
