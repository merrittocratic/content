# Did Ya Get That Memo?

---

Have you ever been a week out from a a product launch or presentation, and come to the realization that this could go *horribly* wrong.  Well, that happened to me earlier this week when the model I've been working on for months thought Odell Beckham Jr. was a top-30 fantasy receiver for Week 1. That might have been fine in 2016, but in 2026 after he hasn't played an NFL snap in over a year, that's not the result I was looking for.

Sometimes when building these projects, the automation and architecture around the model seem WAAaayyy more important than the actual model itself.  But a model that consistently surfaces guys like Odell Beckham Jr. as a prediction in a new and innovative way is still consistently terrible.

Can't sugarcoat it, but that is what the real Week 1 board said earlier this week, before it was caught. I bring this up not because it's funny, even though it kind of is, but because the whole point of this operation is that you get to see the math, not just the polished output.

## Just When I Thought You Couldn't Be Any Dumber, You Go And Do This...

Here's the **why** behind this gaffe. At the start of a season, the model's rolling in-game stats: targets, snaps, and dropbacks are blank.  These might otherwise be known as the stuff that tells the model how much a guy is actually playing right now, so they're kind of important.  *Almost* nobody has real 2026 snaps yet.  I'll say a little more on that later.  In this case, the model leans on last year's role and, when that's also missing, a fallback is tied to draft pedigree. Reasonable most of the time. It breaks the moment a player's actual situation has nothing to do with either number.

Malik Willis is another clean example of this problem. He signed with Miami months ago and has been the starting quarterback the entire time, an official depth-chart fact, not a rumor. The model didn't know that. His own trailing stats are backup-tier, because he's spent most of his career in that role, so that's what the fallback gave him: QB79 out of roughly 90 quarterbacks on the board, buried below players who aren't even active this week. Deshaun Watson, back from a long injury layoff with the same blank trailing data, had the identical problem.  You can't have two starting QBs on Week 1 ranked behind Mason Rudolph, no matter how good of a backup he is.

Beckham is the mirror image, and honestly the funnier one. He's been out of the league for over a year, which means the model has no recent stats to lean on either, so it fell back to his draft pedigree from a decade ago, a number built for a rookie, not a guy who hasn't been on a roster. That's how a player currently oscillating between WR3 and WR4 on the Giants became our 28th-ranked wide receiver.

## ...And Totally Redeem Yourself!

We built a fix that checks the actual, current, official depth chart.  Not last year's stats, not draft slot, the real team depth chart, updated in the current week. A confirmed starter with no usable trailing data gets bumped up to what a real, established starter at his position typically looks like. A confirmed backup who's just coasting on old stats gets capped back down. Willis went from 79th to 27th. Watson to 29th. Beckham dropped from 28th to 125th, which is roughly where a receiver with zero routes run in over a year should sit.

We did the same audit for running backs, receivers, and tight ends, because there was no reason to assume the bug was quarterback-specific. It mostly wasn't there to find since an earlier fix (the one we wrote about with Jeremiyah Love a few weeks back) already covers most of that ground for the other three positions. But receivers and tight ends had a smaller version of the same problem, and we found real cases: a receiver who took over a starting job through a trade the model's own numbers couldn't see, a tight end now catching passes on a team that isn't the one his old stats are attached to. Same root cause, smaller scale, fixed the same way.

We also run a separate system now for real-world update: live beat-reporter news, read and turned into a small, capped nudge to a player's number, never a full swing. It's the right idea, and most weeks it's plenty. But the cap is deliberately conservative, a few percentage points, not a full re-ranking, so it was never going to be the thing that pulls a real starter up from the bottom of a 90-man board.  So, the two fixes work in tandem to create an overall better output.

## If Loving You Is Wrong, I Don't Want To Be Right

Here are some players where our model differed from the Expert Consensus Ranking (ECR), along with an early win.  ECR is down on Caleb Douglas and Kayshon Boutte, but the model thinks they could have decent weeks.  Boutte appears to be WR2 on the Texans, and C.J. Stroud loves to go deep.  Boutte's 16.7 yards per reception should pair nicely with Nico in Houston.  Caleb Douglas is more on the side of, "Malik Willis has to throw it to someone in Miami, why not Caleb?"  One early win for the model vs. ECR was Deebo Samuel.  The model liked him, and he rewarded it with a better than **"startable"** week, accumulating 48 receiving yards, a TD, and 12 yards rushing.  

The model is colder on Tyler Warren and Terry McLaurin than ECR.  Is Jayden Daniels the rookie breakout star or the brittle rollercoaster from last year?  He has to try to prove the latter against a completely revamped Cowboys defense that could make noise in the NFC East.  Tyler Warren is catching passes from a Daniel Jones coming off Achilles surgery, and this week he faces a Baltimore defense that's expected to be very stout.  Jesse Minter's Chargers defenses **struggled** against TEs last year, but the Chargers didn't have Kyle Hamilton, so I'm guessing that gets cleaned up a a bit. 

## Fixing The Unknown Knowns

None of this is us claiming we found some hidden edge. Time will tell on that, and maybe if our predictions start panning out a little better, we can put them behind a paywall.  For now, it's about finding real Odell-sized bugs, fixing them quickly and keeping the content flowing.  *No one* is gonna pay for a fantasy prediction that says Malik Willis will score the 79th most fantasy points for QBs this week, and I'm quite sure there are other Malik's lurking in the data that I need to correct. 

---

*Method: caught during the real Week 1 production run, verified against the official NFL depth chart (nflverse) and the deployed model directly, not estimated. Full technical writeup, including the two wrong fixes we tried before landing on this one, at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
