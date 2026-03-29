### FINAL — Short thread (3 tweets, pin tweet 1)

**1/3**
Introducing Merrittocracy.

Sports media is a narrative machine. Every season, every sport — consensus takes get built on vibes, repeated until they feel like facts, and almost never checked against the data after the fact.

Merrittocracy is the check.

**2/3**
Launching with the 2026 NFL Draft — a boom/bust probability model trained on 15 years of data. Combine measurables, college production, and a program pipeline feature that treats "Ohio State WR" and "Ohio State QB" as very different sentences.

Code and methodology are public.

**3/3**
The draft is the start of the race, not the finish line. Wherever the consensus gets lazy and the data has something to say, we'll be there.

Coming soon: narrative-checks on the 2026 class, position group deep dives, and a model-based mock before April 23.

Full story: [Substack link](https://open.substack.com/pub/themerrittocracy/p/sports-narratives-are-broken-the?r=2327xj&utm_campaign=post&utm_medium=web&showWelcomeOnShare=true)
Code: [GitHub link](https://github.com/merrittocratic/nfl-draft-model)

---

## POST 2: SUBSTACK ORIGIN POST

# Sports Narratives are broken. The only fix, Receipts!

Every sport comes equipped with a narrative-building machine.

The NFL has it's draft cycle beginning right after the Super Bowl.  Every year, analysts begin repeating each other's evaluations until mock drafts harden into consensus, a team picks the guy everyone expected, and three years later nobody goes back to grade the pre-draft analysis. In the NBA, the narratives center around "Is this team really good enough to win the Finals", or my favorite, "Who will be the next Face of the League". In golf, "Who will be the next Tiger Woods?", and is it their time to win the Masters?  Gotta be honest though, right now, being the next Tiger Woods doens't feel too appealing.  

The cycle works the same across the entire sports landscape: narratives are created, audiences consume them, the moment passes, and accountability expires. The experts just move on to create the next cycle.

Merrittocracy exists because that cycle is broken — and because the tools to do better are sitting right there in the data.

## What this is

Merrittocracy is a sports analytics brand built on a simple premise: the conventional wisdom should have to survive first contact with the enemy, a man with some code who's not afraid to use it.  

Sometimes the consensus opinion will hold up. The wisdom of the crowd does gets things right, and when it does, we'll show how the data that backs it up. But when it doesn't — when the narrative is running on vibes instead of evidence — we'll show that too.

Why now?  Well, two things will become clear with Merrittocracy, I love College and Pro football, and the NFL Draft is the perfect intersection of both.  The Draft ia also the perfect proving ground: a months-long evaluation cycle, measurable outcomes, and an entire mediasphere that produces confident opinions with surprisingly little accountability or data.  The draft is the starting point, not the finish line. The same narrative-checking lens applies anywhere sports media produces consensus takes that outpace the data.  Football, Basketball, Golf, and maybe a little bit of baseball, we'll cover it all.  Sorry, no Hockey...

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

Our primary novel feature is the **program pipeline**: rolling 10-year, position-group-specific draft outcomes for every college program. Ohio State's track record producing wide receivers is a completely different data point than Ohio State's track record producing quarterbacks. Georgia's defensive line pipeline tells you something different than their offensive line pipeline.

Why 10 years and not all-time? Coaching changes and scheme evolution matter. Saban's Alabama produced prospects in a fundamentally different developmental environment than what came before — and what's coming after. A rolling window captures current program identity rather than diluting it with decades of irrelevant history.

When someone says "trust the Alabama brand," the program pipeline asks: *at which position, in which era, producing what results?*

## Three algorithms, Seven sub-models, one comparison

This section is a little more technical, but don't worry we'll get through it!  We don't just run a single model. We will end up running thousands of simulations across mutliple variations of the data.  The model complexity will range from functional to frontier, and we'll compare the results head-to-head:

**XGBoost** — the gradient boosted tree baseline, tuned across dozens of hyperparameter combinations. If you've seen a public draft model, it's probably some version of this.

**TabPFN** — a foundation model for tabular data, published in Nature. Zero tuning — a single forward pass produces predictions. If a zero-shot transformer beats tuned XGBoost on NFL data, that's a headline.

**TabNet** — attention-based deep learning with built-in interpretability. TabNet tells us *what the model focuses on* when evaluating a specific player. Being able to tell you "here's what the model pays attention to when it looks at this QB" is way more interesting than "the model says bust probability of 42%."

This will be a genuine methodological experiment for the analytics community, and three independent perspectives on every prospect for NFL fans.

Shocking to hear I'm sure, but not every position on the field has the same measurables, so why out them all in one model?  Instead of one mega-model trying to predict outcomes for quarterbacks and offensive linemen with the same features, we run position-group-specific sub-models: QB, WR/TE, DL, OL, DB, LB, RB. Each group shares enough evaluation DNA to use common features while keeping enough historical observations to train reliably.

## Beyond the draft

The draft is where we prove the concept. The lens is portable.

The same question we ask about draft prospects — *does the data support what the consensus is saying?* — applies everywhere in sports. Playoff narratives that ignore the numbers. Award races driven by storylines instead of performance. Historical comparisons built on nostalgia instead of evidence.

We'll go where the narratives are loudest and the data is most interesting. The NFL Draft is April 23. After that, the work keeps going.

## Everything is public

The code is on GitHub. The methodology is explained here. The model outputs are transparent. If we're wrong, you'll be able to see exactly why — and that's the point. Accountability is what separates analysis from content.

## Why "Merrittocracy"

Because analysis should be earned by the data, not inherited from consensus. 

If you had a two-minute elevator ride with just me, you'd find: I flew helicopters in the Navy for 20 years — H-60s, 4,500 hours, eventually commanding a squadron. Then I pivoted into data science, where I've spent the years since building production-grade predictive models and wondering quite loudly (ask my wife) why nobody applies the same rigor to the NFL Draft.

Military aviation has a term for when you stop trusting your instruments and start flying by feel: spatial disorientation. It’s the moment your senses diverge from reality — and it kills people. Draft analysis has the same problem — analysts abandon the data and start flying by vibes. Nobody dies, but franchises crater for half a decade.

The draft is full of confident people flying blind, let Merrittocracy be your instrument panel.

Follow along:
- **X:** [@Merrittocratic](https://x.com/Merrittocratic) — narrative-checks, data viz, short takes
- **Substack:** [substack.com/@themerrittocracy](https://substack.com/@themerrittocracy) — deep dives, methodology, full model output
- **GitHub:** [github.com/merrittocratic/nfl-draft-model](https://github.com/merrittocratic/nfl-draft-model) — code, data, transparency

First analysis piece drops this week.

---

*Data via nflverse/nflreadr and Pro Football Reference.*