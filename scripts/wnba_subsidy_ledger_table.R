# wnba_subsidy_ledger_table.R
# Produces "The Ledger" table for the wnba_clark_subsidy_argument post.
# The point of the table: the audience explosion and the reported losses grew
# in the same year. The loss row is the punchline and gets the visual anchor.
# Output: graphics/wnba_subsidy_vs_clark_revenue_timeline.png
#
# Packages: tidyverse, gt, gtExtras, fontawesome, cli
# Install if needed:
#   install.packages(c("tidyverse", "gt", "gtExtras", "fontawesome", "cli"))

library(tidyverse)
library(gt)
library(gtExtras)

# --- Colors ---------------------------------------------------------------------
good_green <- "#2E7D32"
bad_red    <- "#B71C1C"
amber_fill <- "#FFF8E1"

# --- Data (verified 2026-07-04) ---------------------------------------------------
# Fever attendance: 81,336 over 20 home games (2023) vs. record 340,715 (2024),
#   per WNBA.com / Front Office Sports.
# League attendance: 1,587,488 (2023, WNBA.com official recap) vs. 2,353,735 (2024).
# Losses: Silver's ~$10M/yr is his 2018 historical-average remark, NOT a 2023
#   figure (footnoted as such). 2024: ~$40M final vs. $50M WaPo projection.
# Revenue share: Ryan Brewer (IU Columbus) for the Indianapolis Star -- 26.5%.

ledger <- tribble(
  ~metric,                          ~y2023,           ~y2024,           ~change, ~direction,
  "Fever avg. home attendance",     "4,067 / game",   "17,036 / game",  "+319%", "good",
  "League-wide total attendance",   "1,587,488",      "2,353,735",      "+48%",  "good",
  "League-wide reported annual loss", "~$10M / yr",   "~$40M",          "~4x",   "bad",
  "Revenue share, single player",   "n/a",            "26.5% (Clark)",  "n/a",   "none"
)

loss_row <- which(ledger$direction == "bad")

# Manual per-row semantic coloring. Every change value is numerically positive,
# so a sign- or magnitude-driven scale would paint the loss row "good" -- the
# arrow color has to come from the direction column, not the number.
arrow_for <- function(direction) {
  color <- switch(direction, good = good_green, bad = bad_red, NA_character_)
  if (is.na(color)) return("")
  as.character(fontawesome::fa("arrow-up", fill = color, height = "0.85em"))
}

ledger <- ledger |>
  mutate(
    change = if_else(
      direction == "none",
      change,
      paste0(
        map_chr(direction, arrow_for), " ",
        "<span style='color:", if_else(direction == "good", good_green, bad_red),
        ";font-weight:700;'>", change, "</span>"
      )
    )
  )

# --- Build table ------------------------------------------------------------------

tbl <- ledger |>
  select(-direction) |>
  gt() |>
  tab_header(
    title    = md("**The Ledger**"),
    subtitle = "What grew alongside the audience boom"
  ) |>
  cols_label(
    metric = "",
    y2023  = "2023 (PRE-CLARK)",
    y2024  = "2024 (CLARK ROOKIE)",
    change = "CHANGE"
  ) |>
  fmt_markdown(columns = change) |>

  # -- Loss row: amber anchor, bold throughout ------------------------------------
  gt_highlight_rows(
    rows        = loss_row,
    fill        = amber_fill,
    font_weight = "bold"
  ) |>
  tab_style(
    style     = cell_text(color = bad_red),
    locations = cells_body(columns = c(y2023, y2024), rows = loss_row)
  ) |>

  # -- Metric column: bold labels ---------------------------------------------------
  tab_style(
    style     = cell_text(weight = "bold", color = "#333333"),
    locations = cells_body(columns = metric)
  ) |>

  # -- Footnotes --------------------------------------------------------------------
  tab_footnote(
    footnote  = "Adam Silver, 2018: the WNBA had lost an average of ~$10M per year in every year of its existence. A historical average, not a 2023-specific figure.",
    locations = cells_body(columns = y2023, rows = loss_row)
  ) |>
  tab_footnote(
    footnote  = "Washington Post projected a ~$50M loss in June 2024; the league finished ~$40M in the red per subsequent reporting.",
    locations = cells_body(columns = y2024, rows = loss_row)
  ) |>
  tab_footnote(
    footnote  = "Dr. Ryan Brewer (Indiana University Columbus), for the Indianapolis Star: Clark accounted for 26.5% of all 2024 WNBA economic activity -- tickets, merchandise, and TV.",
    locations = cells_body(columns = y2024, rows = which(ledger$metric == "Revenue share, single player"))
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** | Attendance: WNBA.com season recaps | Losses: Washington Post, SportsPro | Revenue share: Ryan Brewer, Indiana University")
  ) |>

  # -- Alignment and widths -----------------------------------------------------------
  cols_align(align = "left",  columns = metric) |>
  cols_align(align = "right", columns = c(y2023, y2024, change)) |>
  cols_width(
    metric ~ px(230),
    y2023  ~ px(130),
    y2024  ~ px(150),
    change ~ px(110)
  ) |>

  # -- House table options ------------------------------------------------------------
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
    footnotes.font.size               = px(10),
    source_notes.font.size            = px(10),
    source_notes.border.lr.style      = "none",
    data_row.padding                  = px(12)
  ) |>
  tab_style(
    style     = cell_text(color = "#888888", size = px(11)),
    locations = cells_column_labels(everything())
  )

# --- Save as PNG -------------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

output_path <- file.path(output_dir, "wnba_subsidy_vs_clark_revenue_timeline.png")
gtsave(tbl, filename = output_path, vwidth = 700, expand = 10)

cli::cli_alert_success("Table saved to {.file {output_path}}")
