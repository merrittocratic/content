# substack_rec_prospector.R -------------------------------------------------
#
# Finds sports / analytics Substacks in the right size band for a
# recommendation swap, by walking the recommendation graph outward from a
# seed set and scoring each discovered publication on engagement proxies.
#
# WHY A PROXY: Substack does not publish subscriber counts. Median reactions
# per free post is the best public stand-in. Calibrate the band yourself using
# two or three publications whose real size you know (see CALIBRATION below).
#
# The v1 API is undocumented. Endpoint shapes drift. Every fetch here is
# wrapped and returns NULL on failure rather than blowing up the crawl.
#
# Rate limiting is real. Default 1.5s between calls. Do not lower it.

library(httr2)
library(jsonlite)
library(dplyr)
library(purrr)
library(tibble)
library(stringr)

UA        <- "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
PAUSE_SEC <- 1.5

# --- seeds: edit these -----------------------------------------------------
# Start with sports-analytics pubs you already read. Subdomain only, or a full
# custom domain host. The graph does the rest.
# Probed 2026-08-23. Every entry below returned a live archive AND at least
# one recommendation; dead or rec-less hosts are recorded so nobody re-probes
# them. Edge count in comments -- the crawl is only as wide as these.
# TOPIC controls both the seed set and the scoring gate.
#   "football" -- NFL + college football only. Use during the Aug-Dec push.
#   "allsports" -- the original wide net.
TOPIC <- "football"

# Probed 2026-08-23. Every host below returned a live archive AND >=1
# recommendation. Edge counts in comments; the crawl is only as wide as these.
SEEDS_FOOTBALL <- c(
  "www.matchquarters.com",     # 26 -- defensive scheme, widest football hub
  "extrapoints",               # 20 -- college sports business
  "www.y-option.com",          # 17 -- college football
  "onmontlake",                # 16 -- Washington football
  "splitzoneduo",              # 16 -- college football
  "cfbnumbers",                # 13 -- CFB analytics, closest to our lane
  "wkcfb",                     # 12 -- Who Killed College Football?
  "insidethelions",            # 11 -- Penn State
  "www.auburnobserver.com",    # 10 -- Auburn
  "www.insidezonemf.com",      #  7
  "www.billanddougshow.com",   #  6 -- Ohio State
  "www.evaluationperiod.info", #  6
  "www.sid-sports.com",        #  5
  "unexpectedpoints",          #  4
  "coverzero",                 #  4
  "footballiq",                #  4
  "sumersports",               #  1 -- NFL
  "gridironanalytics",         #  1
  "themerrittocracy"           #  1 -- your own; calibration anchor
)
# Probed and NOT usable (dead subdomain): thefootballeducator, dynastynerds,
#   footballguys, nflmatchups, brettkollmann, thedraftnetwork, nfldraftbible,
#   33rdteam, thescoutingacademy, gridironheroics, fantasylife,
#   thefantasyfootballers, footballoutsiders, xsandos, theqbschool,
#   deepballdata, nflstatsandanalysis, gameonpaper, bcbanter, thefieldofsixty
# Live but zero recommendations: pigskinpundit, thepowerrank, thefriedegg,
#   huddleup, thefootballanalyst, footballanalytics

SEEDS_ALLSPORTS <- c(
  "basketballpoetry", "extrapoints", "splitzoneduo", "unexpectedpoints",
  "inpredictable", "sumersports", "gridironanalytics", "themerrittocracy"
)

SEEDS <- if (TOPIC == "football") SEEDS_FOOTBALL else SEEDS_ALLSPORTS

MAX_HOPS         <- 1      # 1 hop off 8 seeds is ~80 pubs / ~4 min.
                           # 2 pushes past 400 pubs and ~20 min of
                           # rate-limited calls. Raise only if hop 1
                           # does not yield enough qualified names.
ARCHIVE_N        <- 25     # posts to sample per publication
BAND_REACT_LOW   <- 4      # median reactions/post -- lower edge of target band
BAND_REACT_HIGH  <- 70     # upper edge
MIN_POSTS_90D    <- 2      # must still be alive

# --- fetch helpers ---------------------------------------------------------

`%||%` <- function(a, b) if (is.null(a) || length(a) == 0) b else a

pause <- function() Sys.sleep(PAUSE_SEC)

base_url <- function(host) {
  if (str_detect(host, "\\.")) paste0("https://", host)
  else paste0("https://", host, ".substack.com")
}

safe_json <- function(url) {
  pause()
  out <- tryCatch({
    resp <- request(url) |>
      req_user_agent(UA) |>
      req_timeout(20) |>
      req_retry(max_tries = 2, backoff = ~ 5) |>
      req_error(is_error = function(r) FALSE) |>
      req_perform()
    if (resp_status(resp) >= 400) return(NULL)
    resp_body_json(resp, simplifyVector = FALSE)
  }, error = function(e) NULL)
  out
}

# --- API wrappers ----------------------------------------------------------

# DEAD AS OF 2026-08-23. /api/v1/search 404s; /api/v1/publication/search
# answers 200 but always returns {"results":[]} without auth. Kept only so
# the next person does not rediscover this. Widen seeds by probing hosts
# directly against the archive endpoint instead -- see SEEDS above.
search_publications <- function(query, limit = 25) {
  url <- sprintf("https://substack.com/api/v1/search?query=%s&type=publication&limit=%d",
                 URLencode(query, reserved = TRUE), limit)
  res <- safe_json(url)
  if (is.null(res)) return(tibble())
  # response shape varies: sometimes $results, sometimes $publications
  items <- res$results %||% res$publications %||% res
  map_dfr(items, function(p) {
    tibble(
      pub_id    = p$id           %||% NA_integer_,
      name      = p$name         %||% NA_character_,
      subdomain = p$subdomain    %||% NA_character_,
      host      = p$custom_domain %||% p$subdomain %||% NA_character_,
      hero      = p$hero_text    %||% NA_character_
    )
  })
}

# The numeric id the rec endpoint needs.
#
# /api/v1/publication returns 403 as of 2026-08-23 -- it is authenticated now.
# But every post in the public archive carries publication_id, so the id is
# recoverable without it. Name and hero text are NOT available this way; they
# come from the parent's recommendation payload during the crawl, which is why
# seeds themselves end up with name = host and usually fail topic_match. That
# is harmless: seeds are inputs, not prospects.
get_publication <- function(host) {
  res <- safe_json(sprintf("%s/api/v1/archive?sort=new&limit=1", base_url(host)))
  if (is.null(res) || length(res) == 0) return(NULL)
  pid <- res[[1]]$publication_id %||% NA_integer_
  if (is.na(pid)) return(NULL)
  tibble(
    pub_id    = pid,
    name      = NA_character_,
    subdomain = host,
    host      = host,
    hero      = NA_character_,
    author    = NA_character_
  )
}

# The recommendation graph. This is the money endpoint.
get_recommendations <- function(host, pub_id) {
  if (is.na(pub_id)) return(tibble())
  url <- sprintf("%s/api/v1/recommendations/from/%s?limit=40", base_url(host), pub_id)
  res <- safe_json(url)
  if (is.null(res)) return(tibble())
  items <- res$recommendations %||% res
  map_dfr(items, function(r) {
    p <- r$recommendedPublication %||% r$publication %||% r
    tibble(
      pub_id    = p$id            %||% NA_integer_,
      name      = p$name          %||% NA_character_,
      subdomain = p$subdomain     %||% NA_character_,
      host      = p$custom_domain %||% p$subdomain %||% NA_character_,
      hero      = p$hero_text     %||% NA_character_
    )
  }) |> filter(!is.na(host))
}

# Engagement sample from the public archive.
get_archive_stats <- function(host, n = ARCHIVE_N) {
  url <- sprintf("%s/api/v1/archive?sort=new&limit=%d", base_url(host), n)
  res <- safe_json(url)
  if (is.null(res) || length(res) == 0) return(NULL)

  posts <- map_dfr(res, function(p) {
    tibble(
      date      = suppressWarnings(as.Date(substr(p$post_date %||% NA_character_, 1, 10))),
      audience  = p$audience %||% NA_character_,
      # The reactions map is emoji-keyed ("\u2764" and friends). Indexing it by
      # a literal emoji is both encoding-fragile and non-ASCII, so sum the map
      # instead -- that also counts reaction types beyond the heart.
      reactions = {
        rx <- suppressWarnings(sum(unlist(p$reactions %||% list()), na.rm = TRUE))
        if (is.finite(rx) && rx > 0) as.numeric(rx)
        else as.numeric(p$reaction_count %||% NA)
      },
      comments  = as.numeric(p$comment_count %||% NA),
      restacks  = as.numeric(p$restacks %||% NA)
    )
  })
  if (nrow(posts) == 0) return(NULL)

  free <- posts |> filter(is.na(audience) | audience == "everyone")
  if (nrow(free) < 3) free <- posts

  tibble(
    n_posts_sampled = nrow(posts),
    posts_90d       = sum(posts$date >= Sys.Date() - 90, na.rm = TRUE),
    last_post       = suppressWarnings(max(posts$date, na.rm = TRUE)),
    med_reactions   = median(free$reactions, na.rm = TRUE),
    med_comments    = median(free$comments,  na.rm = TRUE),
    med_restacks    = median(free$restacks,  na.rm = TRUE),
    paid_share      = mean(posts$audience %in% c("only_paid", "founding"), na.rm = TRUE)
  )
}

# --- crawl -----------------------------------------------------------------

crawl <- function(seeds, max_hops = MAX_HOPS) {
  seen      <- character(0)
  frontier  <- seeds
  collected <- tibble()

  for (hop in seq_len(max_hops + 1)) {
    frontier <- setdiff(unique(frontier), seen)
    if (length(frontier) == 0) break
    message(sprintf("hop %d: %d publications", hop - 1, length(frontier)))

    next_frontier <- character(0)

    for (h in frontier) {
      seen <- c(seen, h)
      meta <- get_publication(h)
      if (is.null(meta)) { message("  skip (no meta): ", h); next }

      collected <- bind_rows(collected, meta |> mutate(hop = hop - 1))

      if (hop <= max_hops) {
        recs <- get_recommendations(h, meta$pub_id)
        if (nrow(recs) > 0) next_frontier <- c(next_frontier, recs$host)
        # also keep the rec metadata so we learn names we never visit
        collected <- bind_rows(collected, recs |> mutate(hop = hop, author = NA_character_))
      }
    }
    frontier <- next_frontier
  }

  collected |>
    filter(!is.na(host)) |>
    group_by(host) |>
    slice_min(hop, n = 1, with_ties = FALSE) |>
    ungroup()
}

# --- score -----------------------------------------------------------------

SPORTS_RE <- regex(
  paste0("football|nfl|nba|basketball|baseball|mlb|golf|hockey|nhl|soccer|",
         "fantasy|draft|analytics|sabermetric|stats|model|data|sport|wager|",
         "college|cfb|betting"),
  ignore_case = TRUE
)

# American football. "football" alone is ambiguous -- half the world means
# soccer by it -- so a positive hit is disqualified by SOCCER_RE below.
FOOTBALL_RE <- regex(
  paste0("football|\\bnfl\\b|\\bcfb\\b|gridiron|quarterback|touchdown|",
         "\\bqb\\b|running back|wide receiver|tight end|offensive line|",
         "linebacker|defensive back|secondary|blitz|coverage|scheme|snap|",
         "recruiting|\\bbowl\\b|big ten|big 12|pac-12|\\bsec\\b|\\bacc\\b|",
         "buckeye|nittany|huskies|auburn|longhorn|sooner|wolverine|",
         "draft|combine|depth chart"),
  ignore_case = TRUE
)
SOCCER_RE <- regex(
  paste0("soccer|premier league|match report|futbol|la liga|bundesliga|",
         "serie a|\\bmls\\b|uefa|fifa|striker|midfield|\\bfc\\b|wrexham"),
  ignore_case = TRUE
)

# Other sports, used as a DISQUALIFIER in football mode.
OTHER_SPORT_RE <- regex(
  paste0("basketball|hoops|\\bnba\\b|\\bwnba\\b|hockey|\\bnhl\\b|",
         "baseball|\\bmlb\\b|golf|tennis|cricket|rugby|nascar|\\bf1\\b|",
         "soccer|premier league|futbol|\\bmls\\b|uefa|fifa"),
  ignore_case = TRUE
)

# Football mode keeps a publication when it either names football explicitly
# OR names no other sport at all. Requiring a positive football keyword was
# tried first and it discarded Joe Marino (NFL draft), Oregon, Nebraska, Cal,
# UCLA and The Rooster -- team publications whose hero_text never says the
# word. The graph is seeded entirely from football, so silence about sport is
# evidence FOR football, not against it. What has to be excluded is the
# basketball and soccer that arrives via cross-recommendation, and those name
# themselves readily.
topic_hit <- function(txt) {
  if (TOPIC == "football") {
    is_fb    <- str_detect(txt, FOOTBALL_RE) & !str_detect(txt, SOCCER_RE)
    is_other <- str_detect(txt, OTHER_SPORT_RE)
    is_fb | !is_other
  } else {
    str_detect(txt, SPORTS_RE)
  }
}

enrich_and_score <- function(pubs) {
  message(sprintf("pulling archives for %d publications", nrow(pubs)))
  stats <- map_dfr(pubs$host, function(h) {
    s <- get_archive_stats(h)
    if (is.null(s)) tibble(host = h) else bind_cols(tibble(host = h), s)
  })

  pubs |>
    left_join(stats, by = "host") |>
    mutate(
      topic_match = topic_hit(paste(coalesce(name, ""), coalesce(hero, ""))),
      in_band     = med_reactions >= BAND_REACT_LOW &
                    med_reactions <= BAND_REACT_HIGH,
      alive       = posts_90d >= MIN_POSTS_90D,
      # In "allsports" mode topic is a RANKING signal only -- every seed is a
      # sports publication, so the graph itself is the topic filter, and using
      # keywords as a gate threw away obviously on-topic pubs whose hero_text
      # was empty. In "football" mode it IS a gate, because a football-seeded
      # graph still reaches plenty of NBA and soccer via cross-recommendations
      # and the whole point is to exclude them.
      qualified   = coalesce(in_band, FALSE) & coalesce(alive, FALSE) &
                    (TOPIC != "football" | coalesce(topic_match, FALSE)),
      # rank inside the band: engagement depth relative to reach is the
      # signal that a swap will actually convert
      engage_ratio = (coalesce(med_comments, 0) + coalesce(med_restacks, 0)) /
                     pmax(coalesce(med_reactions, 1), 1)
    ) |>
    arrange(desc(qualified), desc(coalesce(topic_match, FALSE)),
            desc(engage_ratio), desc(med_reactions))
}

# --- run -------------------------------------------------------------------

if (sys.nframe() == 0) {
  pubs   <- crawl(SEEDS)
  scored <- enrich_and_score(pubs)

  readr::write_csv(scored, "substack_rec_prospects.csv")

  cat("\n--- QUALIFIED PROSPECTS ---\n")
  scored |>
    filter(qualified) |>
    select(name, host, hop, med_reactions, med_comments, posts_90d, engage_ratio) |>
    print(n = 60)
}

# --- CALIBRATION -----------------------------------------------------------
# Before you trust the band: run get_archive_stats() on two or three pubs whose
# real subscriber count you know (ask them, or use ones that display it). Fit
# the ratio. Reactions typically land somewhere around 1-3% of list size, but
# it varies enormously by niche -- sports runs hotter than most. Adjust
# BAND_REACT_LOW / BAND_REACT_HIGH to whatever maps to your 200-3,000 target.
#
# Your own numbers are a free calibration point: 30 subscribers, 62% open.
# Whatever median reactions themerrittocracy.substack.com shows is the floor
# anchor for a 30-person list.