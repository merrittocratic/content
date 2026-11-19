# Data pull: price paid vs. size of hole, 2026 in-season trades (relative paths)
# Expected (written before running): no strong correlation across deals; JAX/Davis
# and HOU/Harrison = high price, small need; SF/Buckner, SF/Allen, MIN/Cousins = low price, high need.
suppressMessages({library(nflreadr); library(dplyr)})

pbp <- load_pbp(2026) |> filter(season_type == "REG", week <= 9, !is.na(epa), play_type %in% c("pass","run"))

# Rough pick-value scale (Jimmy Johnson-style, mid-round); approximation, documented in output
rv <- c(`1`=1000, `2`=370, `3`=170, `4`=80, `5`=35, `6`=15, `7`=6)

# buyer = team receiving the player; paid = picks buyer sends; got = picks buyer receives
trades <- tribble(
 ~deal, ~buyer, ~pos_group, ~paid, ~got,
 "Cousins to MIN", "MIN", "pass_off", "3", "",
 "Allen to SF", "SF", "pass_off", "6", "",
 "Downs to KC", "KC", "pass_off", "4,5", "7",
 "Harrison to HOU", "HOU", "pass_off", "2,7", "6",
 "Davis to JAX", "JAX", "rush_def", "1,2", "",
 "Godchaux to JAX", "JAX", "rush_def", "6", "",
 "Bates to JAX", "JAX", "pass_def", "2,5", "",
 "Buckner to SF", "SF", "pass_rush", "4", "",
 "Simmons to CHI", "CHI", "overall_def", "1,1,4", "5",
 "Hooker to BUF", "BUF", "pass_def", "2", "5",
 "Cisco to DET", "DET", "pass_def", "6", "",
 "Brissett to BAL", "BAL", "pass_off", "4,7", "5",
 "Neuzil to BAL", "BAL", "rush_off", "0", "6",
 "Nelson to SEA", "SEA", "rush_off", "3,5", "",
 "Jurgens to BAL", "BAL", "rush_off", "5,2", "7",
 "Porter to DAL", "DAL", "pass_def", "6,2", "",
 "McCarthy to NYG", "NYG", "pass_off", "5", ""
)
val <- function(s) if (s == "") 0 else sum(unname(rv[strsplit(s, ",")[[1]]]), na.rm = TRUE)
trades <- trades |> rowwise() |> mutate(price = val(paid) - val(got)) |> ungroup()

# Unit EPA ranks (1 = best, 32 = worst), weeks 1-9. Hole rank = 33 - rank of how bad the unit is.
off <- pbp |> group_by(team = posteam) |> summarise(
  pass_off = mean(epa[play_type == "pass"]), rush_off = mean(epa[play_type == "run"]))
def <- pbp |> group_by(team = defteam) |> summarise(
  pass_def = mean(epa[play_type == "pass"]), rush_def = mean(epa[play_type == "run"]),
  pass_rush = mean(sack[play_type == "pass"], na.rm = TRUE),
  overall_def = mean(epa))
u <- left_join(off, def, by = "team")
# need rank: 1 = worst unit. Offense/defense EPA: offense low = bad; defense high = bad; sacks high = good
need <- u |> mutate(
  pass_off = rank(pass_off), rush_off = rank(rush_off),
  pass_def = rank(-pass_def), rush_def = rank(-rush_def), pass_rush = rank(pass_rush),
  overall_def = rank(-overall_def)) |>
  tidyr::pivot_longer(-team, names_to = "pos_group", values_to = "need_rank")
out <- trades |> left_join(need, by = c("buyer" = "team", "pos_group")) |>
  mutate(hole = 33 - need_rank)   # 32 = worst unit in league
print(as.data.frame(out |> select(deal, buyer, pos_group, price, need_rank)))
cat("Spearman price vs. need rank (hole=33-rank; high = worse unit):",
    round(cor(out$price, out$hole, method = "spearman"), 2), "n =", nrow(out), "\n")
write.csv(out, "price_vs_hole.csv", row.names = FALSE)
