# LinkedIn Series 4/5: Golf Model Post-Mortem

Status: draft, ready to paste
Source: draft/golf_model_evolution.md ("Three Tournaments, One Model, Lots of Questions")

---

This is the one where I grade my one of my models in public.

Two tournaments this summer, same golf model. At the US Open, the players it liked filled the top of the leaderboard, and the top-10 Brier skill came in at +10.2%. At the RBC Canadian Open the week prior, that number was +0.3%. Same code, same features, effectively a coin flip.

The failure had a name and it's a name that kept popping up throughout the model iteration process.  Kristoffer Reitan arrived at Aronimink for the PGA Championship with the hottest recent form in the field and a career baseline the model didn't trust. Our model averaged the two, the prior baseline had the larger impact, and he ended up contending from a 97th-place projection. At the RBC, the whole top ten looked like Reitan: hot, low-prior players at a birdie-fest where the gap between the field's 20th-best and 60th-best player narrows to almost nothing. The model applied major-championship confidence to a shootout.

Under the hood, the model is skill priors built on DataGolf data with a live stacking layer that re-scores the leaderboard after every round. Rewriting that live layer because the random effects were adding noise resulted in one number at Shinnecock: Wyndham Clark's win probability moving from 2.6% to 33.4% after one round.

The practitioner takeaway: the signal was real at both events, but the confidence wasn't "event-aware". The next build adds what's essentially a regime feature, so the model knows a major from a birdie-fest before it assigns probabilities. And the post-mortem pipeline that caught all of this is the part I'd tell anyone building prediction systems to write first. Grading yourself is a feature.

If you like this content, please consider following me on substack.  It's free to subscribe, and you'll get weekly long form articles on sports analytics, and maybe a few strong vibe opinions on occasion.

https://themerrittocracy.substack.com

x.com/Merrittocratic
https://themerrittocracy.substack.com/p/three-tournaments-one-model-lots
