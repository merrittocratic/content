# ============================================================================
# week5_cfb_wrapup_florida_offense_scatter.R
#
# Candidate 2 (standard) for draft/week5_cfb_wrapup.md ("Records Are Cheap").
# Section: "Florida Didn't Get Unlucky. It Got Run Over."
#
# Florida's offensive EPA/play vs. the opponent's SP+ defensive rank
# through Week 4 -- the offense is real against soft defenses and
# disappears against good ones.
#
# Data (verified against Steve's data packet, matches article text exactly):
#   Florida Atlantic 106th / 0.340; Ole Miss 75th / 0.343;
#   Auburn 16th / 0.082; Missouri 14th / -0.176
#   Season-long offense ranks 17th in EPA: 4th passing, 79th rushing.
#
# House theme: theme_merrittocracy_light(), copied from
# scripts/trust_but_verify_sample_size_funnel.R (lines 69-96), per Steve's
# course correction to a white-background house standard for charts.
#
# Output: graphics/week5_cfb_wrapup/candidate_2.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(ggrepel)
library(glue)

set.seed(42)

# --- Data --------------------------------------------------------------------

off_data <- tibble::tribble(
  ~opponent,          ~def_rank, ~off_epa,
  "Florida Atlantic",  106,       0.340,
  "Ole Miss",          75,        0.343,
  "Auburn",            16,        0.082,
  "Missouri",          14,       -0.176
)

# --- Palette (house light theme, matches trust_but_verify_sample_size_funnel.R) --

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"   # steel blue -- reference trend
col_flag    <- "#C0392B"   # red -- data points
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

# --- Plot ----------------------------------------------------------------

p <- ggplot(off_data, aes(x = def_rank, y = off_epa)) +
  geom_hline(yintercept = 0, color = col_text, linewidth = 1.1) +
  geom_point(color = col_flag, size = 6) +
  geom_point(color = col_bg, size = 2.2) +
  geom_text_repel(
    aes(label = glue("{opponent} (SP+ {def_rank}th)\n{sprintf('%+.3f', off_epa)} EPA/play")),
    seed = 42,
    color = col_text,
    size  = 4.0,
    fontface = "bold",
    lineheight = 0.95,
    box.padding = 0.7,
    point.padding = 0.35,
    segment.color = col_subtext,
    min.segment.length = 0.3,
    force = 3
  ) +
  scale_x_reverse(
    limits = c(115, 5),
    breaks = seq(20, 100, 20),
    labels = function(x) paste0(x, "th")
  ) +
  scale_y_continuous(
    limits = c(-0.25, 0.45),
    breaks = seq(-0.2, 0.4, 0.1)
  ) +
  labs(
    title    = "Florida's Offense Is Real -- Until the Defense Is",
    subtitle = "EPA/play by opponent's SP+ defense rank through Week 4\n(rank 1 = best defense)",
    x        = "Opponent SP+ defense rank",
    y        = "Florida offense EPA/play",
    caption  = glue(
      "TheMerrittocracy  ·  Data: cfbfastR play-by-play; SP+ through Week 4\n",
      "Season-long: Florida ranks 17th nationally in offensive EPA (4th passing, 79th rushing)"
    )
  ) +
  theme_merrittocracy_light()

# --- Save ----------------------------------------------------------------

out_dir <- "graphics/week5_cfb_wrapup"
if (!dir.exists(out_dir)) dir.create(out_dir, recursive = TRUE)

ggsave(
  filename = file.path(out_dir, "candidate_2.png"),
  plot     = p,
  width    = 1200 / 150,
  height   = 800 / 150,
  dpi      = 150,
  bg       = col_bg
)

message("Saved: ", file.path(out_dir, "candidate_2.png"))
