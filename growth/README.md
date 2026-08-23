# content/growth

Tooling for Substack subscriber growth. Currently one thing: finding
recommendation swap partners.

## Why this exists

As of August 2026 Merrittocracy sits at ~30 subscribers with a 62% 30-day
open rate. That combination means the product is fine and the funnel is
empty -- the people who read it, read it. The constraint is that almost
nobody has encountered it.

Substack recommendations are the highest-leverage fix available: a mutual
recommendation drips subscribers indefinitely, costs nothing, and compounds.
The bottleneck is *finding* the right partners. Too big and they ignore you.
Too small and the swap sends nobody.

## The measurement problem

**Substack does not publish subscriber counts.** There is no endpoint, no
API field, no reliable scrape. Every commercial tool advertising "subscriber
counts" is either reading the small minority of publications that opt to
display them, or inferring from the same public signals available here.

So the target criterion -- publications in the 200-3,000 subscriber range --
is not directly filterable. `substack_rec_prospector.R` uses **median
reactions per free post** as a proxy instead.

This is an honest approximation with real error. Reactions run roughly 1-3%
of list size, but the ratio varies enormously by niche, post cadence, and how
aggressively a publication cultivates Notes. Sports runs hotter than average.
A quiet 2,000-subscriber newsletter and a loud 400-subscriber one can land in
the same band. Accept that; the band is a filter, not a measurement.

## How discovery works

Keyword search returns noise. The script walks the **recommendation graph**
instead: seed with publications you actually read, pull each one's
recommendations, repeat for two hops.

This is better than search for a non-obvious reason. A publication that
already recommends five others has demonstrated it participates in swaps.
Search returns publications that merely exist. The graph pre-filters for
willingness.

Two hops off five good seeds typically surfaces 100-300 candidates. Three
hops explodes the crawl and drifts off-topic.

## Calibration

The band constants in the script are **guesses and must be replaced**:

```r
BAND_REACT_LOW   <- 4
BAND_REACT_HIGH  <- 70
```

To calibrate:

1. Run `get_archive_stats("themerrittocracy")`. Whatever median reactions
   comes back is the anchor for a 30-subscriber list -- the floor.
2. Find two or three publications whose real subscriber count you know
   (ask directly, or use ones that display it). Run the same function.
3. Fit the ratio. Set `BAND_REACT_LOW` to whatever maps to ~200 subscribers
   and `BAND_REACT_HIGH` to ~3,000.

**Record what you settled on and what you calibrated against, right here,
with the date.** This is the number you will not remember in six months.

```
Calibrated 2026-08-23 -- WEAKLY. Read the caveat below before trusting it.
  themerrittocracy   30 known subs   median 4 reactions  -> 13.3%
Band left at defaults: LOW = 4, HIGH = 70
```

**The calibration did not work, and the band is still a guess.** Only one
publication with a known subscriber count was available -- our own -- and it
sits at the extreme low end, where the ratio does not behave. 4 reactions on
30 subscribers is 13.3%, four to thirteen times the 1-3% rule of thumb. That
is what a 30-person list with a 62% open rate looks like: essentially everyone
who receives it engages. Extrapolating 13.3% upward would put the 200-3,000
band at 27-400 median reactions, which is certainly wrong.

The defaults (4-70) survive because under the 1-3% rule they map to roughly
130-7,000 subscribers -- wider than the 200-3,000 target, but centred on it.
Treat band membership as "plausibly small enough to answer, big enough to
matter," nothing more.

To actually calibrate, ask two or three publications in the list what their
count is. Operators at this size usually just tell you, and asking is a
reasonable opening move in an outreach conversation anyway.

## Known-bad signal: paid_share

`get_archive_stats()` computes `paid_share` and the scorer ignores it. It
should not. When a publication paywalls most of its output, the archive
sample is mostly paid posts, and `get_archive_stats()` falls back to scoring
those whenever fewer than three free posts are found. Reactions on a paid post
measure the *paying subset*, not the list -- so a high-`paid_share`
publication's size is systematically understated.

Several names in the 2026-08-23 run sit at 83-100% paid. Their reaction
medians are not comparable to the 0-26% ones and they are probably larger
than they look. Either filter on `paid_share` or read it as a column and
adjust by eye.

## Ranking

Sort by `engage_ratio` -- (comments + restacks) / reactions -- not by size.
A 900-subscriber publication with eight comments per post sends more
converting readers than a silent 3,000, because that audience treats a
recommendation as signal rather than noise. Size gets you in the band;
engagement depth decides the order you work it.

## What is NOT automated

Outreach. Deliberately.

A templated DM to 25 newsletters converts at approximately zero and burns
the list permanently -- these are small operators who can tell. The process
is: subscribe, read two posts, leave a real comment, recommend them
unprompted, then ask. Roughly 8 of 25 convert when done this way.

This does not belong to Earnest and should never be scheduled. The script
produces a list to work through by hand.

## Files

| File | Committed | Purpose |
|------|-----------|---------|
| `substack_rec_prospector.R` | yes | Crawl + score |
| `README.md` | yes | This file, including calibration record |
| `substack_rec_prospects.csv` | **no** | Regenerated output |
| `outreach_log.md` | **no** | Who, when, what, result |

Add to `.gitignore`:

```
content/growth/*.csv
content/growth/outreach_log.md
```

The CSV and the log stay out of version control because they are regenerated
output and a working log -- there is no reason to version either.

**This directory lives in `content` and that is settled.** An earlier draft of
this README said it belonged in `OpenClaw-Ops` if `content` were public. It
does not. `content` is public, deliberately, and that is fine. `OpenClaw-Ops`
is for work Earnest runs on a schedule, and the whole point of the section
below is that this work is manual and must never be scheduled. It belongs
here, beside the publication it exists to grow.

## Outreach log structure

The script runs quarterly. The log is the durable asset -- it is what answers
"were recommendation swaps worth the hours" in December. Structure it so the
answer is *which swaps converted*, not *how many did I send*:

```
| Date | Publication | Contact | Approach | Reciprocated | Subs attributed | Notes |
```

Attribute subscribers using Substack's own source breakdown, which reports
recommendation-driven signups by referring publication.

## Operational notes

- The v1 API is undocumented. Endpoint shapes drift. Every fetch is wrapped
  and returns `NULL` on failure rather than killing the crawl. Print raw JSON
  from one `get_recommendations()` call before trusting a full run.
- Reactions come back emoji-keyed and encoding-fragile. If `med_reactions`
  is uniformly `NA`, that is the cause; `reaction_count` is the fallback field.
- Keep `PAUSE_SEC` at 1.5. Substack throttles by IP. Do not get the brand's
  residential IP flagged over a growth script.
