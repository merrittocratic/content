# build.R -- week5_wrap_week6_storylines (repo: boxscore-prophet)
# Run from repo root: Rscript graphics/week5_wrap_week6_storylines/build.R
# Sources (all in ../boxscore-prophet/output): 10d_receipts_2026_w01..w05.csv,
# 10d_start_board_2026_w06.csv, 10d_ecr_gap_2026_w06.csv

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(ggtext)
library(ggrepel)
library(gt)
library(gtExtras)
library(patchwork)

out_dir <- "graphics/week5_wrap_week6_storylines"
base    <- "../boxscore-prophet/output"

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

save_chart <- function(p, n) {
  ggsave(file.path(out_dir, glue("candidate_{n}.png")), p,
         width = 1200 / 150, height = 800 / 150, dpi = 150, bg = col_bg)
}

# --- Data ---------------------------------------------------------------------
who <- c("Jeremiyah Love", "Marvin Harrison Jr.", "C.J. Stroud",
         "Jayden Daniels", "Dak Prescott")

rec <- bind_rows(lapply(1:5, function(w) {
  read.csv(file.path(base, glue("10d_receipts_2026_w0{w}.csv"))) |>
    mutate(week = w)
})) |>
  filter(player_name %in% who) |>
  mutate(
    dnp = as.logical(dnp),
    cleared = !dnp & fp_actual >= thresh_start
  ) |>
  select(player_name, position, posteam, defteam, week, start_pct, boom_pct,
         thresh_start, fp_actual, dnp, cleared)

sb  <- read.csv(file.path(base, "10d_start_board_2026_w06.csv")) |>
  filter(player_name %in% who) |>
  select(player_name, position, posteam, defteam, start_pct, boom_pct,
         model_rank = rank)
ecr <- read.csv(file.path(base, "10d_ecr_gap_2026_w06.csv")) |>
  filter(player_name %in% who) |>
  select(player_name, ecr_rank, rank_gap)
w6 <- sb |> left_join(ecr, by = "player_name")
stopifnot(nrow(w6) == 5, !anyNA(w6$ecr_rank))

ord <- c("Jeremiyah Love", "Marvin Harrison Jr.", "C.J. Stroud",
         "Dak Prescott", "Jayden Daniels")

# --- Candidate 1: gt table, Week 6 board -------------------------------------
t1 <- w6 |>
  arrange(match(player_name, ord)) |>
  mutate(
    matchup = glue("{posteam} vs. {defteam}"),
    pos_rank = glue("{position}{model_rank}"),
    ecr_pos  = glue("{position}{ecr_rank}"),
    start    = start_pct / 100,
    gap_lab  = ifelse(rank_gap > 0, glue("+{rank_gap}"), as.character(rank_gap))
  ) |>
  select(player_name, matchup, start, pos_rank, ecr_pos, gap_lab)

tbl1 <- t1 |>
  gt() |>
  cols_label(player_name = "Player", matchup = "Week 6 game",
             start = "Startable-week chance", pos_rank = "Model rank",
             ecr_pos = "Consensus (ECR)", gap_lab = "Spots vs. ECR") |>
  fmt_percent(columns = start, decimals = 0) |>
  tab_header(
    title = md("**The Week 6 Breakup Board**"),
    subtitle = md("Boxscore Prophet's Tuesday run vs. FantasyPros Expert Consensus Ranking. Negative = model is lower than consensus.")
  ) |>
  tab_style(cell_text(weight = "bold"), cells_column_labels()) |>
  tab_style(
    list(cell_fill("#FDECEA"), cell_text(color = col_red, weight = "bold")),
    cells_body(columns = gap_lab, rows = grepl("^-", gap_lab))
  ) |>
  tab_style(
    list(cell_fill("#E8F1F7"), cell_text(color = col_blue, weight = "bold")),
    cells_body(columns = gap_lab, rows = grepl("^\\+", gap_lab))
  ) |>
  cols_align("center", columns = c(matchup, start, pos_rank, ecr_pos, gap_lab)) |>
  cols_align("left", columns = player_name) |>
  tab_source_note(md("**TheMerrittocracy** - Boxscore Prophet Week 6 start board and ECR lock (10d_start_board, 10d_ecr_gap). Startable = PPR points at or above the position threshold (20 QB, 15 RB/WR).")) |>
  tab_options(
    table.font.size = px(14), heading.title.font.size = px(20),
    heading.subtitle.font.size = px(12), column_labels.font.size = px(12),
    data_row.padding = px(9), source_notes.font.size = px(10),
    table.background.color = "#FFFFFF",
    table.border.top.color = "#222222", heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color = "#222222"
  )
gtsave(tbl1, file.path(out_dir, "candidate_1.png"), vwidth = 1000, vheight = 520,
       zoom = 1.5)

# --- Candidate 2: Arizona skill players, actual PPR vs. startable line --------
az <- rec |>
  filter(player_name %in% c("Jeremiyah Love", "Marvin Harrison Jr.")) |>
  mutate(status = case_when(dnp ~ "DNP", cleared ~ "Cleared", TRUE ~ "Missed"))
thr_az <- 15

p2 <- ggplot(az, aes(x = factor(week), y = fp_actual)) +
  geom_col(aes(fill = status), width = 0.6) +
  geom_hline(yintercept = thr_az, color = col_gold, linewidth = 0.5,
             linetype = "dashed") +
  geom_text(aes(label = ifelse(dnp, "DNP", sprintf("%.1f", fp_actual)),
                y = pmax(fp_actual, 0) + 0.8),
            size = 3.4, color = col_text, fontface = "bold") +
  scale_x_discrete(labels = function(x) paste("Wk", x)) +
  scale_fill_manual(values = c(Cleared = col_blue, Missed = "#B8C4CC",
                               DNP = "#DDDDDD")) +
  facet_wrap(~player_name, nrow = 1) +
  scale_y_continuous(limits = c(0, 26), expand = c(0, 0)) +
  annotate("text", x = 0.55, y = thr_az + 1.1, label = "15-point startable line",
           hjust = 0, size = 3, color = col_gold, fontface = "italic") +
  labs(
    title = "Love Cleared the Line Once; Harrison Never Did",
    subtitle = "Actual PPR points, Weeks 1-5, vs. the 15-point startable line for RB/WR. Blue = cleared.",
    x = NULL, y = "PPR points",
    caption = "TheMerrittocracy  \u00b7  Boxscore Prophet 10d_receipts_2026_w01-w05. Harrison did not play Week 5 (DNP).\nLove: 1 of 5 weeks at 15+ (21.9 in Week 3)."
  ) +
  theme_merrittocracy_light()
save_chart(p2, 2)

# --- Candidate 3: QBs, Stroud highlighted -------------------------------------
qb <- rec |>
  filter(position == "QB") |>
  mutate(fp_actual = ifelse(dnp, NA_real_, fp_actual),
         is_stroud = player_name == "C.J. Stroud")
qb_pts <- filter(qb, !is.na(fp_actual))
ends <- qb_pts |> group_by(player_name) |> filter(week == max(week)) |> ungroup()

p3 <- ggplot(qb, aes(week, fp_actual, group = player_name)) +
  geom_hline(yintercept = 20, color = col_gold, linewidth = 0.5, linetype = "dashed") +
  geom_line(aes(color = is_stroud, linewidth = is_stroud), na.rm = TRUE) +
  geom_point(data = qb_pts, aes(color = is_stroud, size = start_pct), alpha = 0.95) +
  geom_text_repel(
    data = ends, aes(label = player_name, color = is_stroud),
    seed = 42, nudge_x = 0.35, hjust = 0, direction = "y", size = 3.6,
    fontface = "bold", segment.color = NA, xlim = c(5.2, 6.4)
  ) +
  annotate("text", x = 1, y = 20.9, label = "20-point startable line (QB)",
           hjust = 0, size = 3, color = col_gold, fontface = "italic") +
  scale_color_manual(values = c(`TRUE` = col_red, `FALSE` = "#9AA5AE")) +
  scale_linewidth_manual(values = c(`TRUE` = 1.2, `FALSE` = 0.6)) +
  scale_size_continuous(range = c(2, 7)) +
  scale_x_continuous(breaks = 1:5, labels = paste("Wk", 1:5),
                     limits = c(0.8, 6.4), expand = c(0, 0)) +
  labs(
    title = "Stroud Cleared the Line Twice in Five Weeks",
    subtitle = "Actual PPR points; point size = pre-kickoff startable-week chance. Daniels DNP in Weeks 3-4.",
    x = NULL, y = "PPR points",
    caption = "Boxscore Prophet 10d_receipts_2026_w01-w05. Stroud cleared 20 in Week 4 (23.1, 43% start chance) and Week 5 (20.9, 25% start chance)."
  ) +
  theme_merrittocracy_light()
save_chart(p3, 3)

# --- Candidate 4 (wildcard): tile grid + rank dumbbell ------------------------
grid <- bind_rows(
  rec |> transmute(player_name, week = as.character(week), start_pct,
                   pts = fp_actual, dnp, cleared),
  w6 |> transmute(player_name, week = "6", start_pct, pts = NA_real_,
                  dnp = FALSE, cleared = FALSE)
) |>
  mutate(
    player_name = factor(player_name, levels = rev(ord)),
    lab = case_when(week == "6" ~ glue("{start_pct}%\nproj."),
                    dnp ~ glue("{start_pct}%\nDNP"),
                    TRUE ~ glue("{start_pct}%\n{sprintf('%.1f', pts)}"))
  )

pa <- ggplot(grid, aes(week, player_name)) +
  geom_tile(aes(fill = start_pct), color = "white", linewidth = 1.2) +
  geom_tile(data = filter(grid, cleared), fill = NA, color = col_gold,
            linewidth = 1.3, width = 0.92, height = 0.92) +
  geom_text(aes(label = lab, color = start_pct > 40), size = 3, lineheight = 0.9) +
  scale_fill_gradient(low = "#F4F8FB", high = col_blue, limits = c(0, 60),
                      oob = squish) +
  scale_color_manual(values = c(`TRUE` = "white", `FALSE` = col_text)) +
  scale_x_discrete(labels = c(paste("Wk", 1:5), "Wk 6\nTue run"),
                   position = "top") +
  labs(x = NULL, y = NULL) +
  theme_merrittocracy_light() +
  theme(panel.grid = element_blank(),
        axis.text.y = element_text(size = 10, color = col_text))

dd <- w6 |>
  mutate(player_name = factor(player_name, levels = rev(ord)))
pb <- ggplot(dd, aes(y = player_name)) +
  geom_segment(aes(x = ecr_rank, xend = model_rank, yend = player_name),
               color = "#B8C4CC", linewidth = 1.2) +
  geom_point(aes(x = ecr_rank), color = col_gold, size = 3.5) +
  geom_point(aes(x = model_rank), color = col_red, size = 3.5) +
  geom_text(aes(x = pmax(ecr_rank, model_rank) + 7,
                label = sprintf("%+d", rank_gap)),
            hjust = 0, size = 3.4, fontface = "bold", color = col_text) +
  scale_x_continuous(limits = c(0, 100), breaks = c(0, 25, 50, 75)) +
  labs(x = "Week 6 rank (red = model, gold = ECR)", y = NULL) +
  theme_merrittocracy_light() +
  theme(axis.text.y = element_blank())

p4 <- (pa + pb + plot_layout(widths = c(2.3, 1))) +
  plot_annotation(
    title = "Five Players, Six Weeks: The Breakup Board",
    subtitle = "Left: start chance over actual PPR points, gold outline = cleared the startable line. Right: model vs. ECR rank, label = spots gap.",
    caption = "Boxscore Prophet 10d_receipts_2026_w01-w05, 10d_start_board_2026_w06, 10d_ecr_gap_2026_w06.\nDNP weeks shown as DNP, not zero.",
    theme = theme(
      plot.background = element_rect(fill = col_bg, color = NA),
      plot.title = element_text(color = col_text, face = "bold", size = 15),
      plot.subtitle = element_text(color = col_sub, size = 9),
      plot.caption = element_text(color = col_sub, size = 8, hjust = 0),
      plot.margin = margin(14, 20, 10, 14)
    )
  )
save_chart(p4, 4)

cat("done\n")
