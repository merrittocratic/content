# Donald Ross might have won Friday

---

What is it about guys named Donald?  When they're in the headlines, the results can be.... complicated.

I'm willing to bet most of you did not have Maverick McNealy and Alex Smalley leading the PGA Championship.  

The pre-tournament narrative at Aronimink ran roughly as follows: Scottie Scheffler might finally play Scheffler golf this season, Rory McIlroy would either get to work on Grand Slam number 2 or fizzle due to pre-tournament rust.  The rest of the field would sort itself into a collection of certified elite players, players with elite form, or guys elated to make the weekend. A Donald Ross course and some diabolical Friday pin placements had other plans.  Scottie described the course set-up as the hardest he's ever faced anywhere on Tour, and the 73.1 scoring-average reality check handed the halfway lead to two guys the consensus had largely ignored.

---

## You win some, you lose some

Before Thursday, we flagged two names: **Ludvig Aberg** (form mean +1.34, steepest positive slope in the field) and **Tyrrell Hatton** (form mean +1.47, 129 events of history). The case for both was genuine hot-hand signal going into a major that punishes everyone who doesn't earn it.

One of them is in contention. One of them is watching the weekend, surprisingly with a full bag of unbroken clubs.

**Hatton missed the cut.** The preview noted that his career prior was slightly negative (-0.18), meaning the entire model case for him was form-driven, a player running meaningfully above his historical baseline at exactly the right time. When Aronimink got brutal on Friday, the prior reasserted itself. So, maybe next time, we won't feature a known hot-headed Englishman to outperform his prior ahead of a tournament when the course set-up was going to be challenging.

**Aberg**, on the other hand, has been one of the best ball-strikers in the field through 36 holes. His round-two strokes-gained number (6.61 relative to the field) is among the highest of the week. On a day the field averaged more than three over par, he was deep in the red. The model still has him 17th heading into Moving Day.

It should be noted that these rankings reflect what the model expects from each player in Round 3 specifically, not where they'll finish on Sunday. The model predicts each player's strokes gained for the next round; the leaderboard is simply those predictions sorted. A player ranked #1 here is projected to gain the most strokes against the field average in Round 3, full stop. Where the player will finish on Sunday is a separate question that requires cumulating those per-round predictions across all four rounds, something we're building toward for the U.S. Open.

One of the best 36-hole performances in the field, ranked 17th by the model, is not a bug. It's the prior anchor problem we wrote about before Thursday, now visible in real numbers. Aberg has 66 events of history. His career baseline is still developing, and it's slightly negative. The model sees what he's doing this week and applies heavy regression to the mean anyway. On some level it's correct, career baselines don't evaporate in two rounds. On another level it's watching a player shoot himself into contention and filing it under "probably an outlier."

Resolving all of this is exactly what's going into the Shinnecock roadmap.  

---

## Some other players worth talking about

Yes, we have to talk about **Rory**.  He went four over par on Thursday, and started Friday on the cut line. The model kept him at number two in the projected rankings because his career skill prior (1.682, highest in the field) said the Thursday round was an outlier, not a trend.

He shot 67 on Friday.  Regression to the mean is a two-way street.  

**Chris Gotterup** shot a 65 on Friday. That's the lowest round of the tournament. He's tied for third. The model has him 28th.

Gotterup's prior is slightly negative (-0.124), his form is solid but not elite, and the model looked at one of the best rounds of the week and shrugged. He's not a player the model is rooting against. It just doesn't know what to make of him yet, and when models don't know what to make of someone, they push them toward the middle.

**Alex Smalley** is a different story. He didn't have Aberg's name recognition as someone building towards a victory or McIlroy's elite prior keeping him afloat when his form was not its best. Instead, he came into the week with a skill baseline of 0.30 — real, but modest — and a recent 8-event form number that was quietly positive. Neither input was loud, but together, they were enough for the model to slot him 13th heading into the weekend. He went out Thursday and posted 5.26 strokes gained and then backed it up again on Friday with a 3.61.  The model didn't see a star coming. It saw two inputs pointing the same direction on a player with a clean ball-striking profile, and ranked him accordingly. It's not a prediction of an eventual winner, but it's a signal the model found that most didn't bother to read. 

[Insert Graphic Here]

---

## Saturday....Saturday..Satur--day...Saturday

The cut line settled at three over par. McNealy and Smalley lead at four under, with six players within a stroke. Fifty-eight players are within six of the lead, reportedly the most in PGA Championship history at the halfway point. Scheffler, Young, Thomas, and Aberg are two back. McIlroy is five back but alive.

Aronimink is a par 70 with no bailout holes. Donald Ross didn't believe in par fives, and he really didn't believe in letting anyone off the hook. Whatever Moving Day produces, the course will have a vote.

The model will be watching. So will I.

---

*Model output based on rolling 8-event strokes-gained residuals. Skill prior anchored to 2025 year-end DataGolf values. Course-specific fit not modeled. Tournament wrap-up Sunday evening.*
