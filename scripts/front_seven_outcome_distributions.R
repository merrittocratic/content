# front_seven_outcome_distributions.R
# Produces the grouped boom/bust bar chart for the front_seven Substack post
# Output: graphics/front_seven_outcome_distributions.png
#
# Packages: ggplot2, dplyr, tibble
# Install if needed:
#   install.packages(c("ggplot2", "dplyr", "tibble"))

library(ggplot2)
library(dplyr)
library(tibble)

# --- Data -------------------------------------------------------------------
# Round 1 boom/bust rates by front-seven position

data <- tibble::tribble(
  ~position, ~type,   ~rate,
  "IDL",     "Boom",  26.1,
  "IDL",     "Bust",  15.2,
  "LB",      "Boom",  23.3,
  "LB",      "Bust",  32.6,
  "EDGE",    "Boom",  18.3,
  "EDGE",    "Bust",  29.6
) |>
  mutate(
    position = factor(position, levels = c("IDL", "EDGE", "LB")),
    type     = factor(type, levels = c("Boom", "Bust"))
  )

# Differential labels to annotate each position group
differentials <- tibble::tribble(
  ~position, ~label,        ~y,
  "IDL",     "+10.9%",      38.5,
  "EDGE",    "\u221211.3%", 38.5,
  "LB",      "\u22129.3%",  38.5
) |>
  mutate(position = factor(position, levels = c("IDL", "EDGE", "LB")))

# --- Colors -----------------------------------------------------------------

boom_color <- "#2E7D32"   # dark green
bust_color <- "#C62828"   # dark red
bg_color   <- "#FFFFFF"
grid_color <- "#EEEEEE"
text_color <- "#222222"

# --- Plot -------------------------------------------------------------------

p <- ggplot(data, aes(x = type, y = rate, fill = type)) +
  geom_col(width = 0.6, show.legend = FALSE) +
  geom_text(
    aes(label = paste0(rate, "%")),
    vjust = -0.5,
    size  = 3.8,
    fontface = "bold",
    color = text_color
  ) +
  # Differential annotation above each group
  geom_text(
    data = differentials,
    aes(x = 1.5, y = y, label = label),
    inherit.aes = FALSE,
    size     = 4,
    fontface = "bold",
    color    = ifelse(differentials$label == "+10.9%", boom_color, bust_color)
  ) +
  # Thin divider line at 0
  geom_hline(yintercept = 0, color = "#AAAAAA", linewidth = 0.4) +
  facet_wrap(~position, nrow = 1) +
  scale_fill_manual(values = c("Boom" = boom_color, "Bust" = bust_color)) +
  scale_y_continuous(
    limits = c(0, 42),
    breaks = c(0, 10, 20, 30, 40),
    labels = function(x) paste0(x, "%")
  ) +
  labs(
    title    = "Round 1 Outcomes by Front-Seven Position",
    subtitle = "Boom vs. Bust Rate, First-round picks since 2010",
    x        = NULL,
    y        = NULL,
    caption  = "TheMerrittocracy  ·  Data via Pro Football Reference"
  ) +
  theme_minimal(base_size = 13) +
  theme(
    plot.title         = element_text(face = "bold", size = 16, color = text_color, margin = margin(b = 4)),
    plot.subtitle      = element_text(size = 11, color = "#555555", margin = margin(b = 12)),
    plot.caption       = element_text(size = 9, color = "#888888", hjust = 0, margin = margin(t = 10)),
    plot.background    = element_rect(fill = bg_color, color = NA),
    panel.background   = element_rect(fill = bg_color, color = NA),
    panel.grid.major.y = element_line(color = grid_color, linewidth = 0.5),
    panel.grid.major.x = element_blank(),
    panel.grid.minor   = element_blank(),
    strip.text         = element_text(face = "bold", size = 14, color = text_color, margin = margin(b = 6)),
    axis.text.x        = element_text(size = 11, color = text_color),
    axis.text.y        = element_text(size = 10, color = "#777777"),
    plot.margin        = margin(16, 20, 12, 16)
  )

# --- Save -------------------------------------------------------------------

output_dir <- "graphics"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

ggsave(
  filename = file.path(output_dir, "front_seven_outcome_distributions.png"),
  plot     = p,
  width    = 7,
  height   = 5,
  dpi      = 200,
  bg       = bg_color
)

message("Saved to graphics/front_seven_outcome_distributions.png")
