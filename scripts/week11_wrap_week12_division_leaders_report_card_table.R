# week11_wrap_week12_division_leaders_report_card_table.R
#
# Report-card table for "Here's the deal, I'm the best there is." (nfl-season,
# 2026-11-29): the eight profiled teams in article order, plus the three
# division leaders outside them (DEN, NYG, CAR) as greyed contrast rows.
#
# Expected result (written before building):
#   - SF has no red (bottom-8) cell; DET's defense (27th) is red; KC (32nd)
#     and CIN (31st) are red on schedule.
#   - The contrast rows sit in the middle of the league: NYG and CAR outside
#     the top 12 in SRS and net EPA, DEN 8th in SRS but 12th in net EPA.
#
# Data: nflverse via nflreadr, regular season, Weeks 1-11. Net EPA uses
# pass == 1 | rush == 1 plays (matches the article's ranks). SRS solved
# iteratively from game margins; shown as rank only, because the values
# run ~0.05-0.1 above the packet's (ranks match exactly). Schedule = opponents' combined win rate,
# rank 1 = hardest.
#
# Packages: nflreadr, dplyr, gt
# Output: graphics/week11_wrap_week12_division_leaders/report_card_table.png

library(nflreadr)
library(dplyr)
library(gt)

out_path <- "graphics/week11_wrap_week12_division_leaders/report_card_table.png"
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

LAST_WEEK <- 11

# --- 1. Game-level data ------------------------------------------------------
sched <- load_schedules(2026) |>
  filter(game_type == "REG", week <= LAST_WEEK, !is.na(result))

games <- bind_rows(
  sched |> transmute(team = home_team, opp = away_team, pf = home_score, pa = away_score),
  sched |> transmute(team = away_team, opp = home_team, pf = away_score, pa = home_score)
) |>
  mutate(w = (pf > pa) + 0.5 * (pf == pa), margin = pf - pa)

rec <- games |>
  group_by(team) |>
  summarise(
    wins = sum(pf > pa), losses = sum(pf < pa), ties = sum(pf == pa),
    win_pct = mean(w), mov = mean(margin), .groups = "drop"
  ) |>
  mutate(record = if_else(ties > 0, sprintf("%d-%d-%d", wins, losses, ties),
                          sprintf("%d-%d", wins, losses)))

# SRS: margin of victory plus average opponent rating, iterated to converge
srs <- setNames(rec$mov, rec$team)
for (i in 1:200) {
  opp_avg <- tapply(srs[games$opp], games$team, mean)
  srs <- rec$mov + opp_avg[rec$team]
  names(srs) <- rec$team
}

# Record vs. teams currently above .500, and schedule strength
games <- games |>
  left_join(rec |> select(opp = team, opp_wins = wins, opp_losses = losses,
                          opp_win_pct = win_pct), by = "opp")

vs_win <- games |>
  filter(opp_wins > opp_losses) |>
  group_by(team) |>
  summarise(vw = sprintf("%d-%d", sum(pf > pa), sum(pf < pa)), .groups = "drop")

sos <- games |> group_by(team) |> summarise(opp_wp = mean(opp_win_pct), .groups = "drop")

# --- 2. EPA ------------------------------------------------------------------
pbp <- load_pbp(2026) |>
  filter(season_type == "REG", week <= LAST_WEEK, !is.na(epa),
         !is.na(posteam), pass == 1 | rush == 1)
off <- pbp |> group_by(team = posteam) |> summarise(off = mean(epa))
def <- pbp |> group_by(team = defteam) |> summarise(def = mean(epa))

# --- 3. League-wide ranks, then keep the table's teams -----------------------
rk <- function(x) rank(x, ties.method = "min")

all_teams <- rec |>
  mutate(srs = srs[team]) |>
  left_join(off, by = "team") |>
  left_join(def, by = "team") |>
  left_join(sos, by = "team") |>
  left_join(vs_win, by = "team") |>
  mutate(
    net = off - def,
    mov_rk = rk(-mov), srs_rk = rk(-srs), net_rk = rk(-net),
    off_rk = rk(-off), def_rk = rk(def), sos_rk = rk(-opp_wp)
  )

profiled <- c("SF", "JAX", "BUF", "KC", "CIN", "DET", "CHI", "LA")
contrast <- c("DEN", "NYG", "CAR")

tbl_df <- all_teams |>
  filter(team %in% c(profiled, contrast)) |>
  mutate(
    grp   = if_else(team %in% profiled, "The eight profiled",
                    "Division leaders not profiled"),
    order = match(team, c(profiled, contrast)),
    mov_txt = sprintf("%+.1f", mov),
    srs_txt = sprintf("%+.1f", srs),
    opp_txt = sub("^0", "", sprintf("%.3f", opp_wp))
  ) |>
  arrange(order) |>
  select(grp, team, record, mov_txt, mov_rk, srs_rk, net_rk,
         off_rk, def_rk, vw, opp_txt, sos_rk)

print(as.data.frame(tbl_df))

# --- 4. Table ----------------------------------------------------------------
rank_cols <- c("mov_rk", "srs_rk", "net_rk", "off_rk", "def_rk", "sos_rk")
fill_good <- "#E8F5E9"; text_good <- "#2E7D32"
fill_bad  <- "#FFEBEE"; text_bad  <- "#C62828"

tbl <- tbl_df |>
  gt(groupname_col = "grp") |>
  tab_header(
    title    = md("**Six Real Leaders, Two Contenders, One Cliff**"),
    subtitle = md("Ranks out of 32, Weeks 1-11. Green: top 8. Red: bottom 8.")
  ) |>
  cols_label(
    team = "Team", record = "Rec",
    mov_txt = "Pt diff/g", mov_rk = "Rk",
    srs_rk = "SRS rk",
    net_rk = "Net EPA rk", off_rk = "Off EPA rk", def_rk = "Def EPA rk",
    vw = "vs. winning", opp_txt = "Opp win %", sos_rk = "Sched rk"
  ) |>
  tab_spanner(label = "Margin", columns = c(mov_txt, mov_rk, srs_rk)) |>
  tab_spanner(label = "Efficiency", columns = c(net_rk, off_rk, def_rk)) |>
  tab_spanner(label = "Schedule", columns = c(vw, opp_txt, sos_rk)) |>
  cols_align("center", columns = -team) |>
  cols_align("left", columns = team) |>
  tab_style(cell_text(weight = "bold"), cells_body(columns = team)) |>
  tab_style(cell_text(weight = "bold"), cells_row_groups())

for (col in rank_cols) {
  tbl <- tbl |>
    tab_style(list(cell_fill(fill_good), cell_text(color = text_good, weight = "bold")),
              cells_body(columns = all_of(col), rows = .data[[col]] <= 8)) |>
    tab_style(list(cell_fill(fill_bad), cell_text(color = text_bad, weight = "bold")),
              cells_body(columns = all_of(col), rows = .data[[col]] >= 25))
}

tbl <- tbl |>
  # Contrast rows: grey text on everything that isn't a colored rank cell
  tab_style(cell_text(color = "#888888"),
            cells_body(columns = c(team, record, mov_txt, vw, opp_txt),
                       rows = grp == "Division leaders not profiled")) |>
  tab_footnote(
    "SRS: average point margin adjusted for opponent strength.",
    locations = cells_column_labels(columns = srs_rk)
  ) |>
  tab_footnote(
    "Net EPA: offensive EPA per play minus defensive EPA per play allowed, pass and run plays.",
    locations = cells_column_labels(columns = net_rk)
  ) |>
  tab_footnote(
    "Record against teams currently above .500.",
    locations = cells_column_labels(columns = vw)
  ) |>
  tab_footnote(
    "Opponents' combined win rate; rank 1 is the hardest schedule.",
    locations = cells_column_labels(columns = sos_rk)
  ) |>
  tab_source_note(md("**TheMerrittocracy** · Data via nflverse/nflreadr. KC listed as a leader by choice; DEN leads the AFC West on the common-games tiebreaker.")) |>
  tab_options(
    table.font.size = px(13), heading.title.font.size = px(18),
    heading.subtitle.font.size = px(12), column_labels.font.size = px(11),
    data_row.padding = px(5), source_notes.font.size = px(9),
    footnotes.font.size = px(9),
    table.border.top.color = "#222222",
    heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color = "#222222",
    row_group.background.color = "#F5F5F5"
  )

gtsave(tbl, out_path, vwidth = 900)
cat("wrote", out_path, "\n")
