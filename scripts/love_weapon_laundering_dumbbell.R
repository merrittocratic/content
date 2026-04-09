# ============================================================================
# content/scripts/love_weapon_laundering_dumbbell.R
#
# RB vs WR/TE dumbbell comparison across Boom%, Bust%, and Avg 4-Yr AV.
# Companion graphic for the "Stop calling him a weapon" piece.
#
# Output: content/graphics/love_weapon_laundering_dumbbell.png
# ============================================================================

library(ggplot2)
library(dplyr)
library(ggtext)
library(glue)

# data ------------------------------------------------------------------------
# source: content/scripts/downs_positional_value_table.R (first-round picks,
# 2006-2020 classes, 4-year AV window)
dat <- tibble::tribble(
  ~metric,  ~metric_label,         ~wr_te, ~rb,
  "boom",   "Boom Rate (%)",       25.4,   22.6,
  "bust",   "Bust Rate (%)",       22.4,   22.6,
  "av",     "Avg 4-Year AV",       22.2,   29.1
) |>
  mutate(
    metric_label = factor(
      metric_label,
      levels = c("Boom Rate (%)", "Bust Rate (%)", "Avg 4-Year AV")
    ),
    # put labels on the OUTSIDE of each dumbbell so tied values (bust row) don't
    # collide. left_ = leftmost dot on the line, right_ = rightmost.
    left_val    = pmin(wr_te, rb),
    right_val   = pmax(wr_te, rb),
    left_color  = ifelse(wr_te <= rb, "#1F77B4", "#D95F02"),
    right_color = ifelse(wr_te <= rb, "#D95F02", "#1F77B4"),
    # gap annotation spells the story out in plain English
    gap_label = case_when(
      metric == "boom" ~ "WR/TE +2.8 pts",
      metric == "bust" ~ "Dead even",
      metric == "av"   ~ "RB +6.9 AV"
    )
  )

# colors ----------------------------------------------------------------------
col_wr   <- "#1F77B4"   # blue
col_rb   <- "#D95F02"   # burnt orange
col_line <- "grey70"

# plot ------------------------------------------------------------------------
p <- ggplot(dat, aes(y = metric_label)) +
  geom_segment(
    aes(x = wr_te, xend = rb, yend = metric_label),
    color     = col_line,
    linewidth = 1.2
  ) +
  geom_point(aes(x = wr_te), color = col_wr, size = 6) +
  geom_point(aes(x = rb),    color = col_rb, size = 6) +
  # outside value labels
  geom_text(
    aes(x = left_val, label = sprintf("%.1f", left_val), color = left_color),
    hjust = 1.4, size = 4, fontface = "bold"
  ) +
  geom_text(
    aes(x = right_val, label = sprintf("%.1f", right_val), color = right_color),
    hjust = -0.4, size = 4, fontface = "bold"
  ) +
  # gap annotation beneath each dumbbell
  geom_text(
    aes(x = (wr_te + rb) / 2, label = gap_label),
    vjust = 3, size = 3.3, color = "grey35", fontface = "italic"
  ) +
  scale_color_identity() +
  scale_x_continuous(expand = expansion(mult = c(0.15, 0.15))) +
  facet_wrap(~ metric_label, scales = "free_x", ncol = 1, strip.position = "top") +
  labs(
    title = "First-Round RBs vs WR/TEs: Same Risk, Higher Ceiling",
    subtitle = glue(
      "<span style='color:{col_wr};'>**WR/TE**</span> ",
      "vs ",
      "<span style='color:{col_rb};'>**RB**</span> ",
      "&nbsp;|&nbsp; Draft classes 2006–2020 &nbsp;|&nbsp; 4-year Career AV"
    ),
    caption = paste(
      "Source: Pro Football Reference.",
      "Boom = std. residual > 1. Bust = std. residual < -1.",
      "AV adjusted for draft position."
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title         = element_text(face = "bold", size = 17, margin = margin(b = 4)),
    plot.subtitle      = element_markdown(size = 11, margin = margin(b = 18)),
    plot.caption       = element_text(color = "grey40", hjust = 0, size = 9,
                                      margin = margin(t = 12)),
    plot.caption.position = "plot",
    plot.title.position   = "plot",
    strip.text         = element_text(face = "bold", size = 11.5, hjust = 0,
                                      margin = margin(b = 6)),
    strip.placement    = "outside",
    axis.title         = element_blank(),
    axis.text.y        = element_blank(),
    axis.text.x        = element_text(color = "grey50", size = 9),
    panel.grid.minor   = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "grey92"),
    panel.spacing.y    = unit(2.2, "lines"),
    plot.margin        = margin(20, 20, 15, 20)
  )

# save ------------------------------------------------------------------------
ggsave(
  filename = "graphics/love_weapon_laundering_dumbbell.png",
  plot     = p,
  width    = 8,
  height   = 6.5,
  dpi      = 300,
  bg       = "white"
)
