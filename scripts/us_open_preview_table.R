library(tidyverse)
library(gt)

players <- tibble(
  player   = c("Scottie Scheffler", "Rory McIlroy", "Tommy Fleetwood",
                "Collin Morikawa", "Cameron Young", "J.J. Spaun",
                "Maverick McNealy", "Chris Gotterup", "Kristoffer Reitan"),
  role     = c("Consensus", "Consensus", "Consensus",
                "Win > SG", "Value", "Noted",
                "Value", "Value", "Off-the-Wall"),
  sg_rank  = c(1L, 2L, 5L, 13L, 16L, 21L, 26L, 37L, 56L),
  win_pct  = c(0.101, 0.074, 0.030, 0.025, 0.013, 0.008, 0.009, 0.008, 0.004),
  form     = c(0.976, 0.217, 0.508, 0.536, 1.970, 1.033, 0.976, 1.090, 1.596),
  sg_ott   = c(0.709, 0.628, 0.242, 0.374, 0.134, 0.218, 0.054, 0.697, 0.967),
  drv_acc  = c(0.659, 0.523, 0.607, 0.698, 0.536, 0.614, 0.598, 0.604, 0.556),
  drv_dist = c(300L, 308L, 290L, 292L, 300L, 294L, 295L, 313L, 308L),
  note     = c("No argument", "No argument", "No argument",
                "Elite approach / leaky putter", "Hottest form / accuracy risk",
                "Defending champ discount", "Quiet riser",
                "Scheffler-level OTT", "Prior vs. form")
)

players |>
  gt() |>
  tab_header(
    title    = md("**Shadow Leaderboard -- US Open Preview**"),
    subtitle = "Where the model and the market agree, diverge, and get it wrong"
  ) |>
  cols_label(
    player   = "PLAYER",
    role     = "ROLE",
    sg_rank  = "SG RANK",
    win_pct  = "WIN %",
    form     = "FORM",
    sg_ott   = "SG OTT",
    drv_acc  = "DRV ACC",
    drv_dist = "DRV DIST",
    note     = "NOTE"
  ) |>
  fmt_integer(columns = c(sg_rank, drv_dist)) |>
  fmt_percent(columns = win_pct, decimals = 1) |>
  fmt_percent(columns = drv_acc, decimals = 1) |>
  fmt_number(columns = c(form, sg_ott), decimals = 3, force_sign = TRUE) |>
  # Role badges
  text_transform(
    locations = cells_body(columns = role),
    fn = function(x) {
      badges <- dplyr::case_when(
        x == "Consensus"    ~ "<span style='background-color:#e5e5e5;color:#444444;padding:2px 9px;border-radius:12px;font-size:11px;white-space:nowrap;'>Consensus</span>",
        x == "Win > SG"     ~ "<span style='background-color:#dbeafe;color:#1d4ed8;padding:2px 9px;border-radius:12px;font-size:11px;white-space:nowrap;'>Win &gt; SG</span>",
        x == "Value"        ~ "<span style='background-color:#dcfce7;color:#15803d;padding:2px 9px;border-radius:12px;font-size:11px;white-space:nowrap;'>Value</span>",
        x == "Noted"        ~ "<span style='border:1px solid #aaaaaa;color:#555555;padding:2px 9px;border-radius:12px;font-size:11px;white-space:nowrap;'>Noted</span>",
        x == "Off-the-Wall" ~ "<span style='background-color:#fef3c7;color:#92400e;padding:2px 9px;border-radius:12px;font-size:11px;white-space:nowrap;'>Off-the-Wall</span>",
        TRUE ~ x
      )
      lapply(badges, gt::html)
    }
  ) |>
  # FORM: green for hot form (>= 1.5), red for cold (<= 0.22)
  tab_style(
    style = cell_text(color = "#15803d", weight = "bold"),
    locations = cells_body(columns = form, rows = form >= 1.5)
  ) |>
  tab_style(
    style = cell_text(color = "#9b2226"),
    locations = cells_body(columns = form, rows = form <= 0.22)
  ) |>
  # SG OTT: green for elite off-the-tee (>= 0.6)
  tab_style(
    style = cell_text(color = "#15803d", weight = "bold"),
    locations = cells_body(columns = sg_ott, rows = sg_ott >= 0.6)
  ) |>
  # DRV ACC: green for high accuracy (>= 61%), red for low (<= 55.6%)
  tab_style(
    style = cell_text(color = "#15803d"),
    locations = cells_body(columns = drv_acc, rows = drv_acc >= 0.610)
  ) |>
  tab_style(
    style = cell_text(color = "#9b2226"),
    locations = cells_body(columns = drv_acc, rows = drv_acc <= 0.556)
  ) |>
  # Player names bold, note column italic gray
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = player)
  ) |>
  tab_style(
    style = cell_text(style = "italic", color = "#666666"),
    locations = cells_body(columns = note)
  ) |>
  cols_align(align = "left",  columns = c(player, role, note)) |>
  cols_align(align = "right", columns = c(sg_rank, win_pct, form, sg_ott, drv_acc, drv_dist)) |>
  cols_width(
    player   ~ px(155),
    role     ~ px(120),
    sg_rank  ~ px(75),
    win_pct  ~ px(65),
    form     ~ px(72),
    sg_ott   ~ px(72),
    drv_acc  ~ px(72),
    drv_dist ~ px(75),
    note     ~ px(160)
  ) |>
  tab_options(
    table.border.top.style            = "none",
    table.border.bottom.style         = "none",
    heading.border.bottom.style       = "none",
    column_labels.background.color    = "white",
    column_labels.font.weight         = "normal",
    column_labels.border.top.style    = "none",
    column_labels.border.bottom.color = "#cccccc",
    column_labels.border.bottom.width = px(1),
    table_body.hlines.color           = "#eeeeee",
    table_body.hlines.style           = "solid",
    table_body.border.bottom.color    = "#cccccc",
    heading.title.font.size           = px(18),
    heading.subtitle.font.size        = px(12),
    heading.align                     = "left",
    table.font.size                   = px(13),
    table.font.names                  = "Georgia",
    source_notes.font.size            = px(10),
    source_notes.border.lr.style      = "none",
    data_row.padding                  = px(12)
  ) |>
  tab_style(
    style = cell_text(color = "#888888", size = px(11)),
    locations = cells_column_labels(everything())
  ) |>
  tab_source_note(
    source_note = "Shadow Leaderboard model | DataGolf skill priors | Driving stats: last 30 rounds | Form: rolling 8-event SG residual mean"
  ) |>
  gtsave("graphics/us_open_preview_table.png", expand = 10)
