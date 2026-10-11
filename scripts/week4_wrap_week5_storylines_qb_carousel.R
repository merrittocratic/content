# week4_wrap_week5_storylines_qb_carousel.R
# Candidate 3 (chart, narrative-anchored): Atlanta's Week 1-4 quarterback
# carousel -- actual PPR points for every week each QB actually played,
# naming Cooper Rush, Jack Strand and Michael Penix Jr. Companion graphic
# for "That's Offensive!" (nfl-season, 2026-10-11).
#
# Data: boxscore-prophet/output/10d_receipts_2026_w0{1..4}.csv, filtered to
#   posteam == "ATL" and position == "QB". Weeks where dnp == TRUE are
#   dropped (the QB did not play that week, so fp_actual of 0 is not a
#   real performance).
#
# Packages: ggplot2, dplyr, ggrepel, scales
# Output: graphics/week4_wrap_week5_storylines/candidate_3.png

library(ggplot2)
library(dplyr)
library(ggrepel)
library(scales)
library(readr)

repo_out <- "/Users/stephenmerritt/boxscore-prophet/output"
weeks <- c("w01", "w02", "w03", "w04")

read_week <- function(w) {
  readr::read_csv(file.path(repo_out, paste0("10d_receipts_2026_", w, ".csv")),
                   show_col_types = FALSE) |>
    mutate(week_num = as.integer(sub("w0", "", w)))
}

raw <- bind_rows(lapply(weeks, read_week))

qbs <- c("Cooper Rush", "Jack Strand", "Michael Penix Jr.")

dat <- raw |>
  filter(posteam == "ATL", position == "QB", player_name %in% qbs, !dnp) |>
  select(player_name, week_num, fp_actual)

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_rush    <- "#3A7CA5"   # steel blue
col_strand  <- "#B8860B"   # dark goldenrod
col_penix   <- "#C0392B"   # red

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
      legend.position    = "none",
      plot.margin        = margin(14, 24, 10, 14)
    )
}

set.seed(42)

p <- ggplot(dat, aes(x = week_num, y = fp_actual, color = player_name)) +
  annotate("rect", xmin = 2.5, xmax = 4.5, ymin = -3, ymax = 20,
           fill = col_grid, alpha = 0.6) +
  annotate("text", x = 3.5, y = 19.2, label = "Penix takes over",
           color = col_subtext, size = 3.2, fontface = "italic") +
  geom_hline(yintercept = 0, color = col_grid, linewidth = 0.5) +
  geom_line(aes(group = player_name), linewidth = 0.9, alpha = 0.85) +
  geom_point(size = 3.2) +
  geom_text_repel(
    aes(label = paste0(player_name, ": ", round(fp_actual, 1))),
    seed = 42, size = 3.2, fontface = "bold", show.legend = FALSE,
    box.padding = 0.7, point.padding = 0.3,
    segment.color = col_subtext, segment.size = 0.3,
    min.segment.length = 0
  ) +
  scale_color_manual(values = c(
    "Cooper Rush" = col_rush,
    "Jack Strand" = col_strand,
    "Michael Penix Jr." = col_penix
  )) +
  scale_x_continuous(breaks = 1:4, limits = c(0.7, 4.5),
                      labels = paste0("Week ", 1:4)) +
  scale_y_continuous(limits = c(-3, 20)) +
  labs(
    title = "Atlanta's Quarterback Carousel",
    subtitle = paste0(
      "Actual PPR points, Weeks 1-4 -- only weeks each QB actually played are shown"
    ),
    x = NULL,
    y = "Actual PPR points",
    caption = paste0(
      "Boxscore Prophet - 10d_receipts_2026_w01-w04.csv, position == QB, posteam == ATL, dnp == FALSE\n",
      "Rush started Weeks 1-2, Strand played Week 2, Penix took over from Week 3 on."
    )
  ) +
  theme_merrittocracy_light()

ggsave(
  filename = "graphics/week4_wrap_week5_storylines/candidate_3.png",
  plot = p, width = 8, height = 5.33, dpi = 150, bg = "white"
)
