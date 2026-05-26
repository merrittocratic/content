# ============================================================================
# wemby_per36_rs_po.R
#
# "Wemby Per 36: Regular Season vs. Playoffs"
# Grouped bar chart, three stat clusters (PTS, TRB, BLK) x two contexts.
#
# Source: 2025-26 season per-36 (regular season) and playoff per-36 across
# 12 games. Values supplied directly.
#
# Output: graphics/wemby_per36_rs_po.png (1200x800px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)

# ── 1. Data ──────────────────────────────────────────────────────────────────
df <- tribble(
  ~stat, ~context,         ~value,
  "PTS", "Regular Season", 30.9,
  "PTS", "Playoffs",       25.6,
  "TRB", "Regular Season", 14.2,
  "TRB", "Playoffs",       14.2,
  "BLK", "Regular Season",  3.8,
  "BLK", "Playoffs",        4.6
) %>%
  mutate(
    stat    = factor(stat, levels = c("PTS", "TRB", "BLK")),
    context = factor(context, levels = c("Regular Season", "Playoffs"))
  )

# ── 2. Palette & theme (Merrittocracy dark) ──────────────────────────────────
col_rs      <- "#4A9EBF"   # steel blue   — Regular Season
col_po      <- "#E07B39"   # burnt orange — Playoffs
col_bg      <- "#111118"
col_panel   <- "#1A1A26"
col_grid    <- "#2A2A3E"
col_text    <- "#E0E0EE"
col_subtext <- "#9090AA"
col_drop    <- "#FF6B6B"   # red for the scoring drop
col_rise    <- "#FFD166"   # gold for the block rise

theme_merrittocracy_dark <- function(base_size = 13) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major.y = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      axis.text.x        = element_text(color = col_text,    size = 13, face = "bold"),
      axis.text.y        = element_text(color = col_subtext, size = 10),
      axis.title         = element_text(color = col_text,    size = 11),
      plot.title         = element_text(color = col_text,    face = "bold",
                                        size = 17, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 11,
                                        margin = margin(b = 14)),
      plot.caption       = element_text(color = col_subtext, size = 9,
                                        hjust = 0, margin = margin(t = 10)),
      legend.position    = "top",
      legend.background  = element_rect(fill = col_bg, color = NA),
      legend.text        = element_text(color = col_text, size = 11),
      legend.title       = element_blank(),
      legend.key         = element_rect(fill = col_bg, color = NA),
      plot.margin        = margin(16, 22, 12, 16)
    )
}

# ── 3. Bar-value labels (top of each bar) ────────────────────────────────────
df <- df %>%
  mutate(label = sprintf("%.1f", value))

# ── 4. Plot ──────────────────────────────────────────────────────────────────
p <- ggplot(df, aes(x = stat, y = value, fill = context)) +

  geom_col(
    position = position_dodge(width = 0.75),
    width    = 0.68,
    alpha    = 0.92
  ) +

  geom_text(
    aes(label = label),
    position = position_dodge(width = 0.75),
    vjust    = -0.55,
    color    = col_text,
    size     = 4.0,
    fontface = "bold"
  ) +

  # ── Annotation: scoring drop on PTS ────────────────────────────────────────
  annotate(
    "segment",
    x = 0.81, xend = 1.19,
    y = 33.5, yend = 33.5,
    color = col_drop, linewidth = 0.6
  ) +
  annotate(
    "label",
    x = 1.0, y = 35.7,
    label = "-5.3 PPG",
    color = col_drop, fill = col_panel,
    size = 4.2, fontface = "bold", label.size = 0
  ) +

  # ── Annotation: block rise on BLK ──────────────────────────────────────────
  annotate(
    "segment",
    x = 2.81, xend = 3.19,
    y = 6.8, yend = 6.8,
    color = col_rise, linewidth = 0.6
  ) +
  annotate(
    "label",
    x = 3.0, y = 9.0,
    label = "+0.8 BLK",
    color = col_rise, fill = col_panel,
    size = 4.2, fontface = "bold", label.size = 0
  ) +

  scale_fill_manual(values = c("Regular Season" = col_rs, "Playoffs" = col_po)) +
  scale_y_continuous(
    limits = c(0, 38),
    breaks = seq(0, 35, 5),
    expand = expansion(mult = c(0, 0.02))
  ) +

  labs(
    title    = "Wemby Per 36: Regular Season vs. Playoffs",
    subtitle = "2025-26 season  ·  Playoffs across 12 games",
    x        = NULL,
    y        = "Per 36 Minutes",
    caption  = "Data: Basketball Reference  ·  TheMerrittocracy"
  ) +
  theme_merrittocracy_dark()

# ── 5. Save ──────────────────────────────────────────────────────────────────
out_path <- "graphics/wemby_per36_rs_po.png"

ggsave(
  filename = out_path,
  plot     = p,
  width    = 1200 / 150,
  height   =  800 / 150,
  dpi      = 150,
  bg       = col_bg
)

message("Saved: ", out_path)
