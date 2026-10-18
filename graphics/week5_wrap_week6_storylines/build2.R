# build2.R -- week5_wrap_week6_storylines (repo: boxscore-prophet)
# Additional candidates 5-7, covering non-fantasy angles supplied directly by
# Steve's data packet (public nflverse/NGS/FTN numbers; see candidates.md).
# Does NOT touch candidates 1-4 or build.R.
# Run from repo root: Rscript graphics/week5_wrap_week6_storylines/build2.R

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(ggtext)
library(patchwork)
library(tibble)

out_dir <- "graphics/week5_wrap_week6_storylines"

col_bg <- "#FFFFFF"; col_grid <- "#EEEEEE"; col_text <- "#1A1A1A"
col_sub <- "#666666"; col_blue <- "#3A7CA5"; col_red <- "#C0392B"
col_gold <- "#B8860B"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background  = element_rect(fill = col_bg, color = NA),
      panel.background = element_rect(fill = col_bg, color = NA),
      panel.grid.major = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text        = element_text(color = col_sub, size = 9),
      axis.title       = element_text(color = col_text, size = 10),
      plot.title       = element_text(color = col_text, face = "bold", size = 15,
                                      margin = margin(b = 4)),
      plot.subtitle    = element_text(color = col_sub, size = 10,
                                      margin = margin(b = 10)),
      plot.caption     = element_text(color = col_sub, size = 8, hjust = 0,
                                      margin = margin(t = 10)),
      strip.text       = element_text(color = col_text, face = "bold", size = 10),
      legend.position  = "none",
      plot.margin      = margin(14, 20, 10, 14)
    )
}

patch_theme <- theme(
  plot.background = element_rect(fill = col_bg, color = NA),
  plot.title      = element_text(color = col_text, face = "bold", size = 15),
  plot.subtitle   = element_text(color = col_sub, size = 9.5),
  plot.caption    = element_text(color = col_sub, size = 8, hjust = 0),
  plot.margin     = margin(14, 20, 10, 14)
)

save_chart <- function(p, n) {
  ggsave(file.path(out_dir, glue("candidate_{n}.png")), p,
         width = 1200 / 150, height = 800 / 150, dpi = 150, bg = col_bg)
}

# --- Candidate 5: Harrison's target share and catchable-target rate, by season
# Source: Steve's data packet (public) -- target share via nflverse/nflreadr;
# catchable-target rate via FTN charting (nflverse). "Raising Arizona" section.

ts_df <- tibble(season = factor(c("2024", "2025", "2026")),
                value  = c(22.6, 18.1, 8.3))
cr_df <- tibble(season = factor(c("2024", "2025", "2026")),
                value  = c(68, 65, 46))

pA5 <- ggplot(ts_df, aes(season, value)) +
  geom_col(aes(fill = season == "2026"), width = 0.55) +
  geom_text(aes(label = sprintf("%.1f%%", value)), vjust = -0.6,
            fontface = "bold", size = 3.8, color = col_text) +
  scale_fill_manual(values = c(`TRUE` = col_red, `FALSE` = col_blue), guide = "none") +
  scale_y_continuous(limits = c(0, 26), expand = c(0, 0)) +
  labs(title = "Target share", x = NULL, y = "Share of team targets") +
  theme_merrittocracy_light() +
  theme(plot.title = element_text(size = 11, face = "bold", color = col_text))

pB5 <- ggplot(cr_df, aes(season, value)) +
  geom_col(aes(fill = season == "2026"), width = 0.55) +
  geom_text(aes(label = sprintf("%.0f%%", value)), vjust = -0.6,
            fontface = "bold", size = 3.8, color = col_text) +
  geom_hline(yintercept = 74, color = col_gold, linewidth = 0.5, linetype = "dashed") +
  annotate("text", x = 0.55, y = 77, label = "League rate ~74%",
           hjust = 0, size = 3, color = col_gold, fontface = "italic") +
  scale_fill_manual(values = c(`TRUE` = col_red, `FALSE` = col_blue), guide = "none") +
  scale_y_continuous(limits = c(0, 84), expand = c(0, 0)) +
  labs(title = "Catchable-target rate", x = NULL, y = "Share graded catchable") +
  theme_merrittocracy_light() +
  theme(plot.title = element_text(size = 11, face = "bold", color = col_text))

p5 <- (pA5 + pB5) +
  plot_annotation(
    title = "Harrison's Targets Didn't Just Shrink. They Got Worse.",
    subtitle = "Marvin Harrison Jr.'s target share and the share of those targets FTN graded catchable,\nby season. Red = 2026, through 4 games.",
    caption = "TheMerrittocracy  \u00b7  Target share via nflverse/nflreadr; catchable-target rate via FTN charting\n(nflverse). 2026: 13 targets in 4 games, 65-79% snap share every week.",
    theme = patch_theme
  )
save_chart(p5, 5)

# --- Candidate 6: Washington's 43 seconds vs. the league --------------------
# Source: Steve's data packet (public nflverse play-by-play timing).
# "I Can't Unsee That" section.

clock_df <- tibble(
  label     = c("League median (n=63)", "League 90th pct (n=63)",
                "Washington vs. Giants, Wk 5 OT"),
  seconds   = c(16, 25, 43),
  highlight = c(FALSE, FALSE, TRUE)
) |>
  mutate(label = factor(label, levels = rev(label)))

p6 <- ggplot(clock_df, aes(label, seconds, fill = highlight)) +
  geom_col(width = 0.55) +
  geom_text(aes(label = paste0(seconds, "s")), hjust = -0.25,
            fontface = "bold", size = 4.2, color = col_text) +
  scale_fill_manual(values = c(`TRUE` = col_red, `FALSE` = col_blue)) +
  scale_y_continuous(limits = c(0, 50), expand = c(0, 0)) +
  coord_flip(clip = "off") +
  labs(
    title = "43 Seconds: The Slowest Snap in Three Seasons",
    subtitle = glue(
      "Time to the next snap after an in-bounds catch or run, tied or trailing by 8 or less,\n",
      "20-70 seconds left, no timeouts, 2024-2026 (n = 63).\n",
      "Washington's gap after Rachaad White's 2-yard run put the ball at the Giants' 24 with 0:55\n",
      "left; the next snap came at 0:12 -- Daniels was sacked, time expired."
    ),
    x = NULL, y = "Seconds between snaps",
    caption = glue(
      "TheMerrittocracy  \u00b7  Play-clock timing via nflverse play-by-play. Washington's 43 seconds was the\n",
      "longest of all 63 comparable situations; league-wide, the next play was a spike 57% of the time."
    )
  ) +
  theme_merrittocracy_light() +
  theme(
    axis.text.y = element_text(size = 10, color = col_text, face = "bold"),
    plot.subtitle = element_text(size = 9.3, margin = margin(b = 12)),
    plot.margin = margin(14, 42, 10, 14)
  )
save_chart(p6, 6)

# --- Candidate 7: Houston's Pythagorean gap + Stroud's late-game drop -------
# Source: Steve's data packet (public nflverse). "Deserve Has Got Nothin' To
# Do With It" section.

wins_df <- tibble(
  team = factor(c("Houston", "Houston", "Arizona", "Arizona"),
                levels = c("Houston", "Arizona")),
  type = factor(c("Actual", "Pythagorean\nexpected", "Actual", "Pythagorean\nexpected"),
                levels = c("Actual", "Pythagorean\nexpected")),
  wins = c(1, 2.45, 1, 1.4)
)

pA7 <- ggplot(wins_df, aes(team, wins, fill = type)) +
  geom_col(position = position_dodge(width = 0.62), width = 0.56) +
  geom_text(aes(label = sprintf("%.2f", wins)),
            position = position_dodge(width = 0.62), vjust = -0.6,
            fontface = "bold", size = 3.5, color = col_text) +
  scale_fill_manual(values = c(Actual = col_red, `Pythagorean\nexpected` = col_blue),
                     name = NULL) +
  scale_y_continuous(limits = c(0, 3.3), expand = c(0, 0)) +
  annotate("text", x = 0.62, y = 3.05, label = "-1.45: biggest shortfall in the NFL",
           hjust = 0, color = col_red, fontface = "italic", size = 3.1) +
  labs(title = "Wins: actual vs. expected", x = NULL, y = "Wins through Week 5") +
  theme_merrittocracy_light() +
  theme(
    plot.title = element_text(size = 11, face = "bold", color = col_text),
    legend.position = "top", legend.text = element_text(size = 8.5)
  )

epa_df <- tibble(
  segment = factor(c("Qtrs 1-3", "4th qtr + OT"), levels = c("Qtrs 1-3", "4th qtr + OT")),
  epa     = c(0.164, 0.031)
)

pB7 <- ggplot(epa_df, aes(segment, epa, fill = segment)) +
  geom_col(width = 0.5) +
  geom_text(aes(label = sprintf("%.3f", epa)), vjust = -0.6,
            fontface = "bold", size = 3.8, color = col_text) +
  scale_fill_manual(values = c(`Qtrs 1-3` = col_blue, `4th qtr + OT` = col_red)) +
  scale_y_continuous(limits = c(0, 0.22), expand = c(0, 0)) +
  labs(title = "Stroud's EPA per play", x = NULL, y = "EPA per play") +
  theme_merrittocracy_light() +
  theme(plot.title = element_text(size = 11, face = "bold", color = col_text))

p7 <- (pA7 + pB7) +
  plot_annotation(
    title = "Unlucky, But Not Only Unlucky",
    subtitle = "Houston's point differential implies 2.45 wins through five games; they have one, the NFL's\nbiggest Pythagorean shortfall. Stroud's own efficiency fades when it matters most.",
    caption = "TheMerrittocracy  \u00b7  Pythagorean win expectation from points scored/allowed; Stroud EPA per play by game segment, via nflverse.",
    theme = patch_theme
  )
save_chart(p7, 7)

cat("done\n")
