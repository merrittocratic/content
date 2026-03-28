# Merrittocracy Launch — Content Drafts (v3)

## STATUS: DRAFT FOR REVIEW — do not publish without edits

---

## POST 1: X INTRODUCTION

### Option A — Single tweet (pinnable)

Sports media runs on narratives. Most of them never have to survive contact with data.

Merrittocracy is here to check the receipts — starting with the NFL Draft, expanding from there. Models, not mouthpieces. Results and code are public.

First analysis drops this week.

[link to Substack origin post]
[link to GitHub repo]

### Option B — Short thread (3 tweets, pin tweet 1)

**1/3**
Introducing Merrittocracy.

Sports media is a narrative machine. Every season, every sport — consensus takes get built on vibes, repeated until they feel like facts, and almost never checked against the data after the fact.

We're the check.

**2/3**
Launching with the 2026 NFL Draft — a boom/bust probability model trained on 15 years of data. Combine measurables, college production, and a program pipeline feature that treats "Alabama WR" and "Alabama QB" as very different sentences.

Code and methodology are public.

**3/3**
The draft is the starting line, not the finish. Wherever the consensus gets lazy and the data has something to say, we'll be there.

Coming soon: narrative-checks on the 2026 class, position group deep dives, and a model-based mock before April 23.

Full story: [Substack link]
Code: [GitHub link]

---

## POST 2: SUBSTACK ORIGIN POST

# The Narrative Machine Is Broken. We're Building the Receipt Drawer.

Every sport has a narrative machine.

In the NFL, it's the draft cycle. Analysts repeat each other's evaluations until mock drafts harden into consensus, a team picks the guy everyone expected, and three years later nobody goes back to grade the pre-draft analysis. In the NBA, it's playoff narratives — one great series and a player has "arrived," one bad series and he "can't be the guy," and the data that might complicate either story never makes it on air. In golf, it's the same five Masters storylines recycled every April with updated names.

The cycle works the same way everywhere: narratives form, audiences absorb them, the moment passes, and accountability expires. The analysts move on. The takes vanish into the timeline.

Merrittocracy exists because that cycle is broken across sports — and because the tools to do better are sitting right there in the data.

## What this is

Merrittocracy is a sports analytics brand built on a simple premise: the conventional wisdom should have to survive contact with a spreadsheet before we accept it.

Sometimes it will. The consensus gets things right, and when it does, we'll show the data that backs it up. But when it doesn't — when the narrative is running on vibes instead of evidence — we'll show that too.

We're launching with the NFL Draft because it's the perfect proving ground: a months-long evaluation cycle, measurable outcomes, and an entire media ecosystem that produces confident opinions with surprisingly little accountability. But the draft is the starting point, not the finish line. The same narrative-checking lens applies anywhere sports media produces consensus takes that outrun the data.

## The draft model

Our launch vehicle is a boom/bust probability model trained on every NFL draft class from 2006 through 2020 — roughly 3,750 players with four years of career data to measure outcomes against.

The model takes the features available before draft night — combine measurables, college production, draft position, age, experience — and asks a simple question: given where this player is being drafted, how likely is it that he significantly outperforms or underperforms that slot?

That's the key distinction. We're not predicting who's "good" or "bad" in a vacuum. We're predicting who's good *relative to where they're drafted*. A player taken 5th overall has a much higher bar to clear than a player taken 45th. The model measures draft-pick-adjusted production — the gap between what a player actually delivered and what his draft slot historically produces.

From that gap, three labels:

- **Boom**: significantly outperformed draft position
- **Bust**: significantly underperformed draft position
- **Expected**: landed roughly where the pick historically lands

The output is always a probability range. "Our model gives him a 35–55% boom probability" is more useful than a talking head saying "this guy's a stud." Honest analysis admits what it doesn't know.

## What makes this different

Most public draft models treat college program as either a flat categorical variable — Alabama = Alabama, regardless of era or position — or ignore it entirely. That's a mistake.

Our primary novel feature is the **program pipeline**: rolling 10-year, position-group-specific draft outcomes for every college program. Alabama's track record producing wide receivers is a completely different data point than Alabama's track record producing quarterbacks. Ohio State's defensive line pipeline tells you something different than their offensive line pipeline.

Why 10 years and not all-time? Coaching changes and scheme evolution matter. Saban's Alabama produced prospects in a fundamentally different developmental environment than what came before — and what's coming after. A rolling window captures current program identity rather than diluting it with decades of irrelevant history.

When someone says "trust the Alabama brand," the program pipeline asks: *at which position, in which era, producing what results?*

## Three models, one comparison

We don't run a single model. We run three on the same data and cross-validation folds, comparing head-to-head:

**XGBoost** — the gradient boosted tree baseline, tuned across 50 hyperparameter combinations. If you've seen a public draft model, it's probably some version of this.

**TabPFN** — a foundation model for tabular data, published in Nature. Zero tuning — a single forward pass produces predictions. If a zero-shot transformer beats tuned XGBoost on NFL data, that's a headline.

**TabNet** — attention-based deep learning with built-in interpretability. TabNet tells us *what the model focuses on* when evaluating a specific player. That's content as much as it is methodology — "here's what the model pays attention to when it looks at this QB" is a more interesting sentence than "the model says 42%."

The comparison itself is a piece of content for both audiences: a genuine methodological experiment for the analytics community, and three independent perspectives on every prospect for NFL fans.

## Seven sub-models

Not all positions evaluate the same way. Instead of one giant model trying to predict outcomes for quarterbacks and offensive linemen with the same features, we run position-group-specific sub-models: QB, WR/TE, DL, OL, DB, LB, RB. Each group shares enough evaluation DNA to use common features while keeping enough historical observations to train reliably.

## Beyond the draft

The draft is where we prove the concept. The lens is portable.

The same question we ask about draft prospects — *does the data support what the consensus is saying?* — applies everywhere in sports. Playoff narratives that ignore the numbers. Award races driven by storylines instead of performance. Historical comparisons built on nostalgia instead of evidence.

We'll go where the narratives are loudest and the data is most interesting. The NFL Draft is April 23. After that, the work keeps going.

## Everything is public

The code is on GitHub. The methodology is explained here. The model outputs are transparent. If we're wrong, you'll be able to see exactly why — and that's the point. Accountability is what separates analysis from content.

## Why "Merrittocracy"

Because analysis should be earned by the data, not inherited from consensus. And because the pun was right there.

Follow along:
- **X:** [@Merrittocratic](https://x.com/Merrittocratic) — narrative-checks, data viz, short takes
- **Substack:** [themerrittocracy.substack.com](https://themerrittocracy.substack.com) — deep dives, methodology, full model output
- **GitHub:** [github.com/merrittocratic/nfl-draft-model](https://github.com/merrittocratic/nfl-draft-model) — code, data, transparency

First analysis piece drops this week.

---

*Data via nflverse/nflreadr and Pro Football Reference.*

---

## NOTES FOR REVIEW

### X post
- **Option A vs B:** I still lean Option B for the pin. New followers who land on your profile get the full picture from the pinned thread — what you are, what the model does, what's coming. Option A works if you prefer cleaner aesthetics and plan to let the Substack link do the heavy lifting.
- **"First analysis drops this week"** — adjust timing to match when the Simpson/Pickett piece is ready to publish.

### Substack post
- ~1,600 words. Tight for a methodology post, but this is an origin piece, not a full methods paper. The detailed methodology deep dive (CV strategy, feature engineering, AV residual computation) should be its own follow-up once the model is producing output.
- The opening paragraph now name-checks NFL, NBA, and golf in one sweep — establishes multi-sport scope without committing to a specific timeline for any of them.
- "Beyond the draft" section is deliberately vague on future sport specifics. You don't want to promise NBA playoff content in the origin post and not deliver if the draft model runs long. Better to let future content arrive and speak for itself.

### Personal angle
- The "Why Merrittocracy" closer is short and punny. You may want to expand it with a brief personal hook — the analytics community responds well to knowing there's a real person behind the model, not a faceless brand. A sentence or two about being a data scientist who follows the draft closely, without connecting to the day job. Your call on how much to share.

### Pre-publish checklist
- GitHub repo should be public with at least a README before this goes live. An empty or private repo undercuts the transparency claim on launch day.
- Make sure the Substack URL is live and the X handle is set up before publishing.

### Open questions for you
- **NBA playoffs (May–June):** Model or data-backed commentary? A lighter-weight approach (public stats + narrative-checking) ships faster and still fits the brand. Worth deciding soon so you can plan the pipeline.
- **Masters (April 2027):** Golf has excellent public data (strokes gained, course history splits) that practically begs for narrative-checking without heavy custom modeling. Model or commentary?
- **Content repo:** Create `merrittocratic/content` on GitHub before launch if possible. First files will be the published versions of these posts.

### Launch sequence
1. **Substack origin post** (this piece) — publish first, get the URL
2. **X intro thread** — publish same day, link to Substack
3. **Simpson/Pickett Substack + X thread** — 2–4 days later
4. Position group deep dives begin after that
5. NBA playoff narrative-checks begin late May
