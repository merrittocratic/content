base <- "../boxscore-prophet/output"
fs <- list.files(base, pattern = "^10d_receipts_2026_w0[0-9]\\.csv$", full.names = TRUE)
print(basename(fs))
who <- c("Jeremiyah Love", "Marvin Harrison Jr.", "C.J. Stroud",
         "Jayden Daniels", "Dak Prescott")
for (f in fs) {
  d <- read.csv(f)
  d <- d[d$player_name %in% who, c("player_name", "posteam", "defteam",
                                   "start_pct", "boom_pct", "thresh_start",
                                   "fp_actual", "dnp")]
  cat("\n", basename(f), "\n")
  print(d, row.names = FALSE)
}
for (f in c("10d_ecr_lock_2026_w06.csv", "10d_ecr_gap_2026_w06.csv")) {
  d <- read.csv(file.path(base, f))
  cat("\n", f, "\n")
  print(names(d))
  print(d[grepl("Prescott|Jayden Daniels|Stroud|Jeremiyah Love|Harrison Jr", d$player_name), ],
        row.names = FALSE)
}
