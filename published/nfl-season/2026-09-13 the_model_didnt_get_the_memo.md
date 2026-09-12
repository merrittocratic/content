# The Model Didn't Get The Memo

---

For about six hours this week, the model thought Odell Beckham Jr. was a top-30 fantasy receiver. He hasn't played an NFL snap in over a year.

That's not a joke, and it's not a hypothetical. It's what the real Week 1 board actually said, before we caught it. We're telling you now instead of quietly fixing it and moving on, because the whole point of this operation is that you get to see the math, not just the polished output.

## Nobody Told The Model

Here's the mechanic. At the start of a season, the model's rolling in-game stats -- targets, snaps, dropbacks, the stuff that tells it how much a guy is actually playing right now -- are blank. Nobody has real 2026 snaps yet. So the model leans on last year's role and, when that's also missing, a fallback tied to draft pedigree. Reasonable most of the time. It breaks the moment a player's actual situation has nothing to do with either number.

Malik Willis is the clean example. He signed with Miami months ago and has been the starting quarterback the entire time -- an official depth-chart fact, not a rumor. The model didn't know that. His own trailing stats are backup-tier, because he's spent most of his career as a backup, so that's what the fallback gave him: QB79 out of roughly 90 quarterbacks on the board, buried below players who aren't even active this week. Deshaun Watson, back from a long injury layoff with the same blank trailing data, had the identical problem.

Beckham is the mirror image, and honestly the funnier one. He's been out of the league for over a year, which means the model has no recent stats to lean on either -- so it fell back to his draft pedigree from a decade ago, a number built for a rookie, not a guy who hasn't been on a roster. That's how a player currently not employed by an NFL team became our 28th-ranked wide receiver.

## Fixing One Side Without Breaking The Other

We built a fix that checks the actual, current, official depth chart -- not last year's stats, not draft slot, the real one, updated this week -- and corrects both directions at once. A confirmed starter with no usable trailing data gets bumped up to what a real, established starter at his position typically looks like. A confirmed backup who's just coasting on old stats gets capped back down. Willis went from 79th to 27th. Watson to 29th. Beckham dropped from 28th to 125th, which is roughly where a receiver with zero routes run in over a year should sit.

We did the same audit for running backs, receivers, and tight ends, because there was no reason to assume the bug was quarterback-specific. It mostly wasn't there to find -- an earlier fix (the one we wrote about with Jeremiyah Love a few weeks back) already covers most of that ground for the other three positions. But receivers and tight ends had a smaller version of the same problem, and we found real cases: a receiver who took over a starting job through a trade the model's own numbers couldn't see, a tight end now catching passes on a team that isn't the one his old stats are attached to. Same root cause, smaller scale, fixed the same way.

## What We Didn't Fix, Because We Couldn't

One case stayed broken on purpose, and we're not going to pretend otherwise. Charlie Kolar is this week's starting tight end for the Chargers, but he's the starter because of a new run-heavy scheme that wants him blocking, not because anyone thinks he's a big-target guy. Our fix correctly restored his playing time. It has no way to know *why* he's playing, and a run-blocking tight end and a receiving one who get the same number of snaps are not the same fantasy asset. That's not a threshold we can tune our way out of -- it's a signal the model doesn't have at all. So take Kolar's number with more salt than usual this week; we'll say so again if it doesn't correct itself once real routes get run.

None of this is us claiming we found some hidden edge. It's closer to the opposite -- these were real mistakes, not sophisticated ones, and catching them is basic hygiene, not a discovered signal. The actual question this project exists to answer, whether the model beats what you'd get for free from the crowd, is a separate, harder one, and we're not going to dress up a bug fix as evidence for it.

The corrected board is live now. On the Record starts grading real weeks starting next Tuesday.

---

*Method: caught during the real Week 1 production run, verified against the official NFL depth chart (nflverse) and the deployed model directly, not estimated. Full technical writeup, including the two wrong fixes we tried before landing on this one, at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
