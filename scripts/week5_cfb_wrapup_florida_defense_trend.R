# ============================================================================
# week5_cfb_wrapup_florida_defense_trend.R
#
# Candidate 1 (standard) for draft/week5_cfb_wrapup.md ("Records Are Cheap").
# Section: "Florida Didn't Get Unlucky. It Got Run Over."
#
# Florida's defensive EPA/play allowed, game by game vs FBS opponents
# (cfbfastR, garbage time excluded). The defense has gotten worse in every
# game this season.
#
# Data (verified against Steve's data packet, matches article table exactly):
#   Florida Atlantic 0.042; Auburn 0.224; Ole Miss 0.283; Missouri 0.438
#   Season-long: 128th of 138 FBS teams in defensive EPA (111th vs pass,
#   126th vs run).
#
# House theme: theme_merrittocracy_light(), copied from
# scripts/trust_but_verify_sample_size_funnel.R (lines 69-96), per Steve's
# course correction to a white-background house standard for charts.
#
# Output: graphics/week5_cfb_wrapup/candidate_1.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(glue)

# --- Data --------------------------------------------------------------------

def_trend <- tibble::tribble(
  ~game_order, ~opponent,          ~epa_allowed, ~label_hjust, ~label_y,
  1,           "Florida Atlantic", 0.042,        0,            0.042 - 0.045,
  2,           "Auburn",           0.224,        0.5,          0.224 + 0.052,
  3,           "Ole Miss",         0.283,        0.5,          0.283 + 0.052,
  4,           "Missouri",         0.438,        1,            0.438 + 0.052
) |>
  mutate(opponent = factor(opponent, levels = opponent))

# --- Palette (house light theme, matches trust_but_verify_sample_size_funnel.R) --

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"   # steel blue
col_flag    <- "#C0392B"   # red -- the declining defense
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

p <- ggplot(def_trend, aes(x = game_order, y = epa_allowed)) +
  geom_hline(yintercept = 0, color = col_grid, linewidth = 0.6) +
  geom_line(color = col_flag, linewidth = 1.6) +
  geom_point(color = col_flag, size = 5.5) +
  geom_point(color = col_bg, size = 2) +
  geom_text(
    aes(x = game_order, y = label_y,
        label = glue("{opponent}\n{sprintf('%.3f', epa_allowed)}"), hjust = label_hjust),
    color = col_text,
    size  = 4.3,
    fontface = "bold",
    lineheight = 0.95
  ) +
  annotate(
    "label",
    x = 1.5, y = 0.46,
    label = "128th of 138 FBS teams in\ndefensive EPA this season\n(111th vs pass, 126th vs run)",
    color = col_ref, fill = col_bg, label.size = 0.6,
    size = 3.9, fontface = "bold", hjust = 0, lineheight = 1.05
  ) +
  scale_x_continuous(limits = c(0.55, 4.45), expand = c(0, 0), breaks = NULL) +
  scale_y_continuous(
    limits = c(-0.02, 0.56),
    breaks = seq(0, 0.5, 0.1)
  ) +
  labs(
    title    = "Florida's Defense Hasn't Had a Good Week Yet",
    subtitle = "EPA per play allowed vs. FBS opponents, competitive snaps only (garbage time excluded)",
    x        = NULL,
    y        = "EPA/play allowed",
    caption  = "TheMerrittocracy  ·  Data: cfbfastR play-by-play, garbage time excluded"
  ) +
  theme_merrittocracy_light()

# --- Save ----------------------------------------------------------------

out_dir <- "graphics/week5_cfb_wrapup"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

ggsave(
  filename = file.path(out_dir, "candidate_1.png"),
  plot     = p,
  width    = 1200 / 150,
  height   = 800 / 150,
  dpi      = 150,
  bg       = col_bg
)

message("Saved: ", file.path(out_dir, "candidate_1.png"))
