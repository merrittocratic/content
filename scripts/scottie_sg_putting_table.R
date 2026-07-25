# scottie_sg_putting_table.R
# Produces the SG: Putting splits table for the predicting_the_majors post.
# The point: Scheffler's ball-striking traveled to the majors but the putter
# did not -- +0.59 per round everywhere else, flat-to-negative at the majors.
# Output: graphics/scottie_sg_putting_table.png
#
# Packages: tidyverse, gt, gtExtras, cli

library(tidyverse)
library(gt)
library(gtExtras)

amber_fill <- "#FFF8E1"
loss_red   <- "#C0392B"

putting <- tribble(
  ~context,                          ~sg_putt,
  "Masters, PGA, U.S. Open (avg.)",  "+0.07",
  "Open Championship",               "-0.36",
  "All four majors",                 "-0.04",
  "Everything else in 2026",         "+0.59"
)

tour_row <- which(putting$context == "Everything else in 2026")
neg_rows <- which(startsWith(putting$sg_putt, "-"))

tbl <- putting |>
  gt() |>
  tab_header(
    title    = md("**The Putter Stayed Home**"),
    subtitle = "Scottie Scheffler, strokes gained putting per round, 2026"
  ) |>
  cols_label(
    context = "",
    sg_putt = "SG PUTTING / ROUND"
  ) |>
  gt_highlight_rows(
    rows        = tour_row,
    fill        = amber_fill,
    font_weight = "bold"
  ) |>
  tab_style(
    style     = cell_text(color = loss_red),
    locations = cells_body(columns = sg_putt, rows = neg_rows)
  ) |>
  tab_footnote(
    footnote  = "More than half a stroke per round gained on the greens at regular tour stops. At the majors he putted like an average tour pro -- and at the Open, worse.",
    locations = cells_body(columns = sg_putt, rows = tour_row)
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** | DataGolf strokes-gained data | 2026 season through the Open Championship")
  ) |>
  cols_align(align = "left",  columns = context) |>
  cols_align(align = "right", columns = sg_putt) |>
  cols_width(
    context ~ px(380),
    sg_putt ~ px(190)
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
    footnotes.font.size               = px(10),
    source_notes.font.size            = px(10),
    source_notes.border.lr.style      = "none",
    data_row.padding                  = px(12)
  ) |>
  tab_style(
    style     = cell_text(color = "#888888", size = px(11)),
    locations = cells_column_labels(everything())
  )

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

output_path <- file.path(output_dir, "scottie_sg_putting_table.png")
gtsave(tbl, filename = output_path, vwidth = 640, expand = 10)

cli::cli_alert_success("Table saved to {.file {output_path}}")
