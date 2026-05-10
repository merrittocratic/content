# ============================================================================
# east_comeback_contrast.R
#
# Two-panel gt table: 76ers / Knicks R2 article visual anchor
#
# Panel 1 — "The 7-Seed Ceiling"
#   Every 7-seed Round 2 appearance since the 16-team bracket (1984).
#   DATA NOTE: Rows marked "XXXX" are placeholders — fill in from BBRef
#   before running. basketball-reference.com/playoffs/ → each year →
#   check if any 7-seed won their Round 1 series.
#   Confirmed rows: 1994 Denver, 2026 Philadelphia.
#
# Panel 2 — "Same Comeback, Different Seed"
#   Detroit vs. Philadelphia: same 3-1 comeback, opposite Round 2 outcomes.
#
# Packages: gt, dplyr, tibble, magick
#   install.packages(c("gt", "dplyr", "tibble", "magick"))
#
# Output: graphics/east_comeback_contrast.png
# ============================================================================

library(gt)
library(dplyr)
library(tibble)
library(magick)

# ── Colors ────────────────────────────────────────────────────────────────────
col_header_bg  <- "#1A1A2E"    # dark navy header
col_header_txt <- "#FFFFFF"
col_sixers_bg  <- "#E8F0FC"    # light Sixers blue
col_sixers_txt <- "#003DA5"    # Sixers blue
col_pistons_bg <- "#FFF3E0"    # light amber — Pistons
col_win_txt    <- "#2E7D32"    # dark green — winning record
col_loss_txt   <- "#C62828"    # dark red — losing record
col_active_txt <- "#E07B39"    # orange — in-progress
col_verify_txt <- "#BBBBBB"    # muted gray — placeholder rows
col_grid       <- "#E0E0E0"

# ── Panel 1 data ──────────────────────────────────────────────────────────────
# FILL IN: replace "XXXX" rows with real data from BBRef before publishing.
# Add or remove rows as needed — the all-time record summary auto-generates.
# r2_result format: "Won, 4–X" or "Lost, X–4"

sevens <- tribble(
  ~year,  ~team,                  ~opp,               ~r2_result,      ~how_far,
  # ── confirmed ─────────────────────────────────────────────────────────────
  "2026", "Philadelphia 76ers",  "New York Knicks",  "0–3 (active)",  "Round 2",
  # ── fill these in from BBRef ──────────────────────────────────────────────
  "2025", "Golden State Warriors",         "Minnesota Timberwolves",      "Lost, 1-4",   "Round 2",
  "2023", "Los Angeles Lakers",         "Golden State Warriors",      "Won, 4-2",   "Round 3",
  "2010", "San Antonio Spurs",         "Phoenix Suns",      "Lost, 0-4",   "Round 2",
  "1998", "New York Knicks",         "Indiana Pacers",      "Lost, 1-4",   "Round 2",
  "1991", "Golden State Warriors",         "Los Angeles Lakers",      "Lost, 1-4",   "Round 2",
  "1989", "Golden State Warriors",       "Phoenix Suns",        "Lost, 1–4",     "Round 2",
  "1987", "Seattle Supersonics",       "Houston Rockets",        "Won, 4-2",     "Round 3"
)

sixers_row   <- which(sevens$team == "Philadelphia 76ers")
verify_rows  <- which(sevens$year == "XXXX")

# ── Panel 1 table ─────────────────────────────────────────────────────────────
tbl1 <- sevens |>
  gt() |>

  tab_header(
    title    = md("**The 7-Seed Ceiling**"),
    subtitle = "Every 7-seed Round 2 appearance since the bracket expanded to 16 teams (1984)"
  ) |>

  cols_label(
    year      = "Year",
    team      = "Team",
    opp       = "Opponent",
    r2_result = "Round 2 Result",
    how_far   = "How Far"
  ) |>

  tab_footnote(
    footnote  = md("**All-time: 2–5** in Round 2, including 2026 · No 7-seed has ever reached the NBA Finals"),
    locations = cells_title(groups = "subtitle")
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data: Basketball Reference")
  ) |>

  tab_options(
    table.font.names                   = "sans-serif",
    table.font.size                    = px(13),
    heading.title.font.size            = px(17),
    heading.subtitle.font.size         = px(11),
    column_labels.font.size            = px(11),
    column_labels.font.weight          = "bold",
    data_row.padding                   = px(7),
    heading.padding                    = px(10),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(10),
    table.border.top.color             = col_header_bg,
    table.border.bottom.color          = col_header_bg,
    heading.border.bottom.color        = col_header_bg,
    column_labels.border.top.color     = col_header_bg,
    column_labels.border.bottom.color  = col_grid,
    table_body.border.bottom.color     = col_grid,
    table_body.hlines.color            = col_grid,
    table.width                        = px(640)
  ) |>

  # Dark column headers
  tab_style(
    style     = list(cell_fill(color = col_header_bg),
                     cell_text(color = col_header_txt, weight = "bold")),
    locations = cells_column_labels()
  ) |>

  # 76ers row — blue highlight
  tab_style(
    style     = list(cell_fill(color = col_sixers_bg),
                     cell_text(color = col_sixers_txt, weight = "bold")),
    locations = cells_body(rows = sixers_row)
  ) |>

  # Active result in orange
  tab_style(
    style     = cell_text(color = col_active_txt, weight = "bold"),
    locations = cells_body(columns = r2_result, rows = sixers_row)
  ) |>

  # Placeholder rows — muted italic
  tab_style(
    style     = cell_text(color = col_verify_txt, style = "italic"),
    locations = cells_body(rows = verify_rows)
  ) |>

  cols_align(align = "center", columns = c(year, r2_result, how_far)) |>
  cols_align(align = "left",   columns = c(team, opp)) |>

  cols_width(
    year      ~ px(55),
    team      ~ px(185),
    opp       ~ px(185),
    r2_result ~ px(120),
    how_far   ~ px(95)
  )

# ── Panel 2 data ──────────────────────────────────────────────────────────────
comeback <- tribble(
  ~team,                  ~seed, ~round1,                          ~r2_record, ~status,
  "Detroit Pistons",      "1",   "Won, 4–3 (trailed 1–3 vs ORL)", "2–0",      "Leading",
  "Philadelphia 76ers",   "7",   "Won, 4–3 (trailed 1–3 vs BOS)", "0–3",      "Trailing"
)

pistons_row <- which(comeback$team == "Detroit Pistons")
sixers_row2 <- which(comeback$team == "Philadelphia 76ers")

# ── Panel 2 table ─────────────────────────────────────────────────────────────
tbl2 <- comeback |>
  gt() |>

  tab_header(
    title    = md("**Same Comeback, Different R2 Result**"),
    subtitle = "Both teams came back from 3–1 deficits in Round 1"
  ) |>

  cols_label(
    team      = "Team",
    seed      = "Seed",
    round1    = "Round 1",
    r2_record = "R2 Record",
    status    = "Series Status"
  ) |>

  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data: Basketball Reference · 2025–26 NBA Playoffs")
  ) |>

  tab_options(
    table.font.names                   = "sans-serif",
    table.font.size                    = px(13),
    heading.title.font.size            = px(17),
    heading.subtitle.font.size         = px(11),
    column_labels.font.size            = px(11),
    column_labels.font.weight          = "bold",
    data_row.padding                   = px(9),
    heading.padding                    = px(10),
    source_notes.font.size             = px(10),
    table.border.top.color             = col_header_bg,
    table.border.bottom.color          = col_header_bg,
    heading.border.bottom.color        = col_header_bg,
    column_labels.border.top.color     = col_header_bg,
    column_labels.border.bottom.color  = col_grid,
    table_body.border.bottom.color     = col_grid,
    table_body.hlines.color            = col_grid,
    table.width                        = px(640)
  ) |>

  tab_style(
    style     = list(cell_fill(color = col_header_bg),
                     cell_text(color = col_header_txt, weight = "bold")),
    locations = cells_column_labels()
  ) |>

  # Pistons row — amber tint, green record
  tab_style(
    style     = list(cell_fill(color = col_pistons_bg), cell_text(weight = "bold")),
    locations = cells_body(rows = pistons_row)
  ) |>
  tab_style(
    style     = cell_text(color = col_win_txt, weight = "bold"),
    locations = cells_body(columns = c(r2_record, status), rows = pistons_row)
  ) |>

  # 76ers row — blue tint, red record
  tab_style(
    style     = list(cell_fill(color = col_sixers_bg), cell_text(weight = "bold")),
    locations = cells_body(rows = sixers_row2)
  ) |>
  tab_style(
    style     = cell_text(color = col_sixers_txt, weight = "bold"),
    locations = cells_body(columns = team, rows = sixers_row2)
  ) |>
  tab_style(
    style     = cell_text(color = col_loss_txt, weight = "bold"),
    locations = cells_body(columns = c(r2_record, status), rows = sixers_row2)
  ) |>

  cols_align(align = "center", columns = c(seed, r2_record, status)) |>
  cols_align(align = "left",   columns = c(team, round1)) |>

  cols_width(
    team      ~ px(175),
    seed      ~ px(55),
    round1    ~ px(230),
    r2_record ~ px(90),
    status    ~ px(90)
  )

# ── Save and stack with magick ────────────────────────────────────────────────
tmp1 <- tempfile(fileext = ".png")
tmp2 <- tempfile(fileext = ".png")

gtsave(tbl1, filename = tmp1, vwidth = 700)
gtsave(tbl2, filename = tmp2, vwidth = 700)

img1 <- image_read(tmp1) |> image_trim()
img2 <- image_read(tmp2) |> image_trim()

# Match widths before stacking
w <- max(image_info(img1)$width, image_info(img2)$width)
img1 <- image_extent(img1, paste0(w, "x", image_info(img1)$height), gravity = "West", color = "white")
img2 <- image_extent(img2, paste0(w, "x", image_info(img2)$height), gravity = "West", color = "white")

# Add a small gap between panels
gap <- image_blank(w, 20, color = "white")
combined <- image_append(c(img1, gap, img2), stack = TRUE)

out_path <- "graphics/east_comeback_contrast.png"
image_write(combined, out_path, density = 150)

file.remove(tmp1, tmp2)
message("Saved: ", out_path)
message("Panel 1 placeholder rows to fill in: ", length(verify_rows))
