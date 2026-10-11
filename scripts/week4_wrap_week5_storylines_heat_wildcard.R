# week4_wrap_week5_storylines_heat_wildcard.R
# Candidate 4 (WILDCARD, chart, patchwork): two heat-tile rosters,
# Jacksonville and Atlanta, actual PPR points by player and week,
# Weeks 1-4 -- Jacksonville's offense humming steadily, Atlanta's flipping
# on once Michael Penix Jr. takes over at QB in Week 3. Companion graphic
# for "That's Offensive!" (nfl-season, 2026-10-11).
#
# Data: boxscore-prophet/output/10d_receipts_2026_w0{1..4}.csv
#   fp_actual by player/week; dnp == TRUE rendered as a grey "DNP" tile
#   rather than a 0, since the player did not take the field that week.
#
# Packages: ggplot2, dplyr, patchwork, scales, readr
# Output: graphics/week4_wrap_week5_storylines/candidate_4.png

library(ggplot2)
library(dplyr)
library(patchwork)
library(scales)
library(readr)

repo_out <- "/Users/stephenmerritt/boxscore-prophet/output"
weeks <- c("w01", "w02", "w03", "w04")

read_week <- function(w) {
  readr::read_csv(file.path(repo_out, paste0("10d_receipts_2026_", w, ".csv")),
                   show_col_types = FALSE) |>
    mutate(week_num = as.integer(sub("w0", "", w)))
}

raw <- bind_rows(lapply(weeks, read_week))

jax_players <- c("Trevor Lawrence", "Brian Thomas Jr.", "Parker Washington",
                  "Jakobi Meyers", "Brenton Strange", "Bhayshul Tuten")

atl_players <- c("Cooper Rush", "Michael Penix Jr.", "Bijan Robinson",
                  "Brian Robinson", "Drake London", "Kyle Pitts")

jax_dat <- raw |>
  filter(posteam == "JAX", player_name %in% jax_players) |>
  select(player_name, week_num, fp_actual, dnp)

atl_dat <- raw |>
  filter(posteam == "ATL", player_name %in% atl_players) |>
  select(player_name, week_num, fp_actual, dnp)

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_point   <- "#3A7CA5"
col_flag    <- "#C0392B"
col_ref     <- "#B8860B"
col_dnp     <- "#E8E8E8"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid          = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.title         = element_text(color = col_text, size = 10),
      plot.title         = element_text(color = col_text, face = "bold",
                                        size = 13, margin = margin(b = 2)),
      plot.subtitle      = element_text(color = col_subtext, size = 9.5,
                                        margin = margin(b = 8)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 10)),
      legend.position    = "none",
      plot.margin        = margin(10, 16, 6, 10)
    )
}

make_panel <- function(dat, player_order, title, subtitle) {
  dat <- dat |>
    mutate(
      player_name = factor(player_name, levels = rev(player_order)),
      week_lab = paste0("Wk ", week_num),
      tile_label = ifelse(dnp, "DNP", sprintf("%.1f", fp_actual))
    )

  ggplot(dat, aes(x = week_num, y = player_name)) +
    geom_tile(aes(fill = ifelse(dnp, NA, fp_actual)),
              color = "white", linewidth = 1.4, width = 0.92, height = 0.86) +
    geom_tile(data = dat |> filter(dnp),
              fill = col_dnp, color = "white", linewidth = 1.4,
              width = 0.92, height = 0.86) +
    geom_text(aes(label = tile_label, color = ifelse(dnp, "dnp", "val")),
              size = 3.2, fontface = "bold") +
    scale_color_manual(values = c(dnp = col_subtext, val = col_text), guide = "none") +
    scale_fill_gradientn(
      colors = c("#F4F8FB", col_point, col_flag),
      limits = c(0, 36), na.value = col_dnp
    ) +
    scale_x_continuous(breaks = 1:4, labels = paste0("Wk ", 1:4),
                        position = "top", expand = expansion(add = 0.55)) +
    labs(title = title, subtitle = subtitle, x = NULL, y = NULL) +
    theme_merrittocracy_light()
}

p_jax <- make_panel(
  jax_dat, jax_players,
  "Jacksonville: steady",
  "Actual PPR points, Weeks 1-4"
)

p_atl <- make_panel(
  atl_dat, atl_players,
  "Atlanta: a switch flips",
  "Actual PPR points, Weeks 1-4\nPenix in from Week 3"
)

combined <- p_jax + p_atl +
  plot_annotation(
    title = "Offense Sells Tickets",
    subtitle = paste(strwrap(
      paste0(
        "Weekly actual fantasy points for each team's core skill players -- ",
        "Jacksonville's offense hums every week; Atlanta's was dead on arrival ",
        "until Michael Penix Jr. took over"
      ), width = 108), collapse = "\n"),
    caption = paste0(
      "Boxscore Prophet - 10d_receipts_2026_w01-w04.csv, fp_actual by player/week (posteam == JAX or ATL)\n",
      "DNP = did not play that week (bench or inactive); tile color scaled 0-36 PPR points, shared across both panels."
    ),
    theme = theme(
      plot.background = element_rect(fill = col_bg, color = NA),
      plot.title = element_text(color = col_text, face = "bold", size = 17,
                                 margin = margin(b = 2)),
      plot.subtitle = element_text(color = col_subtext, size = 10.5,
                                    margin = margin(b = 10)),
      plot.caption = element_text(color = col_subtext, size = 8, hjust = 0,
                                   margin = margin(t = 10))
    )
  )

ggsave(
  filename = "graphics/week4_wrap_week5_storylines/candidate_4.png",
  plot = combined, width = 8, height = 5.33, dpi = 150, bg = "white"
)
