suppressMessages(library(dplyr))
out <- "/Users/stephenmerritt/boxscore-prophet/output"
f <- list.files(out, pattern = "^10d_receipts_2026_w[0-9]+\\.csv$", full.names = TRUE)
d <- bind_rows(lapply(f, function(x) {
  read.csv(x) |> mutate(week = as.integer(sub(".*_w([0-9]+)\\.csv$", "\\1", x)))
}))
pl <- c("Keenan Allen", "Josh Downs", "Marvin Harrison Jr.", "Kirk Cousins", "Daniel Jones",
        "Jonathan Taylor", "Tony Pollard", "Brock Purdy", "Kyler Murray", "Carson Wentz",
        "Rashee Rice", "Xavier Worthy", "Brian Thomas Jr.", "Quenton Nelson")
x <- d |> filter(player_name %in% pl) |>
  mutate(p = round(p_start_recal, 3), fp = round(fp_actual, 1)) |>
  select(player_name, posteam, week, thr = thresh_start, p, fp, dnp, hit = hit_start)
for (n in pl) { cat("\n", n, "\n"); print(as.data.frame(filter(x, player_name == n) |> arrange(week) |> select(-player_name)), row.names = FALSE) }
