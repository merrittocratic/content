# ============================================================================
# heisman_base_rate_counterweight.R
#
# "The Counterweight" -- how often a Power 4 player at a given starting
# percentile reaches a top-3 national finish at his position the NEXT season.
# The monotonic climb is the piece's thesis reversal: being already elite is
# the single best predictor of being elite again.
#
# Companion graphic for "The Discovery Channel" (cfb-season, 2026-08-23).
# Pairs with the closing "Special Bulletin" section. Built to stand alone.
#
# Data: ../nfl-draft-model/output/heisman_handoff/base_rates_by_starting_position.csv
#   n = 1,785 consecutive qualifying P4 player-seasons, 2010-2025.
#
# IMPORTANT -- two different rates live in this handoff and they disagree:
#   * base_rates_by_starting_position.csv pools ALL positions. The 95-100
#     band is 21.4% on n = 84.
#   * candidates_2026_targets.csv$p_top3_next_season_pct is POSITION-SPECIFIC.
#     Jeremiah Smith's own row reads 8.1% on n = 37 (WR only).
#   Smith's marker below sits on the BAND, and the caption states both numbers.
#   Do not relabel the marker with his individual rate -- it is not what the
#   bar measures. Related: Smith does NOT have the best odds in the field.
#   Mateer's healthy-2024 row is 25.0%; Manning and Sayin are 10.3%.
#
# This is P(elite stat season), NOT P(wins Heisman) -- roughly 15-30 players
# a year reach the zone and exactly one wins.
#
# Packages: ggplot2, dplyr, readr
#
# Output: content/graphics/heisman_base_rate_counterweight.png (1200x800px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(readr)

# --- 1. Paths ----------------------------------------------------------------
in_path  <- "../nfl-draft-model/output/heisman_handoff/base_rates_by_starting_position.csv"
out_path <- "graphics/heisman_base_rate_counterweight.png"

SMITH_BAND <- "95-100"
SMITH_PCTL <- 99.4
SMITH_OWN_RATE <- 8.1
SMITH_OWN_N    <- 37

# --- 2. Palette (house dark theme) -------------------------------------------
col_bar      <- "#4A9EBF"   # steel blue   -- the base-rate bars
col_hi       <- "#FFD166"   # gold         -- the band Smith starts in
col_bg       <- "#111118"
col_panel    <- "#1A1A26"
col_grid     <- "#2A2A3E"
col_text     <- "#E0E0EE"
col_subtext  <- "#9090AA"

theme_merrittocracy_dark <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major.y = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.title         = element_text(color = col_text, size = 10),
      plot.title         = element_text(color = col_text,    face = "bold",
                                        size = 15, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 10,
                                        margin = margin(b = 10)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 8)),
      legend.position    = "none",
      plot.margin        = margin(14, 18, 10, 14),
      strip.text         = element_text(color = col_text, face = "bold",
                                        size = 11)
    )
}

# --- 3. Data -----------------------------------------------------------------
raw <- read_csv(in_path, show_col_types = FALSE)

dat <- raw |>
  mutate(
    # sample size rides on the axis label -- inside the bar it clips on the
    # 1.1% band, which is too short to hold text
    band_label = sprintf("%s\n(n = %s)", starting_percentile_band,
                         format(n_player_seasons, big.mark = ",", trim = TRUE)),
    band       = factor(band_label, levels = band_label),
    is_top     = starting_percentile_band == SMITH_BAND,
    bar_color  = if_else(is_top, col_hi, col_bar),
    val_label  = sprintf("%.1f%%", probability_pct)
  )

# the climb must be monotonic for the argument to hold -- assert it
stopifnot(
  nrow(dat) == 7,
  !is.unsorted(dat$probability_pct)
)

y_top <- max(dat$probability_pct)

# --- 4. Plot -----------------------------------------------------------------
p <- ggplot(dat, aes(x = band, y = probability_pct)) +
  geom_col(aes(fill = bar_color), width = 0.68) +
  # value on top of each bar
  geom_text(
    aes(label = val_label, color = bar_color),
    vjust    = -0.7,
    size     = 3.9,
    fontface = "bold"
  ) +
  # Smith annotation, pinned to the top band. The arrow lands on the bar's
  # top-left corner, not its center, so it clears the "21.4%" value label.
  annotate(
    "segment",
    x = 6.10, xend = 6.68, y = y_top * 1.27, yend = y_top * 1.02,
    color     = col_hi,
    linewidth = 0.5,
    arrow     = arrow(length = unit(0.16, "cm"), type = "closed")
  ) +
  annotate(
    "text",
    x     = 6.05,
    y     = y_top * 1.33,
    label = paste0(
      "Jeremiah Smith starts here\n",
      "(", SMITH_PCTL, "th percentile) -- the best\n",
      "starting point in the field, and\n",
      "still barely one year in five."
    ),
    hjust    = 1,
    vjust    = 0.5,
    color    = col_hi,
    size     = 3.5,
    lineheight = 1.15,
    fontface = "bold"
  ) +
  scale_fill_identity() +
  scale_color_identity() +
  scale_y_continuous(
    labels = function(x) paste0(x, "%"),
    expand = expansion(mult = c(0, 0.22))
  ) +
  labs(
    title    = "Being Famous Already Is the Best Predictor There Is",
    subtitle = paste(
      "Share of Power 4 players who reach a top-3 national finish at their",
      "position the following season,\nby where they started."
    ),
    x = "Starting percentile at position, prior season",
    y = "Reached top 3 the next season",
    caption = paste0(
      "n = 1,785 consecutive qualifying P4 player-seasons, 2010-2025. ",
      "This is P(elite stat season), not P(wins Heisman) --\n",
      "roughly 15-30 players a year reach the zone and one wins. ",
      "Band rates pool all positions; the 95-100 band is n = 84.\n",
      "Smith's position-specific rate in the candidate file is lower still, ",
      SMITH_OWN_RATE, "% on n = ", SMITH_OWN_N, " wide receivers. ",
      "Source: cfbfastR / College Football Data API."
    )
  ) +
  theme_merrittocracy_dark() +
  theme(panel.grid.major.y = element_line(color = col_grid, linewidth = 0.4))

# --- 5. Save -----------------------------------------------------------------
ggsave(
  filename = out_path,
  plot     = p,
  width    = 1200 / 150,
  height   =  800 / 150,
  dpi      = 150,
  bg       = col_bg
)

cat("wrote", out_path, "\n")
