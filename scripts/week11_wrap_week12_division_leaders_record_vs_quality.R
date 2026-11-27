# week11_wrap_week12_division_leaders_record_vs_quality.R
#
# Hero graphic for "Here's the deal, I'm the best there is." (nfl-season,
# 2026-11-29): what the standings see (win %) vs. how good the team is
# (net EPA per play), all 32 teams, Weeks 1-11.
#
# Expected result (written before plotting):
#   - KC and DEN share x = .800, with KC near the top (+0.20, 2nd in net EPA)
#     and DEN well below (+0.03, 12th). Same record, different teams.
#   - CHI and DET land on nearly the same point (.800, ~+0.07), so they get
#     one combined label.
#   - LA (~+0.15 at .600) sits far above every team near its record.
#   - NYG and CAR, division leaders, sit near zero among the non-leaders.
#
# Data: nflverse via nflreadr, regular season, Weeks 1-11. Net EPA uses
# pass == 1 | rush == 1 plays, which reproduces the article's ranks.
#
# Packages: nflreadr, dplyr, ggplot2, ggrepel
# Output: graphics/week11_wrap_week12_division_leaders/record_vs_quality.png

library(nflreadr)
library(dplyr)
library(ggplot2)
library(ggrepel)

out_path <- "graphics/week11_wrap_week12_division_leaders/record_vs_quality.png"
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

LAST_WEEK <- 11

# --- 1. Data -----------------------------------------------------------------
sched <- load_schedules(2026) |>
  filter(game_type == "REG", week <= LAST_WEEK, !is.na(result))

games <- bind_rows(
  sched |> transmute(team = home_team, pf = home_score, pa = away_score),
  sched |> transmute(team = away_team, pf = away_score, pa = home_score)
)

records <- games |>
  group_by(team) |>
  summarise(win_pct = mean((pf > pa) + 0.5 * (pf == pa)), .groups = "drop")

pbp <- load_pbp(2026) |>
  filter(season_type == "REG", week <= LAST_WEEK, !is.na(epa),
         !is.na(posteam), pass == 1 | rush == 1)

off <- pbp |> group_by(team = posteam) |> summarise(off = mean(epa))
def <- pbp |> group_by(team = defteam) |> summarise(def = mean(epa))

profiled <- c("SF", "JAX", "BUF", "KC", "CIN", "DET", "CHI", "LA")
other_leaders <- c("DEN", "NYG", "CAR")

df <- records |>
  left_join(off, by = "team") |>
  left_join(def, by = "team") |>
  mutate(
    net   = off - def,
    group = case_when(
      team %in% profiled      ~ "profiled",
      team %in% other_leaders ~ "leader",
      TRUE                    ~ "other"
    ),
    label = case_when(
      team %in% c("CHI", "DET") ~ NA_character_,
      group != "other"          ~ team,
      TRUE                      ~ NA_character_
    )
  )

# One combined label for the near-identical Bears and Lions
chi_det <- df |>
  filter(team %in% c("CHI", "DET")) |>
  summarise(win_pct = mean(win_pct), net = mean(net)) |>
  mutate(label = "CHI / DET")

print(df |> filter(group != "other") |> arrange(desc(net)) |>
        mutate(net = round(net, 3)), n = 20)

# --- 2. Palette (house light theme) -----------------------------------------
col_bg      <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_blue    <- "#3A7CA5"
col_red     <- "#C0392B"
col_gold    <- "#B8860B"
col_other   <- "#C8C8C8"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background  = element_rect(fill = col_bg, color = NA),
      panel.background = element_rect(fill = col_bg, color = NA),
      panel.grid.major = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text        = element_text(color = col_subtext, size = 9),
      axis.title       = element_text(color = col_text, size = 10),
      plot.title       = element_text(color = col_text, face = "bold",
                                      size = 15, margin = margin(b = 4)),
      plot.subtitle    = element_text(color = col_subtext, size = 10,
                                      margin = margin(b = 10)),
      plot.caption     = element_text(color = col_subtext, size = 8,
                                      hjust = 0, margin = margin(t = 10)),
      legend.position  = "none",
      plot.margin      = margin(14, 20, 10, 14)
    )
}

# --- 3. Plot -----------------------------------------------------------------
kc  <- df |> filter(team == "KC")
den <- df |> filter(team == "DEN")

set.seed(42)

p <- ggplot(df, aes(win_pct, net)) +
  geom_hline(yintercept = 0, color = "#BBBBBB", linewidth = 0.5) +
  # KC-DEN bracket: same record, different teams
  geom_segment(aes(x = 0.815, xend = 0.815, y = den$net, yend = kc$net),
               data = data.frame(), inherit.aes = FALSE,
               color = col_gold, linewidth = 0.5, linetype = "dashed") +
  # White-filled label so no gridline runs through the text
  annotate("label", x = 0.815, y = -0.075,
           label = "Same 8-2 record.\nKC 2nd in net EPA, DEN 12th.\nDEN leads the AFC West.",
           hjust = 0.5, size = 3, color = col_gold, fill = col_bg,
           border.colour = NA, lineheight = 0.95) +
  geom_segment(aes(x = 0.815, xend = 0.815, y = den$net, yend = -0.03),
               data = data.frame(), inherit.aes = FALSE,
               color = col_gold, linewidth = 0.4, linetype = "dotted") +
  geom_point(data = df |> filter(group == "other"),
             color = col_other, size = 2.6) +
  geom_point(data = df |> filter(group == "leader"),
             color = col_red, size = 3.2) +
  geom_point(data = df |> filter(group == "profiled"),
             color = col_blue, size = 3.2) +
  # DEN labeled separately, placed left so neither label nor leader crosses the bracket
  geom_text_repel(
    data = df |> filter(team == "DEN"), aes(label = label),
    color = col_red, size = 3.4, fontface = "bold", seed = 42,
    nudge_x = -0.06, nudge_y = -0.015, min.segment.length = 0,
    segment.color = "#999999", segment.size = 0.3
  ) +
  geom_text_repel(
    data = df |> filter(!is.na(label), team != "DEN"),
    aes(label = label, color = group),
    size = 3.4, fontface = "bold", seed = 42,
    box.padding = 0.45, point.padding = 0.3, min.segment.length = 0.2,
    segment.color = "#999999", segment.size = 0.3
  ) +
  geom_text_repel(
    data = chi_det, aes(label = label),
    color = col_blue, size = 3.4, fontface = "bold", seed = 42,
    nudge_x = -0.07, nudge_y = 0.01, min.segment.length = 0,
    segment.color = "#999999", segment.size = 0.3
  ) +
  scale_color_manual(values = c(profiled = col_blue, leader = col_red)) +
  scale_x_continuous(labels = function(x) sub("^0", "", sprintf("%.3f", x)),
                     breaks = seq(0, 1, 0.1),
                     expand = expansion(mult = c(0.03, 0.12))) +
  scale_y_continuous(labels = function(y) sprintf("%+.2f", y)) +
  labs(
    title    = "The standings see records. EPA sees teams.",
    subtitle = "Win % vs. net EPA per play, Weeks 1-11. Blue: the eight teams profiled. Red: division leaders outside them.",
    x        = "Win percentage",
    y        = "Net EPA per play (offense minus defense allowed)",
    caption  = "TheMerrittocracy  |  Data via nflverse/nflreadr. EPA on pass and run plays, not opponent-adjusted."
  ) +
  theme_merrittocracy_light()

# --- 4. Save -----------------------------------------------------------------
ggsave(out_path, p, width = 1200 / 150, height = 800 / 150, dpi = 150,
       bg = col_bg)
cat("wrote", out_path, "\n")
