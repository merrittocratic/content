# ============================================================================
# nurse_coy_scatter.R
#
# "The Playoff Premium" — Nick Nurse article visual anchor
# Scatter: career regular-season win % vs. career playoff win %
# Population: NBA Coach of the Year winners (modern era, 2000–2026)
#             with at least 20 career playoff games
#
# Data: manually compiled from Basketball Reference
# IMPORTANT: Verify all values before publishing.
#            basketball-reference.com/awards/coy.html
#
# Packages: ggplot2, dplyr, tibble, ggrepel
#   install.packages(c("ggplot2", "dplyr", "tibble", "ggrepel"))
#
# Output: content/graphics/nurse_coy_scatter.png (1200x900px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(ggrepel)

# ── 1. Data ───────────────────────────────────────────────────────────────────
# rs_w:  career regular-season wins
# rs_l:  career regular-season losses
# po_w:  career playoff wins
# po_l:  career playoff losses
# coy:   COY award year(s) — most notable listed
#
# VERIFY all records at Basketball Reference before publishing.
# Records include all seasons through end of 2025-26 where applicable.

coaches <- tribble(
  ~name,                ~coy,    ~rs_w, ~rs_l, ~po_w, ~po_l,
  "Nick Nurse",         "'20",    343,   293,    30,    23,   # BBRef verified
  "Mark Daigneault",    "'24",    275,   207,    26,    11,   # BBRef verified — 2025 NBA Champion
  "Steve Kerr",         "'16",    604,   353,   104,    48,   # verified
  "Gregg Popovich",     "'12/'14", 1390,  824,   170,   114,   # verified career totals
  "Mike Budenholzer",   "'15/'19", 520,   363,    56,    48,   # verified
  "Tom Thibodeau",      "'11/'21", 578,   420,    48,    55,   # verified
  "Monty Williams",     "'22",    381,   404,    29,    27,   # verified
  "Dwane Casey",        "'18",    494,   570,    21,    34,   # verified
  "Mike D'Antoni",      "'05/'17", 672,   527,    54,    56,   # verified
  "Scott Brooks",       "'10",    521,   414,    49,    48,   # verified
  "Rick Carlisle",      "'02",    1012,   923,    86,    87,   # verified
  "George Karl",        "'13",    1175,  824,    80,   105,   # verified career
  "Mike Brown",         "'09/'23", 507,   333,    54,    42,   # verified
  "Doc Rivers",         "'00",    1194,  866,    114,   112,   # VERIFY — no active bench
) %>%
  mutate(
    rs_pct  = rs_w / (rs_w + rs_l),
    po_pct  = po_w / (po_w + po_l),
    po_games = po_w + po_l,
    gap     = po_pct - rs_pct,          # positive = better in playoffs
    is_nurse = name == "Nick Nurse"
  ) %>%
  filter(po_games >= 20)                # minimum meaningful sample

# ── 2. Palette & theme ────────────────────────────────────────────────────────
col_nurse   <- "#C0392B"   # bold red — Nurse highlight
col_other   <- "#2C3E50"   # dark navy — all other coaches
col_above   <- "#27AE60"   # green — "Playoffs > RS" region label
col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_diag    <- "#AAAAAA"   # break-even diagonal

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major   = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.title         = element_text(color = col_text,    size = 10),
      plot.title         = element_text(color = col_text,    face = "bold",
                                        size = 16, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 10,
                                        margin = margin(b = 12)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 10)),
      legend.position    = "none",
      plot.margin        = margin(16, 20, 12, 16)
    )
}

# ── 3. Axis range (padded symmetrically for the diagonal to read cleanly) ─────
axis_min <- 0.35
axis_max <- 0.80

# ── 4. Plot ───────────────────────────────────────────────────────────────────
p <- ggplot(coaches, aes(x = rs_pct, y = po_pct)) +

  # Break-even diagonal — where PO win% = RS win%
  geom_abline(slope = 1, intercept = 0,
              color = col_diag, linewidth = 0.5, linetype = "dashed", alpha = 0.4) +

  # Region labels flanking the diagonal
  annotate("text", x = 0.72, y = 0.67,
           label = "RS > Playoffs", color = col_subtext,
           size = 3.2, angle = 35, alpha = 0.9) +
  annotate("text", x = 0.60, y = 0.72,
           label = "Playoffs > RS", color = col_above,
           size = 3.2, angle = 35, alpha = 1.0) +

  # All other coaches
  geom_point(
    data   = filter(coaches, !is_nurse),
    color  = col_other, size = 3.5, alpha = 0.75
  ) +

  # Nurse — larger, highlighted
  geom_point(
    data   = filter(coaches, is_nurse),
    color  = col_nurse, size = 5.5, alpha = 1
  ) +

  # Labels for all coaches (ggrepel)
  geom_label_repel(
    aes(
      label = paste0(name, "\n(COY ", coy, ")"),
      color = if_else(is_nurse, col_nurse, col_other),
      fill  = col_bg
    ),
    size          = 2.8,
    seed          = 42,
    box.padding   = 0.5,
    point.padding = 0.3,
    label.size    = 0.25,
    label.r       = unit(0.1, "lines"),
    show.legend   = FALSE,
    max.overlaps  = Inf,
    segment.color = col_subtext,
    segment.alpha = 0.6
  ) +

  # Nurse gap callout — vertical segment from diagonal up to Nurse's PO%
  annotate(
    "segment",
    x    = filter(coaches, is_nurse)$rs_pct,
    xend = filter(coaches, is_nurse)$rs_pct,
    y    = filter(coaches, is_nurse)$rs_pct,
    yend = filter(coaches, is_nurse)$po_pct - 0.01,
    color = col_nurse, linewidth = 0.9,
    arrow = arrow(length = unit(0.10, "inches"), type = "closed")
  ) +
  # Label placed directly above the Nick Nurse ggrepel callout
  annotate(
    "label",
    x        = filter(coaches, is_nurse)$rs_pct - 0.03,
    y        = filter(coaches, is_nurse)$po_pct + 0.09,
    label    = paste0("+", round(filter(coaches, is_nurse)$gap * 100, 1), " pts\nplayoff premium"),
    color    = col_nurse,
    fill     = col_bg,
    size     = 3.0,
    fontface = "bold"
  ) +

  scale_color_identity() +
  scale_fill_identity() +
  scale_x_continuous(
    limits = c(axis_min, axis_max),
    breaks = seq(0.35, 0.80, 0.05),
    labels = function(x) paste0(round(x * 100), "%")
  ) +
  scale_y_continuous(
    limits = c(axis_min, axis_max),
    breaks = seq(0.35, 0.80, 0.05),
    labels = function(x) paste0(round(x * 100), "%")
  ) +

  labs(
    title    = "The Playoff Premium",
    subtitle = "Career regular-season win % vs. career playoff win % — NBA Coach of the Year winners (2000–2026, min. 20 playoff games)\nDashed line = break-even. Above the line: playoffs > regular season.",
    x        = "Career Regular-Season Win %",
    y        = "Career Playoff Win %",
    caption  = "Data: Basketball Reference  ·  TheMerrittocracy"
  ) +
  theme_merrittocracy_light()

# ── 5. Save ───────────────────────────────────────────────────────────────────
out_path <- "graphics/nurse_coy_scatter.png"

ggsave(
  filename = out_path,
  plot     = p,
  width    = 1200 / 150,
  height   =  900 / 150,
  dpi      = 150,
  bg       = "#FFFFFF"
)

message("Saved: ", out_path)
message("\nNurse gap: ", round(filter(coaches, is_nurse)$gap * 100, 1), " percentage points above break-even")
message("Coaches plotted: ", nrow(filter(coaches, !is.na(rs_pct))))
