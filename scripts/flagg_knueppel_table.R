# flagg_knueppel_table.R
# Produces the Flagg / Knueppel ROY comparison table for flagg_knueppel_roty post
# Output: graphics/flagg_knueppel_table.png
#
# Packages: gt, gtExtras, dplyr, tibble
# Install if needed:
#   install.packages(c("gt", "gtExtras", "dplyr", "tibble"))

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Team colors ---------------------------------------------------------------
mavs_blue   <- "#00538C"
mavs_silver <- "#B8C4CA"
mavs_navy   <- "#002B5E"
horn_teal   <- "#00788C"
horn_purple <- "#1D1160"
horn_light  <- "#A1C4E0"

# --- Data ----------------------------------------------------------------------

comp <- tibble::tribble(
  ~metric,          ~flagg,               ~knueppel,            ~edge,
  "Games",          "70",                 "81",                 "Knueppel",
  "Total points",   "1,470",              "1,499",              "Knueppel (+29)",
  "Points / game",  "21.0",               "18.5",               "Flagg",
  "Rebounds / game","6.7",                "5.3",                "Flagg",
  "Assists / game", "4.5",                "3.4",                "Flagg",
  "Steals / game",  "1.2",                "0.7",                "Flagg",
  "Blocks / game",  "0.9",                "0.2",                "Flagg",
  "FG%",            "46.8%",              "47.5%",              "Push",
  "3P%",            "29.5%",              "43.0%",              "Knueppel",
  "3PM (total)",    "~70",                "273 (NBA leader)",   "Knueppel",
  "Team wins",      "26",                 "44",                 "Knueppel"
)

# --- Row index helpers ---------------------------------------------------------
flagg_rows    <- which(comp$edge == "Flagg")
knueppel_rows <- which(comp$edge %in% c("Knueppel", "Knueppel (+29)"))
push_rows     <- which(comp$edge == "Push")

# --- Build table ---------------------------------------------------------------

tbl <- comp |>
  gt() |>

  # -- Column labels with colored team headers ----------------------------------
  cols_label(
    metric    = "",
    flagg     = md(paste0(
      "<span style='color:#ffffff;font-weight:700;font-size:14px;'>",
      "Cooper Flagg</span>",
      "<br><span style='color:", mavs_silver, ";font-weight:400;font-size:11px;'>",
      "Dallas Mavericks</span>"
    )),
    knueppel  = md(paste0(
      "<span style='color:#ffffff;font-weight:700;font-size:14px;'>",
      "Kon Knueppel</span>",
      "<br><span style='color:", horn_light, ";font-weight:400;font-size:11px;'>",
      "Charlotte Hornets</span>"
    )),
    edge      = md("<span style='font-size:12px;font-weight:600;'>Edge</span>")
  ) |>

  # -- Title and subtitle -------------------------------------------------------
  tab_header(
    title    = md("**ROY by the Numbers**"),
    subtitle = md("Cooper Flagg vs. Kon Knueppel · 2025–26 Regular Season")
  ) |>

  # -- Source footer ------------------------------------------------------------
  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data via NBA.com, Basketball-Reference")
  ) |>

  # -- Flagg column header: Mavs blue -------------------------------------------
  tab_style(
    style = list(
      cell_fill(color = mavs_blue),
      cell_text(color = "#ffffff", weight = "bold")
    ),
    locations = cells_column_labels(columns = flagg)
  ) |>

  # -- Knueppel column header: Hornets purple -----------------------------------
  tab_style(
    style = list(
      cell_fill(color = horn_purple),
      cell_text(color = "#ffffff", weight = "bold")
    ),
    locations = cells_column_labels(columns = knueppel)
  ) |>

  # -- Edge column header: neutral dark -----------------------------------------
  tab_style(
    style = list(
      cell_fill(color = "#333333"),
      cell_text(color = "#ffffff", weight = "bold")
    ),
    locations = cells_column_labels(columns = edge)
  ) |>

  # -- Metric column: bold label ------------------------------------------------
  tab_style(
    style = cell_text(weight = "bold", size = px(12), color = "#333333"),
    locations = cells_body(columns = metric)
  ) |>

  # -- Alternating row shading --------------------------------------------------
  tab_style(
    style = cell_fill(color = "#F8F8F8"),
    locations = cells_body(rows = c(2, 4, 6, 8, 10))
  ) |>

  # -- Flagg-edge rows: light blue tint on Flagg cell, bold edge ----------------
  tab_style(
    style = list(
      cell_fill(color = "#E3F2FD"),
      cell_text(weight = "bold", color = mavs_blue)
    ),
    locations = cells_body(columns = flagg, rows = flagg_rows)
  ) |>
  tab_style(
    style = cell_text(weight = "bold", color = mavs_blue),
    locations = cells_body(columns = edge, rows = flagg_rows)
  ) |>

  # -- Knueppel-edge rows: light purple tint on Knueppel cell, bold edge --------
  tab_style(
    style = list(
      cell_fill(color = "#EDE7F6"),
      cell_text(weight = "bold", color = horn_purple)
    ),
    locations = cells_body(columns = knueppel, rows = knueppel_rows)
  ) |>
  tab_style(
    style = cell_text(weight = "bold", color = horn_purple),
    locations = cells_body(columns = edge, rows = knueppel_rows)
  ) |>

  # -- Push rows: muted edge label ----------------------------------------------
  tab_style(
    style = cell_text(color = "#888888", style = "italic"),
    locations = cells_body(columns = edge, rows = push_rows)
  ) |>

  # -- Alignment ----------------------------------------------------------------
  cols_align(align = "center", columns = c(flagg, knueppel, edge)) |>
  cols_align(align = "left",   columns = metric) |>

  # -- Column widths ------------------------------------------------------------
  cols_width(
    metric   ~ px(150),
    flagg    ~ px(145),
    knueppel ~ px(155),
    edge     ~ px(130)
  ) |>

  # -- Overall table options ----------------------------------------------------
  tab_options(
    table.font.size                    = px(13),
    table.font.names                   = "Georgia",
    heading.title.font.size            = px(19),
    heading.subtitle.font.size         = px(12),
    heading.padding                    = px(10),
    column_labels.font.size            = px(13),
    data_row.padding                   = px(8),
    source_notes.font.size             = px(10),
    table.border.top.color             = "#222222",
    table.border.top.width             = px(2),
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#222222",
    column_labels.border.bottom.width  = px(2),
    table_body.border.bottom.color     = "#222222",
    table_body.border.bottom.width     = px(2),
    table.width                        = px(620)
  )

# --- Save as PNG ---------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "flagg_knueppel_table.png"), vwidth = 660)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'flagg_knueppel_table.png')}}")
