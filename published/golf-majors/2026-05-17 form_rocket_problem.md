# You can't escape your past

---

Is my model any good?  Kristoffer Reitan is ranked 97th, and he just won Truist by two shots.

We're building a model specifically for the U.S. Open at Shinnecock Hills, but this miss deserves an honest accounting going into the PGA Championship at Aronimink. We're treating the PGA as dry run for Shinnecock, so course set up and other features won't be live for this tournament, but the features that caused this miss will have a say in that story too, so let's introduce them.

## I have a bad feeling about this Chewie

The reality is the model didn't miss Reitan's recent form. His form residual over the last eight events was +4.07, the highest number in the entire field. First by a wide margin. The model even predicted he'd massively outperform his historical baseline. The problem is his historical baseline is **terrible**. 

Reitan has 13 events of event history, and a lot of those early rounds were..... *rough*.  U.S. Open puns are already flowing.  His skill prior of -3.965 is catastrophically negative. When you add +4.0 to -3.965, I can do this math, you get a predicted total of just over Flounder's GPA of 0.0.  Funny how that Flounder guy keeps coming up.  This is how a player the model sees as coming into the tournament in great form ends up ranked 97th. That's a **big** *albatross* to hang on someone's neck.  I'll be here all week.

The model is actually working, but some of the inputs are problematic. A short-term fix would be a post-prediction adjustment that would discount the prior slightly in favor of recent form.  With a slight tweak, I can move Reitan from 97th to 25th, which feels realistic.  The more principled solution is a prior that decays gracefully toward recent results as a function of recency and events played. Not going to happen by Thursday, but it's on the roadmap for Shinnecock.   

## The Young and the Restless

Before we get to the PGA, it's also worth pointing out what happened to Cameron Young on Sunday. The model had him as the hottest player by form among anyone with real a sample size.  108 events of history, with a form mean of +1.97 on a positive and accelerating trend. He finished T10 at -9, which included a rough Sunday score of +3.

T10 at a $20 million signature event is not a miss. But the clean "hottest form wins" story didn't hold up over 72 holes, and glossing over that to protect the narrative would be the exact thing this brand exists to call out when other people do it. The form signal was real. The result was complicated. Both things are true.

## Some names to look out for at the PGA

For the players the model can actually evaluate with some confidence:

**Ludvig Aberg** is the cleanest case. Sixty-five events of history, so the prior is real if still developing. Form mean of +1.34, and the steepest positive slope in the legitimate-sample portion of the full field. He's not just playing well; he's still improving week over week. The market is offering him somewhere around +2000, which is where players land when the ball-striking is undeniable but the wins haven't come. Four top-five finishes in five events is not a coincidence.

**Tyrrell Hatton** is the name that doesn't get enough airtime in this conversation. One hundred twenty-nine events of history, form mean of +1.47, positive slope of +0.38. The prior is slightly negative (-0.18), meaning his historical baseline is fractionally below the field mean, he's not a career elite, but he's playing well above himself right now. The combination of real sample size and genuine hot-hand signal is exactly what you want to see.

The upper right quadrant below shows who's hot and getting hotter....



---

## Not quite ready for Vegas

Don't take all of this to Polymarket **yet**.  The model doesn't know what Aronimink looks like and how it will play.  Also, we don't know when Scheffler will put together 4-full rounds of Scottie Scheffler golf and blow away the field.  Course fit is on the roadmap, but not there yet.

What the model can say: Aberg and Hatton are carrying genuine form into Thursday. The Reitan caveat stands too. The model missed him once. It might miss him again.

---

*Model output based on rolling 8-event strokes gained residuals. Skill prior anchored to 2025 year-end DataGolf values — in-season improvement not yet captured. Course-specific fit not modeled.*