# ============================================================================
# week8_cfb_wrapup_normal_vs_not.R
#
# Hero graphic for draft/week8_cfb_wrapup.md ("Inconceivable!").
# Section: "Uneasy Lies The Head"
#
# Two panels, one bar per season (1989-2026, the AP top-25 era), counting
# games through Week 8 where an unranked team beat an AP-ranked team:
#   Left:  all unranked wins over ranked teams  -- 2026 looks ordinary
#   Right: unranked wins over AP top-10 teams   -- 2026 does not
#
# Expected (Steve's Week 8 data packet):
#   2026: 17 total (median 18, record 33 in 2007)
#   2026: 8 over the top 10 (median 4, record 13 in 2007)
# The script stops before plotting if the pull doesn't reproduce these.
#
# Ranks are from the AP poll entering each week. CFBD numbers the preseason
# poll week 1, so a Week w game uses the latest AP poll with week <= w
# (Week 0 games use the preseason poll).
#
# Exception: in 1990 and 1998, CFBD's poll weeks run one ahead of its game
# weeks -- the poll labeled week w already reflects week w's results (1990:
# Notre Dame is #8 in the week 7 poll after losing to Stanford in game week 7;
# Michigan is #10 in the week 8 poll after losing to Michigan State in game
# week 8). Those two seasons use poll week w-1. Found by checking, for every
# season, whether ranked losers drop into poll w or poll w+1; every other
# season through Week 8 lines up. Uncorrected, 1990 shows 4 unranked wins
# (actual 17) and 1998 shows 2 (actual 15).
#
# Data: cfbfastR / College Football Data API. Needs CFBD_API_KEY in the
# environment for the first run, e.g.
#   op run --env-file=<your .env> -- Rscript scripts/week8_cfb_wrapup_normal_vs_not.R
# The pull is cached to data/week8_unranked_wins_by_season.csv; later runs
# read the cache and need no key.
#
# House theme: theme_merrittocracy_light(), copied from
# scripts/week5_cfb_wrapup_florida_defense_trend.R.
#
# Output: graphics/week8_cfb_wrapup/normal_vs_not.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(purrr)

out_path   <- "graphics/week8_cfb_wrapup/normal_vs_not.png"
cache_path <- "data/week8_unranked_wins_by_season.csv"
seasons    <- 1989:2026
max_week   <- 8
off_by_one <- c(1990, 1998)   # seasons whose poll weeks run one ahead

# --- Data --------------------------------------------------------------------

pull_season <- function(yr) {
  polls <- cfbfastR::cfbd_rankings(year = yr, season_type = "regular") |>
    filter(poll == "AP Top 25") |>
    select(poll_week = week, school, rank)

  games <- cfbfastR::cfbd_game_info(year = yr, season_type = "regular") |>
    filter(week <= max_week, !is.na(home_points), !is.na(away_points),
           home_points != away_points) |>
    mutate(
      winner = if_else(home_points > away_points, home_team, away_team),
      loser  = if_else(home_points > away_points, away_team, home_team),
      # latest AP poll released on or before this game's week
      poll_week = map_int(pmax(week - (yr %in% off_by_one), 1L), \(w) {
        wk <- polls$poll_week[polls$poll_week <= w]
        if (length(wk) == 0) NA_integer_ else as.integer(max(wk))
      })
    ) |>
    select(week, poll_week, winner, loser)

  games |>
    left_join(rename(polls, winner = school, winner_rank = rank),
              by = c("poll_week", "winner")) |>
    left_join(rename(polls, loser = school, loser_rank = rank),
              by = c("poll_week", "loser")) |>
    filter(is.na(winner_rank), !is.na(loser_rank)) |>
    summarise(
      total = n(),
      top10 = sum(loser_rank <= 10)
    ) |>
    mutate(season = yr)
}

if (file.exists(cache_path)) {
  by_season <- read.csv(cache_path)
} else {
  if (Sys.getenv("CFBD_API_KEY") == "") {
    stop("CFBD_API_KEY is not set and no cache exists at ", cache_path)
  }
  by_season <- map(seasons, pull_season) |> list_rbind()
  write.csv(by_season, cache_path, row.names = FALSE)
}

# --- Check against the data packet before plotting ---------------------------

hist_med <- by_season |>
  filter(season < 2026) |>
  summarise(total = median(total), top10 = median(top10))
yr26   <- filter(by_season, season == 2026)
yr2007 <- filter(by_season, season == 2007)

checks <- c(
  "2026 total = 17"   = yr26$total == 17,
  "2026 top10 = 8"    = yr26$top10 == 8,
  "median total = 18" = hist_med$total == 18,
  "median top10 = 4"  = hist_med$top10 == 4,
  "2007 total = 33"   = yr2007$total == 33,
  "2007 top10 = 13"   = yr2007$top10 == 13
)
print(by_season |> filter(season %in% c(2007, 2026)))
print(hist_med)
if (!all(checks)) {
  stop("Pull doesn't match the data packet: ",
       paste(names(checks)[!checks], collapse = ", "))
}

plot_df <- by_season |>
  pivot_longer(c(total, top10), names_to = "measure", values_to = "wins") |>
  mutate(
    # the median goes in the panel title, so no text sits on the bars or lines
    measure = factor(measure, levels = c("total", "top10"),
                     labels = c(paste0("Unranked wins over ranked teams\n",
                                       "(1989-2025 median: ", hist_med$total, ")"),
                                paste0("Unranked wins over top-10 teams\n",
                                       "(1989-2025 median: ", hist_med$top10, ")"))),
    highlight = case_when(season == 2026 ~ "2026",
                          season == 2007 ~ "2007",
                          TRUE ~ "other")
  )

med_df <- tibble::tibble(
  measure = factor(levels(plot_df$measure), levels = levels(plot_df$measure)),
  med     = c(hist_med$total, hist_med$top10)
)

lab_df <- plot_df |>
  filter(highlight != "other") |>
  mutate(label = paste0(season, ": ", wins),
         # 2007 sits above its bar; 2026 sits right of its bar, past the end
         # of the median line, so it can't touch the line
         x     = if_else(season == 2026, season + 0.7, season),
         hjust = if_else(season == 2026, 0, 0.5),
         vjust = if_else(season == 2026, 1, -0.5))

# --- Palette (house light theme, matches week5_cfb_wrapup_florida_defense_trend.R) --

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"   # steel blue -- 2007, the comparison season
col_flag    <- "#C0392B"   # red -- 2026
col_ref     <- "#B8860B"   # dark goldenrod -- median line
col_other   <- "#C9D3DC"   # muted bars for every other season

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
      plot.margin        = margin(14, 20, 10, 14)
    )
}

# --- Plot ---------------------------------------------------------------------

p <- ggplot(plot_df, aes(x = season, y = wins, fill = highlight)) +
  geom_col(width = 0.8) +
  geom_segment(data = med_df,
               aes(x = 1988.5, xend = 2026.5, y = med, yend = med),
               inherit.aes = FALSE,
               color = col_ref, linewidth = 0.5, linetype = "dashed") +
  geom_text(data = lab_df,
            aes(x = x, label = label, color = highlight,
                hjust = hjust, vjust = vjust),
            size = 3.1, fontface = "bold") +
  facet_wrap(~measure, ncol = 2, scales = "free_y") +
  coord_cartesian(clip = "off") +
  scale_fill_manual(values = c(`2026` = col_flag, `2007` = col_point,
                               other = col_other)) +
  scale_color_manual(values = c(`2026` = col_flag, `2007` = col_point)) +
  scale_x_continuous(breaks = c(1990, 2000, 2010, 2020, 2026),
                     expand = expansion(add = c(0.8, 7.5))) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Normal vs. Not",
    subtitle = paste0(
      "Unranked teams beating AP-ranked teams through Week 8, by season. ",
      "2026 is ordinary overall,\nbut double the usual rate against the top 10. ",
      "Dashed line = 1989-2025 median."
    ),
    x = NULL, y = "Wins through Week 8",
    caption = paste0(
      "TheMerrittocracy \u00b7 Data: cfbfastR / College Football Data API. ",
      "AP ranks from the poll entering each week. 1989-2026 (AP top-25 era)."
    )
  ) +
  theme_merrittocracy_light() +
  theme(strip.text = element_text(color = col_text, face = "bold", size = 10.5),
        panel.spacing.x = unit(1.5, "lines"))

dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
ggsave(out_path, p, width = 8, height = 5.333, dpi = 150, bg = col_bg)
message("Saved ", out_path)
