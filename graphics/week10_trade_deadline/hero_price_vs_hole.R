# Hero: price paid vs. size of the hole. Run from repo root.
# Expected (stated before plotting): no strong relationship (Spearman about -0.1);
# Davis/Simmons/Harrison high price + small hole; Buckner/Cousins low price + big hole.
suppressMessages({library(ggplot2); library(dplyr); library(ggrepel); library(scales)})
d <- read.csv("graphics/week10_trade_deadline/price_vs_hole.csv") |>
  filter(price > 0) |>
  mutate(hole = 33 - need_rank,
         feat = deal %in% c("Davis to JAX","Godchaux to JAX","Bates to JAX","Buckner to SF",
                            "Allen to SF","Downs to KC","Cousins to MIN","Simmons to CHI",
                            "Harrison to HOU"),
         lab = sub(" to .*", "", deal) |> paste0(" (", buyer, ")"))
rho <- round(cor(d$price, d$hole, method = "spearman"), 2)
brk <- c(15, 35, 80, 170, 370, 1000)
p <- ggplot(d, aes(price, hole)) +
  geom_point(aes(color = feat, size = feat)) +
  geom_text_repel(aes(label = lab, color = feat), seed = 42, size = 3.4,
                  box.padding = 0.5, point.padding = 0.4, min.segment.length = 0.2,
                  segment.color = "grey70", max.overlaps = Inf, show.legend = FALSE) +
  scale_color_manual(values = c(`TRUE` = "#2E6F9E", `FALSE` = "#8A9399"), guide = "none") +
  scale_size_manual(values = c(`TRUE` = 3.6, `FALSE` = 2.4), guide = "none") +
  scale_x_log10(breaks = brk, labels = c("6th","5th","4th","3rd","2nd","1st"),
                limits = c(10, 3000), expand = expansion(mult = c(0.02, 0.02))) +
  scale_y_continuous(limits = c(-1, 33), breaks = c(0, 8, 16, 24, 32)) +
  annotate("text", x = 3000, y = 31.5, hjust = 1, size = 3.3, color = "grey35",
           label = "Big hole, big price") +
  annotate("text", x = 11, y = 31.5, hjust = 0, size = 3.3, color = "grey35",
           label = "Big hole, small price") +
  annotate("text", x = 3000, y = -0.6, hjust = 1, size = 3.3, color = "grey35",
           label = "Paid a lot for a unit that was fine") +
  labs(title = "What teams paid barely tracked how badly they needed it",
       subtitle = glue::glue("Price in pick-value terms (x, labeled by the round it equals) vs. how weak the buyer's unit ranked (y, 32 = worst in the NFL by EPA per play, Weeks 1-9). Rank correlation: {rho}."),
       x = "Net price paid (draft-pick value, log scale)",
       y = "Weakness of the buyer's unit",
       caption = "Source: nflverse play-by-play (Weeks 1-9), NFL.com trade tracker. 16 of 17 deals shown; the Neuzil/Vorhees swap had no net price.\nPick values are approximate (1st = 1,000; 2nd = 370; 3rd = 170; 4th = 80; 5th = 35; 6th = 15). Unit = pass or rush offense, pass or rush defense by position; Simmons scored on overall defense.") +
  theme_minimal(base_size = 12) +
  theme(plot.background = element_rect(fill = "white", color = NA),
        plot.title = element_text(face = "bold", size = 17),
        plot.subtitle = element_text(color = "grey35", size = 10.5, lineheight = 1.1),
        plot.caption = element_text(color = "grey45", size = 8, hjust = 0),
        panel.grid.minor = element_blank(), plot.title.position = "plot",
        plot.caption.position = "plot")
p$labels$subtitle <- stringr::str_wrap(p$labels$subtitle, 120)
ggsave("graphics/week10_trade_deadline/hero_price_vs_hole.png", p, width = 11, height = 7.5, dpi = 150, bg = "white")
