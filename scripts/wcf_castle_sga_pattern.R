# wcf_castle_sga_pattern.R
# Produces the WCF game-log table for the Castle "one-job-rule" post
# Output: graphics/wcf_castle_sga_pattern.png
#
# Packages: gt, gtExtras, dplyr, tibble
# Install if needed:
#   install.packages(c("gt", "gtExtras", "dplyr", "tibble"))

library(gt)
library(gtExtras)
library(dplyr)
library(tibble)

# --- Palette ------------------------------------------------------------------
sas_row_fill  <- "#E8E8E8"   # muted Spurs silver
okc_row_fill  <- "#FFF5E0"   # cream / faint Thunder gold
sas_badge_bg  <- "#5A5A5A"
okc_badge_bg  <- "#E07B39"   # Merrittocracy burnt orange
fta_high_fill <- "#FFE0E0"   # danger-zone tint
fta_high_text <- "#B71C1C"

# --- Data ---------------------------------------------------------------------
rdf <- tibble::tibble(
  game        = c("G1", "G2", "G3", "G4", "G5", "G6"),
  date        = c("May 18", "May 20", "May 22", "May 24", "May 26", "May 28"),
  result      = c("SAS Win", "OKC Win", "OKC Win", "SAS Win", "OKC Win", "SAS Win"),
  harper_pts  = c(24, 12, 6, 7, 5, 18),
  harper_note = c("Started", "Hurt (mid-game)", "Bench / limited", "Bench", "Bench", "Bench / not 100%"),
  castle_pts  = c(17, 25, 14, 13, 24, 17),
  castle_fg   = c(.357, .588, .125, .455, .636, .500),
  sga_pts     = c(24, 30, 26, 19, 32, 15),
  sga_fta     = c(9, 6, 12, 7, 17, 3)
)

# --- Build the display tibble with markdown sub-text --------------------------
display <- rdf |>
  mutate(
    game_col   = paste0(
      "<span style='font-weight:700;font-size:14px;'>", game, "</span>",
      "<br><span style='font-size:10px;color:#666;font-weight:400;'>", date, "</span>"
    ),
    harper_col = paste0(
      "<span style='font-weight:700;font-size:14px;'>", harper_pts, "</span>",
      "<br><span style='font-size:10px;font-style:italic;color:#666;'>", harper_note, "</span>"
    ),
    castle_col = paste0(
      "<span style='font-weight:700;font-size:14px;'>", castle_pts, "</span>",
      "<br><span style='font-size:10px;color:#666;'>",
      sprintf("%.1f%%", castle_fg * 100), " FG</span>"
    )
  ) |>
  select(game_col, result, harper_col, castle_col, sga_pts, sga_fta)

# --- Row index helpers --------------------------------------------------------
sas_rows      <- which(rdf$result == "SAS Win")
okc_rows      <- which(rdf$result == "OKC Win")
fta_high_rows <- which(rdf$sga_fta >= 12)

# --- Build table --------------------------------------------------------------
tbl <- display |>
  gt() |>

  # -- Render markdown sub-text columns -----------------------------------------
  fmt_markdown(columns = c(game_col, harper_col, castle_col)) |>

  # -- Column labels ------------------------------------------------------------
  cols_label(
    game_col   = md("**Game**"),
    result     = md("**Result**"),
    harper_col = md("**Harper Pts**"),
    castle_col = md("**Castle Pts**"),
    sga_pts    = md("**SGA Pts**"),
    sga_fta    = md("**SGA FTA**<br><span style='font-weight:400;font-size:10px;color:#666;'>(how he scored)</span>")
  ) |>

  # -- Title + subtitle ---------------------------------------------------------
  tab_header(
    title    = md("**The One-Job Rule**"),
    subtitle = md("WCF game log — Spurs are 3–0 when Castle scores ≤17 pts, 0–3 when he scores ≥24")
  ) |>

  # -- Source footer ------------------------------------------------------------
  tab_source_note(
    source_note = md("**TheMerrittocracy** · Data via Basketball Reference")
  ) |>

  # -- Footnote marks: †, *, ‡ in the order they're attached ----------
  opt_footnote_marks(marks = c("†", "*", "‡")) |>

  # -- Footnotes ---------------------------------------------------------------
  tab_footnote(
    footnote  = "OKC won via field goal efficiency (12-24, 50%), not foul-drawing — Castle's 9 turnovers as solo ball-handler is the G2 story",
    locations = cells_body(columns = sga_fta, rows = 2)
  ) |>
  tab_footnote(
    footnote  = "1-for-8 from field; 11-of-14 FTs — shooting was broken, not heavy load",
    locations = cells_body(columns = castle_col, rows = 3)
  ) |>
  tab_footnote(
    footnote  = "32 pts on 7 field goals — 16-of-17 at the line while Castle scored 24 on offense",
    locations = cells_body(columns = sga_fta, rows = 5)
  ) |>

  # -- Row tint: SAS Win = muted silver -----------------------------------------
  tab_style(
    style = cell_fill(color = sas_row_fill),
    locations = cells_body(rows = sas_rows)
  ) |>

  # -- Row tint: OKC Win = cream/gold -------------------------------------------
  tab_style(
    style = cell_fill(color = okc_row_fill),
    locations = cells_body(rows = okc_rows)
  ) |>

  # -- Result badge: SAS Win ----------------------------------------------------
  tab_style(
    style = list(
      cell_fill(color = sas_badge_bg),
      cell_text(color = "#FFFFFF", weight = "bold", size = px(11))
    ),
    locations = cells_body(columns = result, rows = sas_rows)
  ) |>

  # -- Result badge: OKC Win ----------------------------------------------------
  tab_style(
    style = list(
      cell_fill(color = okc_badge_bg),
      cell_text(color = "#FFFFFF", weight = "bold", size = px(11))
    ),
    locations = cells_body(columns = result, rows = okc_rows)
  ) |>

  # -- SGA FTA column: always bold ----------------------------------------------
  tab_style(
    style = cell_text(weight = "bold", size = px(14)),
    locations = cells_body(columns = sga_fta)
  ) |>

  # -- SGA FTA ≥ 12: danger-zone highlight ---------------------------------
  tab_style(
    style = list(
      cell_fill(color = fta_high_fill),
      cell_text(weight = "bold", color = fta_high_text, size = px(14))
    ),
    locations = cells_body(columns = sga_fta, rows = fta_high_rows)
  ) |>

  # -- SGA Pts: a touch heavier -------------------------------------------------
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = sga_pts)
  ) |>

  # -- Alignment ----------------------------------------------------------------
  cols_align(align = "center",
             columns = c(game_col, result, harper_col, castle_col, sga_pts, sga_fta)) |>

  # -- Column widths ------------------------------------------------------------
  cols_width(
    game_col   ~ px(75),
    result     ~ px(85),
    harper_col ~ px(135),
    castle_col ~ px(115),
    sga_pts    ~ px(80),
    sga_fta    ~ px(105)
  ) |>

  # -- Overall table options ----------------------------------------------------
  tab_options(
    table.font.size                    = px(13),
    table.font.names                   = "Georgia",
    heading.title.font.size            = px(19),
    heading.subtitle.font.size         = px(12),
    heading.padding                    = px(10),
    column_labels.font.size            = px(12),
    data_row.padding                   = px(8),
    source_notes.font.size             = px(10),
    footnotes.font.size                = px(10),
    table.border.top.color             = "#222222",
    table.border.top.width             = px(2),
    heading.border.bottom.color        = "#222222",
    column_labels.border.bottom.color  = "#222222",
    column_labels.border.bottom.width  = px(2),
    table_body.border.bottom.color     = "#222222",
    table_body.border.bottom.width     = px(2),
    table.width                        = px(620)
  )

# --- Save as PNG --------------------------------------------------------------
output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

gtsave(tbl, filename = file.path(output_dir, "wcf_castle_sga_pattern.png"), vwidth = 680)

cli::cli_alert_success("Table saved to {.file {file.path(output_dir, 'wcf_castle_sga_pattern.png')}}")
