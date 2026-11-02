# ============================================================================
# week7_wrap_week8_storylines_mirror_images.R
#
# Hero graphic for draft/week7_wrap_week8_storylines.md
# ("You Know Nothing, Jon Snow"). Sections: "Luck Be A Lady Tonight" and
# "Let's Get Ready To Rumble!"
#
# All 32 teams by offensive rank (EPA per play) and defensive rank (EPA per
# play allowed), 2026 regular season through Week 7. Minnesota and Detroit,
# the Week 8 matchup, sit in opposite corners; the other North teams are
# labeled; everyone else is gray.
#
# Expected (matches the article's text):
#   MIN: 30th offense, 1st defense
#   DET: 3rd offense, 31st defense
# The script stops before plotting if the pull doesn't reproduce these.
#
# EPA per play uses pass and rush plays with non-missing EPA. Net EPA from
# the same pull reproduces every net EPA rank in the article (CIN 3rd, CHI
# 8th, BAL 10th, GB 12th, PIT 16th, CLE 18th, DET 21st).
#
# Data: nflreadr. The pull is cached to data/week7_nfl_off_def_ranks.csv;
# later runs read the cache.
#
# House theme: theme_merrittocracy_light(), copied from
# scripts/week8_cfb_wrapup_normal_vs_not.R.
#
# Output: graphics/week7_wrap_week8_storylines/mirror_images.png
# (1200x1050 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(ggrepel)

out_path   <- "graphics/week7_wrap_week8_storylines/mirror_images.png"
cache_path <- "data/week7_nfl_off_def_ranks.csv"
max_week   <- 7
norths     <- c("MIN", "DET", "CHI", "GB", "CIN", "CLE", "PIT", "BAL")

# --- Data --------------------------------------------------------------------

if (file.exists(cache_path)) {
  ranks <- read.csv(cache_path)
} else {
  plays <- nflreadr::load_pbp(2026) |>
    filter(season_type == "REG", week <= max_week, !is.na(epa),
           pass == 1 | rush == 1)
  off <- plays |> group_by(team = posteam) |> summarise(off_epa = mean(epa))
  def <- plays |> group_by(team = defteam) |> summarise(def_epa = mean(epa))
  ranks <- off |>
    inner_join(def, by = "team") |>
    mutate(off_rank = rank(-off_epa), def_rank = rank(def_epa))
  dir.create(dirname(cache_path), showWarnings = FALSE, recursive = TRUE)
  write.csv(ranks, cache_path, row.names = FALSE)
}

# --- Check against the article before plotting -------------------------------

get_rank <- function(tm, col) ranks[[col]][ranks$team == tm]
checks <- c(
  "MIN offense 30th" = get_rank("MIN", "off_rank") == 30,
  "MIN defense 1st"  = get_rank("MIN", "def_rank") == 1,
  "DET offense 3rd"  = get_rank("DET", "off_rank") == 3,
  "DET defense 31st" = get_rank("DET", "def_rank") == 31
)
print(ranks |> filter(team %in% norths) |> arrange(off_rank))
if (!all(checks)) {
  stop("Pull doesn't match the article: ",
       paste(names(checks)[!checks], collapse = ", "))
}

team_names <- c(MIN = "Vikings", DET = "Lions", CHI = "Bears",
                GB = "Packers", CIN = "Bengals", CLE = "Browns",
                PIT = "Steelers", BAL = "Ravens")

plot_df <- ranks |>
  mutate(
    group = case_when(team == "MIN" ~ "MIN",
                      team == "DET" ~ "DET",
                      team %in% norths ~ "north",
                      TRUE ~ "other"),
    label = if_else(team %in% norths,
                    paste0(team_names[team], " (", off_rank, ", ", def_rank, ")"),
                    "")   # blank labels still repel the named ones
  )

# --- Palette (house light theme) ----------------------------------------------

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"   # steel blue -- Detroit
col_flag    <- "#C0392B"   # red -- Minnesota
col_north   <- "#444444"   # the other North teams
col_other   <- "#C9D3DC"   # muted points for the rest of the league
col_ref     <- "#B8860B"   # dark goldenrod -- league midpoint lines

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

group_cols <- c(MIN = col_flag, DET = col_point, north = col_north,
                other = col_other)

# corner labels sit outside the 1-32 range, clear of the points
corner_df <- tibble::tibble(
  x     = c(32.6, 0.4, 32.6, 0.4),
  y     = c(-0.8, -0.8, 33.8, 33.8),
  hjust = c(0, 1, 0, 1),
  label = c("Bad offense, good defense", "Good offense, good defense",
            "Bad offense, bad defense", "Good offense, bad defense")
)

# --- Plot ---------------------------------------------------------------------

# Both axes reversed so 1st is top and right: better is up and to the right.
p <- ggplot(plot_df, aes(x = off_rank, y = def_rank)) +
  geom_vline(xintercept = 16.5, color = col_ref, linewidth = 0.4,
             linetype = "dashed") +
  geom_hline(yintercept = 16.5, color = col_ref, linewidth = 0.4,
             linetype = "dashed") +
  geom_text(data = corner_df,
            aes(x = x, y = y, label = label, hjust = hjust),
            color = col_subtext, size = 3, fontface = "italic") +
  geom_point(data = filter(plot_df, group == "other"),
             color = col_other, size = 2.6) +
  geom_point(data = filter(plot_df, group != "other"),
             aes(color = group), size = 3.6) +
  geom_text_repel(data = plot_df,
                  aes(label = label, color = group),
                  size = 3.3, fontface = "bold", seed = 42,
                  box.padding = 0.6, point.padding = 0.4,
                  min.segment.length = 0.3, segment.color = col_subtext,
                  segment.size = 0.3, max.overlaps = Inf,
                  # Minnesota's corner is crowded; push its label down and
                  # right, away from the corner label (nudges apply on the
                  # reversed scales, so positive is right and up)
                  nudge_x = if_else(plot_df$team == "MIN", 3, 0),
                  nudge_y = if_else(plot_df$team == "MIN", -2.5, 0)) +
  scale_color_manual(values = group_cols) +
  scale_x_reverse(breaks = c(1, 8, 16, 24, 32), limits = c(34.5, -1.5),
                  expand = expansion(add = 0)) +
  scale_y_reverse(breaks = c(1, 8, 16, 24, 32), limits = c(34.5, -1.5),
                  expand = expansion(add = 0)) +
  coord_cartesian(clip = "off") +
  labs(
    title = "Mirror Images",
    subtitle = paste0(
      "NFL offense and defense ranks in EPA per play, through Week 7. ",
      "Minnesota (1st on defense, 30th on offense)\n",
      "visits Detroit (3rd on offense, 31st on defense) in Week 8. ",
      "North teams labeled (offense rank, defense rank)."
    ),
    x = "Offense rank, EPA per play (1st = best)",
    y = "Defense rank, EPA per play allowed (1st = best)",
    caption = paste0(
      "TheMerrittocracy · Data: nflverse / nflreadr. ",
      "Pass and rush plays, 2026 regular season Weeks 1-7. ",
      "Dashed lines = league midpoint."
    )
  ) +
  theme_merrittocracy_light() +
  # no gridlines: the corner labels and the midpoint lines carry the layout
  theme(panel.grid.major = element_blank(),
        axis.ticks = element_line(color = col_grid))

dir.create(dirname(out_path), showWarnings = FALSE, recursive = TRUE)
ggsave(out_path, p, width = 8, height = 7, dpi = 150, bg = col_bg)
message("Saved ", out_path)
