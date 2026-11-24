# cfp_committee_usual_suspects_committee_vs_ap.R
# Expected result (written before plotting): Alabama (+4) and Texas (+3) are the
# biggest movers UP versus the AP; Notre Dame (-3) and Miami/Indiana/Iowa (-2) move
# DOWN. Most other teams sit within one spot. Source: Nov 17 CFP release vs AP.
# Output: graphics/cfp_committee_usual_suspects/committee_vs_ap.png

library(ggplot2)
library(dplyr)

out_path <- "graphics/cfp_committee_usual_suspects/committee_vs_ap.png"
dir.create(dirname(out_path), recursive = TRUE, showWarnings = FALSE)

d <- tibble::tribble(
  ~team,         ~cfp, ~ap,
  "Georgia",      1,    1,
  "Utah",         2,    2,
  "Alabama",      3,    7,
  "UCLA",         4,    4,
  "Texas",        5,    8,
  "Notre Dame",   6,    3,
  "Miami",        7,    5,
  "Indiana",      8,    6,
  "Tennessee",    9,    9,
  "BYU",         10,   12,
  "Wake Forest", 11,   10,
  "Texas Tech",  12,   11,
  "Oregon",      13,   14,
  "Ohio State",  14,   16,
  "Iowa",        15,   13,
  "Kentucky",    16,   17
) |>
  mutate(
    move  = ap - cfp,   # positive = committee ranks the team HIGHER than the AP
    label = sprintf("%s  (CFP %d / AP %d)", team, cfp, ap),
    label = factor(label, levels = rev(label)),
    grp   = case_when(move >= 3 ~ "up", move <= -3 ~ "down", TRUE ~ "other"),
    txt   = case_when(move > 0 ~ sprintf("+%d", move),
                      move < 0 ~ sprintf("%d", move),
                      TRUE ~ "0")
  )

col_bg <- "#FFFFFF"; col_grid <- "#EEEEEE"; col_text <- "#1A1A1A"
col_sub <- "#666666"; col_up <- "#C0392B"; col_down <- "#3A7CA5"; col_other <- "#BDBDBD"

p <- ggplot(d, aes(x = move, y = label, fill = grp)) +
  geom_vline(xintercept = 0, color = col_text, linewidth = 0.5) +
  geom_col(width = 0.65) +
  geom_text(aes(label = txt, hjust = ifelse(move >= 0, -0.3, 1.3)),
            size = 3.4, color = col_text, fontface = "bold") +
  scale_fill_manual(values = c(up = col_up, down = col_down, other = col_other)) +
  scale_x_continuous(limits = c(-5, 5.5), breaks = seq(-4, 4, 2),
                     labels = function(x) ifelse(x > 0, paste0("+", x), x)) +
  labs(
    title    = "The committee lifted two SEC teams past the AP",
    subtitle = "Spots higher (+) or lower (-) in the committee's Nov. 17 ranking than in the AP poll",
    x = "Committee rank versus AP rank (spots)", y = NULL,
    caption  = "TheMerrittocracy · Data via College Football Data API; CFP ranking of Nov. 17, AP poll same week"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.background  = element_rect(fill = col_bg, color = NA),
    panel.background = element_rect(fill = col_bg, color = NA),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = col_grid, linewidth = 0.4),
    panel.grid.minor = element_blank(),
    axis.text        = element_text(color = col_sub, size = 9),
    axis.title.x     = element_text(color = col_text, size = 10),
    plot.title       = element_text(color = col_text, face = "bold", size = 15, margin = margin(b = 4)),
    plot.subtitle    = element_text(color = col_sub, size = 10, margin = margin(b = 10)),
    plot.caption     = element_text(color = col_sub, size = 8, hjust = 0, margin = margin(t = 10)),
    legend.position  = "none",
    plot.margin      = margin(14, 20, 10, 14)
  )

ggsave(out_path, p, width = 1200 / 150, height = 800 / 150, dpi = 150, bg = col_bg)
cat("wrote", out_path, "\n")
