# simpson_pickett_table.R
# Produces the four-way QB comparison table for the Simpson/Pickett Substack post
# Output: graphics/simpson_pickett_table.png
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
  ~metric,             ~newton,                                          ~haskins,                             ~pickett,                          ~simpson,
  "FBS starts",        "14 (one year)",                                  "14 (one year)",                      "13 (52 career games)",            "15 (one year)",
  "Comp %",            "66.1%",                                          "70.0%",                              "67.2%",                           "64.5%",
  "Pass yards",        "2,854",                                          "4,831",                              "4,319",                           "3,567",
  "Pass TDs",          "30",                                             "50",                                 "42",                              "28",
  "INTs",              "7",                                              "8",                                  "7",                               "5",
  "Rush yards",        "1,473",                                          "108",                                "233",                             "93",
  "Rush TDs",          "20",                                             "4",                                  "5",                               "2",
  "Total TDs",         "51",                                             "54",                                 "47",                              "30",
  "Total offense",     "4,327",                                          "4,939",                              "4,552",                           "3,660",
  "Size",              "6-6, 250",                                       "6-3, 214",                           "6-3, 220",                        "6-2, 208",
  "Prior experience",  "JUCO season\n(natl title, 38 total TDs)",        "Backup reps only",                   "52 career games",                 "50 career pass attempts",
  "Awards",            "Heisman, national title,\nMaxwell, Davey O'Brien", "Heisman finalist,\nBig Ten OPoY, 28 records", "Heisman finalist,\nACC OPoY, ACC Champion", "\u2014",
  "NFL outcome",       "MVP, 3x Pro Bowl,\n11-year career",              "Released after\n2 years",            "4th team\nin 4 years",            "TBD"
)

# --- Rows to highlight -------------------------------------------------------
# These are the rows where Simpson's deficit is most stark
rush_rows <- which(qb_comp$metric %in% c("Rush yards", "Rush TDs"))
total_rows <- which(qb_comp$metric %in% c("Total TDs", "Total offense"))
outcome_row <- which(qb_comp$metric == "NFL outcome")

# --- Build table --------------------------------------------------------------

tbl <- qb_comp |>
  gt() |>

  # -- Column labels -----------------------------------------------------------
  cols_label(
    metric  = "",
    newton  = md("**Cam Newton**<br><span style='font-weight:normal;color:#666;'>Auburn 2010</span>"),
    haskins = md("**Dwayne Haskins**<br><span style='font-weight:normal;color:#666;'>Ohio State 2018</span>"),
    pickett = md("**Kenny Pickett**<br><span style='font-weight:normal;color:#666;'>Pitt 2021</span>"),
    simpson = md("**Ty Simpson**<br><span style='font-weight:normal;color:#666;'>Alabama 2025</span>")
  ) |>

  # -- Title and subtitle ------------------------------------------------------
  tab_header(
    title    = md("**The Low-Start QB Comparison**"),
    subtitle = md("Every one-year or low-experience starting QB drafted in Round 1 since 2010 — plus Pickett")
  ) |>

  # -- Source footer -----------------------------------------------------------
  tab_source_note(
    source_note = md("**Merrittocracy** · Data via Pro Football Reference and ESPN · github.com/merrittocratic")
  ) |>

  # -- Overall table style -----------------------------------------------------
  tab_options(
    table.font.size        = px(13),
    heading.title.font.size = px(18),
    heading.subtitle.font.size = px(12),
    column_labels.font.size = px(12),
    table.width            = pct(100),
    data_row.padding       = px(6),
    heading.padding        = px(8),
    source_notes.font.size = px(10),
    table.border.top.color = "#222222",
    heading.border.bottom.color = "#222222",
    column_labels.border.bottom.color = "#666666",
    table_body.border.bottom.color = "#222222"
  ) |>

  # -- Metric column styling ---------------------------------------------------
  tab_style(
    style = cell_text(weight = "bold", size = px(12)),
    locations = cells_body(columns = metric)
  ) |>

  # -- Highlight rush rows (the killer comparison) -----------------------------
  tab_style(
    style = list(
      cell_fill(color = "#FFF3E0"),
      cell_text(weight = "bold")
    ),
    locations = cells_body(rows = rush_rows)
  ) |>

  # -- Highlight total TDs and total offense -----------------------------------
  tab_style(
    style = cell_fill(color = "#FFF8E1"),
    locations = cells_body(rows = total_rows)
  ) |>

  # -- NFL outcome row styling -------------------------------------------------
  tab_style(
    style = list(
      cell_fill(color = "#F5F5F5"),
      cell_text(style = "italic")
    ),
    locations = cells_body(rows = outcome_row)
  ) |>

  # -- Newton column: success = green tint on outcome --------------------------
  tab_style(
    style = list(
      cell_fill(color = "#E8F5E9"),
      cell_text(weight = "bold", color = "#2E7D32")
    ),
    locations = cells_body(columns = newton, rows = outcome_row)
  ) |>

  # -- Haskins column: bust = red tint on outcome ------------------------------
  tab_style(
    style = list(
      cell_fill(color = "#FFEBEE"),
      cell_text(color = "#C62828")
    ),
    locations = cells_body(columns = haskins, rows = outcome_row)
  ) |>

  # -- Pickett column: bust = red tint on outcome ------------------------------
  tab_style(
    style = list(
      cell_fill(color = "#FFEBEE"),
      cell_text(color = "#C62828")
    ),
    locations = cells_body(columns = pickett, rows = outcome_row)
  ) |>

  # -- Simpson column: subtle highlight to draw the eye ------------------------
  tab_style(
    style = cell_fill(color = "#FAFAFA"),
    locations = cells_body(columns = simpson)
  ) |>

  # -- Simpson NFL outcome: gray/unknown --------------------------------------
  tab_style(
    style = list(
      cell_fill(color = "#EEEEEE"),
      cell_text(color = "#888888", style = "italic")
    ),
    locations = cells_body(columns = simpson, rows = outcome_row)
  ) |>

  # -- Center-align all data columns ------------------------------------------
  cols_align(align = "center", columns = c(newton, haskins, pickett, simpson)) |>
  cols_align(align = "left", columns = metric) |>

  # -- Column widths -----------------------------------------------------------
  cols_width(
    metric  ~ px(130),
    newton  ~ px(150),
    haskins ~ px(150),
    pickett ~ px(150),
    simpson ~ px(150)
  )

# --- Save as PNG --------------------------------------------------------------
# Adjust path as needed for your repo structure

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "simpson_pickett_table.png"), vwidth = 780)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'simpson_pickett_table.png')}}")

# --- Optional: also save as HTML for web embed --------------------------------
# gtsave(tbl, filename = file.path(output_dir, "simpson_pickett_table.html"))