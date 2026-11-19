# Verdict board (gt). Run from repo root. Facts from the corrected W10 packet (nflverse thru Wk 9)
# and NFL.com trade tracker. Expected: reader sees at a glance which deals fixed a real
# hole (JAX, SF Buckner, MIN), which bought a name (SF Allen, KC), and the miss (HOU).
suppressMessages({library(gt); library(dplyr)})
d <- tribble(
 ~deal, ~price, ~why, ~cause, ~verdict, ~watch,
 "Jacksonville: Davis, Godchaux, Bates", "2027 1st, 2027 2nd, 2029 2nd, 2028 5th, 2028 6th",
   "Run defense went from 72.7 to 141.5 yards a game after Hamilton went down, though EPA per rush held at -0.17", "Injury", "Real patch, steep price",
   "Pollard's yards per carry at Tennessee (4.5 is the bar)",
 "San Francisco: Buckner", "2027 4th", "Sack rate of 5.2% is 27th", "Season-long", "Real fix", "Whether the 49ers sack Prescott at all",
 "San Francisco: Allen", "2027 6th", "No receiver above 11 targets in Weeks 6-9 with Evans and Samuel out", "Injury", "A name, cheap", "Whether a chain-mover (separation 101st of 118) moves the offense",
 "Kansas City: Downs", "2027 4th, 2027 5th (get a 7th)", "Worthy averages 5.91 yards a target, 60th of 66", "Season-long", "Fair price", "Downs's snap share against Worthy's",
 "Minnesota: Cousins", "2027 3rd", "Murray at -0.07 and Wentz at -0.27 EPA per dropback", "Injury and play", "Biggest upgrade", "Sacks taken: line allows a 9.2% sack rate, 27th",
 "Chicago: Simmons", "2027 1st, 2028 1st, 2027 4th (get a 5th)", "Not a hole: defense already 10th in EPA per play", "None", "Good, ahead of profile", "Giveaways: -4 turnover margin, ten of 17 in two games",
 "Houston: Harrison", "2027 2nd, 2027 7th (get a 6th)", "Not a hole: Stroud's completion rate above expectation is +5.9, 3rd of 37", "None", "The miss", "Snap share: 19%, 21%, 46%",
 "Indianapolis: seller", "Got a 3rd, two 4ths, two 5ths, a 6th", "Sold Allen, Downs, Buckner, Nelson at 2-7", "Selling", "Made a bad unit worse", "Taylor's snap share, not just his yards"
)
col_for <- function(v) dplyr::case_when(
  v %in% c("Real patch, steep price","Real fix","Biggest upgrade","Good, ahead of profile") ~ "#2E6F9E",
  v %in% c("The miss") ~ "#C0392B", TRUE ~ "#6B7378")
t <- d |> gt() |>
  cols_label(deal = "Deal", price = "Price paid", why = "Why they bought", cause = "Source of need",
             verdict = "Verdict", watch = "Watch") |>
  tab_header(title = md("**The buyers with real holes fixed them. Houston's was never a hole.**"),
             subtitle = "The deadline's biggest deals: what each cost and what it fixed") |>
  tab_source_note("Source: nflverse play-by-play (Weeks 1-9, Thursday's Week 10 game excluded), NFL.com trade tracker. Picks are listed as the buyer sends them.") |>
  tab_style(style = cell_text(weight = "bold"), locations = cells_body(columns = deal)) |>
  tab_options(table.font.size = px(13), heading.title.font.size = px(18),
              heading.subtitle.font.size = px(13), table.background.color = "white",
              table.border.top.color = "white", column_labels.font.weight = "bold",
              data_row.padding = px(7)) |>
  cols_width(deal ~ px(190), price ~ px(190), why ~ px(290), cause ~ px(100), verdict ~ px(140), watch ~ px(240))
for (i in seq_len(nrow(d))) {
  t <- t |> tab_style(style = cell_text(color = col_for(d$verdict[i]), weight = "bold"),
                      locations = cells_body(columns = verdict, rows = i))
}
gtsave(t, "graphics/week10_trade_deadline/verdict_board.png", vwidth = 1250, vheight = 800)
