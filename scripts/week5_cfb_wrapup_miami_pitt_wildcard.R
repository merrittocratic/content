# ============================================================================
# week5_cfb_wrapup_miami_pitt_wildcard.R
#
# Candidate 4 (WILDCARD) for draft/week5_cfb_wrapup.md ("Records Are
# Cheap"). Section: "Pitt Has the Per-Play Numbers. Miami Has the Passing
# Game."
#
# Two-panel patchwork:
#   Panel A -- season-long rank comparison (Net EPA, Offense EPA, Defense
#              EPA, SP+ overall, FPI SOS, 247 talent composite) as a
#              slope/bump chart, Miami vs Pitt, one line per metric. Lower
#              rank = better, so the y-axis is reversed.
#   Panel B -- the "matchup inside the matchup": one row per unit matchup
#              (each offense vs. the opposing defense, FBS pass/run EPA
#              ranks), sorted by rank gap, with an edge tag colored by the
#              team the mismatch favors.
#
# Data (verified against Steve's data packet; matches article text where
# the article gives a number):
#   Net EPA rank: Miami 13th, Pitt 10th
#   Offense EPA rank: Miami 6th, Pitt 38th
#   Defense EPA rank: Miami 70th, Pitt 16th
#   SP+ overall: Miami 5th, Pitt 20th
#   FPI SOS: Miami 70th, Pitt 100th
#   247 talent composite: Miami 13th, Pitt 64th
#   Pass EPA / Run EPA (FBS ranks):
#     Miami offense 7th / 65th; Pitt defense 56th / 9th
#     Pitt offense 25th / 95th; Miami defense 104th / 5th
#
# House theme: theme_merrittocracy_light(), copied from
# scripts/trust_but_verify_sample_size_funnel.R (lines 69-96), per Steve's
# course correction to a white-background house standard for charts.
#
# Output: graphics/week5_cfb_wrapup/candidate_4.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(tibble)
library(glue)
library(patchwork)

# --- Palette (house light theme, matches trust_but_verify_sample_size_funnel.R) --

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_miami   <- "#3A7CA5"   # steel blue -- Miami
col_pitt    <- "#C0392B"   # red -- Pitt
col_ref     <- "#B8860B"   # dark goldenrod -- reference / annotation

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
                                        size = 14, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 9.5,
                                        margin = margin(b = 10), lineheight = 1.15),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 8)),
      legend.position    = "none",
      plot.margin        = margin(10, 16, 8, 12)
    )
}

# =============================================================================
# Panel A: season ratings bump chart (Miami vs Pitt, across six metrics)
# =============================================================================

ratings <- tibble::tribble(
  ~metric,            ~metric_order, ~miami, ~pitt,
  "Net EPA",           1,            13,     10,
  "Offense EPA",       2,            6,      38,
  "Defense EPA",       3,            70,     16,
  "SP+ overall",       4,            5,      20,
  "FPI SOS",           5,            70,     100,
  "247 talent",        6,            13,     64
)

ratings_long <- ratings |>
  tidyr::pivot_longer(cols = c(miami, pitt), names_to = "team", values_to = "rank") |>
  mutate(
    team = recode(team, miami = "Miami", pitt = "Pitt"),
    metric = factor(metric, levels = ratings$metric)
  )

# Rank labels sit in two colored rows beneath the lines (Miami, then Pitt)
# instead of on the points, so no label can land on a line where the series
# cross or run close together.
label_rows <- ratings_long |>
  mutate(label_y = ifelse(team == "Miami", 122, 140))

p_a <- ggplot(ratings_long, aes(x = metric_order, y = rank, color = team, group = team)) +
  geom_line(linewidth = 1.3) +
  geom_point(size = 3.6) +
  geom_text(
    data = label_rows,
    aes(x = metric_order, y = label_y, label = glue("{rank}th")),
    size = 3.2, fontface = "bold", show.legend = FALSE
  ) +
  scale_x_continuous(
    breaks = ratings$metric_order,
    labels = ratings$metric,
    limits = c(-0.6, 6.4),
    expand = c(0, 0)
  ) +
  scale_y_reverse(limits = c(148, -6), breaks = c(1, 25, 50, 75, 100)) +
  scale_color_manual(values = c("Miami" = col_miami, "Pitt" = col_pitt)) +
  labs(
    title = "Season Ratings: Agree on Little",
    subtitle = "National rank by metric (1 = best). Miami leads on offense and overall\nefficiency; Pitt leads on defense and has played the easier schedule.",
    x = NULL, y = "National rank (1 = best)", color = NULL
  ) +
  theme_merrittocracy_light() +
  theme(
    axis.text.x = element_text(angle = 20, hjust = 1, size = 8.5),
    legend.position = "top",
    legend.justification = "left",
    legend.text = element_text(size = 13, face = "plain")
  )

# =============================================================================
# Panel B: unit matchup rows (pass vs run, FBS ranks)
# =============================================================================

# One row per unit matchup (offense vs. the opposing defense), sorted by the
# size of the rank gap. Offense label on the left, defense on the right, and
# an edge tag colored by the team the mismatch favors.
matchups <- tibble::tribble(
  ~off_team, ~off_unit,        ~off_rank, ~def_team, ~def_unit,        ~def_rank,
  "Pitt",    "Pitt run O",     95,        "Miami",   "Miami run D",    5,
  "Pitt",    "Pitt pass O",    25,        "Miami",   "Miami pass D",   104,
  "Miami",   "Miami run O",    65,        "Pitt",    "Pitt run D",     9,
  "Miami",   "Miami pass O",   7,         "Pitt",    "Pitt pass D",    56
) |>
  mutate(
    gap      = abs(off_rank - def_rank),
    favors   = ifelse(off_rank < def_rank, off_team, def_team),
    y        = rev(seq_len(n())),
    off_col  = ifelse(off_team == "Miami", col_miami, col_pitt),
    def_col  = ifelse(def_team == "Miami", col_miami, col_pitt),
    fav_col  = ifelse(favors == "Miami", col_miami, col_pitt),
    off_lab  = glue("{off_unit} ({off_rank}th)"),
    def_lab  = glue("{def_unit} ({def_rank}th)"),
    edge_lab = glue("{favors} +{gap}")
  )

p_b <- ggplot(matchups) +
  geom_segment(
    aes(x = 1.55, xend = 2.45, y = y, yend = y),
    color = col_subtext, linewidth = 0.6,
    arrow = arrow(length = unit(0.09, "inches"), type = "closed")
  ) +
  geom_text(aes(x = 1.45, y = y, label = off_lab, color = off_col),
            hjust = 1, size = 3.7, fontface = "bold") +
  geom_text(aes(x = 2.55, y = y, label = def_lab, color = def_col),
            hjust = 0, size = 3.7, fontface = "bold") +
  geom_text(aes(x = 3.75, y = y, label = edge_lab, color = fav_col),
            hjust = 0, size = 3.7, fontface = "bold") +
  annotate("text", x = 3.75, y = 4.85, label = "Edge (rank gap)",
           hjust = 0, size = 3, color = col_subtext) +
  scale_color_identity() +
  scale_x_continuous(limits = c(0.25, 4.5), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0.5, 5.25), expand = c(0, 0)) +
  labs(
    title = "The Matchup Inside the Matchup",
    subtitle = "Each offense vs. the opposing defense, FBS EPA ranks. Pitt's best shot: throwing on Miami's 104th-ranked pass defense.",
    caption = glue(
      "TheMerrittocracy  \u00b7  Data: cfbfastR season EPA (garbage time excluded); SP+ through Week 4; FPI; 247 talent composite\n",
      "Neither team has played an SP+ top-25 opponent. Miami 3-0 in ACC (AP 4th), Pitt 2-0 (AP 25th)."
    )
  ) +
  theme_void(base_size = 12) +
  theme(
    plot.background = element_rect(fill = col_bg, color = NA),
    plot.title      = element_text(color = col_text, face = "bold", size = 14,
                                    margin = margin(b = 4), hjust = 0),
    plot.subtitle   = element_text(color = col_subtext, size = 9.5,
                                    margin = margin(b = 6), hjust = 0),
    plot.caption    = element_text(color = col_subtext, size = 8,
                                    hjust = 0, margin = margin(t = 10)),
    plot.margin     = margin(10, 16, 8, 12)
  )

# =============================================================================
# Combine
# =============================================================================

combined <- p_a / p_b +
  plot_layout(heights = c(1.3, 1)) +
  plot_annotation(
    title = "Miami Hosts Pitt for the ACC's Unbeaten Crown (Oct. 24)",
    theme = theme(
      plot.background = element_rect(fill = col_bg, color = NA),
      plot.title = element_text(color = col_text, face = "bold", size = 18,
                                 margin = margin(t = 4, b = 2), hjust = 0.02)
    )
  )

# --- Save ----------------------------------------------------------------

out_dir <- "graphics/week5_cfb_wrapup"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

ggsave(
  filename = file.path(out_dir, "candidate_4.png"),
  plot     = combined,
  width    = 1200 / 150,
  height   = 800 / 150,
  dpi      = 150,
  bg       = col_bg
)

message("Saved: ", file.path(out_dir, "candidate_4.png"))
