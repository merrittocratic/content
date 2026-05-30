# chet_scoring_trajectory.R
# Chet Holmgren PPG by playoff round + regular-season vs. NYK comparison
# Data: Basketball Reference 2026 playoff game log
# Output: graphics/chet_scoring_trajectory.png

library(tidyverse)
library(ggtext)
library(glue)
library(scales)

# ── 1. DATA ────────────────────────────────────────────────────────────────────
# Pull Chet's game log from BBRef, calculate PPG per series.
# Series-level rows only. Regular-season NYK avg is a comparison point,
# not a playoff data point — styled differently on the chart.
#
# Columns needed:
#   round_label  : display label for x-axis (e.g. "R1 vs. PHX")
#   ppg          : points per game for that series / comparison
#   is_playoff   : TRUE for playoff rounds, FALSE for reg-season comparison
#   sort_order   : integer controlling x-axis order (1 = leftmost)

chet_data <- tribble(
  ~round_label,              ~ppg,   ~is_playoff,  ~sort_order,
  "R1 vs. PHX",             17.3,   TRUE,          1,   # PLACEHOLDER — fill from BBRef
  "R2 vs. LAL",             20.0,   TRUE,          2,   # PLACEHOLDER — fill from BBRef
  "WCF vs. SAS\n(Gms 1-4)", 12.2,   TRUE,          3,   # 7-17 FG, avg from search
  "Reg. Season\nvs. NYK",   22.0,   FALSE,         4    # (28 + 16) / 2 — two games
)

# Factor with explicit order
chet_data <- chet_data |>
  mutate(
    round_label = fct_reorder(round_label, sort_order),
    point_color = if_else(is_playoff, "#002D62", "#C8A84B"),  # OKC navy / gold
    point_shape = if_else(is_playoff, 21L, 23L)               # circle / diamond
  )

# Playoff-only rows for the connecting line
playoff_only <- chet_data |> filter(is_playoff)

# ── 2. ANNOTATIONS ─────────────────────────────────────────────────────────────
wemby_label <- glue(
  "Wembanyama effect:\n{playoff_only$ppg[3]} PPG on 21-for-41 FG\n(Games 1–5)"
)

nyk_label <- glue(
  "Reg. season vs. NYK\n{chet_data$ppg[4]} PPG avg\n(28 pts + 16 pts)"
)

# ── 3. PLOT ─────────────────────────────────────────────────────────────────────
p <- ggplot() +

  # Dashed vertical separator before the comparison point
  geom_vline(
    xintercept = 3.5,
    linetype   = "dashed",
    color      = "grey70",
    linewidth  = 0.5
  ) +

  # Line connecting playoff rounds only
  geom_line(
    data    = playoff_only,
    aes(x = round_label, y = ppg, group = 1),
    color   = "#002D62",
    linewidth = 1.1
  ) +

  # All points (playoff = navy circle, comparison = gold diamond)
  geom_point(
    data  = chet_data,
    aes(x = round_label, y = ppg,
        fill  = is_playoff,
        shape = is_playoff),
    size  = 5,
    color = "white",
    stroke = 1.5
  ) +

  # PPG labels above each point
  geom_text(
    data  = chet_data,
    aes(x = round_label, y = ppg, label = ppg),
    vjust = -1.2,
    size  = 3.8,
    fontface = "bold",
    color = "grey20"
  ) +

  # Wemby annotation
  annotate(
    "text",
    x     = 3,              # WCF point
    y     = 10.5 - 4.5,    # below the dot
    label = wemby_label,
    size  = 3.1,
    color = "#8B0000",
    hjust = 0.5,
    lineheight = 1.2
  ) +

  # NYK comparison annotation
  annotate(
    "text",
    x     = 4,
    y     = 22.0 - 4.5,
    label = nyk_label,
    size  = 3.1,
    color = "#006BB6",       # Knicks blue
    hjust = 0.5,
    lineheight = 1.2
  ) +

  # Separator label
  annotate(
    "text",
    x     = 3.5,
    y     = max(chet_data$ppg, na.rm = TRUE) + 1,
    label = "← Playoffs  |  Regular Season →",
    size  = 2.9,
    color = "grey55",
    hjust = 0.5
  ) +

  scale_fill_manual(
    values = c("TRUE" = "#002D62", "FALSE" = "#C8A84B"),
    guide  = "none"
  ) +
  scale_shape_manual(
    values = c("TRUE" = 21, "FALSE" = 23),
    guide  = "none"
  ) +
  scale_y_continuous(
    limits = c(0, NA),
    expand = expansion(mult = c(0, 0.2))
  ) +

  labs(
    title    = "**Chet Holmgren's Scoring Trajectory** — 2026 Playoffs",
    subtitle = "Points per game by round · Regular-season NYK average shown for comparison",
    x        = NULL,
    y        = "Points Per Game",
    caption  = "Data: Basketball Reference · Merrittocracy"
  ) +

  theme_minimal(base_size = 13) +
  theme(
    plot.title      = element_markdown(face = "bold", size = 14, margin = margin(b = 4)),
    plot.subtitle   = element_text(color = "grey40", size = 10, margin = margin(b = 12)),
    plot.caption    = element_text(color = "grey55", size = 8, hjust = 1),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    axis.text.x     = element_text(size = 10, lineheight = 1.2),
    axis.text.y     = element_text(color = "grey40"),
    plot.margin     = margin(16, 20, 12, 16)
  )

# ── 4. SAVE ──────────────────────────────────────────────────────────────────────
ggsave(
  filename = "graphics/chet_scoring_trajectory.png",
  plot     = p,
  width    = 8,
  height   = 5,
  dpi      = 300,
  bg       = "white"
)

message("Saved: graphics/chet_scoring_trajectory.png")
