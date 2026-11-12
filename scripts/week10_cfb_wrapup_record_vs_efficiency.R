# ============================================================================
# week10_cfb_wrapup_record_vs_efficiency.R
#
# Graphic for draft/week10_cfb_wrapup.md ("Life Is A Game Of Inches").
# Section: "You Can't Handle The Truth!" -- callback to the "Kansas" piece's
# record-vs-computers argument.
#
# Dumbbell: each team's CFP rank (Nov. 3 release, entering Week 10) against
# its net EPA rank through Week 10. Net EPA = offensive EPA per play minus
# defensive EPA per play allowed, garbage time excluded, ranked out of 138
# FBS teams.
#
# Expected (Week 10 data packet): Kentucky 6th in the CFP rankings vs 58th in
# net EPA (the long "record lying" bar); LSU 14th vs 3rd (the long bar the
# other way); Alabama 5th vs 12th; Georgia 2nd vs 1st; Ohio State 12th vs 14th.
#
# Data: ranks are typed in from the Week 10 data packet, which computes net
# EPA on the corrected 2026 play order; a raw cfbfastR pull lands a few spots
# off, so the packet's numbers are used as published in the article. Only the
# five teams with packet net EPA ranks are shown.
#
# Output: graphics/week10_cfb_wrapup/record_vs_efficiency.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)

out_path <- "graphics/week10_cfb_wrapup/record_vs_efficiency.png"

ranks <- tibble::tribble(
  ~team,        ~cfp, ~net_epa, ~result,
  "Georgia",       2,        1, "W 42-7 at Ole Miss",
  "Alabama",       5,       12, "W 31-13 at LSU",
  "Kentucky",      6,       58, "L 6-34 vs. Tennessee",
  "Ohio State",   12,       14, "L 28-41 vs. Oregon",
  "LSU",          14,        3, "L 13-31 vs. Alabama"
) |>
  mutate(
    dir   = if_else(net_epa > cfp, "worse", "better"),
    label = paste0("**", team, "**<br><span style='color:#666666;font-size:8pt;'>",
                   result, "</span>"),
    label = factor(label, levels = rev(label))   # CFP order, top to bottom
  )

# --- Palette (house light theme) ---------------------------------------------

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_better  <- "#3A7CA5"   # steel blue -- numbers better than the ranking
col_worse   <- "#C0392B"   # red -- numbers worse than the ranking
col_cfp     <- "#1A1A1A"   # CFP rank: open circle

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
# CFP numbers sit above each row and net EPA numbers below (the segments are
# horizontal at the row's y), so no label touches a line and close pairs
# (Georgia 2/1, Ohio State 12/14) don't collide.

p <- ggplot(ranks, aes(y = label)) +
  geom_segment(aes(x = cfp, xend = net_epa, yend = label, color = dir),
               linewidth = 2.2, alpha = 0.55) +
  geom_point(aes(x = cfp), shape = 21, fill = col_bg, color = col_cfp,
             size = 4, stroke = 1.2) +
  geom_point(aes(x = net_epa, color = dir), size = 4.2) +
  geom_text(aes(x = cfp, label = cfp), color = col_cfp, size = 3,
            nudge_y = 0.3, fontface = "bold") +
  geom_text(aes(x = net_epa, label = net_epa, color = dir), size = 3,
            nudge_y = -0.3, fontface = "bold") +
  scale_color_manual(values = c(better = col_better, worse = col_worse)) +
  scale_x_continuous(breaks = c(1, 10, 20, 30, 40, 50, 60),
                     limits = c(0, 62), expand = expansion(add = c(1, 1))) +
  labs(
    title    = "Kentucky's record was lying. LSU's wasn't telling the whole truth.",
    subtitle = paste0("Open circle, number above: CFP rank entering Week 10 (Nov. 3). ",
                      "Solid, number below: net EPA rank through Week 10.\n",
                      "Red: the numbers rate the team worse than the committee. ",
                      "Blue: better."),
    x        = "Rank (1 = best)",
    y        = NULL,
    caption  = paste0("TheMerrittocracy · Data via cfbfastR and the College ",
                      "Football Data API. Net EPA = offensive EPA per play minus ",
                      "defensive EPA per play allowed,\ngarbage time excluded, ",
                      "ranked out of 138 FBS teams. CFP ranks from the Nov. 3 release.")
  ) +
  theme_merrittocracy_light() +
  theme(
    axis.text.y.left   = ggtext::element_markdown(color = col_text, size = 10,
                                                  hjust = 1, lineheight = 1.1),
    panel.grid.major.y = element_blank(),
    # title, subtitle and caption align to the whole plot, not the panel the
    # team labels push right, so they don't clip
    plot.title.position   = "plot",
    plot.caption.position = "plot"
  )

ggsave(filename = out_path, plot = p, width = 1200 / 150, height = 800 / 150,
       dpi = 150, bg = col_bg)
cat("wrote", out_path, "\n")
