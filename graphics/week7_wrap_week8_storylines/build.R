# build.R -- hero candidates for week7_wrap_week8_storylines (repo: boxscore-prophet)
# Expected result: only the Week 7 QB start board / ECR gap is verifiable from
# the repo. Week 8 claims (Goff 29%, market QB12) have no artifact.
# Run from repo root: Rscript graphics/week7_wrap_week8_storylines/build.R

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(ggtext)
library(ggrepel)
library(patchwork)
library(gt)
library(gtExtras)

out_dir <- "graphics/week7_wrap_week8_storylines"
bp      <- "../boxscore-prophet/output"

col_bg <- "#FFFFFF"; col_grid <- "#EEEEEE"; col_text <- "#1A1A1A"
col_subtext <- "#666666"; col_blue <- "#3A7CA5"; col_red <- "#C0392B"
col_gold <- "#B8860B"; col_gray <- "#B8BEC4"; col_dgray <- "#7A828A"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background  = element_rect(fill = col_bg, color = NA),
      panel.background = element_rect(fill = col_bg, color = NA),
      panel.grid.major = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text        = element_text(color = col_subtext, size = 9),
      axis.title       = element_text(color = col_text, size = 10),
      plot.title       = element_text(color = col_text, face = "bold", size = 15,
                                      margin = margin(b = 4)),
      plot.subtitle    = element_text(color = col_subtext, size = 10,
                                      margin = margin(b = 10)),
      plot.caption     = element_text(color = col_subtext, size = 8, hjust = 0,
                                      margin = margin(t = 10)),
      legend.position  = "none",
      plot.margin      = margin(14, 20, 10, 14)
    )
}

# ---- data (Week 7 artifacts only) ------------------------------------------
gap <- read.csv(file.path(bp, "10d_ecr_gap_2026_w07.csv")) |> filter(position == "QB")
sb  <- read.csv(file.path(bp, "10d_start_board_2026_w07.csv")) |>
  filter(position == "QB") |> select(player_name, boom_pct)
qb <- gap |> left_join(sb, by = "player_name") |> mutate(
  division = case_when(
    posteam %in% c("DET", "MIN", "GB", "CHI") ~ "NFC North",
    posteam %in% c("BAL", "CIN", "CLE", "PIT") ~ "AFC North",
    posteam == "NYG" ~ "NFC East",
    TRUE ~ "Other"))
stopifnot(!anyNA(qb$boom_pct))
# opponent team per QB from the start board
opp_map <- read.csv(file.path(bp, "10d_start_board_2026_w07.csv")) |>
  filter(position == "QB") |> select(player_name, defteam)
qb <- qb |> left_join(opp_map, by = "player_name")

is_north <- function(d) d %in% c("NFC North", "AFC North")
north <- qb |> filter(is_north(division), start_pct >= 20) |> arrange(desc(start_pct))
mccarthy <- qb |> filter(player_name == "J.J. McCarthy")
cap <- "Source: Boxscore Prophet Week 7 start board and ECR gap files. Start chance = model probability of a startable week. TheMerrittocracy"

# ---- candidate 1: gt table --------------------------------------------------
t1 <- bind_rows(north, mccarthy) |>
  mutate(group = ifelse(player_name == "J.J. McCarthy",
                        "The one Minnesota moved on from", "North starting quarterbacks")) |>
  select(group, player_name, posteam, division, start_pct, boom_pct,
         model_rank, ecr_rank, rank_gap)

tbl <- t1 |>
  gt(groupname_col = "group") |>
  cols_label(player_name = "Quarterback", posteam = "Team", division = "Division",
             start_pct = "Start chance", boom_pct = "Boom chance",
             model_rank = "Model QB rank", ecr_rank = "ECR QB rank",
             rank_gap = "Gap") |>
  tab_header(title = md("**Monsters Of The North, Quarterback Edition**"),
             subtitle = md("Week 7 start and boom chances for every North QB the model gave a real shot, plus J.J. McCarthy. Gap = ECR rank minus model rank.")) |>
  fmt_number(columns = c(start_pct, boom_pct), decimals = 0, pattern = "{x}%") |>
  fmt_number(columns = rank_gap, decimals = 0, force_sign = TRUE) |>
  data_color(columns = start_pct, palette = c("#FFFFFF", "#9CC5DD"), domain = c(0, 50)) |>
  tab_style(cell_text(weight = "bold", color = "#C62828"),
            cells_body(columns = c(rank_gap), rows = rank_gap <= -3)) |>
  tab_style(cell_text(weight = "bold", color = "#2E7D32"),
            cells_body(columns = c(rank_gap), rows = rank_gap >= 3)) |>
  tab_style(cell_text(weight = "bold"), cells_column_labels()) |>
  tab_style(cell_fill(color = "#F4F6F8"), cells_row_groups()) |>
  tab_style(cell_text(weight = "bold"), cells_row_groups()) |>
  cols_align("center", columns = c(posteam, start_pct, boom_pct, model_rank, ecr_rank, rank_gap)) |>
  tab_source_note(md("**TheMerrittocracy** | Boxscore Prophet Week 7 start board and ECR gap. Lamar Jackson and Caleb Williams are not on the final Week 7 start board.")) |>
  tab_options(table.font.size = px(13), heading.title.font.size = px(18),
              heading.subtitle.font.size = px(12), column_labels.font.size = px(12),
              data_row.padding = px(7), table.border.top.color = "#222222",
              heading.border.bottom.color = "#222222",
              column_labels.border.bottom.color = "#666666",
              table_body.border.bottom.color = "#222222")
gtsave(tbl, file.path(out_dir, "candidate_1.png"), vwidth = 820, zoom = 2)

# ---- candidate 2: ranked ladder of every QB at 20%+ -------------------------
lad <- qb |> filter(start_pct >= 20) |>
  mutate(player_name = factor(player_name, levels = rev(player_name[order(-start_pct, model_rank)])),
         grp = ifelse(is_north(division), division, "Other"))
p2 <- ggplot(lad, aes(start_pct, player_name)) +
  geom_segment(aes(x = 0, xend = start_pct, yend = player_name, color = grp), linewidth = 0.9) +
  geom_point(aes(color = grp), size = 3.6) +
  geom_text(aes(label = paste0(start_pct, "%"), color = grp), hjust = -0.5, size = 3, fontface = "bold") +
  scale_color_manual(values = c("NFC North" = col_red, "AFC North" = col_gold, "Other" = col_dgray)) +
  scale_x_continuous(limits = c(0, 56), expand = c(0, 0), labels = function(x) paste0(x, "%")) +
  labs(title = "Four North Quarterbacks Rank In The Model's Top 10 For Week 7",
       subtitle = glue("Week 7 start chance, all {nrow(lad)} quarterbacks at 20% or better. <span style='color:{col_red}'>**NFC North**</span> and <span style='color:{col_gold}'>**AFC North**</span> highlighted."),
       x = "Start chance (model)", y = NULL, caption = cap) +
  theme_merrittocracy_light() +
  theme(plot.subtitle = element_markdown(color = col_subtext, size = 10, margin = margin(b = 10)),
        panel.grid.major.y = element_blank(), axis.text.y = element_text(color = col_text, size = 9))
ggsave(file.path(out_dir, "candidate_2.png"), p2, width = 8, height = 5.3333, dpi = 150, bg = "white")

# ---- candidate 3: Murray vs McCarthy ----------------------------------------
pick <- qb |> filter(player_name %in% c("Kyler Murray", "J.J. McCarthy"))
mm <- pick |>
  tidyr::pivot_longer(c(start_pct, boom_pct), names_to = "metric", values_to = "pct") |>
  mutate(metric = factor(ifelse(metric == "start_pct", "Start chance", "Boom chance"),
                         levels = c("Start chance", "Boom chance")),
         who = ifelse(player_name == "Kyler Murray", "Murray", "McCarthy"))
mur <- pick |> filter(player_name == "Kyler Murray")
mcc <- pick |> filter(player_name == "J.J. McCarthy")
p3 <- ggplot(mm, aes(pct, metric, fill = who)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.62) +
  geom_text(aes(label = paste0(pct, "%")), position = position_dodge(width = 0.7),
            hjust = -0.2, size = 4.2, fontface = "bold", color = col_text) +
  scale_fill_manual(values = c(Murray = col_blue, McCarthy = col_red)) +
  scale_x_continuous(limits = c(0, 42), expand = c(0, 0), labels = function(x) paste0(x, "%")) +
  scale_y_discrete(limits = rev) +
  annotate("richtext", x = 41, y = 1.55, hjust = 1, size = 3.6, fill = NA, label.color = NA,
           label = glue("<span style='color:{col_blue}'>**Kyler Murray, MIN**</span><br>Model QB{mur$model_rank} | ECR QB{mur$ecr_rank}<br><br><span style='color:{col_red}'>**J.J. McCarthy, NYG**</span><br>Model QB{mcc$model_rank} | ECR QB{mcc$ecr_rank}")) +
  labs(title = "The Model Had Murray Ahead Of McCarthy For Week 7",
       subtitle = "Minnesota kept Kyler Murray; J.J. McCarthy landed with the Giants. Week 7 chances.",
       x = NULL, y = NULL, caption = "Source: Boxscore Prophet Week 7 start board and ECR gap.\nStart chance = model probability of a startable week. TheMerrittocracy") +
  theme_merrittocracy_light() +
  theme(panel.grid.major.y = element_blank(), axis.text.y = element_text(color = col_text, size = 11, face = "bold"))
ggsave(file.path(out_dir, "candidate_3.png"), p3, width = 8, height = 5.3333, dpi = 150, bg = "white")

# ---- candidate 4 (wildcard): mirrored North QB vs opposite number -----------
pairs <- bind_rows(lapply(seq_len(nrow(north)), function(i) {
  n <- north[i, ]
  o <- qb |> filter(posteam == n$defteam) |> arrange(desc(start_pct)) |> slice(1)
  tibble(north_qb = n$player_name, north_team = n$posteam, n_start = n$start_pct,
         n_boom = n$boom_pct, n_mr = n$model_rank, n_er = n$ecr_rank,
         opp_qb = o$player_name, opp_team = o$posteam, o_start = o$start_pct,
         o_boom = o$boom_pct, o_mr = o$model_rank, o_er = o$ecr_rank)
})) |>
  filter(north_qb != "Jordan Love")   # Goff-Love game already shown from Goff's side
stopifnot(!anyNA(pairs$opp_qb))
pairs <- pairs |> mutate(row = factor(north_qb, levels = rev(north_qb)))

base_theme <- theme_merrittocracy_light() +
  theme(panel.grid.major.y = element_blank(), axis.text.y = element_blank(),
        axis.title = element_blank(), plot.margin = margin(4, 4, 4, 4))
pl <- ggplot(pairs, aes(y = row)) +
  geom_col(aes(x = n_start), fill = col_blue, width = 0.6) +
  geom_point(aes(x = n_boom), shape = 18, size = 4, color = col_gold) +
  geom_text(aes(x = n_start, label = paste0(n_start, "%")), hjust = 1.2, color = col_text,
            size = 3.4, fontface = "bold") +
  scale_x_reverse(limits = c(60, 0), expand = c(0, 0), breaks = c(0, 20, 40),
                  labels = function(x) paste0(x, "%")) +
  labs(subtitle = "North QB") + base_theme
pr <- ggplot(pairs, aes(y = row)) +
  geom_col(aes(x = o_start), fill = col_gray, width = 0.6) +
  geom_point(aes(x = o_boom), shape = 18, size = 4, color = col_gold) +
  geom_text(aes(x = o_start, label = paste0(o_start, "%")), hjust = -0.2, color = col_text,
            size = 3.4, fontface = "bold") +
  scale_x_continuous(limits = c(0, 60), expand = c(0, 0), breaks = c(0, 20, 40),
                     labels = function(x) paste0(x, "%")) +
  labs(subtitle = "Opposing QB") + base_theme
pm <- ggplot(pairs, aes(y = row)) +
  geom_text(aes(x = 0, label = north_qb), hjust = 1, size = 3.3, fontface = "bold",
            color = col_blue, nudge_y = 0.17) +
  geom_text(aes(x = 0, label = glue("{north_team}  QB{n_mr} model / QB{n_er} ECR")),
            hjust = 1, size = 2.6, color = col_subtext, nudge_y = -0.2) +
  geom_text(aes(x = 0.15, label = opp_qb), hjust = 0, size = 3.3, fontface = "bold",
            color = col_text, nudge_y = 0.17) +
  geom_text(aes(x = 0.15, label = glue("{opp_team}  QB{o_mr} model / QB{o_er} ECR")),
            hjust = 0, size = 2.6, color = col_subtext, nudge_y = -0.2) +
  scale_x_continuous(limits = c(-1, 1.15)) +
  labs(subtitle = " ") + base_theme +
  theme(panel.grid.major = element_blank(), axis.text.x = element_blank())
p4 <- (pl | pm | pr) + plot_layout(widths = c(1.15, 1.7, 1.15)) +
  plot_annotation(
    title = "Every North Quarterback Against The Quarterback Across The Field",
    subtitle = "Week 7 start chance (bar) and boom chance (diamond) for five North starters and their opposite numbers.",
    caption = "Source: Boxscore Prophet Week 7 start board and ECR gap. Detroit-Green Bay shown from Goff's side. TheMerrittocracy",
    theme = theme(plot.background = element_rect(fill = col_bg, color = NA),
                  plot.title = element_text(color = col_text, face = "bold", size = 15),
                  plot.subtitle = element_text(color = col_subtext, size = 10),
                  plot.caption = element_text(color = col_subtext, size = 8, hjust = 0),
                  plot.margin = margin(14, 16, 8, 14)))
ggsave(file.path(out_dir, "candidate_4.png"), p4, width = 8, height = 5.3333, dpi = 150, bg = "white")
print(as.data.frame(pairs |> select(north_qb, n_start, opp_qb, o_start)))
