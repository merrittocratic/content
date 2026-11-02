library(dplyr)
bp <- "../boxscore-prophet/output"
names_re <- "Jared Goff|Kyler Murray|McCarthy|Joe Burrow|Caleb Williams|Deshaun Watson|Lamar Jackson|Aaron Rodgers|Tyler Huntley"
al <- bind_rows(lapply(1:7, function(w) {
  f <- file.path(bp, sprintf("10c_scored_slate_2026_w%02d.csv", w))
  read.csv(f) |> filter(position == "QB") |>
    select(week, player_name, posteam, defteam, p_start_recal, p_boom_recal, pred_tot)
}))
print(al |> filter(grepl(names_re, player_name)) |> arrange(player_name, week))
cat("QBs per week:\n"); print(table(al$week))
g <- read.csv(file.path(bp, "10d_ecr_gap_2026_w07.csv"))
print(g |> filter(position == "QB") |> arrange(model_rank))
print(al |> filter(grepl("Goff", player_name)) |> summarise(m = mean(p_start_recal), m6 = mean(p_start_recal[week < 7])))
