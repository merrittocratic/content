---
repo: boxscore-prophet
---

# Four Games, Four Storylines: Checking Week 1's Receipts

The headlines write themselves after Week 1: the Giants looked "strong," Cincinnati "survived," Kansas City was "scary," and the Chargers looked "lost." That's the easy read. The harder question — the one our model tries to answer before kickoff, not after — is whether the box score actually backs up the story, and whether we saw it coming. Four games, four different flavors of right and wrong. Let's check the receipts.

## The Giants weren't just "strong" — they had the best QB in the building

Jaxson Dart went 23-of-29 for 230 yards and 3 touchdowns with zero picks, added 54 yards on the ground, and posted a passing EPA of +21.9 with a CPOE of +13.4 — the best mark of any quarterback in the four games we tracked this week. The Giants' offense as a whole led the group too, at +0.243 EPA per play and a 56.5% success rate. None of that was a surprise to our model. Pre-week, we had Dart six full spots ahead of the Expert Consensus Ranking (model rank 5 versus an ECR of 11), which is our biggest gap of the week in the "we like him more than the market does" direction. It hit. Cam Skattebo did his part too — 18 carries for 81 yards and a score, landing in the 81st percentile on our internal run-efficiency read. This wasn't a fluky shootout; it was a genuinely efficient offense the market was underpricing.

## Cincinnati's defense won it — not Burrow

The headline says the Bengals D "let Burrow contend," but flip that around. Burrow actually missed his own 20-point bar: 25-of-35 for 254 yards, 1 touchdown, 1 interception, a passing EPA of -2.6, and 14.2 PPR points. Our model flagged this ahead of time — it had Burrow at rank 4 against ECR's #1, its single most bearish call relative to the market all week, with a start probability of just 43.9%. That's a coinflip, not a lock, and the skepticism paid off. So who actually won this game? The defense, sort of — four Tampa Bay giveaways (their worst turnover game of the week) and four sacks, despite allowing 27 points and a 52.6% success rate. That's opportunistic, not shutdown-good. And it wasn't the ground game bailing anyone out either: Chase Brown's 16 carries for 56 yards graded in the 30th percentile. Cincinnati won on takeaways, full stop, while its two best offensive weapons both had quiet nights.

## Kansas City looked "scary" because our model said they would

Mahomes cleared his 20-point bar with 2 passing touchdowns, a rushing score, and 21.7 PPR points, but the real story is the team number: Kansas City's offensive EPA per play was +0.071 in Week 1, nearly double their +0.039 rate across all of 2025. The defense matched it, holding Denver to -0.235 EPA per play — the best defensive mark of any of the four teams — with a pick and four sacks to go with it. Our model had Mahomes at rank 9 against an ECR of 17, the largest model-versus-market gap of the entire quartet this week, and it hit. Kenneth Walker III backed it up on the ground with 23 carries for 173 yards and a touchdown, a 97th-percentile run-efficiency profile — the best of any back we tracked in these four games. When both sides of the ball outperform their own baseline this much, "scary" is actually underselling it.

## The Chargers were our biggest miss — and we're not hiding it

Here's the one that didn't work. Herbert went 17-of-27 for 209 yards, 1 touchdown and 1 interception, took 3 sacks, and posted a passing EPA of -5.6 — the worst quarterback mark of the group. Our model's single highest-conviction call of the week was Herbert over the field (model rank 1 versus an ECR of 5), and it busted. We're keeping this one in the writeup rather than trimming it for a cleaner sweep, because showing the misses is the whole point of publishing the math instead of just the polished output. And this wasn't a Herbert-only problem: the Chargers' team offense was the worst of the four at -0.227 EPA per play and a 38.6% success rate, actually below their already-mediocre 2025 baseline of -0.013. Omarion Hampton's 12 carries for 43 yards landed in the 6th percentile, the worst run-efficiency profile in this set. That's a step back for the whole offense, not just a bad game from the quarterback our model liked most.

---

Three hits, one honest miss, all from a four-game sample — small enough that we're not calling any of it a trend yet, but real enough to be worth writing down before hindsight rewrites the story for us.

*Method: pre-week model ranks (model_rank vs. ECR) compared against actual Week 1 outcomes; EPA, CPOE, and success rate via nflverse/nflreadr; run-efficiency percentiles from our internal public-data model. Full technical writeup at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
