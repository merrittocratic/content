# week4_wrap_week5_storylines_boom_leaderboard.R
# Candidate 2 (chart, leaderboard): Boxscore Prophet's pre-kickoff flex
# board for the Week 4 Falcons-Saints game, ranked by boom chance, with
# Bijan Robinson and Drake London called out. Companion graphic for
# "That's Offensive!" (nfl-season, 2026-10-11).
#
# Data: boxscore-prophet/output/10d_boom_board_2026_w04.csv, board == "flex"
#   (pre-kickoff boom chance for every flex-eligible player in the ATL-NO
#   Week 4 game)
#
# Packages: ggplot2, dplyr, ggrepel, scales
# Output: graphics/week4_wrap_week5_storylines/candidate_2.png

library(ggplot2)
library(dplyr)
library(ggrepel)
library(scales)
library(readr)

repo_out <- "/Users/stephenmerritt/boxscore-prophet/output"

board <- readr::read_csv(file.path(repo_out, "10d_boom_board_2026_w04.csv"),
                          show_col_types = FALSE) |>
  filter(board == "flex") |>
  arrange(rank) |>
  mutate(
    player_disp = sub(" \\(Q\\)$", "", player_disp),
    highlight = case_when(
      player_name == "Bijan Robinson" ~ "Bijan Robinson (ATL)",
      player_name == "Drake London"   ~ "Drake London (ATL)",
      TRUE ~ "Other"
    ),
    label = paste0(player_disp, " (", posteam, ")")
  )

# Keep the top 15 by boom chance -- below that the board thins into
# single-digit chances that would just clutter the axis.
top <- board |> slice_max(order_by = boom_pct, n = 15, with_ties = FALSE)

top <- top |>
  mutate(label = factor(label, levels = rev(label)))

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"
col_flag    <- "#C0392B"
col_ref     <- "#B8860B"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major.y = element_blank(),
      panel.grid.major.x = element_line(color = col_grid, linewidth = 0.4),
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
      plot.margin        = margin(14, 24, 10, 14)
    )
}

p <- ggplot(top, aes(x = boom_pct, y = label, fill = highlight)) +
  geom_col(width = 0.65) +
  geom_text(
    aes(label = paste0(boom_pct, "%")),
    hjust = -0.15, size = 3.3, color = col_text, fontface = "bold"
  ) +
  scale_fill_manual(values = c(
    "Bijan Robinson (ATL)" = col_flag,
    "Drake London (ATL)"   = col_ref,
    "Other"                = col_point
  )) +
  scale_x_continuous(limits = c(0, 38), expand = expansion(mult = c(0, 0.05))) +
  labs(
    title = "Bijan Took Off Right Alongside Him",
    subtitle = paste0(
      "Boxscore Prophet's pre-kickoff boom chance, Falcons-Saints, Week 4 --\n",
      "Bijan Robinson ranked 2nd of 24 flex-eligible players, Drake London 3rd"
    ),
    x = "Boom chance (pre-kickoff)",
    y = NULL,
    caption = paste0(
      "Boxscore Prophet - 10d_boom_board_2026_w04.csv, flex board (top 15 of 24 shown)\n",
      "Boom chance is the model's pre-kickoff probability of a top-tier fantasy game; both players cleared it --\n",
      "Bijan scored 27.7 PPR points, Drake London 14.6."
    )
  ) +
  theme_merrittocracy_light()

ggsave(
  filename = "graphics/week4_wrap_week5_storylines/candidate_2.png",
  plot = p, width = 8, height = 5.33, dpi = 150, bg = "white"
)
