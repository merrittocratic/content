# arch_mendoza_table.R
# Produces the two-way QB comparison table for the Arch Manning / Fernando Mendoza Substack post
# Output: graphics/arch_mendoza_table.png
#
# Packages: gt, gtExtras, dplyr, tibble
# Install if needed:
#   install.packages(c("gt", "gtExtras", "dplyr", "tibble"))

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------

qb_comp <- tibble::tribble(
  ~metric,              ~mendoza,                                                         ~manning,
  "School",             "Indiana",                                                        "Texas",
  "Height / Weight",    "6-5, 225",                                                       "6-4, 219",
  "Career starts",      "35",                                                             "~15",
  "2025 Record",        "16-0",                                                           "10-3",
  "Comp %",             "72.0%",                                                          "61.4%",
  "Pass yards",         "3,535",                                                          "3,163",
  "Pass TDs",           "41",                                                             "26",
  "INTs",               "6",                                                              "7",
  "QBR",                "90.3",                                                           "78.0",
  "Rush yards",         "284",                                                            "399",
  "Rush TDs",           "7",                                                              "10",
  "Heisman",            "Won",                                                            "\u2014",
  "Other major awards", "Maxwell, Davey O'Brien, Walter Camp,\nAP Player of the Year, Big Ten OPoY", "\u2014"
)

# --- Row indices for highlighting -------------------------------------------

comp_row    <- which(qb_comp$metric == "Comp %")
td_row      <- which(qb_comp$metric == "Pass TDs")
qbr_row     <- which(qb_comp$metric == "QBR")
record_row  <- which(qb_comp$metric == "2025 Record")
awards_rows <- which(qb_comp$metric %in% c("Heisman", "Other major awards"))
starts_row  <- which(qb_comp$metric == "Career starts")

# --- Build table ------------------------------------------------------------

tbl <- qb_comp |>
  gt() |>

  # -- Column labels ---------------------------------------------------------
  cols_label(
    metric  = "",
    mendoza = md("**Fernando Mendoza**<br><span style='font-weight:normal;color:#666;'>Indiana 2025</span>"),
    manning = md("**Arch Manning**<br><span style='font-weight:normal;color:#666;'>Texas 2025</span>")
  ) |>

  # -- Title and subtitle ----------------------------------------------------
  tab_header(
    title    = md("**The 2025 Season, Side by Side**"),
    subtitle = md("Same year. Same defenses. Same sport.")
  ) |>

  # -- Source footer ---------------------------------------------------------
  tab_source_note(
    source_note = md("**TheMerrittocracy** \u00b7 Data via ESPN, Pro Football Reference, and Sports Reference")
  ) |>

  # -- Overall table style ---------------------------------------------------
  tab_options(
    table.font.size                    = px(13),
    heading.title.font.size            = px(18),
    heading.subtitle.font.size         = px(12),
    column_labels.font.size            = px(12),
    table.width                        = pct(100),
    data_row.padding                   = px(6),
    heading.padding                    = px(8),
    source_notes.font.size             = px(10),
    table.border.top.color             = "#222222",
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#666666",
    table_body.border.bottom.color     = "#222222"
  ) |>

  # -- Metric column: bold ---------------------------------------------------
  tab_style(
    style     = cell_text(weight = "bold", size = px(12)),
    locations = cells_body(columns = metric)
  ) |>

  # -- Comp % row: stark gap, highlight both cells ---------------------------
  tab_style(
    style     = list(cell_fill(color = "#FFF3E0"), cell_text(weight = "bold")),
    locations = cells_body(rows = comp_row)
  ) |>

  # -- Pass TDs row ----------------------------------------------------------
  tab_style(
    style     = cell_fill(color = "#FFF8E1"),
    locations = cells_body(rows = td_row)
  ) |>

  # -- QBR row ---------------------------------------------------------------
  tab_style(
    style     = cell_fill(color = "#FFF8E1"),
    locations = cells_body(rows = qbr_row)
  ) |>

  # -- Record row ------------------------------------------------------------
  tab_style(
    style     = cell_fill(color = "#F1F8E9"),
    locations = cells_body(rows = record_row)
  ) |>

  # -- Awards rows -----------------------------------------------------------
  tab_style(
    style     = list(cell_fill(color = "#F5F5F5"), cell_text(style = "italic")),
    locations = cells_body(rows = awards_rows)
  ) |>

  # -- Mendoza: green tint on record and awards (winner) --------------------
  tab_style(
    style     = list(cell_fill(color = "#E8F5E9"), cell_text(weight = "bold", color = "#2E7D32")),
    locations = cells_body(columns = mendoza, rows = c(record_row, awards_rows))
  ) |>

  # -- Manning: subtle gray on awards (none) ---------------------------------
  tab_style(
    style     = list(cell_fill(color = "#EEEEEE"), cell_text(color = "#888888")),
    locations = cells_body(columns = manning, rows = awards_rows)
  ) |>

  # -- Manning column: light tint throughout ---------------------------------
  tab_style(
    style     = cell_fill(color = "#FAFAFA"),
    locations = cells_body(columns = manning)
  ) |>

  # -- Career starts: highlight the experience gap ---------------------------
  tab_style(
    style     = list(cell_fill(color = "#E3F2FD"), cell_text(weight = "bold")),
    locations = cells_body(columns = mendoza, rows = starts_row)
  ) |>

  tab_style(
    style     = list(cell_fill(color = "#FFEBEE"), cell_text(color = "#C62828", weight = "bold")),
    locations = cells_body(columns = manning, rows = starts_row)
  ) |>

  # -- Alignment -------------------------------------------------------------
  cols_align(align = "center", columns = c(mendoza, manning)) |>
  cols_align(align = "left",   columns = metric) |>

  # -- Column widths ---------------------------------------------------------
  cols_width(
    metric  ~ px(160),
    mendoza ~ px(220),
    manning ~ px(180)
  )

# --- Save as PNG ------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "arch_mendoza_table.png"), vwidth = 620)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'arch_mendoza_table.png')}}")

# --- Optional: also save as HTML for web embed ------------------------------
# gtsave(tbl, filename = file.path(output_dir, "arch_mendoza_table.html"))
