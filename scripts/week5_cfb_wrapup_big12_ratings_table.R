# ============================================================================
# week5_cfb_wrapup_big12_ratings_table.R
#
# Candidate 3 (standard, table) for draft/week5_cfb_wrapup.md ("Records Are
# Cheap"). Section: "Oklahoma State Has the Win. Everyone Else Has a
# Schedule."
#
# Four Big 12 contenders, four rating systems that do not agree on any of
# them. Columns: AP rank, record, Net EPA rank, SP+ rank, FPI rank, Elo
# rank, best win.
#
# Data (verified against Steve's data packet; matches article text where
# the article gives a number):
#   Oklahoma State: 3-1, AP 18th; SP+ 34th, net EPA 45th, FPI 45th, Elo
#     101st; FPI SOS 51st; best win Oregon (SP+ 8th)
#   BYU: 4-0, AP 8th; net EPA 3rd, SP+ 17th, FPI 16th, Elo 28th; best win
#     Arizona (SP+ 33rd)
#   Texas Tech: 5-0, AP 11th; net EPA 64th, SP+ 11th, FPI 11th, Elo 9th;
#     FPI SOS 88th; best win Houston (SP+ 29th)
#   Utah: 4-0, AP 12th; SP+ 9th, net EPA 6th, FPI 12th, Elo 8th; FPI SOS
#     111th; best win Iowa State (SP+ 58th)
#
# FPI and Elo re-pulled Oct. 5 and ranked against the same 138 FBS teams
# (second data packet), which filled the three blank cells and corrected
# Oklahoma State's Elo (101st, not 102nd) and FPI SOS (51st, not 45th).
#
# Output: graphics/week5_cfb_wrapup/candidate_3.png
# ============================================================================

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Data --------------------------------------------------------------------

big12 <- tibble::tribble(
  ~team,           ~record,  ~ap_rank, ~net_epa, ~sp_plus, ~fpi,  ~elo,  ~best_win,
  "Oklahoma State", "3-1",   "18th",   "45th",   "34th",   "45th", "101st", "Oregon (SP+ 8th)",
  "BYU",            "4-0",   "8th",    "3rd",    "17th",   "16th", "28th",  "Arizona (SP+ 33rd)",
  "Texas Tech",     "5-0",   "11th",   "64th",   "11th",   "11th", "9th",   "Houston (SP+ 29th)",
  "Utah",           "4-0",   "12th",   "6th",    "9th",    "12th", "8th",   "Iowa State (SP+ 58th)"
)

# Row indices for styling
osu_row  <- which(big12$team == "Oklahoma State")
byu_row  <- which(big12$team == "BYU")
ttu_row  <- which(big12$team == "Texas Tech")
utah_row <- which(big12$team == "Utah")

# --- Build table --------------------------------------------------------------

tbl <- big12 |>
  gt() |>

  cols_label(
    team     = "Team",
    record   = "Record",
    ap_rank  = "AP rank",
    net_epa  = "Net EPA",
    sp_plus  = "SP+",
    fpi      = "FPI",
    elo      = "Elo",
    best_win = "Best win"
  ) |>

  tab_header(
    title    = md("**Four Ratings Systems, Four Different Stories**"),
    subtitle = md("Big 12's ranked teams, by system (all ranks nationally, 1 = best)")
  ) |>

  tab_footnote(
    footnote  = "Opened the season with a 24-10 loss at Tulsa (SP+ 83rd).",
    locations = cells_body(columns = team, rows = osu_row)
  ) |>
  tab_footnote(
    footnote  = "SP+ was 121st a year ago; now 34th.",
    locations = cells_body(columns = sp_plus, rows = osu_row)
  ) |>
  tab_footnote(
    footnote  = "FPI rates Oklahoma State's strength of schedule 51st nationally.",
    locations = cells_body(columns = fpi, rows = osu_row)
  ) |>
  tab_footnote(
    footnote  = "FPI rates BYU's strength of schedule 93rd nationally.",
    locations = cells_body(columns = fpi, rows = byu_row)
  ) |>
  tab_footnote(
    footnote  = "FPI rates Utah's schedule 111th, the weakest of the four (Texas Tech 88th, BYU 93rd, Oklahoma State 51st).",
    locations = cells_body(columns = best_win, rows = utah_row)
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** \u00b7 Data via cfbfastR / College Football Data API. Net EPA is raw, garbage time excluded; SP+ through Week 4; FPI and Elo as of Oct. 5.")
  ) |>

  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(19),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(7),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(9.5),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_column_labels()
  ) |>

  tab_style(
    style     = cell_text(weight = "bold"),
    locations = cells_body(columns = team)
  ) |>

  # Oklahoma State: the one top-20 win, call it out
  tab_style(
    style     = list(cell_fill(color = "#E8F5E9")),
    locations = cells_body(rows = osu_row)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold", color = "#2E7D32"),
    locations = cells_body(columns = best_win, rows = osu_row)
  ) |>

  # Texas Tech: SP+ far out of line with net EPA (likely preseason-prior propped)
  tab_style(
    style     = list(cell_fill(color = "#FFEBEE")),
    locations = cells_body(columns = c(net_epa, sp_plus), rows = ttu_row)
  ) |>
  tab_style(
    style     = cell_text(weight = "bold", color = "#C62828"),
    locations = cells_body(columns = net_epa, rows = ttu_row)
  ) |>

  cols_align(align = "center", columns = c(record, ap_rank, net_epa, sp_plus, fpi, elo)) |>
  cols_align(align = "left",   columns = c(team, best_win)) |>

  cols_width(
    team     ~ px(130),
    record   ~ px(70),
    ap_rank  ~ px(75),
    net_epa  ~ px(80),
    sp_plus  ~ px(70),
    fpi      ~ px(70),
    elo      ~ px(75),
    best_win ~ px(170)
  )

# --- Save as PNG ------------------------------------------------------------

output_dir <- "graphics/week5_cfb_wrapup"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "candidate_3.png"), vwidth = 760)

message("Saved: ", file.path(output_dir, "candidate_3.png"))
