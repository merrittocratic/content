# Pour One Out for My Homies

---

The first thing I installed on the Mac Mini was Homebrew.

If you're not a developer, Homebrew is a package manager — a tool that installs other tools. It's the foundation of any modern Mac development environment, the thing you put in before everything else. But what makes Homebrew worth talking about isn't just what it does. It's how it thinks about what it does.

Homebrew is built entirely around a craft brewing metaphor. You don't add a software source, you *tap* a repository — like tapping a keg. You don't install packages, you install *formulae*. GUI applications live in *casks*. Everything that gets installed lives in the *Cellar*. The whole system is designed as if a brewmaster sat down and asked: what if the thing developers do every day felt a little more like making something with your hands?

That framing turned out to be exactly right for this project.

One person. A $700 machine in the corner of a home office. Open-source tools stacked on open-source tools. Formulae tapped from repos across the internet, assembled into something that didn't exist four weeks ago. We brewed a sports analytics operation from scratch — models, pipeline, automation agent, content engine — and we did it before the NFL Draft.

The draft is over. Here's what one month of building looks like from the outside:

**1 month. 4 repos. 12 articles. 15,000 words. 7 position-specific machine learning models. 1 automation agent who files his own journal entries. 1 sports analytics brand that didn't exist on March 29th.**

We tapped the repos. We ran the formulae. We poured what came out.

Pour one out for the homies.

---

## The Lucius Fox Problem

There's a scene in Batman Begins where Lucius Fox explains to Bruce Wayne how he synthesized an antidote — isolating receptor compounds, identifying protein-based catalysts, the whole technical picture. Wayne stares at him and asks if he's meant to understand any of this.

> "Not at all. I just wanted you to know how hard it was."

That's the honest version of a building-in-public post. I'm not going to make you a machine learning engineer. I'm not even going to try. What I want you to walk away with is a feel for the actual terrain — why it took months, why plans that looked airtight on paper got shredded by contact with reality, and why the final product is built differently than the version I originally designed.

The technical details are receipts. The story is the journey.

---

## Meet Earnest

Before we get into the model, you should meet the other member of this operation.

Earnest is an AI automation agent — built on OpenClaw, running on the Mac Mini — whose job is to extend the brand's reach without replacing the human judgment behind it. He monitors for new Substack articles, drafts X threads in Merrittocracy voice, surfaces reply opportunities, and routes everything through Telegram for approval before anything posts. He also files his own journal entries when something significant happens, which is either useful documentation discipline or a little unsettling depending on your perspective.

The approval loop is the whole point. Earnest doesn't publish. He proposes. Every draft goes through Telegram, every post requires an explicit yes, every irreversible action has a human in the loop. The relationship is editor and writer, not owner and tool.

[IMAGE: IMG_6168.PNG]

*The Telegram conversation that introduces him says it better than I could: "amplify his voice, not replace it." Steve gives feedback. Earnest revises. Earnest asks "Better?" Nothing posts without the answer being yes.*

Earnest went live for the first time during draft week. Getting him there was its own project, with its own set of things that didn't survive first contact with reality. More on that later. For now — he exists, he works, and he's a character in this story, not just a tool in the stack.

---

## The Decisions That Changed the Model

Building any model involves a long series of choices that look minor until you see what they were actually hiding. Three of ours turned out to matter more than we anticipated.

**The DB Split.** The original design grouped Cornerbacks and Safeties together as "defensive backs." Reasonable football intuition — same side of the ball, similar evaluation criteria, combined sample size is comfortable. The problem surfaced in the data. CB booms 4% of the time. Safety booms 12% of the time. These are not similar positions wearing similar jerseys. They are opposite phenomena crammed into the same model, canceling each other out. Splitting them was the right call — and it was the move that sharpened the Caleb Downs piece considerably. Once Safety stands on its own, the positional value argument gets a lot stronger. The data isn't just a footnote to the analysis. Sometimes it's the analysis.

**The Imputation Artifact.** When you have missing data, the standard move is to fill it with the median value and move on. We did that for college defensive statistics, where the data source doesn't cover seasons reliably before 2012. For Linebackers, roughly 65% of the training data predates that cutoff, so 65% of LBs got the median fill. The other 35% had real, measured statistics. XGBoost — a very good algorithm — found that split immediately and decided it was the most important thing it had ever seen. Interceptions became the dominant model feature. Not because linebacker interception rate predicts NFL outcomes. Because "median fill versus something else" is a dead-reliable indicator of whether a player was drafted before or after 2012. The model was predicting era. We removed the imputation. XGBoost handles missing values natively — it doesn't need us to fill in blanks it's perfectly capable of reading on its own.

**WR/TE Can't Share a Scale.** A tight end with 60 receptions in a college season is an elite, alpha-level weapon. A wide receiver with 60 receptions is slightly below average. When both groups compete for rank in the same percentile table, every tight end reads as a receiving monster and every wide receiver reads as ordinary. Both signals get washed out, and the model falls back on draft position as the primary predictor — which defeats the purpose of having college production features at all. The fix was straightforward: rank each position within itself. WRs against WRs. TEs against TEs. The solution was obvious the moment I stopped thinking like a data engineer and started thinking like a scout.

None of these produced error messages. None of them crashed the pipeline. They produced valid-looking outputs that were quietly wrong, and the only way to catch them was to ask uncomfortable questions about why certain features were behaving strangely. Models don't wave a flag when they're confused. That's your job.

---

## The Pick Ladder

Some design decisions were proactive rather than corrective. This one matters more than it looks.

The model doesn't score a prospect at a single projected draft pick. It scores him across a *range* — a ladder of positions from 1 to 257 — and shows how boom and bust probability shifts across that range. "Simpson at pick 20: 38–52% bust. Simpson at pick 45: still 30–42%." Honest uncertainty ranges instead of false precision, and the model stays decoupled from mock accuracy, which is genuinely unreliable past round two.

The design question was what intervals to use on that ladder. The obvious answer is clean steps of 5 or 10 — picks 1, 5, 10, 15, 20, 25, 30. Tidy. Easy to explain. Also wrong.

Round numbers in draft discourse are psychological categories as much as positional values. "Top-10 pick" carries meaning that has nothing to do with the mathematical distance between pick 9 and pick 11. If the ladder lands on 10, 20, and 30, those slots arrive pre-loaded with narrative weight that we're actively trying to strip out. The ladder uses increments of 4 from pick 1 through round 2, then increments of 10 through round 7 — threading past the anchor numbers without hitting them.

Here's the insight that makes this more than a methodology footnote. The *distance* between pick 1 and pick 5 is four picks. The *distance* between pick 25 and pick 29 is also four picks. Same interval. But the *value* difference between those two pairs is not remotely similar. The historical production curve for draft picks follows a steep log function at the top and flattens dramatically by the end of the first round. Moving from pick 1 to pick 5 is a significant devaluation. Moving from pick 25 to pick 29 barely registers.

Equal distances. Completely different value gaps. Nobody notices the ladder design in the outputs. That's exactly the point.

---

## Three Naming Systems, Zero Margin for Error

The model joins data from three separate sources — nflreadr for combine measurements, cfbfastR for college statistics, and our mock board CSVs — and none of them use the same naming conventions. The failure mode is never a crash. It's a silent missing value that the model quietly absorbs and keeps moving.

UCF is "UCF" in one database and "Central Florida" in another. One fix in a configuration file, discovered only because Malachi Lawrence's entire defensive stats row was empty and someone went looking.

Sonny Styles — top linebacker prospect, attended the combine — shows up in nflreadr as "Alex Styles," his legal first name. The join found no match. He was added as a mock-only player with all-NA combine measurables, despite having attended the combine. One lookup table entry fixed it. Neither issue produced an error. Both required knowing which player to look up and why.

This is the unglamorous reality of building a pipeline across sources that were never designed to talk to each other. The analytical sophistication of the model is completely irrelevant if the names don't match. You can have the best formula in the cellar and still pour nothing if the keg fitting is wrong.

---

## Three Algorithms Walked In. One Walked Out.

We ran three fundamentally different algorithms against the same data, the same cross-validation folds, and the same outcome variable. Here's how it went.

**XGBoost** is the gradient boosted tree that the analytics community has been using for fifteen years. Tuned across fifty hyperparameter combinations per position group. The incumbent.

**TabPFN** is a foundation model published in *Nature*, pre-trained on millions of synthetic tabular datasets. It makes predictions in a single forward pass — no training on your data, just pattern recognition from a model that's seen more tables than any individual problem will ever produce. The challenger with the pedigree.

**TabNet** is attention-based deep learning built specifically for tabular data, with the ability to show you *what the model focused on* for each individual player. The technology demo.

XGBoost won all eight position groups. TabPFN managed a marginal improvement on two. TabNet didn't beat the baseline — just predicting the mean for every player — on a single group. On Offensive Linemen, TabNet posted an RMSE of 2.08 against a null model of 1.0. Twice as confused as doing nothing.

*RUN_TABNET <- FALSE* is now a permanent flag in the codebase.

Here's the honest explanation for why this was predictable: the academic literature on tabular machine learning is consistent on this point. Tree models dominate at small-to-medium data sizes with mixed feature types and low signal-to-noise ratios. Our dataset is all three — between 162 and 545 players per position group, a mix of numeric and categorical features, and an outcome variable that's inherently noisy because pre-draft data can't see coaching quality, injury luck, or scheme fit. The fancy model lost to a spreadsheet. That's not a failure. That's a result.

The comparison itself is the content. We ran the test. Here are the receipts.

---

## The Infrastructure That Didn't Survive First Contact

Getting Earnest operational was a separate build with its own set of plans that looked right until they weren't.

The original secrets management approach: store everything in 1Password, inject credentials at startup using the 1Password CLI. Clean, secure, well-designed. It lasted approximately 24 hours. The 1Password CLI requires an interactive session to authenticate. Background services have no interactive session. These two facts cannot be reconciled. The fix was macOS Keychain — scoped to a single service, encrypted at rest, headless by design. Twelve secrets migrated. The new approach was more robust than the original. It also required throwing out the original entirely.

Getting the X API working produced its own chapter. The first live post hit an error immediately — the R HTTP library had no native OAuth 1.0a support, despite that function appearing in multiple examples online. Switched implementations. Same error. Switched again. All of them returned error code 32: "Could not authenticate you."

Error code 32 looks like a signing bug. It isn't. It means the credentials are the problem, not the code. The diagnostic: test the Bearer token in isolation. A 403 "Unsupported Authentication" response — not a 401 Unauthorized — confirms the API key pair is valid and the access token is the failure point. Root cause: the tokens were generated before the app's permissions were upgraded to "Read and Write." Old tokens inherit the permission level at generation. They can't be retroactively upgraded. Regenerate in the developer portal, update the environment, and the first post goes through clean.

Two hours debugging authentication code. Fixed by a button click in a dashboard.

The Telegram notification system hit its own wall — a cron gateway authentication error that wouldn't resolve. Earnest didn't wait for a fix. He checked for pending drafts during his existing heartbeat cycle and sent notifications from within the agent session instead. The cron auth problem became irrelevant. He routed around it without being asked, which is exactly the kind of thing you want from a system you're depending on during a live draft.

---

## The Feature Nobody Planned For

The original model design had combine measurables, college production, draft position, age, and the program pipeline. The drafting organization was not in scope.

It got added mid-cycle, driven by a content need. The "Van Isn't the Variable" piece on team development quality required building a rolling 10-year pick-adjusted AV residual per franchise — how much better or worse does each organization develop players relative to what their draft slots historically produce? The feature went into the model to support one article.

On draft night, it became the story.

Kenyon Sadiq landed with the Jets. His predicted z-score swung from +0.169 pre-draft to -0.08 post-pick. The entire swing — a quarter of a standard deviation — came from one feature: the Jets' player retention rate, a proxy for organizational development continuity. Omar Cooper Jr. took the same penalty at pick 30. Two players, same organization, same feature, same discount applied before either of them had attended a single practice.

Max Iheanachor to Pittsburgh: the Steelers have produced zero first-round offensive tackle booms in fifteen years of training data. Keylan Rutledge to Houston: same feature, same value. Two offensive linemen. Two organizations with empty first-round OL boom columns in the historical record.

The model doesn't hate any of these players. It has documented, specific concerns about where they landed. Some destinations amplify talent. Some discount it. That signal was sitting in fifteen years of data. We found it by accident while writing a different article.

I didn't plan for that. The data found it.

---

## Draft Night

The *draft_night_helper.R* script does one thing: type *pick("Player Name")* and receive a full player card — boom probability, bust probability, predicted z-score, athleticism percentile, program pipeline note — plus the exact file path to the SHAP waterfall chart, ready to copy to Telegram.

Earnest receives the file path, pulls the waterfall, drafts the X thread in Merrittocracy voice, and routes it back for approval. The whole chain — pick announced, model re-scored with the actual drafting team, waterfall regenerated, content drafted, approval requested — under ten minutes.

I want to be honest about what that felt like after months of building toward it.

It worked. Picks came across the ticker, I typed *pick("Kenyon Sadiq")*, the waterfall populated, Earnest had a draft thread in Telegram before the next commercial break. The infrastructure that had been a theoretical exercise for weeks became a real thing at a specific moment on a Thursday night in April. That's a different feeling than passing a unit test.

And when the organizational tax landed exactly where the model said it would — Sadiq, Cooper, Iheanachor, Rutledge, all carrying the development penalties we'd documented — that was something closer to vindication. The model didn't just run. It *said something* that turned out to be true.

Pre-draft snapshots were preserved separately, so the diff between "what we predicted before the pick" and "what the model thinks now that we know the team" is a content angle in its own right. Ty Simpson was a model favorite before the Rams took him. The Rams' development environment is one of the few that doesn't hurt that projection. The model and the narrative disagreed, and the honest version required holding both. That tension is exactly what Merrittocracy is supposed to produce.

---

## The Honest Scorecard

**XGBoost wins.** A tuned gradient boosted tree trained on 3,750 historical prospects outperformed two transformer-based architectures on every position group. The algorithm the analytics community has been using for fifteen years is still the right tool at this data scale. That's not a failure of ambition. It's a result.

**Pre-draft prediction has a ceiling.** RMSE ranges from 0.948 on quarterbacks to 0.999 on running backs, against a null model of 1.0. The signal is real but modest. Coaching quality, injury luck, scheme fit, and organizational development explain outcomes that no combine measurement can touch. A model that quantifies what it can't predict is more trustworthy than one that doesn't admit the question.

**The program pipeline works.** Rolling 10-year, position-specific draft outcomes per college program — leave-one-out computed — is a genuine differentiator. Most public models treat college program as a flat categorical. Alabama WRs are not Alabama QBs. The 2026 class confirmed the feature adds signal.

**The organizational tax is real.** Built mid-cycle to support one article. Became the organizing principle of draft night coverage.

---

## What's Next

The 2027 model has a long wishlist: conference tier (NA all cycle, never caught until too late), birth dates sourced at the start of the season instead of patched on draft eve, proper player ID joining instead of name matching across three databases. Structural fixes that would have made this cycle cleaner.

The NBA Playoffs are already generating narrative debt. Victor Wembanyama is playing at a level that demands historical context — the Kareem precedent is genuinely instructive about what elite young bigs need to sustain a championship window. That piece is next.

And somewhere on the Mac Mini in the corner of a home office, Earnest is running his heartbeat check, monitoring for new content, filing journal entries, routing around the next blocked feature before anyone asks him to.

The cellar is stocked. The tap is open.

---

*Model trained on 2006–2020 NFL draft classes using pick-adjusted 4-year Career Approximate Value. Program pipeline features computed using a rolling 10-year leave-one-out window. Organizational development features computed as rolling 10-year pick-adjusted AV residuals by franchise. Data via Pro Football Reference and nflverse. Full methodology at [github.com/merrittocratic/nfl-draft-model](https://github.com/merrittocratic/nfl-draft-model).*
