# ============================================================================
# build.R -- hero candidates for draft/week10_trade_deadline.md ("Everything Must Go")
# Repo: boxscore-prophet.  Run from content repo root:
#   Rscript graphics/week10_trade_deadline/build.R
#
# Expected results (stated before plotting):
#  - Cousins cleared the 20-pt start line in 5 of 9 games (W2,3,4,7,8) while the
#    model never gave him better than 34% (W6) -> the draft's "miss I'm not hiding".
#  - Indy skill players (Allen, Downs, Jones) almost never clear their lines;
#    Taylor's model start chance fell from 77% (W4) to ~50% (W8-9).
# ONLY source: boxscore-prophet/output/10d_receipts_2026_w01..w09.csv
#   (p_start_recal = model start chance, fp_actual, thresh_start, hit_start, dnp).
# Trade prices, EPA ranks, snap counts, etc. are NOT in repo artifacts and are
# deliberately not charted (see log).
# ============================================================================

library(ggplot2)
library(dplyr)
library(glue)
library(scales)
library(ggtext)
library(ggrepel)
library(gt)
library(gtExtras)
library(patchwork)

out_dir <- "graphics/week10_trade_deadline"
src_dir <- "/Users/stephenmerritt/boxscore-prophet/output"

# --- palette / theme (copied from scripts/trust_but_verify_sample_size_funnel.R)
col_bg <- "#FFFFFF"; col_panel <- "#FFFFFF"; col_grid <- "#EEEEEE"
col_text <- "#1A1A1A"; col_subtext <- "#666666"
col_blue <- "#3A7CA5"; col_red <- "#C0392B"; col_gold <- "#B8860B"

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background  = element_rect(fill = col_bg, color = NA),
      panel.background = element_rect(fill = col_panel, color = NA),
      panel.grid.major = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor = element_blank(),
      axis.text  = element_text(color = col_subtext, size = 9),
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

# titles/captions are anchored to the full plot, not the panel, so they never clip
theme_full <- theme(plot.title.position = "plot", plot.caption.position = "plot")

save_chart <- function(p, name) {
  ggsave(file.path(out_dir, name), p, width = 1200 / 150, height = 800 / 150,
         dpi = 150, bg = col_bg)
}

# --- data -------------------------------------------------------------------
files <- list.files(src_dir, pattern = "^10d_receipts_2026_w[0-9]+\\.csv$",
                    full.names = TRUE)
stopifnot(length(files) == 9)
rec <- bind_rows(lapply(files, function(f) {
  read.csv(f) |>
    mutate(week = as.integer(sub(".*_w([0-9]+)\\.csv$", "\\1", f)))
})) |>
  mutate(p = p_start_recal)

cap <- paste0("Source: Boxscore Prophet 10d receipts, 2026 Weeks 1-9. Model start chance is the pre-game recalibrated probability.\n",
              "Start line: QB 20 pts, RB/WR 15 pts.")

# --- verification asserts (draft claims) ------------------------------------
cou <- rec |> filter(player_name == "Kirk Cousins") |> arrange(week)
stopifnot(nrow(cou) == 9, sum(cou$hit_start) == 5, round(max(cou$p), 2) == 0.34)

# ============================================================================
# Candidate 1 -- chart: Cousins, nine games vs the 20-pt line
# ============================================================================
cou <- cou |>
  mutate(lab_x = paste0("W", week, "\n", defteam),
         hit = hit_start,
         pct = percent(p, accuracy = 1))
p1 <- ggplot(cou, aes(factor(week), fp_actual)) +
  geom_col(aes(fill = hit), width = 0.65) +
  geom_hline(yintercept = 20, color = col_red, linetype = "dashed", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%.1f", fp_actual)), vjust = -0.5, size = 3.6,
            color = col_text, fontface = "bold") +
  geom_text(aes(y = -3.2, label = pct), size = 3.6, color = col_subtext) +
  annotate("label", x = 9.45, y = 31.2, label = "Dashed line = 20-pt start line", hjust = 1,
           size = 3.2, color = col_red, fill = "white", linewidth = 0) +
  annotate("text", x = 0.45, y = -3.2, label = "Model\nstart\nchance", hjust = 1,
           size = 2.9, color = col_subtext, lineheight = 0.9) +
  scale_x_discrete(labels = setNames(cou$lab_x, cou$week)) +
  scale_fill_manual(values = c(`TRUE` = col_blue, `FALSE` = "#C9CED3")) +
  scale_y_continuous(limits = c(-5.5, 33), breaks = seq(0, 30, 10),
                     expand = c(0, 0)) +
  coord_cartesian(clip = "off") +
  labs(title = "The model never gave Kirk Cousins better than a 34% shot.\nHe cleared 20 points five times in nine games.",
       subtitle = "Fantasy points by game, Weeks 1-9, with the model's pre-game chance of reaching 20 below each bar (blue = cleared it)",
       x = NULL, y = "Fantasy points", caption = cap) +
  theme_merrittocracy_light() + theme_full +
  theme(axis.text.x = element_text(size = 9, lineheight = 0.95),
        plot.margin = margin(14, 20, 10, 14))
save_chart(p1, "candidate_1.png")

# ============================================================================
# Candidate 2 -- gt table: the receipts for the players the draft names
# ============================================================================
tbl_players <- c("Kirk Cousins", "Kyler Murray", "Carson Wentz",
                 "Keenan Allen", "Josh Downs", "Daniel Jones",
                 "Jonathan Taylor", "Marvin Harrison Jr.")
played <- rec |>
  filter(player_name %in% tbl_players, !dnp) |>
  group_by(player_name) |>
  summarise(line = first(thresh_start), g = n(),
            hits = sum(hit_start), exp_hits = sum(p),
            avg_p = mean(p), avg_fp = mean(fp_actual), .groups = "drop")
missed <- rec |> filter(player_name %in% tbl_players) |>
  group_by(player_name) |> summarise(dnp = sum(dnp), .groups = "drop")
tbl_df <- played |>
  left_join(missed, by = "player_name") |>
  mutate(player_name = factor(player_name, tbl_players)) |>
  arrange(player_name) |>
  mutate(player_name = as.character(player_name),
         record = paste0(hits, " of ", g)) |>
  select(player_name, line, record, exp_hits, avg_p, avg_fp, dnp)
stopifnot(tbl_df$record[tbl_df$player_name == "Kirk Cousins"] == "5 of 9")
zero_rows <- which(startsWith(tbl_df$record, "0 "))

t2 <- tbl_df |>
  gt() |>
  cols_label(player_name = "Player", line = "Line (pts)",
             record = "Cleared line", exp_hits = "Model expected",
             avg_p = "Avg start chance", avg_fp = "Avg pts", dnp = "Games missed") |>
  tab_header(
    title = md("**The Receipts Behind The Deadline Deals**"),
    subtitle = md("Model start chance vs. what happened, 2026 Weeks 1-9")) |>
  fmt_number(columns = c(exp_hits, avg_fp), decimals = 1) |>
  fmt_percent(columns = avg_p, decimals = 0) |>
  cols_align(align = "center", columns = -player_name) |>
  tab_style(style = cell_text(weight = "bold"), locations = cells_column_labels()) |>
  tab_style(style = list(cell_fill(color = "#E8F1F7"),
                         cell_text(weight = "bold", color = "#2A5F82")),
            locations = cells_body(rows = 1)) |>
  tab_style(style = cell_text(color = "#C0392B", weight = "bold"),
            locations = cells_body(columns = record, rows = zero_rows)) |>
  tab_footnote("Sum of pre-game start chances over games played. Compare with 'Cleared line'.",
               locations = cells_column_labels(columns = exp_hits)) |>
  tab_footnote("Averages cover games played only; missed games are counted here instead.",
               locations = cells_column_labels(columns = dnp)) |>
  tab_source_note(md("**TheMerrittocracy** · Source: Boxscore Prophet 10d receipts, 2026 Weeks 1-9. Start line: QB 20 pts, RB/WR 15 pts.")) |>
  gtExtras::gt_theme_nytimes() |>
  tab_options(table.font.size = px(13), heading.title.font.size = px(18),
              heading.subtitle.font.size = px(12), column_labels.font.size = px(12),
              data_row.padding = px(7), source_notes.font.size = px(10),
              footnotes.font.size = px(10),
              table.background.color = "#FFFFFF")
gtsave(t2, file.path(out_dir, "candidate_2.png"), vwidth = 900, vheight = 640)

# ============================================================================
# Candidate 3 -- chart: Indy offense start chances, Taylor highlighted
# ============================================================================
ind <- rec |>
  filter(player_name %in% c("Jonathan Taylor", "Keenan Allen", "Josh Downs", "Daniel Jones"),
         posteam == "IND") |>
  mutate(hi = ifelse(player_name == "Jonathan Taylor", "Taylor", "Other"))
ends <- ind |> filter(week == 9)
stopifnot(round(max(ind$p[ind$player_name == "Jonathan Taylor"]), 2) == 0.77)
stopifnot(max(ind$p[ind$player_name != "Jonathan Taylor"]) < 0.46)
p3 <- ggplot(ind, aes(week, p, group = player_name, color = hi)) +
  geom_hline(yintercept = 0.5, color = "#CFCFCF", linetype = "dashed", linewidth = 0.4) +
  geom_line(aes(linewidth = hi)) +
  geom_point(aes(size = hi)) +
  geom_text_repel(data = ends, aes(label = glue("{player_name}  {percent(p, accuracy = 1)}")),
                  seed = 42, direction = "y", hjust = 0, nudge_x = 0.25,
                  xlim = c(9.2, 12.4), size = 3.6, fontface = "bold",
                  segment.color = "#BBBBBB", segment.size = 0.3, box.padding = 0.35) +
  annotate("text", x = 4, y = 0.83, label = "Week 4 peak: 77%", size = 3.4,
           color = col_gold, fontface = "bold", hjust = 0.5) +
  scale_color_manual(values = c(Taylor = col_gold, Other = col_blue)) +
  scale_linewidth_manual(values = c(Taylor = 1.5, Other = 0.8)) +
  scale_size_manual(values = c(Taylor = 3, Other = 2)) +
  scale_x_continuous(breaks = 1:9, labels = paste0("W", 1:9), limits = c(1, 12.4),
                     expand = expansion(mult = c(0.02, 0))) +
  scale_y_continuous(labels = percent_format(accuracy = 1), limits = c(0, 0.9)) +
  labs(title = "Before the fire sale, the model had Jonathan Taylor\nsliding from 77% to 51%",
       subtitle = "Pre-game chance to clear the start line (RB/WR 15 pts, QB 20 pts). Allen, Downs and Daniel Jones never topped 45%.",
       x = NULL, y = "Model start chance", caption = cap) +
  theme_merrittocracy_light() + theme_full
save_chart(p3, "candidate_3.png")

# ============================================================================
# Candidate 4 (wildcard) -- patchwork: receipt barcode + expected vs actual
# ============================================================================
wc_players <- c("Kirk Cousins", "Kyler Murray", "Carson Wentz",
                "Keenan Allen", "Josh Downs", "Daniel Jones", "Jonathan Taylor",
                "Marvin Harrison Jr.")
grp_lv <- c("Vikings QBs", "Colts offense", "Houston's buy")
grp_of <- c("Kirk Cousins" = grp_lv[1], "Kyler Murray" = grp_lv[1],
            "Carson Wentz" = grp_lv[1],
            "Keenan Allen" = grp_lv[2], "Josh Downs" = grp_lv[2],
            "Daniel Jones" = grp_lv[2], "Jonathan Taylor" = grp_lv[2],
            "Marvin Harrison Jr." = grp_lv[3])
wc <- rec |>
  filter(player_name %in% wc_players) |>
  mutate(grp = factor(grp_of[player_name], grp_lv),
         player = factor(player_name, rev(wc_players)),
         ratio = fp_actual / thresh_start,
         hit = !dnp & ratio >= 1,
         lab = ifelse(dnp, "DNP", ifelse(abs(fp_actual) < 0.5, "0", sprintf("%.0f", fp_actual))),
         # misses run light red -> near white; hits jump to blue so 20.2 reads as a clear
         fillv = ifelse(dnp, NA, ifelse(hit, 1.15 + pmin(ratio - 1, 0.7), pmin(ratio, 0.99))),
         txtcol = ifelse(!dnp & hit & ratio > 1.3, "w", "d"))

pA <- ggplot(wc, aes(week, player)) +
  geom_tile(aes(fill = fillv), color = "white", linewidth = 1.2) +
  geom_text(aes(label = lab, color = txtcol), size = 3.2, fontface = "bold") +
  scale_color_manual(values = c(w = "#FFFFFF", d = col_text)) +
  scale_fill_gradient2(low = "#E8A59C", mid = "#FBF3F1", high = col_blue,
                       midpoint = 1.0, na.value = "#E2E2E2", limits = c(0, 1.85)) +
  scale_x_continuous(breaks = 1:9, labels = paste0("W", 1:9), position = "top",
                     expand = c(0, 0)) +
  facet_grid(grp ~ ., scales = "free_y", space = "free_y", switch = "y") +
  labs(x = NULL, y = NULL,
       subtitle = "Fantasy points per game\nBlue = cleared the start line") +
  theme_merrittocracy_light() +
  theme(panel.grid = element_blank(),
        axis.text.y = element_text(color = col_text, size = 9.5, face = "bold"),
        axis.text.x = element_text(size = 9),
        strip.placement = "outside",
        strip.text.y.left = element_text(angle = 0, hjust = 1, face = "bold",
                                         color = col_subtext, size = 8.5),
        panel.spacing.y = unit(8, "pt"),
        plot.subtitle = element_text(size = 9, color = col_subtext, margin = margin(b = 4)),
        plot.margin = margin(4, 4, 4, 4))

sm <- rec |>
  filter(player_name %in% wc_players, !dnp) |>
  group_by(player_name) |>
  summarise(g = n(), hits = sum(hit_start), exp = sum(p), .groups = "drop") |>
  mutate(grp = factor(grp_of[player_name], grp_lv),
         player = factor(player_name, rev(wc_players)),
         rate = hits / g, exp_rate = exp / g,
         dir = ifelse(rate > exp_rate, "over", "under"))
stopifnot(sm$hits[sm$player_name == "Kirk Cousins"] == 5)
pB <- ggplot(sm, aes(y = player)) +
  geom_segment(aes(x = exp_rate, xend = rate, yend = player), color = "#BBBBBB", linewidth = 1.1) +
  geom_point(aes(x = exp_rate), shape = 21, fill = "white", color = col_subtext,
             size = 3.6, stroke = 1) +
  geom_point(aes(x = rate, color = dir), size = 3.6) +
  geom_text(aes(x = 1.08, label = paste0(hits, " of ", g)),
            hjust = 0, size = 3.2, color = col_text) +
  scale_color_manual(values = c(over = col_blue, under = col_red)) +
  scale_x_continuous(labels = percent_format(accuracy = 1), limits = c(0, 1.45),
                     breaks = c(0, 0.5, 1), position = "top") +
  facet_grid(grp ~ ., scales = "free_y", space = "free_y") +
  labs(x = NULL, y = NULL,
       subtitle = "Share of games cleared\nOpen = model expected\nFilled = actual") +
  theme_merrittocracy_light() +
  theme(axis.text.y = element_blank(), strip.text = element_blank(),
        panel.spacing.y = unit(8, "pt"),
        plot.subtitle = element_text(size = 9, color = col_subtext, margin = margin(b = 4)),
        plot.margin = margin(4, 4, 4, 4))

p4 <- (pA + pB + plot_layout(widths = c(3.1, 1.4))) +
  plot_annotation(
    title = "Nine weeks of receipts on the deadline's cast:\nKirk Cousins is the one who beat the model",
    subtitle = "Model start chance vs. actual results for the players the draft names, 2026 Weeks 1-9.",
    caption = cap,
    theme = theme(plot.background = element_rect(fill = col_bg, color = NA),
                  plot.title = element_text(color = col_text, face = "bold", size = 15),
                  plot.subtitle = element_text(color = col_subtext, size = 9,
                                               margin = margin(b = 8)),
                  plot.caption = element_text(color = col_subtext, size = 8, hjust = 0),
                  plot.margin = margin(14, 16, 10, 14)))
save_chart(p4, "candidate_4.png")

cat("done\n")
