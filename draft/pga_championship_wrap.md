# Both Sides of the Receipt

---

The model's two highest-confidence picks going into Sunday were Scottie Scheffler and Rory McIlroy. Scheffler finished T11 at -2. McIlroy finished at -4. The winner was a +17500 longshot who the model ranked 41st. 

That's the honest version of Sunday at Aronimink, and it deserves an honest accounting. But honest accountings cut both ways. And before we get to what the model missed, we have to talk about what it found — because one of the quietest signals of this entire tournament may be the most important receipt this brand has banked.

## The player nobody was talking about

Alex Smalley came into the week with two modestly positive inputs: a skill prior of +0.304, and an eight-event form residual of +0.815. Nothing loud. Nothing that was going to show up in your broadcast preview or your betting rundown. The model had him 13th.

He entered Sunday as co-leader at -6 and finished T2. He double-bogeyed the 6th, bogeyed the 8th, spotted the field three shots in eight holes, and still walked off Aronimink with a top-two finish at a major championship. The broadcast framing will write itself around the Sunday collapse that wasn't. The actual story is that the model was pointing at this player before the leaderboard was, with the quietest legitimate inputs of anyone in the top 20 — and he validated it when it counted.

That's not a small thing. The model found Alex Smalley at a major. His T2 finish earned him an invitation to the 2027 Masters — the kind of downstream consequence that doesn't show up in a model output but makes the signal feel very real in retrospect.

Ludvig Aberg is the supporting receipt. He entered Sunday in the -4 cluster, ranked 16th by the model, prior of -0.27, form residual of +2.07. The prior penalty has been a running theme of this entire tournament — it's the same problem that had Reitan at 97th before Truist. Aberg absorbed the same discount going into the week, finished T4, and validated the form signal anyway. Two players the model quietly liked. Both finished inside the top five at the second major of the year.

## The problem the receipts can't cover

Here is where the both-sides accounting gets uncomfortable.

Five players started Sunday at -4: Rahm, Aberg, Rai, Taylor, and Schmid. The model ranked them 5th, 16th, 41st, 46th, and 59th respectively. The actual winner came from that group ranked 41st. The model had Aberg as the best of the cluster. Rahm finished T2. Rai won. Schmid finished T4. Taylor faded.

The model correctly identified that the -4 group contained real contenders. What it couldn't do was sort them. Aaron Rai's prior is -0.127 — slightly negative, nothing alarming. His eight-event form residual was essentially zero (+0.04). Nothing in his model inputs said "this is the player who shoots 65 on Sunday and makes a 70-foot birdie putt at 17." The model had no mechanism to see that, and there is no version of the current inputs that would have.

This is a different problem than the prior anchor problem. Reitan at 97th was a known flaw — a player with 13 events of history getting buried by stale early-career data. The fix is a prior that decays toward recent form over time. Rai at 41st isn't that. He had 121 events of history. The prior was working correctly. The model just couldn't differentiate between five players who all had reasonable résumés and the same 54-hole score.

Within-tier discrimination is now on the Shinnecock roadmap alongside prior decay.

## What happened to the sure things

The model's most confident call entering Sunday was Scheffler at +2.003 predicted strokes gained — the highest number in the entire R4 projection. He shot 69 and finished T11, seven strokes back. McIlroy was #2 at +1.377, driven almost entirely by a skill prior of +1.682, the highest in the field. He finished at -4, which is exactly what "regression to the mean" looks like in practice — big round up in R2, big round up in R3, modest R4, finished in the top 10. The prior kept him from disappearing. It didn't make him a contender.

The lesson isn't that priors don't work. It's that priors produce floors, not ceilings. McIlroy played like his historical baseline over 72 holes — respectable, not transformative. Scheffler had a week where the baseline wasn't good enough and the form signal (-1 in R3) was warning the model something was off. The model dismissed it.

## The form signals that didn't convert

Cameron Young entered Sunday ranked 11th with the highest form residual of any player with real sample size — +2.115 over 109 events. He finished T31 at even par. The form signal was genuine. The week-long result wasn't. That's the honest counterweight to Smalley: the signal can be real without the outcome following through, and a single tournament is a small sample regardless of what the model says going in.

## Three problems, not two

Going into Aronimink the Shinnecock roadmap had two items: prior decay as a function of recency and events played, and continued tracking of the short-history prior-penalty cases.

Sunday added a third: within-tier discrimination. When five players start a final round tied and one of them shoots 65 to win a major, the model needs some mechanism to sort that cluster. What that mechanism looks like — course-fit features, round-specific form weighting, something else entirely — is an open question. But the question is now on the board.

The model found Smalley. It found Aberg. It had no idea about Aaron Rai. At Shinnecock, all three of those things need to be true simultaneously.

---

*Boom/bust probabilities and predicted strokes-gained values derived from the Merrittocracy golf model. Skill prior anchored to 2025 year-end DataGolf values. Course-specific fit not modeled. Full methodology on the roadmap for the U.S. Open at Shinnecock Hills.*
