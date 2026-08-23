# ============================================================================
# heisman_leap_slope.R
#
# "The Leap" -- three slope panels in ONE figure, all sharing a single unit:
# national rank within position.
#
#   1. QUARTERBACK   -- 2026 candidates: 2025 rank -> the target, No. 3
#   2. WIDE RECEIVER -- same
#   3. PAST WINNERS  -- where the last 15 Heisman winners ranked the year
#                       before, and where they ranked when they won
#
# Companion graphic for "The Discovery Channel" (cfb-season, 2026-08-23).
#
# WHY RANK AND NOT PRODUCTION
# ---------------------------
# An earlier pass put production index on y so the two rank-3 bars (the
# 2021-25 median and the 2025 field alone) could be drawn as separate dots.
# That works in isolation but makes this figure incomparable with the
# winners panel, which is inherently a rank story. Rank is the shared unit,
# so rank wins. In rank space both bars ARE No. 3 by construction, so the
# fact that No. 3 got cheaper in 2025 is carried as a per-panel annotation
# instead of a second geometry. Do NOT reintroduce a vertical connector
# between two target dots -- it reads as a candidate's path and confuses.
#
# The winners panel duplicates logic in heisman_winners_discovery_curve.R,
# which remains the standalone version of that chart. Change both together.
#
# Data: ../nfl-draft-model/output/heisman_handoff/candidates_2026_targets.csv
#       ../nfl-draft-model/output/heisman_handoff/winners_leap_table.csv
#
# Packages: ggplot2, dplyr, readr, ggrepel, patchwork
#
# Output: content/graphics/heisman_leap_slope.png (1600x850px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(readr)
library(ggrepel)
library(patchwork)

# --- 1. Paths and constants --------------------------------------------------
cand_path <- "../nfl-draft-model/output/heisman_handoff/candidates_2026_targets.csv"
win_path  <- "../nfl-draft-model/output/heisman_handoff/winners_leap_table.csv"
out_path  <- "graphics/heisman_leap_slope.png"

TARGET_RANK <- 3    # worst finish of any winner since 2011
TOP_TIER    <- 10   # the article's "outside the national top 10" line.
                    # Everything downstream -- the rule, its label, the
                    # blue/gold split, and the caption count -- derives from
                    # this, so moving it can never leave stale copy behind.
                    # At 10, Daniels '23 (prior rank 15) reads as discovery.

# Candidates cut from the article. The CSV is the model's field; this is the
# editorial field. Moore was dropped when Dead Air and Rerun merged.
DROP <- c("Dante Moore")

# What No. 3 actually cost, by position: 2021-25 median vs the 2025 field
# alone. Hand-carried from BRIDGE_PROMPT.md; drives the annotation only.
#
# IMPORTANT: on a rank axis the dashed target line is the 2025 number, not
# the 2021-25 one. Rank 3 here means rank 3 IN THE 2025 FIELD, so the line
# sits at BAR_2025 by construction. BAR_5YR cannot be drawn at all -- 645.3
# outranks every quarterback who played in 2025 (Pavia led at 617.8), and
# 190.9 outranks the No. 2 receiver. Both are off the top of their panel.
# The annotation has to say which one the line is, or the reader assumes
# it covers both.
BAR_5YR  <- c(QB = 645.3, WR = 190.9)
BAR_2025 <- c(QB = 556.0, WR = 174.1)

# how far above the visible field the 2021-25 bar sits, per position. Both
# claims are provable from the 2025 field and are stated no more strongly
# than that: 645.3 > Pavia's 617.8 (No. 1); 190.9 > Smith's 182.6 (No. 2).
BAR_5YR_NOTE <- c(
  QB = "No. 1 in 2025, so it is off this chart.",
  WR = "No. 2 in 2025, so it is off this panel."
)

# --- 2. Palette (house dark theme) -------------------------------------------
col_climb   <- "#4A9EBF"   # steel blue   -- climbing / came from outside top 20
col_clear   <- "#FFD166"   # gold         -- already at or past the bar / top 20
col_target  <- "#E07B39"   # burnt orange -- the target, and winners' finish
col_bg      <- "#111118"
col_panel   <- "#1A1A26"
col_grid    <- "#2A2A3E"
col_text    <- "#E0E0EE"
col_subtext <- "#9090AA"

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
      plot.title         = element_text(color = col_text, face = "bold",
                                        size = 11, hjust = 0.5,
                                        margin = margin(b = 8)),
      legend.position    = "none",
      plot.margin        = margin(6, 8, 4, 6)
    )
}

# --- 3. Candidate panels -----------------------------------------------------
cand_raw <- read_csv(cand_path, show_col_types = FALSE)

cand <- cand_raw |>
  filter(!player %in% DROP) |>
  mutate(
    start_rank    = rank_vs_2025_field,
    already_clear = start_rank <= TARGET_RANK,
    seg_color     = if_else(already_clear, col_clear, col_climb),
    name_label    = case_when(
      candidate == "Mateer (2024, healthy)" ~ "Mateer '24 (healthy)",
      candidate == "Mateer (2025, hurt)"    ~ "Mateer '25 (hurt)",
      TRUE                                  ~ player
    ),
    left_label = sprintf("%s  (%d)", name_label, start_rank)
  )

stopifnot(
  nrow(cand) == 7,
  # a typo in DROP must fail loudly, not silently leave someone on the chart
  all(DROP %in% cand_raw$player),
  all(!is.na(cand$start_rank))
)

candidate_panel <- function(pos, panel_title, pool_n) {
  d <- filter(cand, position == pos)
  # what No. 3 cost then vs. now -- the point of the annotation
  drop_pct <- round(100 * (1 - BAR_2025[[pos]] / BAR_5YR[[pos]]))

  ggplot(d) +
    annotate("segment", x = 0.93, xend = 2.10,
             y = TARGET_RANK, yend = TARGET_RANK,
             color = col_target, linetype = "dashed", linewidth = 0.5) +
    annotate("text", x = 2.14, y = max(d$start_rank) * 1.19,
             label = sprintf(
               "Dashed line = No. 3 in the 2025 field (%.0f pts).\nThe 2021-25 bar was %.0f, %d%% dearer -- above\n%s",
               BAR_2025[[pos]], BAR_5YR[[pos]], drop_pct, BAR_5YR_NOTE[[pos]]),
             hjust = 1, vjust = 1, color = col_target,
             size = 2.6, fontface = "italic", lineheight = 1.25) +
    geom_segment(aes(x = 1, xend = 2, y = start_rank, yend = TARGET_RANK,
                     color = seg_color),
                 linewidth = 1.3, lineend = "round") +
    geom_point(aes(x = 1, y = start_rank, color = seg_color), size = 4) +
    annotate("point", x = 2, y = TARGET_RANK, color = col_target, size = 4) +
    geom_text_repel(aes(x = 1, y = start_rank, label = left_label,
                        color = seg_color),
                    hjust = 1, nudge_x = -0.10, direction = "y",
                    size = 3.1, fontface = "bold",
                    box.padding = 0.24, point.padding = 0.35,
                    min.segment.length = Inf, seed = 42) +
    scale_color_identity() +
    scale_y_reverse(
      breaks = function(l) { b <- pretty(c(1, max(l))); b[b >= 1] },
      expand = expansion(mult = c(0.34, 0.10))
    ) +
    scale_x_continuous(breaks = c(1, 2), labels = c("2025", "Target"),
                       limits = c(-0.95, 2.18)) +
    labs(title = sprintf("%s  (pool of %d)", panel_title, pool_n),
         x = NULL, y = "National rank within position (1 = best)") +
    theme_merrittocracy_dark()
}

p_qb <- candidate_panel("QB", "QUARTERBACK", 73)
p_wr <- candidate_panel("WR", "WIDE RECEIVER", 175) + labs(y = NULL)

# --- 4. Winners panel --------------------------------------------------------
SUFFIXES  <- c("Jr.", "Jr", "Sr.", "Sr", "II", "III", "IV", "V")
AMBIGUOUS <- c("Smith")   # DeVonta vs Jeremiah, who is in the WR panel

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

win_raw <- read_csv(win_path, show_col_types = FALSE)

# NA prior rank means backup or redshirt -- not a rank of zero. Never plotted.
plotted <- win_raw |>
  filter(!is.na(prior_natl_rank)) |>
  mutate(
    surname    = display_surname(player),
    yy         = sprintf("'%02d", heisman_season %% 100),
    discovery  = prior_natl_rank > TOP_TIER,
    seg_color  = if_else(discovery, col_climb, col_clear),
    left_label = sprintf("%s %s  (%d)", surname, yy, prior_natl_rank)
  )
unranked <- win_raw |>
  filter(is.na(prior_natl_rank)) |>
  mutate(surname = display_surname(player))

stopifnot(nrow(win_raw) == 15, nrow(plotted) == 11, nrow(unranked) == 4)
n_disc   <- sum(plotted$discovery)
n_hidden <- n_disc + nrow(unranked)   # the article's headline claim
# 20 -> 10 of 15; 10 -> 11 of 15 (Daniels crosses over). Recomputed, never
# hardcoded, so the caption and the article can be checked against it.
stopifnot(n_hidden == if (TOP_TIER == 20) 10L else 11L)

p_win <- ggplot(plotted) +
  geom_segment(aes(x = 1, xend = 2, y = prior_natl_rank,
                   yend = heisman_natl_rank, color = seg_color),
               linewidth = 1.15, lineend = "round") +
  geom_point(aes(x = 1, y = prior_natl_rank, color = seg_color), size = 3.6) +
  geom_point(aes(x = 2, y = heisman_natl_rank), color = col_target, size = 3.6) +
  # Repelled in TWO layers, each fenced to its own side of the TOP_TIER rule.
  # With one layer, ggrepel escapes the 5-5-5-6 pile by pushing Griffin III
  # (rank 6) down past the line, which makes a top-10 winner read as if he
  # started outside it. The ylim fences make that impossible: a label can
  # never cross the threshold its own dot sits above.
  #
  # GOTCHA: scale_y_reverse plots data value v at position -v, and ggrepel
  # applies ylim in THAT space, not in data units. So the fences are negated.
  # Passing them unnegated silently drops every discovery label off the panel.
  geom_text_repel(data = filter(plotted, !discovery),
                  aes(x = 1, y = prior_natl_rank, label = left_label,
                      color = seg_color),
                  hjust = 1, nudge_x = -0.10, direction = "y",
                  ylim = c(-(TOP_TIER - 0.7), NA),   # stays above the rule
                  size = 3.0, fontface = "bold",
                  box.padding = 0.20, point.padding = 0.32,
                  min.segment.length = 0.35, segment.color = col_grid,
                  segment.size = 0.3, seed = 42) +
  geom_text_repel(data = filter(plotted, discovery),
                  aes(x = 1, y = prior_natl_rank, label = left_label,
                      color = seg_color),
                  hjust = 1, nudge_x = -0.10, direction = "y",
                  ylim = c(NA, -(TOP_TIER + 0.7)),   # stays below the rule
                  size = 3.0, fontface = "bold",
                  box.padding = 0.20, point.padding = 0.32,
                  min.segment.length = 0.35, segment.color = col_grid,
                  segment.size = 0.3, seed = 42) +
  annotate("segment", x = 0.34, xend = 2.10,
           y = TOP_TIER, yend = TOP_TIER,
           color = col_text, linetype = "dashed", linewidth = 0.7) +
  # Short on purpose. At TOP_TIER = 10 the rule lands inside the 5-5-5-6
  # cluster, and the long form ran straight into Griffin III's label. The
  # y-axis title already says these are ranks, so "TOP 10" carries it.
  annotate("text", x = -1.18, y = TOP_TIER,
           label = sprintf("TOP %d", TOP_TIER), hjust = 0, vjust = 0.5,
           color = col_text, size = 3.4, fontface = "bold") +
  scale_color_identity() +
  scale_y_reverse(breaks = c(1, 10, 20, 30, 40, 50, 60),
                  expand = expansion(mult = c(0.20, 0.08))) +
  scale_x_continuous(breaks = c(1, 2),
                     labels = c("Year before", "Won it"),
                     limits = c(-1.20, 2.14)) +
  labs(title = "PAST WINNERS  (2011-2025)", x = NULL, y = NULL) +
  theme_merrittocracy_dark()

# --- 5. Assemble -------------------------------------------------------------
fig <- (p_qb | p_wr | p_win) +
  plot_layout(widths = c(1, 1, 1.3)) +
  plot_annotation(
    title = "Everybody Is Climbing to the Same Place. Almost Nobody Starts Near It.",
    subtitle = paste0(
      "Left two panels: what the 2026 field must climb to reach No. 3. ",
      "Right panel: what the last fifteen winners actually climbed.\n",
      sprintf("Blue = started outside the top %d, or still climbing. ", TOP_TIER),
      "Gold = already there. Orange = the destination."
    ),
    caption = sprintf(paste0(
      "Production index = total yards / 10 + 6 per touchdown, ranked within ",
      "position. Power 4 only, regular season only (voting closes before the ",
      "Playoff).\nNo. 3 is the target because it is the worst any winner has ",
      "finished since 2011 -- but it got cheaper: rank-3 production fell every ",
      "year but one from 2021 to 2025.\nNot shown -- %d winners had no ",
      "qualifying P4 season the year before, being backups or redshirts: %s. ",
      "Counting them, %d of 15 were invisible or outside the top %d.\n",
      "Pools differ by panel, so compare within a panel, not across. Cam ",
      "Newton (2010) is absent from the source data. Source: cfbfastR / ",
      "College Football Data API."),
      nrow(unranked), paste(unranked$surname, collapse = ", "),
      n_hidden, TOP_TIER),
    theme = theme(
      plot.background = element_rect(fill = col_bg, color = NA),
      plot.title    = element_text(color = col_text, face = "bold", size = 16,
                                   margin = margin(b = 5)),
      plot.subtitle = element_text(color = col_subtext, size = 10,
                                   margin = margin(b = 12)),
      plot.caption  = element_text(color = col_subtext, size = 7.6, hjust = 0,
                                   margin = margin(t = 10)),
      plot.margin   = margin(14, 16, 10, 14)
    )
  )

# --- 6. Save -----------------------------------------------------------------
ggsave(
  filename = out_path,
  plot     = fig,
  width    = 1600 / 150,
  height   =  850 / 150,
  dpi      = 150,
  bg       = col_bg
)

cat("wrote", out_path, "\n")
