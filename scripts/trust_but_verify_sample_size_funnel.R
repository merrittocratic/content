# ============================================================================
# trust_but_verify_sample_size_funnel.R
#
# "The Ruler Has a Floor" -- funnel plot of calibration gap vs. sample size,
# one point per model-said probability bin. Companion graphic for
# "Trust, But Verify" (nfl-season, 2026-09-06).
#
# The article's own point (see boxscore-prophet/content/drafts/
# cousin_claude_grading_brief.md, lines 53-82): grouping every prediction by
# what the model SAID and checking each bin separately, every bin with real
# sample size holds calibration within about three-quarters of a point. The
# 70-80% bin looks shaky (-8.46pp) only because it also has by far the
# smallest sample (120 player-weeks), well below the 400-week floor the
# piece itself sets as the minimum for trusting a number at all.
#
# This chart is built specifically NOT to lead with "the model is bad at
# 70-80%". Each point carries its own 95% CI (that bin's own probability
# and n) -- worth checking before you claim anything from it: the 70-80%
# bin's own CI is [-16.2, -0.7], which does NOT include zero. So this is
# NOT "just noise that vanishes under a significance test" -- don't claim
# that. What IS true and defensible: this bin fails the piece's own
# explicit rule for calling something a finding (>=4pp AND >=400 player-
# weeks) on the sample-size half alone, 120 vs. 400. The chart leans on
# that stated rule, visible as the two reference lines, rather than an
# implied statistical-significance argument the numbers don't back up.
#
# Data: boxscore-prophet/content/drafts/cousin_claude_grading_brief.md,
# the "grouping every prediction ... by what the model actually SAID" table
# (lines 58-67). Hand-transcribed from a verified source table, not
# recomputed -- these are the published numbers.
#
# Packages: ggplot2, dplyr, ggrepel, scales
#
# Output: graphics/trust_but_verify/sample_size_funnel.png (1200x800px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(ggrepel)
library(scales)

out_path <- "graphics/trust_but_verify/sample_size_funnel.png"

FIND_BAR   <- 4    # pp -- the article's "real finding" gap threshold
FLOOR_N    <- 400  # player-weeks -- the article's sample-size floor

# --- 1. Data (verified against cousin_claude_grading_brief.md:58-67) --------
bins <- tibble(
  bin_label = c("0-10%", "10-20%", "20-30%", "30-40%",
                "40-50%", "50-60%", "60-70%", "70-80%"),
  midpoint  = c(5, 15, 25, 35, 45, 55, 65, 75),
  n         = c(18900, 22136, 14570, 8337, 4674, 1959, 521, 120),
  gap       = c(-0.05, -0.13, 0.25, 0.75, 0.36, 0.66, 0.40, -8.46)
)

# Per-bin own 95% CI, using each bin's own midpoint as p. A single pooled
# reference band (one p for every n) would understate the true uncertainty
# at the 70-80% bin specifically -- variance is highest near p=0.5-0.75, so
# a pooled-p band skews narrow for that bin and visually undercuts the
# point instead of making it. Each bin gets its own CI instead.
bins <- bins |>
  mutate(
    se_own = 1.96 * sqrt((midpoint / 100) * (1 - midpoint / 100) / n) * 100,
    flagged = n < FLOOR_N & abs(gap) > FIND_BAR
  )

# --- 3. Palette (house light theme, matches nurse_coy_scatter.R)
col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"   # steel blue   -- ordinary bins
col_flag    <- "#C0392B"   # red          -- below-floor bin
col_ref     <- "#B8860B"   # dark goldenrod -- reference lines

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

# --- 4. Plot -----------------------------------------------------------------
set.seed(42)

p <- ggplot() +
  geom_hline(yintercept = 0, color = col_grid, linewidth = 0.5) +
  geom_hline(yintercept = c(-FIND_BAR, FIND_BAR),
             color = col_ref, linewidth = 0.4, linetype = "dashed") +
  geom_vline(xintercept = FLOOR_N,
             color = col_ref, linewidth = 0.4, linetype = "dashed") +
  geom_errorbar(
    data = bins, aes(x = n, ymin = gap - se_own, ymax = gap + se_own,
                      color = flagged),
    width = 0, linewidth = 0.6, alpha = 0.8
  ) +
  geom_point(
    data = bins, aes(x = n, y = gap, color = flagged), size = 3.4
  ) +
  geom_text_repel(
    data = bins, aes(x = n, y = gap, label = bin_label, color = flagged),
    seed = 42, size = 3.3, fontface = "bold",
    box.padding = 0.6, segment.color = col_subtext, segment.size = 0.3
  ) +
  annotate("text", x = FLOOR_N, y = 7.6, label = "400-week floor",
           color = col_ref, size = 3, hjust = -0.08, fontface = "italic") +
  annotate("text", x = 22000, y = FIND_BAR + 0.55, label = "4pp finding bar",
           color = col_ref, size = 3, hjust = 1, fontface = "italic") +
  scale_x_log10(labels = comma) +
  scale_color_manual(values = c(`FALSE` = col_point, `TRUE` = col_flag)) +
  labs(
    title = "The Ruler Has a Floor",
    subtitle = paste0(
      "Calibration gap by probability bin vs. sample size -- every bin with\n",
      "real sample size holds within about three-quarters of a point"
    ),
    x = "Player-weeks in bin (log scale)",
    y = "Gap: actual minus model-said (pp)",
    caption = paste0(
      "Boxscore Prophet - 2016-2025 backtest, grouped by what the model said\n",
      "Error bars: each bin's own 95% confidence interval, using that bin's own probability and sample size\n",
      "The 70-80% bin misses by 8.46pp on just 120 player-weeks -- short of the 400-week floor this\n",
      "piece sets for calling any gap a finding, so it's parked on the watch registry, not reported as one."
    )
  ) +
  theme_merrittocracy_light()

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
