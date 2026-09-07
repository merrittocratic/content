# Public Math

Before Boxscore Prophet starts grading itself in public, we wanted to explain what "grading" means, and why the number should be trusted at all.  Every Tuesday after the season kicks off, we'll give you a number: the chance a running back, receiver, quarterback, or tight end gives you a startable week, and a smaller chance he goes full boom. Then the games happen, and a few days later we check. Not "I liked that pick" type of checking. Not vibes. The stated probability, against the box score that actually occurred.

That's the whole model, 60% of the time, it works every time.  Wait, that's not right. What I meant was if we say a probability for a player to start reaches 60%, it needs to happen close to 60% of the time, or the number is not worth publishing. The Week 1 board goes live Tuesday. The first live grading column runs two Tuesdays after that. Before either one, here's the ruler.

## The Receipts

We ran the backtest the honest way: every probability the model would have published from 2016 through 2025, compared against what actually happened, using only what was knowable the Friday before kickoff. Two numbers per player per week, a startable line (15 PPR points for a back or receiver, 20 for a quarterback, 12 for a tight end) and a boom line (20/25/17, same order). 71,228 player-weeks, pooled across all four positions and both thresholds.

When you take the average of each combined position and probability bin (start or boom), the model and reality are barely distinguishable:



The worst combination in the whole table is start probability for Tight Ends, off by three-quarters of a point. That's the honesty number for the entire operation, and it's a good one.

## The Law of Averages

The problem is averages forgive a lot. When you start slicing those same probabilities into ten-point buckets instead, like everything we ever called "40-50%" grouped together, and the worst bucket misses by 8.46 percentage points. A single bucket, a single week, a single player can get noisy even when the whole system is honest on average. 

That looks complicated! Don't worry, I'll explain it.  The graphic above is every one of those probability buckets, plotted two ways at once. Each dot is one confidence group, meaning every time the model ever said something like "30 to 40 percent," win or lose, it lands in that same dot. How far off the dot sits from the zero line is how wrong that group actually was, on average. How far right the dot sits is how many chances are behind it, and the buckets are spread far apart on purpose, because the biggest one (22,136) and the smallest one (120) aren't remotely close in size, and they shouldn't look close on the page.

Going from left to right and nearly every dot sits close to zero, with a tight little line through it, with lots of chances behind those numbers, not much room for them to be lying.  Then there's the one in red, off to the left, sitting more than 8 points low. That looks like the worst number on the page, and if you stopped there, it would be. But look at the line running through it: it stretches almost back up to zero. Only 120 chances sit behind that dot, which is the thinnest group by far, and short of the floor this piece is about to set. The true number could be a real miss. It could also be nothing. 120 chances isn't enough to know which, and that's not a number worth reporting as fact.

The 8-point miss in one bucket doesn't automatically become next Tuesday's headline. Before a gap gets called a real finding instead of noise, it has to clear two bars at once: at least 4 percentage points off, on a sample of at least 400 player-weeks. Short on either one and it gets flagged and tracked, but not reported as a conclusion.

That's not a bar being introduced for the first time here. We mentioned it in our last article when we talked about the experiments that missed. Five things that cleared the 4-point line and missed the 400-week floor: a windy-game receiver effect, a first-round rookie running back beating his number, and three others that looked like stories and weren't. All five got parked until we can build enough sample to feel confident in the result.  

## Starting In Two Weeks

Every number in this post is the ruler everything else gets measured against. The Week 1 *Movers* board goes live Tuesday, nothing to grade yet. Two Tuesdays after that, the first *On the Record* column runs: last week's published numbers, next to what actually happened, flattering or not. Now you know exactly what "flattering or not" means when we say it.

---

*Method: every probability the model would have published, 2016-2025, walk-forward validated against Friday-lock-only information, checked against actual box scores. 71,228 player-weeks across RB/WR/QB/TE and both thresholds. Data via nflverse/nflreadr. Full backtest and code at [github.com/merrittocratic/boxscore-prophet](https://github.com/merrittocratic/boxscore-prophet).*
