library(hoopR)
library(dplyr)
library(ggplot2)
library(ggrepel)
library(lubridate)
library(readr)

# ── 1. Load and filter to playoffs only (season_type == 3) ──────────────────
message("Loading NBA box scores via hoopR...")
logs_raw <- load_nba_player_box(seasons = 2002:2026, playoffs = TRUE)
message("Rows loaded (all types): ", nrow(logs_raw))
message("season_type values: ", paste(sort(unique(logs_raw$season_type)), collapse = ", "))

logs <- logs_raw %>% filter(season_type == 3)
message("Rows after filtering to playoffs (season_type == 3): ", nrow(logs))
message("Seasons covered: ", paste(sort(unique(logs$season)), collapse = ", "))

# ── 2. Hardcoded birthdates for players plausibly 37+ in 2002–2026 playoffs ──
# API sources are unreliable; the universe of 37+ playoff players is small enough
# to enumerate. Birth dates from Basketball-Reference.
bdays <- tribble(
  ~athlete_display_name,         ~birth_date,
  "LeBron James",                "1984-12-30",
  "Vince Carter",                "1977-01-26",
  "Paul Pierce",                 "1977-10-13",
  "Ray Allen",                   "1975-07-20",
  "Jason Kidd",                  "1973-03-23",
  "Karl Malone",                 "1963-07-24",
  "Gary Payton",                 "1968-07-23",
  "Shaquille O'Neal",            "1972-03-06",
  "Tim Duncan",                  "1976-04-25",
  "Chauncey Billups",            "1976-09-25",
  "Dirk Nowitzki",               "1978-06-19",
  "Kobe Bryant",                 "1978-08-23",
  "Tony Parker",                 "1982-05-17",
  "Manu Ginobili",               "1977-07-28",
  "Andre Miller",                "1976-03-19",
  "Udonis Haslem",               "1980-06-09",
  "Jamal Crawford",              "1980-03-20",
  "Sam Cassell",                 "1969-11-18",
  "Dikembe Mutombo",             "1966-06-25",
  "Clifford Robinson",           "1966-12-16",
  "Reggie Miller",               "1965-08-24",
  "John Stockton",               "1962-03-26",
  "Hakeem Olajuwon",             "1963-01-21",
  "Patrick Ewing",               "1962-08-05",
  "Theo Ratliff",                "1973-04-17",
  "P.J. Brown",                  "1969-10-14",
  "Antonio Davis",               "1968-10-31",
  "Alonzo Mourning",             "1970-02-08",
  "Damon Stoudamire",            "1973-09-03",
  "Derek Fisher",                "1974-08-09",
  "Steve Nash",                  "1974-02-07",
  "Grant Hill",                  "1972-10-05",
  "Ben Wallace",                 "1974-09-10",
  "Marcus Camby",                "1974-03-22",
  "Rasheed Wallace",             "1974-09-17",
  "Tyson Chandler",              "1982-10-02",
  "Udonis Haslem",               "1980-06-09"
) %>%
  mutate(birth_date = as.Date(birth_date)) %>%
  distinct(athlete_display_name, .keep_all = TRUE)

message("Hardcoded birthdates: ", nrow(bdays))

# ── 3. Aggregate to series level (player + season + opponent) ────────────────
series_stats <- logs %>%
  mutate(pts_num = as.numeric(points)) %>%
  filter(!is.na(pts_num), !is.na(athlete_id)) %>%
  group_by(athlete_id, athlete_display_name, season, opponent_team_id) %>%
  summarise(
    games     = n(),
    total_pts = sum(pts_num, na.rm = TRUE),
    ppg       = total_pts / games,
    .groups   = "drop"
  ) %>%
  mutate(ref_date = as.Date(paste0(season, "-04-15")))

message("Series records: ", nrow(series_stats))

# ── 4. Join birthdates and calculate age ─────────────────────────────────────
series_stats <- series_stats %>%
  left_join(bdays %>% select(athlete_display_name, birth_date), by = "athlete_display_name") %>%
  mutate(
    age_at_series = as.numeric(difftime(ref_date, birth_date, units = "days")) / 365.25
  )

missing_age <- sum(is.na(series_stats$age_at_series))
message("Series missing age: ", missing_age, " of ", nrow(series_stats))
message("Age range: ",
        round(min(series_stats$age_at_series, na.rm = TRUE), 1), " – ",
        round(max(series_stats$age_at_series, na.rm = TRUE), 1))

# ── 5. Filter: age 37+, min 4 games, 20+ PPG ────────────────────────────────
elder <- series_stats %>%
  filter(
    !is.na(age_at_series),
    age_at_series >= 37,
    games >= 4,
    ppg >= 20
  ) %>%
  arrange(desc(ppg))

message("Elder 20+ PPG series (age 37+, 4+ games): ", nrow(elder))
print(elder %>% select(athlete_display_name, season, games, total_pts, ppg, age_at_series))

# Coverage flags
if (!any(series_stats$season == 2026)) {
  message("WARNING: 2026 not in data — LeBron will be manual anchor only.")
}

# ── 6. Save dataset ───────────────────────────────────────────────────────────
write_csv(elder, "/Users/stephenmerritt/content/data/elder_playoff_scoring.csv")
message("Saved data/elder_playoff_scoring.csv")

# ── 7. Build plot dataframe ───────────────────────────────────────────────────
plot_df <- elder %>%
  # Drop LeBron 2026 if present (will add as manual anchor with exact stats)
  filter(!(grepl("LeBron|James", athlete_display_name, ignore.case = TRUE) & season == 2026)) %>%
  select(name = athlete_display_name, season, ppg, age = age_at_series) %>%
  mutate(
    highlight = "other",
    label     = paste0(name, "\n", round(ppg, 1), " PPG, age ", floor(age))
  )

# Manual anchors
parish_row <- tibble(
  name = "Robert Parish", season = 1997L, ppg = 0.33, age = 43.0,
  highlight = "parish",
  label     = "Robert Parish\n2 total points, age 43"
)
lebron_row <- tibble(
  name = "LeBron James", season = 2026L, ppg = 25.3, age = 41.0,
  highlight = "lebron",
  label     = "LeBron James\n25.3 PPG, age 41"
)

plot_df <- bind_rows(plot_df, parish_row, lebron_row)

# Assign a distinct color to each unique player name (LeBron and Parish handled separately)
other_players <- plot_df %>%
  filter(highlight == "other") %>%
  distinct(name)

# Qualitative palette — enough colors for ~10 players
qual_pal <- c(
  "#E07B39", "#3A86FF", "#06D6A0", "#FFB703", "#8338EC",
  "#FB5607", "#118AB2", "#EF476F", "#2EC4B6", "#A7C957"
)
player_colors <- setNames(
  qual_pal[seq_len(nrow(other_players))],
  other_players$name
)
player_colors["LeBron James"] <- "#552583"
player_colors["Robert Parish"] <- "#888888"

plot_df <- plot_df %>%
  mutate(dot_color = player_colors[name])

# ── 8. Plot ───────────────────────────────────────────────────────────────────
pal_lebron <- "#552583"

p <- ggplot(plot_df, aes(x = age, y = ppg)) +

  geom_hline(yintercept = 20, linetype = "dashed", color = "#CCCCCC", linewidth = 0.6) +

  # Other players — colored by player
  geom_point(
    data  = filter(plot_df, highlight == "other"),
    aes(color = name), alpha = 0.85, size = 3.5
  ) +

  # Parish
  geom_point(
    data  = filter(plot_df, highlight == "parish"),
    color = "#888888", alpha = 0.8, size = 3
  ) +

  # LeBron 2026
  geom_point(
    data  = filter(plot_df, highlight == "lebron"),
    color = pal_lebron, size = 5
  ) +

  # Labels on every dot
  geom_label_repel(
    aes(label = label, color = name),
    size          = 3,
    seed          = 42,
    box.padding   = 0.5,
    point.padding = 0.3,
    show.legend   = FALSE,
    label.size    = NA,
    fill          = alpha("white", 0.85),
    max.overlaps  = Inf
  ) +

  scale_color_manual(values = player_colors) +

  scale_x_continuous(limits = c(37, 44), breaks = 37:44) +
  scale_y_continuous(limits = c(0, 35), breaks = seq(0, 35, 5)) +

  labs(
    title    = "Playing Alone in the Upper Right Corner",
    subtitle = "Playoff PPG at age 37+, all-time NBA (min. 4 games in series)",
    caption  = "Source: Basketball Reference | Merrittocracy",
    x        = "Age",
    y        = "Points Per Game"
  ) +

  theme_minimal(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 16, margin = margin(b = 6)),
    plot.subtitle    = element_text(color = "#555555", size = 11, margin = margin(b = 12)),
    plot.caption     = element_text(color = "#888888", size = 9, hjust = 1),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "#EEEEEE"),
    legend.position  = "none"
  )

# ── 9. Save ───────────────────────────────────────────────────────────────────
out_path <- "/Users/stephenmerritt/content/graphics/lebron_elder_scatter.png"
ggsave(out_path, plot = p, width = 1200 / 150, height = 900 / 150, dpi = 150)
message("Saved: ", out_path)
