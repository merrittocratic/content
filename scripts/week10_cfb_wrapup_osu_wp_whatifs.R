# ============================================================================
# week10_cfb_wrapup_osu_wp_whatifs.R
#
# Hero graphic for draft/week10_cfb_wrapup.md ("Life Is A Game Of Inches").
# Section: "Life Moves Pretty Fast"
#
# Ohio State's win probability against Oregon, play by play, with dotted
# "what-if" stubs at the three plays the article walks through:
#   Jay Timmons' dropped pick-six (Q1)     -> 21-0 path, 98%
#   Jaylen McClain's dropped INT (Q2)      -> ball near midfield up 11, ~90%
#   Luke Fahey's INT at 1:06 (Q2)          -> 21-10 at the half, 87%
# Each stub is shown on its own, not stacked (matches the method note).
#
# Expected (article): 88% after Oregon's field goal makes it 14-3, about 35%
# by halftime, near zero at the end. The script stops if the series doesn't
# reproduce the 88% and 35% marks.
#
# Data: cfbfastR play-level win probability (cfbd_pbp_data, epa_wpa = TRUE),
# the model the article cites. A handful of plays in that series come back
# corrupted (e.g. Oregon's first drive has the two teams' values swapped,
# showing Ohio State at 5% while leading 7-0). Those plays are found by
# comparing against CFBD's game-level win probability (cfbd_metrics_wp) and
# dropped when the two disagree by more than 25 points; the plotted line is
# cfbfastR's.
#
# Needs CFBD_API_KEY for the first run:
#   op run --env-file=.env -- Rscript scripts/week10_cfb_wrapup_osu_wp_whatifs.R
# The joined pull is cached to data/week10_osu_oregon_wp.csv.
#
# Output: graphics/week10_cfb_wrapup/osu_wp_whatifs.png (1200x800 @150dpi)
# ============================================================================

library(ggplot2)
library(dplyr)

out_path   <- "graphics/week10_cfb_wrapup/osu_wp_whatifs.png"
cache_path <- "data/week10_osu_oregon_wp.csv"
max_gap    <- 0.25   # drop plays where the two WP series disagree by more

# --- Data --------------------------------------------------------------------

if (file.exists(cache_path)) {
  wp <- read.csv(cache_path)
} else {
  if (Sys.getenv("CFBD_API_KEY") == "") {
    stop("CFBD_API_KEY is not set and no cache exists at ", cache_path)
  }
  pbp <- cfbfastR::cfbd_pbp_data(year = 2026, week = 10, team = "Ohio State",
                                 epa_wpa = TRUE)
  stopifnot(all(pbp$home == "Ohio State"))
  cfbd <- cfbfastR::cfbd_metrics_wp(game_id = unique(pbp$game_id)) |>
    transmute(id_play = as.character(play_id), cfbd_wp = home_win_prob)
  wp <- pbp |>
    mutate(seq = row_number(), id_play = as.character(id_play)) |>
    transmute(seq, id_play, period, pos_team, down, distance, yards_to_goal,
              osu_wp = home_wp_before,
              text = substr(play_text, 1, 80)) |>
    left_join(cfbd, by = "id_play")
  write.csv(wp, cache_path, row.names = FALSE)
}

drop_spikes <- function(df, tol = 0.08) {
  repeat {
    d1 <- df$osu_wp - lag(df$osu_wp)
    d2 <- df$osu_wp - lead(df$osu_wp)
    spike <- !is.na(d1) & !is.na(d2) & sign(d1) == sign(d2) &
      pmin(abs(d1), abs(d2)) > tol
    if (!any(spike)) return(df)
    df <- df[!spike, ]
  }
}

line_df <- wp |>
  filter(!is.na(osu_wp), !is.na(cfbd_wp), abs(osu_wp - cfbd_wp) <= max_gap) |>
  # drop isolated one-play spikes: a play 8+ points away from BOTH neighbors
  # in the same direction (model noise, not a real swing); real values stay
  drop_spikes()
cat("plays plotted:", nrow(line_df), "of", sum(!is.na(wp$osu_wp)), "\n")

# Key plays, located by play text so a re-pull can't silently shift them
find_play <- function(pattern) {
  hit <- wp |> filter(grepl(pattern, text))
  if (nrow(hit) != 1) stop("expected one play matching: ", pattern)
  hit
}
fg_14_3  <- line_df |> filter(seq > find_play("G.Hurych field goal attempt from 33")$seq) |> slice(1)
half     <- line_df |> filter(period == 3) |> slice(1)
timmons  <- line_df |> filter(period == 1, down == 3, distance == 9,
                              yards_to_goal == 60, grepl("incomplete", text))
mcclain  <- line_df |> filter(period == 2, down == 3, distance == 9,
                              yards_to_goal == 69, grepl("incomplete", text))
fahey    <- line_df |> filter(seq == find_play("L.Fahey pass intercepted")$seq)

checks <- c(
  "88% after 14-3 FG" = round(fg_14_3$osu_wp, 2) == 0.88,
  "35% at halftime"   = round(half$osu_wp, 2) == 0.35,
  "one McClain play"  = nrow(mcclain) == 1,
  "one Timmons play"  = nrow(timmons) == 1
)
print(checks)
if (!all(checks)) stop("Series doesn't match the article: ",
                       paste(names(checks)[!checks], collapse = ", "))

whatif <- tibble::tibble(
  seq   = c(timmons$seq, mcclain$seq, fahey$seq),
  from  = c(timmons$osu_wp, mcclain$osu_wp, fahey$osu_wp),
  to    = c(0.98, 0.90, 0.87),
  label = c("Jay Timmons holds the pick-six\n21-0 path: 98%",
            "Jaylen McClain holds the INT\nup 11 near midfield: ~90%",
            "Ohio State scores its usual\nlate-half TD instead: 87%"),
  # labels sit in the empty band above 100%; McClain extends left and Fahey
  # right so the two don't collide
  lab_y = c(1.04, 1.17, 1.06),
  hjust = c(0.5, 1, 0)
)

# Quarter boundaries from the "End of" rows
ends   <- wp |> filter(grepl("^End of", text)) |> pull(seq)
q_mid  <- (c(min(wp$seq), ends[1:3]) + c(ends[1:3], max(wp$seq))) / 2

# --- Palette (house light theme) ---------------------------------------------

col_bg      <- "#FFFFFF"
col_panel   <- "#FFFFFF"
col_grid    <- "#EEEEEE"
col_text    <- "#1A1A1A"
col_subtext <- "#666666"
col_line    <- "#3A7CA5"   # steel blue -- actual win probability
col_flag    <- "#C0392B"   # red -- what-ifs
col_ref     <- "#B8860B"   # dark goldenrod -- 50% and halftime

theme_merrittocracy_light <- function(base_size = 12) {
  theme_minimal(base_size = base_size) +
    theme(
      plot.background    = element_rect(fill = col_bg,    color = NA),
      panel.background   = element_rect(fill = col_panel, color = NA),
      panel.grid.major   = element_line(color = col_grid, linewidth = 0.4),
      panel.grid.minor   = element_blank(),
      axis.text          = element_text(color = col_subtext, size = 9),
      axis.title         = element_text(color = col_text, size = 10),
      plot.title         = element_text(color = col_text, face = "bold",
                                        size = 15, margin = margin(b = 4)),
      plot.subtitle      = element_text(color = col_subtext, size = 10,
                                        margin = margin(b = 10)),
      plot.caption       = element_text(color = col_subtext, size = 8,
                                        hjust = 0, margin = margin(t = 10)),
      legend.position    = "none",
      plot.margin        = margin(14, 20, 10, 14)
    )
}

# --- Plot ---------------------------------------------------------------------

p <- ggplot(line_df, aes(x = seq, y = osu_wp)) +
  geom_hline(yintercept = 0.5, color = col_ref, linewidth = 0.4,
             linetype = "dashed") +
  geom_vline(xintercept = ends[2], color = col_subtext, linewidth = 0.3,
             linetype = "dotted") +
  geom_line(color = col_line, linewidth = 0.9) +
  # what-if stubs: dotted rise from the actual line to the counterfactual
  geom_segment(data = whatif, aes(x = seq, xend = seq, y = from, yend = to),
               inherit.aes = FALSE, color = col_flag, linewidth = 0.6,
               linetype = "dotted") +
  geom_point(data = whatif, aes(x = seq, y = to), inherit.aes = FALSE,
             color = col_flag, size = 2.4) +
  geom_point(data = whatif, aes(x = seq, y = from), inherit.aes = FALSE,
             color = col_line, size = 1.8) +
  # thin leaders from each stub top to its label
  geom_segment(data = whatif, aes(x = seq, xend = seq, y = to + 0.015,
                                  yend = lab_y - 0.035),
               inherit.aes = FALSE, color = col_flag, linewidth = 0.25) +
  geom_text(data = whatif, aes(x = seq, y = lab_y, label = label,
                               hjust = hjust),
            inherit.aes = FALSE, color = col_flag, size = 2.9,
            fontface = "bold", lineheight = 0.9, vjust = 0) +
  # actual-path markers, labeled below the line where it's empty
  geom_point(data = bind_rows(fg_14_3, half), color = col_text, size = 1.8) +
  # 88% label sits in the empty space well below the line, with a leader
  annotate("segment", x = fg_14_3$seq, xend = fg_14_3$seq,
           y = fg_14_3$osu_wp - 0.03, yend = 0.645,
           color = col_text, linewidth = 0.25) +
  annotate("text", x = fg_14_3$seq, y = 0.62,
           label = "14-3 after Oregon's FG: 88%", color = col_text,
           size = 2.9, hjust = 0.5, vjust = 1) +
  annotate("text", x = half$seq + 3, y = half$osu_wp + 0.06,
           label = "Halftime, down 17-14: 35%", color = col_text,
           size = 2.9, hjust = 0) +
  annotate("text", x = ends[2] + 2, y = 0.02, label = "Half",
           color = col_subtext, size = 2.7, hjust = 0) +
  scale_x_continuous(breaks = q_mid, labels = paste0("Q", 1:4),
                     expand = expansion(add = c(2, 2))) +
  scale_y_continuous(breaks = seq(0, 1, 0.25),
                     labels = scales::percent_format(accuracy = 1),
                     limits = c(0, 1.32), expand = expansion(add = 0)) +
  coord_cartesian(clip = "off") +
  labs(
    title    = "Three plays from 87% or better",
    subtitle = paste0("Ohio State's win probability vs. Oregon, play by play. ",
                      "Red: where each play, going the other way, would have put it."),
    x        = NULL,
    y        = "Ohio State win probability",
    caption  = paste0("TheMerrittocracy · Data via cfbfastR and the College ",
                      "Football Data API. Win probability is cfbfastR's model;\n",
                      "each what-if is the model's estimate on its own, not stacked. ",
                      "Corrupted plays (25+ points off CFBD's game win probability)\n",
                      "and isolated one-play spikes are dropped.")
  ) +
  theme_merrittocracy_light() +
  theme(panel.grid.major.x = element_blank())

ggsave(filename = out_path, plot = p, width = 1200 / 150, height = 800 / 150,
       dpi = 150, bg = col_bg)
cat("wrote", out_path, "\n")
