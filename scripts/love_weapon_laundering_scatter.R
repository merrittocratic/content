# ============================================================================
# content/scripts/love_weapon_laundering_scatter.R
#
# All-positions scatter: first-round Boom Rate (x) vs Avg 4-Year AV (y).
# RB and WR/TE highlighted; other positions greyed out for context.
# Companion graphic for the "Stop calling him a weapon" piece. Reusable
# template for subsequent positional-value pieces (highlight different
# positions per piece).
#
# Output: content/graphics/love_weapon_laundering_scatter.png
# ============================================================================

library(ggplot2)
library(dplyr)
library(ggtext)
library(ggrepel)
library(glue)

# data ------------------------------------------------------------------------
dat <- tibble::tribble(
  ~pos,    ~boom, ~bust, ~av,   ~highlight,
  "WR/TE", 25.4,  22.4,  22.2,  "wr_te",
  "OL",    18.2,  18.2,  26.3,  "other",
  "RB",    22.6,  22.6,  29.1,  "rb",
  "S",     17.2,  17.2,  20.9,  "other",
  "DL",    21.4,  23.9,  22.7,  "other",
  "QB",    20.5,  25.0,  32.5,  "qb",
  "CB",    18.6,  27.1,  19.6,  "other",
  "LB",    23.3,  32.6,  27.8,  "other"
)

# colors ----------------------------------------------------------------------
col_wr    <- "#1F77B4"   # blue
col_rb    <- "#D95F02"   # burnt orange
col_qb    <- "grey50"    # labeled but de-emphasized (volume artifact)
col_other <- "grey72"

dat <- dat |>
  mutate(
    dot_color = case_when(
      highlight == "rb"    ~ col_rb,
      highlight == "wr_te" ~ col_wr,
      highlight == "qb"    ~ col_qb,
      TRUE                 ~ col_other
    ),
    label_color = case_when(
      highlight == "rb"    ~ col_rb,
      highlight == "wr_te" ~ col_wr,
      highlight == "qb"    ~ col_qb,
      TRUE                 ~ "grey35"
    ),
    dot_size   = ifelse(highlight %in% c("rb", "wr_te"), 6.5, 4.5),
    label_face = ifelse(highlight %in% c("rb", "wr_te"), "bold", "plain"),
    label_size = ifelse(highlight %in% c("rb", "wr_te"), 4.8, 4.0),
    # augment QB label with volume-artifact caveat
    label_text = ifelse(pos == "QB", "QB*", pos)
  )

# plot ------------------------------------------------------------------------
p <- ggplot(dat, aes(x = boom, y = av)) +
  geom_point(aes(size = dot_size, color = dot_color)) +
  geom_text_repel(
    aes(label = label_text, color = label_color,
        fontface = label_face, size = label_size),
    point.padding     = 0.7,
    box.padding       = 0.5,
    min.segment.length = 0.4,
    segment.color     = "grey70",
    segment.size      = 0.3,
    seed              = 42
  ) +
  scale_color_identity() +
  scale_size_identity() +
  scale_x_continuous(
    name   = "First-Round Boom Rate (%)",
    expand = expansion(mult = c(0.08, 0.08)),
    breaks = scales::pretty_breaks(n = 6)
  ) +
  scale_y_continuous(
    name   = "Avg 4-Year Career AV",
    expand = expansion(mult = c(0.08, 0.12)),
    breaks = scales::pretty_breaks(n = 6)
  ) +
  labs(
    title = "First-Round Ceiling: RB Outproduces Every Non-QB Position",
    subtitle = glue(
      "<span style='color:{col_wr};'>**WR/TE**</span> and ",
      "<span style='color:{col_rb};'>**RB**</span> sit in the same boom-rate ",
      "neighborhood &mdash; but when RB hits, it hits harder."
    ),
    caption = paste(
      "Source: Pro Football Reference. First-round picks, 2006\u20132020. 4-year AV window.",
      "*QB AV inflated by per-snap accumulation; not directly comparable to non-QB positions.",
      sep = "\n"
    )
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title            = element_text(face = "bold", size = 17,
                                         margin = margin(b = 4)),
    plot.subtitle         = element_markdown(size = 11.5, margin = margin(b = 20),
                                             lineheight = 1.3),
    plot.caption          = element_text(color = "grey40", hjust = 0, size = 9,
                                         margin = margin(t = 14), lineheight = 1.2),
    plot.caption.position = "plot",
    plot.title.position   = "plot",
    axis.title            = element_text(color = "grey25", size = 10.5),
    axis.title.x          = element_text(margin = margin(t = 10)),
    axis.title.y          = element_text(margin = margin(r = 10)),
    axis.text             = element_text(color = "grey45", size = 9.5),
    panel.grid.minor      = element_blank(),
    panel.grid.major      = element_line(color = "grey93"),
    plot.margin           = margin(20, 24, 15, 20)
  )

# save ------------------------------------------------------------------------
ggsave(
  filename = "graphics/love_weapon_laundering_scatter.png",
  plot     = p,
  width    = 9,
  height   = 6.5,
  dpi      = 300,
  bg       = "white"
)
