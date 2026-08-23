# ============================================================================
# heisman_winners_discovery_curve.R
#
# "The Discovery Curve" -- where all 15 Heisman winners (2011-2025) ranked
# at their position the year BEFORE they won, and where they ranked when
# they won it.
#
# Companion graphic for "The Discovery Channel" (cfb-season, 2026-08-23).
# Deliberately reuses the visual grammar of heisman_leap_slope.R: left dot
# is the starting rank, right dot is the destination, y is national rank
# within position. Chart 1 is what this year's field must climb; this is
# what the winners actually climbed. Same units, same reading.
#
# Data: ../nfl-draft-model/output/heisman_handoff/winners_leap_table.csv
#
# Four winners (Manziel, Winston, Murray, Young) have prior_natl_rank = NA --
# they were backups or redshirts with no qualifying P4 season. NA is NOT
# zero and must not be plotted as a rank; they are called out separately
# in a footer block.
#
# Pool sizes vary by position and year (65-73 QB, 93-173 WR/RB), so each
# label carries its own "rank of pool" rather than implying one shared
# denominator.
#
# Packages: ggplot2, dplyr, readr, ggrepel
#
# Output: content/graphics/heisman_winners_discovery_curve.png (1200x800px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(readr)
library(ggrepel)

# --- 1. Paths ----------------------------------------------------------------
in_path  <- "../nfl-draft-model/output/heisman_handoff/winners_leap_table.csv"
out_path <- "graphics/heisman_winners_discovery_curve.png"

TOP_TIER <- 10   # the article's dividing line: "outside the national top 10".
                 # Must match TOP_TIER in heisman_leap_slope.R, which draws
                 # this same panel inside the combined three-panel figure.
                 # At 10, Daniels '23 (prior rank 15) reads as discovery.

# --- 2. Palette (house dark theme) -------------------------------------------
col_disc     <- "#4A9EBF"   # steel blue   -- came from outside the top tier
col_known    <- "#FFD166"   # gold         -- already a top-20 name
col_dest     <- "#E07B39"   # burnt orange -- the winning season
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

# Display surname. Two traps in this table:
#   "Robert Griffin III" -- naive last-token gives "III", not "Griffin III".
#   "DeVonta Smith"      -- bare "Smith" collides with Jeremiah Smith, who
#                           appears in the companion chart. Disambiguate any
#                           surname on AMBIGUOUS with a first initial.
SUFFIXES  <- c("Jr.", "Jr", "Sr.", "Sr", "II", "III", "IV", "V")
AMBIGUOUS <- c("Smith")

display_surname <- function(full) {
  vapply(full, function(nm) {
    parts  <- strsplit(trimws(nm), "\\s+")[[1]]
    suffix <- character(0)
    while (length(parts) > 1 && parts[length(parts)] %in% SUFFIXES) {
      suffix <- c(parts[length(parts)], suffix)
      parts  <- parts[-length(parts)]
    }
    last <- parts[length(parts)]
    out  <- paste(c(last, suffix), collapse = " ")
    if (last %in% AMBIGUOUS && length(parts) > 1) {
      out <- paste0(substr(parts[1], 1, 1), ". ", out)
    }
    out
  }, character(1), USE.NAMES = FALSE)
}

raw <- read_csv(in_path, show_col_types = FALSE)

# winners who had a qualifying P4 season the year before -> plottable segments
plotted <- raw |>
  filter(!is.na(prior_natl_rank)) |>
  mutate(
    surname   = display_surname(player),
    yy        = sprintf("'%02d", heisman_season %% 100),
    discovery = prior_natl_rank > TOP_TIER,
    seg_color = if_else(discovery, col_disc, col_known),
    left_label = sprintf("%s %s  (%d of %d)",
                         surname, yy, prior_natl_rank, prior_pool)
  )

# winners with no qualifying prior season -> named in the footer, never plotted
unranked <- raw |>
  filter(is.na(prior_natl_rank)) |>
  mutate(surname = display_surname(player))

stopifnot(
  nrow(raw) == 15,
  nrow(plotted) == 11,
  nrow(unranked) == 4
)

n_disc  <- sum(plotted$discovery)
n_known <- sum(!plotted$discovery)
n_unr   <- nrow(unranked)

# the article's headline claim, recomputed rather than trusted
# 20 -> 10 of 15 hidden, 5 known; 10 -> 11 and 4 (Daniels crosses over).
# Recomputed rather than hardcoded so the caption cannot go stale.
n_hidden <- n_disc + n_unr
stopifnot(n_hidden == if (TOP_TIER == 20) 10L else 11L,
          n_known  == if (TOP_TIER == 20)  5L else  4L)

y_floor <- max(plotted$prior_natl_rank)

# --- 4. Plot -----------------------------------------------------------------
p <- ggplot(plotted) +
  geom_segment(
    aes(x = 1, xend = 2,
        y = prior_natl_rank, yend = heisman_natl_rank,
        color = seg_color),
    linewidth = 1.25,
    lineend   = "round"
  ) +
  geom_point(aes(x = 1, y = prior_natl_rank, color = seg_color), size = 4) +
  geom_point(aes(x = 2, y = heisman_natl_rank), color = col_dest, size = 4) +
  geom_text_repel(
    aes(x = 1, y = prior_natl_rank, label = left_label, color = seg_color),
    hjust              = 1,
    nudge_x            = -0.10,
    direction          = "y",
    size               = 3.3,
    fontface           = "bold",
    box.padding        = 0.22,
    point.padding      = 0.35,
    # three winners sit on the same rank (5), so labels must spread; draw a
    # connector when one ends up far from its dot. Safe here because labels
    # live left of x = 0.9, clear of the dotted top-20 rule.
    min.segment.length = 0.35,
    segment.color      = col_grid,
    segment.size       = 0.3,
    seed               = 42
  ) +
  # the destination cluster is the other half of the argument. Anchored to
  # the RIGHT of x = 2 (hjust = 0) so it never crosses the segments, which
  # all approach the cluster from the left.
  annotate(
    "text",
    x = 2.07, y = 2,
    label = "every winner\nfinished 1st,\n2nd or 3rd",
    hjust = 0, vjust = 0.5,
    color = col_dest, size = 3.1, fontface = "italic", lineheight = 1.2
  ) +
  # the top-20 dividing line the article uses
  annotate(
    "segment",
    x = 0.93, xend = 2.62, y = TOP_TIER, yend = TOP_TIER,
    color = col_subtext, linetype = "dotted", linewidth = 0.45
  ) +
  annotate(
    "text",
    x = 2.62, y = TOP_TIER - 1.4,
    label = sprintf("national top %d", TOP_TIER), hjust = 1, vjust = 1,
    color = col_subtext, size = 3, fontface = "italic"
  ) +
  scale_color_identity() +
  scale_y_reverse(
    breaks = c(1, 10, 20, 30, 40, 50, 60),
    expand = expansion(mult = c(0.07, 0.10))
  ) +
  scale_x_continuous(
    breaks = c(1, 2),
    labels = c("Year before", "Heisman season"),
    limits = c(-0.42, 2.64)
  ) +
  labs(
    title = "Almost Nobody Wins It From a Place You Were Watching",
    subtitle = sprintf(
      paste0("Rank within position the year before winning, and the year ",
             "they won.\n%d of the 11 winners with a prior season came ",
             "from outside the top %d."),
      n_disc, TOP_TIER
    ),
    x = NULL,
    y = "National rank within position (1 = best)",
    caption = sprintf(
      paste0(
        "Production index = total yards / 10 + 6 per touchdown. Power 4 only, ",
        "regular season only. Pool size varies by position and\nseason ",
        "(65-73 QB, 93-173 WR/RB), so each label carries its own ",
        "denominator.\n",
        "Not shown -- %s had no qualifying P4 season the year before ",
        "they won (backups or redshirts): %s.\nCounting them, %d of 15 ",
        "winners were invisible or outside the top %d. Cam Newton (2010) is ",
        "absent from the source data.\nSource: cfbfastR / College Football ",
        "Data API."
      ),
      n_unr, paste(unranked$surname, collapse = ", "), n_hidden, TOP_TIER
    )
  ) +
  theme_merrittocracy_dark()

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
