# build.R -- week6_wrap_week7_storylines (repo: boxscore-prophet)
# Run from repo root: Rscript graphics/week6_wrap_week7_storylines/build.R
# Data: boxscore-prophet/output/10d_start_board_2026_w07.csv and
#       10d_ecr_gap_2026_w07.csv (read as-is, nothing recomputed).

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(ggtext)
library(ggrepel)
library(patchwork)
library(gt)
library(gtExtras)

out_dir <- "graphics/week6_wrap_week7_storylines"
bp <- "../boxscore-prophet/output"

col_bg <- "#FFFFFF"; col_grid <- "#EEEEEE"; col_text <- "#1A1A1A"
col_subtext <- "#666666"; col_blue <- "#3A7CA5"; col_red <- "#C0392B"
col_gold <- "#B8860B"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background = element_rect(fill = col_bg, color = NA),
      panel.background = element_rect(fill = col_bg, color = NA),
      panel.grid.major = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text = element_text(color = col_subtext, size = 9),
      axis.title = element_text(color = col_text, size = 10),
      plot.title = element_text(color = col_text, face = "bold", size = 15,
                                margin = margin(b = 4)),
      plot.subtitle = element_text(color = col_subtext, size = 10,
                                   margin = margin(b = 10)),
      plot.caption = element_text(color = col_subtext, size = 8, hjust = 0,
                                  margin = margin(t = 10)),
      legend.position = "none",
      plot.margin = margin(14, 20, 10, 14)
    )
}

cap <- "TheMerrittocracy  ·  Boxscore Prophet Week 7 run vs. FantasyPros ECR"

sb <- read.csv(file.path(bp, "10d_start_board_2026_w07.csv"))
eg <- read.csv(file.path(bp, "10d_ecr_gap_2026_w07.csv"))

picks <- c("Tanner McKee", "Dak Prescott", "Jared Goff", "George Pickens",
           "Amon-Ra St. Brown", "Jameson Williams", "Jahmyr Gibbs")

d <- eg |>
  filter(player_name %in% picks) |>
  select(player_name, position, posteam, model_rank, ecr_rank, rank_gap) |>
  left_join(sb |> select(player_name, position, start_pct, boom_pct),
            by = c("player_name", "position")) |>
  mutate(
    game = ifelse(posteam %in% c("DAL", "PHI"), "Dallas at Philadelphia (Mon.)",
                  "Green Bay at Detroit (Sun.)"),
    mrk = paste0(position, model_rank),
    erk = paste0(position, ecr_rank)
  )
stopifnot(nrow(d) == 7)

save_plot <- function(p, f) {
  ggsave(file.path(out_dir, f), p, width = 1200 / 150, height = 800 / 150,
         dpi = 150, bg = col_bg)
}

# ---- Candidate 1: gt table --------------------------------------------------
t1 <- d |>
  arrange(game != "Green Bay at Detroit (Sun.)", position != "QB", model_rank) |>
  mutate(
    gap_txt = ifelse(rank_gap == 0, "even",
                     ifelse(rank_gap > 0, paste0(rank_gap, " above ECR"),
                            paste0(abs(rank_gap), " below ECR")))
  ) |>
  select(game, player_name, posteam, mrk, erk, gap_txt, start_pct)

tbl <- t1 |>
  gt(groupname_col = "game") |>
  cols_label(player_name = "Player", posteam = "Team", mrk = "Model rank",
             erk = "ECR rank", gap_txt = "Model vs. ECR",
             start_pct = "Startable chance") |>
  fmt_number(columns = start_pct, decimals = 0, pattern = "{x}%") |>
  tab_header(
    title = md("**Where the Model Leaves the Market**"),
    subtitle = md("Week 7 startable-week chance and positional rank vs. Expert Consensus Ranking (ECR)")
  ) |>
  tab_source_note(md("**TheMerrittocracy** · Boxscore Prophet Tuesday run vs. FantasyPros ECR")) |>
  tab_style(style = cell_text(weight = "bold", color = col_red),
            locations = cells_body(rows = player_name %in% c("Jameson Williams"))) |>
  tab_style(style = cell_text(weight = "bold", color = col_blue),
            locations = cells_body(rows = player_name %in% c("Tanner McKee", "George Pickens"))) |>
  tab_style(style = cell_text(weight = "bold"),
            locations = cells_row_groups()) |>
  cols_align(align = "center", columns = c(posteam, mrk, erk, gap_txt, start_pct)) |>
  cols_align(align = "left", columns = player_name) |>
  data_color(columns = start_pct, fn = col_numeric(c("#FFFFFF", "#BFD7E6"), c(0, 80))) |>
  tab_options(
    table.font.size = px(14), heading.title.font.size = px(20),
    heading.subtitle.font.size = px(12), column_labels.font.size = px(12),
    data_row.padding = px(8), source_notes.font.size = px(10),
    table.background.color = "#FFFFFF",
    table.border.top.color = "#222222", heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color = "#222222"
  )
gtsave(tbl, file.path(out_dir, "candidate_1.png"), vwidth = 760, zoom = 2)

# ---- Candidate 2: rank dumbbell --------------------------------------------
d2 <- d |>
  mutate(lab = glue("{player_name} ({position})"),
         lab = reorder(lab, -rank_gap),
         gapcol = ifelse(rank_gap < 0, col_red, ifelse(rank_gap > 0, col_blue, col_subtext)))

p2 <- ggplot(d2, aes(y = lab)) +
  geom_segment(aes(x = ecr_rank, xend = model_rank, yend = lab, color = gapcol),
               linewidth = 1.6, alpha = 0.7) +
  geom_point(aes(x = ecr_rank), shape = 21, fill = "white", color = col_subtext,
             size = 4.5, stroke = 1.2) +
  geom_point(aes(x = model_rank, color = gapcol), size = 4.5) +
  geom_text(aes(x = pmax(model_rank, ecr_rank) + 1.2,
                label = ifelse(rank_gap == 0, glue("{mrk} = ECR"),
                               glue("model {mrk}, ECR {erk}"))),
            hjust = 0, size = 3.3, color = col_text) +
  scale_color_identity() +
  scale_x_continuous(limits = c(0, 62), breaks = c(1, 10, 20, 30, 40)) +
  labs(
    title = "Jameson Williams Is the Lone Fade in Two Shootouts",
    subtitle = "Model rank (filled) vs. consensus (open); lower is better. Blue = model higher, red = model lower.",
    x = "Positional rank (QB, RB or WR as labeled)", y = NULL, caption = cap
  ) +
  theme_merrittocracy_light()
save_plot(p2, "candidate_2.png")

# ---- Candidate 3: beeswarm of the field ------------------------------------
fld <- sb |> filter(position %in% c("QB", "WR")) |>
  mutate(hi = player_name %in% picks)
fld_hi <- fld |> filter(hi)
set.seed(42)
p3 <- ggplot(fld, aes(x = start_pct, y = position)) +
  geom_jitter(data = fld |> filter(!hi), height = 0.25, width = 0,
                   color = "#BBBBBB", size = 1.6, alpha = 0.8) +
  geom_point(data = fld_hi, aes(color = player_name == "Jameson Williams"),
             size = 4) +
  geom_text_repel(data = fld_hi,
                  aes(label = glue("{player_name} {start_pct}%"),
                      color = player_name == "Jameson Williams"),
                  seed = 42, size = 3.3, fontface = "bold",
                  nudge_y = 0.38, direction = "x", box.padding = 0.3,
                  segment.color = col_subtext, segment.size = 0.3,
                  min.segment.length = 0) +
  scale_color_manual(values = c(`TRUE` = col_red, `FALSE` = col_blue)) +
  scale_x_continuous(labels = function(x) paste0(x, "%"), limits = c(0, 70)) +
  scale_y_discrete(expand = expansion(add = c(0.6, 0.9))) +
  labs(
    title = "Seven Week 7 Names Against Every QB and WR on the Board",
    subtitle = "Each dot is one player's model chance of a startable week. Colored: players named in the Week 7 storylines.",
    x = "Chance of a startable week", y = NULL, caption = cap
  ) +
  theme_merrittocracy_light() +
  theme(axis.text.y = element_text(size = 12, face = "bold", color = col_text))
save_plot(p3, "candidate_3.png")

# ---- Candidate 4 (wildcard): two-game mirrored panels ----------------------
mk_panel <- function(g, ttl, ord) {
  x <- d |> filter(game == g) |>
    mutate(lab = factor(player_name, levels = rev(ord)))
  ggplot(x, aes(y = lab)) +
    geom_col(aes(x = start_pct), fill = col_blue, width = 0.55, alpha = 0.9) +
    geom_point(aes(x = boom_pct), shape = 18, size = 5, color = col_gold) +
    geom_text(aes(x = start_pct, label = paste0(start_pct, "%")),
              hjust = 1.2, color = "white", fontface = "bold", size = 3.6) +
    geom_text(aes(x = 100, label = glue("{mrk} vs. ECR {erk}"),
                  color = ifelse(rank_gap < 0, "r", ifelse(rank_gap > 0, "b", "g"))),
              hjust = 1, size = 3.3, fontface = "bold") +
    scale_color_manual(values = c(r = col_red, b = col_blue, g = col_subtext)) +
    scale_x_continuous(limits = c(0, 100), breaks = seq(0, 60, 20),
                       labels = function(x) paste0(x, "%")) +
    labs(title = ttl, x = NULL, y = NULL) +
    theme_merrittocracy_light() +
    theme(plot.title = element_text(size = 12, face = "bold"),
          panel.grid.major.y = element_blank(),
          axis.text.y = element_text(color = col_text, size = 10),
          plot.margin = margin(6, 10, 4, 10))
}
pa <- mk_panel("Green Bay at Detroit (Sun.)", "Green Bay at Detroit",
               c("Jahmyr Gibbs", "Amon-Ra St. Brown", "Jared Goff", "Jameson Williams"))
pb <- mk_panel("Dallas at Philadelphia (Mon.)", "Dallas at Philadelphia",
               c("George Pickens", "Dak Prescott", "Tanner McKee"))
p4 <- (pa / pb) + plot_layout(heights = c(4, 3)) +
  plot_annotation(
    title = "Shootout and Slog: Who Gets Fed",
    subtitle = "Blue bar = chance of a startable week. Gold diamond = chance of a boom week. Right: model rank vs. ECR rank.",
    caption = cap,
    theme = theme_merrittocracy_light()
  )
save_plot(p4, "candidate_4.png")
cat("done\n")
