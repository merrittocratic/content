# F*** Them Picks

Les Snead made that phrase famous in Los Angeles. For a decade, the Rams' GM was allergic to draft capital, trading picks, flipping futures, mortgaging tomorrows to chase the ring that finally arrived in 2022. His philosophy was simple: if you have the players to win now, draft picks are just chips on the table. F*** them picks.

Thursday night in Pittsburgh, Snead did something that violated the whole premise. With the 13th overall pick, the Rams selected Ty Simpson.  Snead's old line was about not hoarding capital when you're good enough to win. Taking Ty Simpson at 13 is something different, it's spending premium capital on a projection pick for a team with Matthew Stafford, a closing window, and a roster built to compete now. 

We wrote an entire article last week explaining why Simpson's production profile doesn't survive contact with the data. The short version: since 2010, four quarterbacks were drafted in the first round with fewer than 15 career starts. The only one who worked was Cam Newton, who accounted for 4,330 yards of total offense and 51 touchdowns while winning the Heisman and a national title. Simpson accounted for 3,700 yards of offense and 30 total touchdowns on a team that got bounced in the first round of the playoffs. These are not comps.

Here's where it gets complicated: our model actually likes Ty Simpson.

Predicted z-score: **+0.30**. Every major driver is positive, TD percentage percentile, a low interception rate that ranks in the top 12%, the Rams' organizational residual mean. The player-level production signals the model keys on are genuine. And the Rams, whatever you think of the strategic logic, are one of the few organizations where the development environment doesn't actively hurt the projection.

So what's the verdict? The model and the narrative disagree, and the honest version is this: *Simpson the player may be fine. Simpson the pick, on this roster, at this cost, is still hard to defend.* If Stafford gets hurt and Simpson has to play meaningful snaps in Year 1, nobody will care that the model liked his TD rate. But if Stafford plays out his contract and Simpson develops in the background, this could look shrewd in 2028. The Rams may be the only organization in the league with the roster depth to make this bet without it costing them a season.

The real lesson from Simpson isn't about the player. It's about the first thing our model taught us this offseason: **where you land matters as much as who you are.**

---

## The Jets Organizational Tax

The New York Jets ended Thursday night with three first-round picks and real optimism for the first time in years.  We've got some concerns, and they all trace back to the same source.  Say it with me New York, J-E-T-S!  It's gonna get real Game of Thrones around here.

**Kenyon Sadiq, TE, Oregon (Pick 16):** Before last night, our WR/TE model scored Sadiq at **+0.169**, a legitimate positive, one of the cleaner tight end profiles in a class where the position has real first-round value. We liked him so much, he was a focal point of an article.  He's young, his rushing production percentiles are elite for the position, and the pre-draft projection was genuinely encouraging.

Then the J-E-T-S happened. The post-draft projection: **-0.08**.

The entire swing, a quarter of a standard deviation, is explained by one feature: the Jets' two-year player retention rate, which sits at 0.161 in our training data. Low retention means players leave or get cut before the development window closes. It means the organization hasn't historically turned first-round investments at the position into the outcomes the capital should buy. The model doesn't hate Sadiq. It hates where he landed.

**Omar Cooper Jr., WR, Indiana (Pick 30):** Same story, same tax. Cooper was widely mocked in the upper half of Round 1, slipped to 30, and the Jets traded back into the first round to get him. His predicted z: **-0.11**. The dominant negative driver? *team_all_retention_2yr = 0.161*. The exact same value as Sadiq.

Two picks. Two players with legitimate profiles. The same organizational feature dragging both projections underwater. The Jets are going to have to develop their way out of a track record the model has priced in.  To be clear: both players can outperform their projections. The model isn't destiny. But for a franchise trying to break a **significant** playoff drought, spending three first-round picks while carrying a development discount on two of them is not how you want to start the night's scorecard.

The exception is David Bailey at No. 2, our front seven piece made the organizational case for taking a conventional edge rusher over a chess-piece hybrid, and that logic holds. Bailey's model output (-0.42 predicted z) comes with its own concern: a 95th percentile sack rate paired with a 43rd percentile overall defensive production score, the same pattern we've documented in pass rushers who don't translate.  Hello, Chase Young!  But at No. 2, the Jets' track record with conventional edge defenders grades better than their track record with hybrid linebackers. The Simmons template is institutional memory. Bailey avoids it.

---

## Where a Zero Is Actually a Story

The two quietest picks of the first round — and the two that concern the model most as organizational statements — belong to the Steelers and the Texans.

**Max Iheanachor, OT, Pittsburgh (Pick 21):** Predicted z: **-0.01**. Essentially flat. The model isn't worried about Iheanachor the player. It's worried about one feature that dominates his waterfall above everything else: *team_pos_boom_rate = 0*.

The Pittsburgh Steelers have never produced a first-round offensive tackle boom in our training window. Not once. The model has seen 15 years of Steelers OL first-rounders and the boom column is empty. The consensus take frames this as a depth and development pick — parked behind Broderick Jones and Troy Fautanu, no pressure, long runway. That framing is generous. An organization with a 0% first-round OL boom rate isn't a patient developer. It's an organization that has spent first-round capital at the position and consistently not produced the outcomes that capital should buy.

**Keylan Rutledge, IOL, Houston (Pick 26):** Predicted z: **-0.01**. Same feature, same value: *team_pos_boom_rate = 0*. The Texans have also never produced a first-round Interior OL boom in the training window.

Two interior offensive linemen. Two organizations with zero OL boom production in 15 years of first-round data. Both players are individually neutral. Both picks have an organizational ceiling problem baked into them before the players touch an NFL field.

Rutledge generated genuine buzz at the Senior Bowl. His one-on-one reps were impressive and evaluators loved his quickness for the position. The model isn't saying he can't be good. It's saying the Texans, historically, haven't been the place where "good at the Senior Bowl" turns into "first-round ROI."

---

## "Jerry, if you find a suit that fits, you buy it! .....  You don't look for flaws! (G. Costanza)"

Dallas entered Thursday with a defined strategy, trade up if a target falls, trade down if the board goes sideways, and they managed to execute both, while confusing everyone.

Trading up from 12 to 11 to grab Caleb Downs was correct. Downs was the consensus best player on the board at his position, Ohio State's safety pipeline is legitimate, and the Cowboys' secondary needed a genuine playmaker. Good pick.  Better price.

Then at 23, the Cowboys took UCF edge rusher Malachi Lawrence. Predicted z: **-0.38** — the most concerning model output among any of the picks we've covered. This all seems so familiar...  45th percentile overall defensive production, 92nd percentile sacks. We documented this pattern in our front seven piece and we saw it again in David Bailey's waterfall. Elite sack production without broader defensive impact is a known translation risk. The gap between what Lawrence does against college tackles in favorable downs and what he'll be asked to do on third-and-7 in the NFL is real.

A new wrinkle, the Cowboys actually tend to nail their drafts! Their *team_all_boom_rate* of 0.316 is one of the higher values in the league.  In this case though, it is actually pulling Lawrence's prediction *down*, not up. High boom rate organizations have developed well across positions, and Lawrence's profile isn't matching the Cowboys' historical production pattern. So this pick is going outside of the norm for what their development environment has historically turned into outcomes.

To make matters worse, the Cowboys facilitated a trade with the Eagles that let Philadelphia move from 23 to 20 and take Makai Lemon. So, the Eagles got a Biletnikoff Award winner. The Cowboys got Lawrence. One of those transactions is going to sting in NFC East games for years.

---

## I want Winners!

### New York Giants

John Harbaugh entered Pittsburgh with two top-10 picks and a mandate to rebuild. He left having executed the clearest strategy of anyone in the first round.

At No. 5, Arvell Reese had slipped from where most projections had him, legitimate top-3 value, and the Giants took him without overthinking it. Does anyone remember the pass rushing talent that beat the undefeated Patriots in Super Bowl XLII?  History is starting to rhyme again.  At No. 10, the pick acquired in the Dexter Lawrence trade with Cincinnati, they added Miami offensive tackle Francis Mauigoa. A high-upside edge defender and a starting-caliber tackle, both at value, both in the first round. Our model's chess-piece caution on Reese is real, the deployment risk matters and Harbaugh's track record developing defined defensive roles is the primary argument it resolves positively. But as draft nights go, the Giants didn't beat themselves. That alone puts them near the top of the evening.

### Cleveland Browns

Yes Cleveland!  The Browns traded down from No. 6 to No. 9 (collecting a third and fifth from Kansas City in the process), landed Spencer Fano, the cleanest OL prospect in the class by multiple evaluations, and then used the Jacksonville pick at No. 24 to add Texas A&M's KC Concepcion at receiver. Two first-round players at genuine value, one of them funded by prior trade capital. They let the board come to them and pocketed surplus along the way.  Are the Browns geniuses, or are they morons who stumbled into the right answer.  Time will tell.

### Tampa Bay Buccaneers

Rueben Bain Jr. at 15 is the most defensible pass rusher pick in the round. Conventional deployment, clear role, no chess-piece ambiguity. The EDGE bust rate in Round 1 is the highest of any front-seven position, we documented it, but Pick 15 for Bain is better than pick 7 or 8.  Last year's NFC South Champion, the Panthers, are about to be asked: "Do you feel in charge?"  

---

## The Bottom Line

The consensus take on Round 1 of 2026 is that it was weird, unpredictable, philosophy-driven, and hard to grade in isolation. That's true. But the model offers a lens the discourse mostly missed: the destination shapes the projection as much as the player.

Sadiq is good. The Jets' development environment is the variable. Iheanachor and Rutledge may be fine players, but they're going to organizations that have never turned their position into first-round returns. Simpson's player-level profile is stronger than his narrative suggested, and the Rams may be one of the few places that can make the math work on a developmental quarterback pick.

The draft doesn't just select players. It assigns them to development environments with documented track records. Some of those environments amplify talent. Some of them discount it before the player has attended his first practice.

Thursday night's biggest winners understood that. The ones who will regret it didn't.

---

*Boom/bust probabilities and predicted z-scores derived from the Merrittocracy model, trained on 2006–2020 NFL draft classes using pick-adjusted 4-year Career Approximate Value. Organizational pipeline features computed using a rolling 10-year window with leave-one-out methodology. Data via Pro Football Reference. Full methodology at [github.com/merrittocratic/nfl-draft-model](https://github.com/merrittocratic/nfl-draft-model).*
