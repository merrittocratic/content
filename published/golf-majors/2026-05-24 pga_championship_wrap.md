# The Struggle was Real

---

I've struggled to put a bow on the PGA for the past two days.  My model's two highest-confidence picks to lead the field in strokes gained going into Sunday were Scottie Scheffler and Rory McIlroy. Both shot 69s and Scheffler finished T14 at -2. McIlroy finished T7 at -4. The winner, +17500 longshot who the model ranked 41st. 

That's the honest version of Sunday at Aronimink, and it deserves an honest accounting. 

## He didn't come up Small

Alex Smalley came into the week with two modestly positive inputs: a skill prior of +0.304, and an eight-event form residual of +0.815. Nothing loud. Nothing that was going to show up in the broadcast preview or a betting rundown. 

He entered Sunday as co-leader at -6 and finished T2. He double-bogeyed the 6th, bogeyed the 8th, spotted the field three shots in eight holes, and still walked off Aronimink with a top-two finish at a major championship. The broadcast framing will write itself around the Sunday collapse that wasn't. The actual story is that the model was pointing at this player before the leaderboard was, with the quietest legitimate inputs of anyone in the top 20, and he actually validated it when it counted.

That's not a small thing. The model found Alex Smalley at a major. His T2 finish earned him an invitation to the 2027 Masters, the kind of downstream consequence that doesn't show up in a model output but makes the signal feel very real in retrospect.

## Bueller, Bueller - Rai, Rai

I don't know if voodoo economics could have figured this one out.  

Five players started Sunday at -4: Rahm, Aberg, Rai, Taylor, and Schmid. The model ranked them 5th, 16th, 41st, 46th, and 59th respectively. Paulie to told Rocky to "hit the one in the middle", and if you did that with this list, you would have won some money. Rai at 41st won. The model had Rahm as the best of the cluster, and he finished T2. Schmid and Aberg finished T4. Taylor faded.

The model correctly identified that the -4 group contained real contenders. What it couldn't do was sort them. Aaron Rai's prior was -0.127 — slightly negative, nothing alarming. His eight-event form residual was essentially zero (+0.04). Nothing in his model inputs said "this is the player who shoots 65 on Sunday, including 6-under from #9 on, and also makes a 70-foot birdie putt at 17." Make no mistake, Rai won this tournament, and no one really lost it.  

The only signal that we could possibly create for Shinnecock to better capture this is looking at course architects and design for fit.  A lot was made of the fact that Rai's only PGA tour win was on a Donald Ross course.  Course fit keeps coming up, so it's definitely on the Shinnecock roadmap.

## You gotta play the hits

The model's most confident call entering Sunday was Scheffler at +2.003 predicted strokes gained — the highest number in the entire R4 projection. He shot 69 and finished T14, seven strokes back. McIlroy was #2 at +1.377, driven almost entirely by a skill prior of +1.682, the highest in the field. He finished at -4, which is exactly what "regression to the mean" looks like in practice — big round up in R2, big round up in R3, modest R4, finished in the top 10. The prior kept him from disappearing. It didn't make him a contender.

The lesson isn't that priors don't work. It's that priors really produce floors, not ceilings. McIlroy played like his historical baseline over 72 holes, but when you're constantly driving it into the rough, and putting for birdie from 30 feet, it's hard to seal the deal. Scheffler had a week where the baseline wasn't good enough and the form signal (-1 in R3) was warning the model something was off with his game, but the model over-indexed on the idea that he would rebound.

## Mo' Models, Mo' Problems

Going into Aronimink, the Shinnecock roadmap had two items: prior decay as a function of recency and events played, and continued tracking of the short-history prior-penalty cases. In English, that's weighting the recent events over previous year's results, particulary, when a member is new to the tour.  Maybe next time, you just lead with that....

Sunday added a third: within-tier discrimination. When five players start a final round tied and one of them shoots 65 to win a major, the model needs some way to sort that cluster. What that looks like — course-fit features, round-specific form weighting, something else entirely — is an open question. But the question is now on the board.

The model found Smalley. It found Aberg. It had no idea about Aaron Rai. At Shinnecock, all three of those things need to be true simultaneously.

---

*Predicted strokes-gained values derived from the Merrittocracy golf model. Skill prior anchored to 2025 year-end DataGolf values. Course-specific fit not modeled. Full methodology on the roadmap for the U.S. Open at Shinnecock Hills.*
