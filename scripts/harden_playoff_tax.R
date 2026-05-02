# ============================================================================
# harden_playoff_tax.R
#
# "The Playoff Tax: James Harden Regular Season vs. Playoffs"
# Assist-to-turnover ratio and points per game, 2012-13 through 2025-26
#
# Data: manually entered from Basketball Reference
# IMPORTANT: Verify all values at basketball-reference.com/players/h/hardeja01.html
#            before publishing. Seasons marked VERIFY are estimates.
#
# Packages: ggplot2, dplyr, tibble, patchwork
#   install.packages(c("ggplot2", "dplyr", "tibble", "patchwork"))
#
# Output: content/graphics/harden_playoff_tax.png (1200x800px)
# ============================================================================

library(ggplot2)
library(dplyr)
library(tibble)
library(patchwork)

# ── 1. Data ──────────────────────────────────────────────────────────────────
# season:     label shown on x-axis
# ppg:        points per game
# ast:        assists per game
# tov:        turnovers per game
# playoff_gp: games played in playoffs (NA = no playoffs / unknown)
#
# Small-sample threshold: fewer than 5 playoff games → bar marked with "*"
# Seasons with NA playoff values are omitted from the PO series entirely.

rs_raw <- tribble(
  ~season,  ~ppg,  ~ast,  ~tov,
  "12-13",  25.9,   5.8,   3.8,
  "13-14",  25.4,   6.1,   3.7,
  "14-15",  27.4,   7.0,   4.1,
  "15-16",  29.0,   7.5,   5.7,
  "16-17",  29.1,  11.2,   5.7,
  "17-18",  30.4,   8.8,   4.4,
  "18-19",  36.1,   7.5,   5.0,
  "19-20",  34.3,   7.4,   4.5,   # COVID-shortened; HOU only
  "20-21",  24.6,  10.4,   4.8,   # split HOU / BKN
  "21-22",  22.5,  10.0,   4.0,   # split BKN / PHI
  "22-23",  21.0,  10.7,   3.4,
  "23-24",  16.6,   8.5,   2.8,
  "24-25",  22.8,   8.7,   4.3,   # VERIFY — check final BBRef totals
  "25-26",  23.6,   8.0,   3.5    # VERIFY — season in progress as of Apr 2026
)

po_raw <- tribble(
  ~season,  ~ppg,  ~ast,  ~tov,  ~playoff_gp,
  "12-13",  25.7,   6.1,   4.3,   12L,
  "13-14",  17.2,   4.0,   3.6,    5L,  # SMALL SAMPLE — lost R1 in 5 games vs POR
  "14-15",  28.7,   7.1,   5.1,   22L,
  "15-16",  21.9,   6.2,   4.6,    5L,  # SMALL SAMPLE — lost R1 in 5 games vs GSW
  "16-17",  25.8,   8.0,   6.0,   11L,
  "17-18",  28.6,   5.7,   4.1,   19L,
  "18-19",  35.6,   6.7,   5.2,    6L,
  "19-20",  28.3,   7.6,   5.5,   12L,  # bubble
  "20-21",  22.5,   8.9,   5.8,    8L,  # BKN; Harden injured vs MIL
  "21-22",  18.6,   8.6,   3.6,   12L,  # PHI; VERIFY exact stats
  "22-23",  22.1,  10.0,   3.0,   12L,  # PHI; VERIFY game count
  "23-24",  13.5,   7.2,   2.8,    6L,  # LAC vs DAL R1; VERIFY
  "24-25",  18.7,   9.1,   3.0,   7L,  # VERIFY — check if LAC made playoffs
  "25-26",  21.8,   6.5,   6.0,     4L   # Playoffs not yet played
)

# ── 2. Combine and compute derived columns ────────────────────────────────────
rs <- rs_raw %>%
  mutate(
    context      = "Regular Season",
    at_ratio     = tov / ast,
    playoff_gp   = NA_integer_,
    small_sample = FALSE
  )

po <- po_raw %>%
  mutate(
    context      = "Playoffs",
    at_ratio     = if_else(!is.na(ast) & !is.na(tov), tov / ast, NA_real_),
    small_sample = !is.na(playoff_gp) & playoff_gp < 5
  ) %>%
  filter(!is.na(ppg))  # drop seasons with no playoff data

# Season factor — preserve chronological order
season_levels <- rs_raw$season

combined <- bind_rows(rs, po) %>%
  mutate(
    season  = factor(season, levels = season_levels),
    context = factor(context, levels = c("Regular Season", "Playoffs"))
  )

# ── 3. Identify worst-offender seasons for annotation ────────────────────────
# "Worst offender" = largest positive gap (RS − PO) on each metric
gaps <- rs %>%
  select(season, rs_ppg = ppg, rs_atr = at_ratio) %>%
  inner_join(
    po %>% filter(!small_sample) %>% select(season, po_ppg = ppg, po_atr = at_ratio),
    by = "season"
  ) %>%
  mutate(
    gap_ppg = rs_ppg - po_ppg,
    gap_atr = po_atr - rs_atr   # positive = PO worse (higher T/A in playoffs)
  )

# Both annotations pinned to 25-26: the struggle continues narrative
annot_season  <- "25-26"
annot_season_x <- as.numeric(factor(annot_season, levels = season_levels))
annot_x_label  <- annot_season_x - 0.6   # shift left so label doesn't clip the edge

annot_ppg <- inner_join(
  rs %>% select(season, rs_ppg = ppg),
  po %>% select(season, po_ppg = ppg),
  by = "season"
) %>%
  filter(season == annot_season) %>%
  mutate(gap_ppg = rs_ppg - po_ppg)

annot_tar <- inner_join(
  rs %>% select(season, rs_atr = at_ratio),
  po %>% select(season, po_atr = at_ratio),
  by = "season"
) %>%
  filter(season == annot_season) %>%
  mutate(gap_atr = po_atr - rs_atr)

# ── 4. Palette & theme ────────────────────────────────────────────────────────
col_rs       <- "#4A9EBF"   # steel blue  — Regular Season bars
col_po       <- "#E07B39"   # burnt orange — Playoffs bars + trend line
col_bg       <- "#111118"   # near-black background
col_panel    <- "#1A1A26"   # slightly lighter panel fill
col_grid     <- "#2A2A3E"   # subtle grid lines
col_text     <- "#E0E0EE"   # primary text
col_subtext  <- "#9090AA"   # captions / secondary labels
col_annot    <- "#FFD166"   # annotation arrow + label

theme_merrittocracy_dark <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major.y = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.major.x = element_blank(),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.text.x        = element_text(angle = 45, hjust = 1, size = 9),
      axis.title         = element_text(color = col_text, size = 10),
      plot.title         = element_text(color = col_text,    face = "bold",
                                        size = 15, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 10,
                                        margin = margin(b = 10)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 8)),
      legend.position    = "top",
      legend.background  = element_rect(fill = col_bg, color = NA),
      legend.text        = element_text(color = col_text, size = 9),
      legend.title       = element_blank(),
      legend.key         = element_rect(fill = col_bg, color = NA),
      plot.margin        = margin(14, 18, 10, 14),
      strip.text         = element_text(color = col_text, face = "bold", size = 11)
    )
}

# ── 5. Build panel helpers ────────────────────────────────────────────────────
# Playoff-only data for trend line (connected across seasons)
po_trend_ppg <- po %>%
  filter(!small_sample) %>%
  mutate(season = factor(season, levels = season_levels))

po_trend_atr <- po %>%
  filter(!small_sample, !is.na(at_ratio)) %>%
  mutate(season = factor(season, levels = season_levels))

# Small-sample label positions (top of bar + small offset)
ss_ppg <- combined %>%
  filter(context == "Playoffs", small_sample) %>%
  mutate(label_y = ppg + 0.8)

ss_atr <- combined %>%
  filter(context == "Playoffs", small_sample, !is.na(at_ratio)) %>%
  mutate(label_y = at_ratio + 0.04)

# ── 6. Panel 1 — Points Per Game ──────────────────────────────────────────────
p_ppg <- ggplot(
    combined %>% filter(!is.na(ppg)),
    aes(x = season, y = ppg, fill = context)
  ) +

  # Grouped bars
  geom_col(
    aes(alpha = if_else(small_sample, 0.45, 0.85)),
    position = position_dodge(width = 0.7),
    width    = 0.65
  ) +

  # Playoff trend line (excludes small-sample seasons)
  geom_line(
    data     = po_trend_ppg,
    aes(x = as.numeric(season), y = ppg),
    color    = col_po,
    linewidth = 1.1,
    inherit.aes = FALSE
  ) +
  geom_point(
    data     = po_trend_ppg,
    aes(x = as.numeric(season), y = ppg),
    color    = col_po,
    size     = 2.2,
    inherit.aes = FALSE
  ) +

  # Small-sample asterisk
  geom_text(
    data        = ss_ppg,
    aes(x = season, y = label_y, group = context, label = "*"),
    position    = position_dodge(width = 0.7),
    color       = col_annot,
    size        = 4.5,
    inherit.aes = FALSE
  ) +

  # Annotation pinned to 25-26, above the bars
  annotate(
    "segment",
    x     = annot_x_label,
    xend  = annot_x_label,
    y     = max(annot_ppg$rs_ppg, annot_ppg$po_ppg) + 2.0,
    yend  = annot_ppg$po_ppg + 0.5,
    arrow = arrow(length = unit(0.12, "inches"), type = "closed"),
    color = col_annot,
    linewidth = 0.7
  ) +
  annotate(
    "label",
    x        = annot_x_label,
    y        = max(annot_ppg$rs_ppg, annot_ppg$po_ppg) + 5.5,
    label    = paste0("−", round(annot_ppg$gap_ppg, 1), " PPG gap"),
    color    = col_annot,
    fill     = col_panel,
    size     = 3.0,
    fontface = "bold"
  ) +

  scale_fill_manual(
    values = c("Regular Season" = col_rs, "Playoffs" = col_po),
    labels = c("Regular Season", "Playoffs  (* < 5 games)")
  ) +
  scale_alpha_identity() +
  scale_y_continuous(limits = c(0, 42), breaks = seq(0, 40, 10),
                     labels = function(x) paste0(x)) +

  labs(
    title    = "The Playoff Tax: Points Per Game",
    subtitle = "Regular season vs. playoff scoring, 2012-13 through 2025-26",
    x        = NULL,
    y        = "Points Per Game"
  ) +
  theme_merrittocracy_dark()

# ── 7. Panel 2 — Assist-to-Turnover Ratio ────────────────────────────────────
p_atr <- ggplot(
    combined %>% filter(!is.na(at_ratio)),
    aes(x = season, y = at_ratio, fill = context)
  ) +

  geom_col(
    aes(alpha = if_else(small_sample, 0.45, 0.85)),
    position = position_dodge(width = 0.7),
    width    = 0.65
  ) +

  geom_line(
    data     = po_trend_atr,
    aes(x = as.numeric(season), y = at_ratio),
    color    = col_po,
    linewidth = 1.1,
    inherit.aes = FALSE
  ) +
  geom_point(
    data     = po_trend_atr,
    aes(x = as.numeric(season), y = at_ratio),
    color    = col_po,
    size     = 2.2,
    inherit.aes = FALSE
  ) +

  geom_text(
    data        = ss_atr,
    aes(x = season, y = label_y, group = context, label = "*"),
    position    = position_dodge(width = 0.7),
    color       = col_annot,
    size        = 4.5,
    inherit.aes = FALSE
  ) +

  # Annotation pinned to 25-26, above the bars
  annotate(
    "segment",
    x     = annot_x_label,
    xend  = annot_x_label,
    y     = max(annot_tar$rs_atr, annot_tar$po_atr) + 0.08,
    yend  = annot_tar$po_atr + 0.02,
    arrow = arrow(length = unit(0.12, "inches"), type = "closed"),
    color = col_annot,
    linewidth = 0.7
  ) +
  annotate(
    "label",
    x        = annot_x_label,
    y        = max(annot_tar$rs_atr, annot_tar$po_atr) + 0.20,
    label    = paste0("+", round(annot_tar$gap_atr, 2), " T/A gap"),
    color    = col_annot,
    fill     = col_panel,
    size     = 3.0,
    fontface = "bold"
  ) +

  scale_fill_manual(
    values = c("Regular Season" = col_rs, "Playoffs" = col_po),
    labels = c("Regular Season", "Playoffs  (* < 5 games)")
  ) +
  scale_alpha_identity() +
  scale_y_continuous(limits = c(0, 1.5), breaks = seq(0, 1.5, 0.25),
                     labels = function(x) sprintf("%.2f", x)) +

  labs(
    title    = "The Playoff Tax: Turnover-to-Assist Ratio",
    subtitle = "Regular season vs. playoff ball security, 2012-13 through 2025-26",
    x        = NULL,
    y        = "Turnover / Assist",
    caption  = paste0(
      "Data: Basketball Reference  ·  TheMerrittocracy\n",
      "* Playoff bar = fewer than 5 games (small sample)  ·  ",
      "VERIFY: 2024-25 and 2025-26 values before publishing"
    )
  ) +
  theme_merrittocracy_dark()

# ── 8. Combine and save ───────────────────────────────────────────────────────
final <- p_ppg / p_atr +
  plot_layout(guides = "collect") &
  theme(legend.position = "top")

out_path <- "graphics/harden_playoff_tax.png"

ggsave(
  filename = out_path,
  plot     = final,
  width    = 1200 / 150,
  height   =  800 / 150,
  dpi      = 150,
  bg       = col_bg
)

message("Saved: ", out_path)
