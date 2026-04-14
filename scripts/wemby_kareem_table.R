# wemby_kareem_table.R
# Produces the Kareem / Wemby comparison table for the wemby_kareem_precedent post
# Output: graphics/wemby_kareem_table.png
#
# Packages: gt, gtExtras, dplyr, tibble
# Install if needed:
#   install.packages(c("gt", "gtExtras", "dplyr", "tibble"))

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Team colors ---------------------------------------------------------------
bucks_green  <- "#00471B"
bucks_cream  <- "#EEE1C6"
spurs_black  <- "#000000"
spurs_silver <- "#C4CED4"

# --- Data ----------------------------------------------------------------------

comp <- tibble::tribble(
  ~metric,              ~kareem,              ~wemby,
  "Record",             "66–16",              "62–20",
  "Player's year",      "Year 2",             "Year 3",
  "Playoff appearance", "2nd",                "1st",
  "Player's age",       "24",                 "22",
  "#1 overall pick",    "\u2713",             "\u2713",
  "Regular season MVP", "Won it",             "In the Hunt",
  "Defensive Player",   "Dominant",           "DPOY frontrunner",
  "Co-star",            "Oscar Robertson",    "De'Aaron Fox"
)

# --- Row indices for styling ---------------------------------------------------
playoff_row  <- which(comp$metric == "Playoff appearance")
check_rows   <- which(comp$metric == "#1 overall pick")
mvp_row      <- which(comp$metric == "Regular season MVP")
costar_row   <- which(comp$metric == "Co-star")

# --- Build table ---------------------------------------------------------------

tbl <- comp |>
  gt() |>

  # -- Column labels with colored team headers ----------------------------------
  cols_label(
    metric = "",
    kareem = md(paste0(
      "<span style='color:", bucks_cream, ";font-weight:700;font-size:14px;'>",
      "Kareem's Bucks</span>",
      "<br><span style='color:", bucks_cream, ";font-weight:400;font-size:11px;opacity:0.85;'>",
      "1970–71</span>"
    )),
    wemby = md(paste0(
      "<span style='color:#ffffff;font-weight:700;font-size:14px;'>",
      "Wemby's Spurs</span>",
      "<br><span style='color:#ffffff;font-weight:400;font-size:11px;opacity:0.85;'>",
      "2025–26</span>"
    ))
  ) |>

  # -- Title and subtitle -------------------------------------------------------
  tab_header(
    title    = md("**The Only Real Precedent**"),
    subtitle = md("Generational big man · 60+ win team · First playoff appearance")
  ) |>

  # -- Source footer ------------------------------------------------------------
  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data via Basketball Reference")
  ) |>

  # -- Kareem column header: Bucks green background -----------------------------
  tab_style(
    style = list(
      cell_fill(color = bucks_green),
      cell_text(color = bucks_cream, weight = "bold")
    ),
    locations = cells_column_labels(columns = kareem)
  ) |>

  # -- Wemby column header: Spurs black background ------------------------------
  tab_style(
    style = list(
      cell_fill(color = spurs_black),
      cell_text(color = "#ffffff", weight = "bold")
    ),
    locations = cells_column_labels(columns = wemby)
  ) |>

  # -- Metric column: bold left-aligned label -----------------------------------
  tab_style(
    style = cell_text(weight = "bold", size = px(12), color = "#333333"),
    locations = cells_body(columns = metric)
  ) |>

  # -- Alternating row shading --------------------------------------------------
  tab_style(
    style = cell_fill(color = "#F8F8F8"),
    locations = cells_body(rows = c(2, 4, 6, 8))
  ) |>

  # -- Playoff appearance row: Wemby "1st" gets a subtle callout ---------------
  tab_style(
    style = list(
      cell_text(weight = "bold", color = "#2E7D32")
    ),
    locations = cells_body(columns = wemby, rows = playoff_row)
  ) |>
  tab_style(
    style = cell_text(color = "#666666"),
    locations = cells_body(columns = kareem, rows = playoff_row)
  ) |>

  # -- Checkmark rows: green tint + centered bold ------------------------------
  tab_style(
    style = list(
      cell_text(weight = "bold", color = "#2E7D32", size = px(15)),
      cell_fill(color = "#F1F8E9")
    ),
    locations = cells_body(columns = c(kareem, wemby), rows = check_rows)
  ) |>

  # -- MVP row: Kareem "Won it" green, Wemby "Frontrunner" amber ----------------
  tab_style(
    style = list(
      cell_fill(color = "#E8F5E9"),
      cell_text(weight = "bold", color = "#2E7D32")
    ),
    locations = cells_body(columns = kareem, rows = mvp_row)
  ) |>
  tab_style(
    style = list(
      cell_fill(color = "#FFF8E1"),
      cell_text(weight = "bold", color = "#F57F17")
    ),
    locations = cells_body(columns = wemby, rows = mvp_row)
  ) |>

  # -- Co-star row: the crux — red-tinted, italic Wemby side --------------------
  tab_style(
    style = list(
      cell_fill(color = "#FFF3E0"),
      cell_text(weight = "bold", size = px(13))
    ),
    locations = cells_body(rows = costar_row)
  ) |>
  tab_style(
    style = cell_text(color = "#1A237E", weight = "bold"),
    locations = cells_body(columns = kareem, rows = costar_row)
  ) |>
  tab_style(
    style = cell_text(color = "#B71C1C", style = "italic"),
    locations = cells_body(columns = wemby, rows = costar_row)
  ) |>

  # -- Metric label for co-star row: extra emphasis -----------------------------
  tab_style(
    style = cell_text(weight = "bold", color = "#000000", size = px(13)),
    locations = cells_body(columns = metric, rows = costar_row)
  ) |>

  # -- Alignment ----------------------------------------------------------------
  cols_align(align = "center", columns = c(kareem, wemby)) |>
  cols_align(align = "left",   columns = metric) |>

  # -- Column widths ------------------------------------------------------------
  cols_width(
    metric ~ px(160),
    kareem ~ px(170),
    wemby  ~ px(170)
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
    table.width                        = px(520)
  )

# --- Save as PNG ---------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "wemby_kareem_table.png"), vwidth = 560)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'wemby_kareem_table.png')}}")
