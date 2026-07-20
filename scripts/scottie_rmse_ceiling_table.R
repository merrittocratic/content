# scottie_rmse_ceiling_table.R
# Produces the RMSE ceiling table for the shadow_leaderboard_scottie_doesnt_know post.
# The point: round-level accuracy was already near the theoretical floor, so
# feature engineering could not move it -- the bug had to be downstream.
# Output: graphics/scottie_rmse_ceiling_table.png
#
# Packages: tidyverse, gt, gtExtras, cli

library(tidyverse)
library(gt)
library(gtExtras)

amber_fill <- "#FFF8E1"

rmse <- tribble(
  ~predictor,                                    ~rmse,
  "Predict nothing (everyone plays to baseline)", "2.92",
  "Our model",                                    "2.79",
  "Know every player's true skill perfectly",     "~2.76"
)

model_row <- which(rmse$predictor == "Our model")

tbl <- rmse |>
  gt() |>
  tab_header(
    title    = md("**The Wall at 2.79**"),
    subtitle = "Round-level accuracy was never the problem"
  ) |>
  cols_label(
    predictor = "PREDICTOR",
    rmse      = "RMSE (STROKES / ROUND)"
  ) |>
  gt_highlight_rows(
    rows        = model_row,
    fill        = amber_fill,
    font_weight = "bold"
  ) |>
  tab_footnote(
    footnote  = "Only 0.16 strokes/round separate knowing nothing from knowing everything. The model had already captured 0.13 of it -- about 80% of all extractable signal. The rest is round-to-round randomness no feature can reach.",
    locations = cells_body(columns = rmse, rows = model_row)
  ) |>
  tab_source_note(
    source_note = md("**TheMerrittocracy** | Shadow Leaderboard model | Per-round RMSE, 2026 season evaluation window")
  ) |>
  cols_align(align = "left",  columns = predictor) |>
  cols_align(align = "right", columns = rmse) |>
  cols_width(
    predictor ~ px(380),
    rmse      ~ px(190)
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

output_path <- file.path(output_dir, "scottie_rmse_ceiling_table.png")
gtsave(tbl, filename = output_path, vwidth = 640, expand = 10)

cli::cli_alert_success("Table saved to {.file {output_path}}")
