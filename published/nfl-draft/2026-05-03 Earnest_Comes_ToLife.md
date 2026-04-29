# Earnest Goes to the Draft

---

I know, I know...  Not another super technical article.  I promise this will be the last one for awhile, and we can move onto the NBA playoffs, the Majors, and anything else fun that comes up.  But first, you gotta meet this guy!

## Hello World, Earnest

In the last article, we talked alot about how "*we*" built the model to predict boom/bust probabilities in the NFL Draft.  I deliberately used the word "*we*" alot in that article, and it's time I tell you why.  Meet Earnest!

[IMAGE: IMG_6168.PNG]

He is an AI automation agent, built on OpenClaw, running on the aforementioned Mac Mini in the corner.  He has one job, extend Merrittocracy's reach without replacing my voice.  "It's what he does, it's all he does."  Unlike the terminator though, he actually can be reasoned with.  Whether he's monitoring for new Substack articles, drafting X-posts in my voice, or surfacing reply opportunities, Earnest routes everything back to me through Telegram for approval before anything leaves the friendly confines of Merrittocracy. 

We actually go back and forth quite a bit, though he does think all of my ideas are brilliant, so I need to tune him to not be such a **yes** man.  The approval loop is the whole point. Earnest doesn't publish. He proposes. Every draft goes through Telegram, every post requires an explicit yes, every irreversible action has a "*human in the loop*".  He also files his own journal entries when something significant happens.  This would normally be great, but man, my ego is taking a beating seeing all of the mistakes I've made along the way.  

Earnest went live for the first time during draft week. Getting him there was its own project, with its own set of challenges to overcome.  He exists, he works, he has a soul, and he's a character in this story, not just a tool in the stack.

Wait, did you say soul?  Yes I did, and it's one of the cooler things about OpenClaw.  During the onboarding process, you develop a set of instructions that end up becoming the agent's "soul", and the file is called SOUL.md.  It's why he responds like this...



---

## So wait, is this all just AI?

In a word, NO!  I've always considered myself a better editor than initiator.  So, yes every draft article does start as a back and forth with either Earnest of Claude, by Antrhopic. But, that is not what lands in your inbox.  My writing process is *"unique"*.  I guess this is where my nerd takes over.  The draft that I create with AI drops into a content folder in a version control software system.  This system tracks every change I make with the draft, and it is posted online.  

What is displayed in the software is called the *diff* and the *diff* is the receipt. Anyone who wants to ask "is this just AI?" can go look at the answer on the version control site and look at my history of changes for each article. The gap between what AI produces and what I publish is where the editorial judgment lives, and that gap is the whole argument for why AI as a force multiplier works. It's not replacing my voice. It's handling the scaffolding so my voice can focus on what matters.

No AI would ever title an article *The Big Arch vs. The Mendoza Line* or *F*** Them Picks*.

---

## The Infrastructure That Didn't Survive First Contact

Actually, this entire section is not going to survive first contact.  Most people are already not forgiving me for the last two articles, so I'm not going to put you through it again.  If you're technically inclined and want to check out how all this came together from nerd point of view, you can find everything in the two sites below.  Everything is public.

* [github.com/merrittocratic/autopilot](https://github.com/merrittocratic/autopilot)
* [github.com/merrittocratic/OpenClaw-Ops](https://github.com/merrittocratic/OpenClaw-Ops)

Just in case you're wondering if AI is ready to rule the world, I can honestly say, we're not quite there yet.  If you didn't hear, Cooper Flagg won the NBA ROTY award, and I had written an article last week about how I felt he deserved it over Konn Knueppel.  The data supported it, which is kind of the point of Merrittocracy.  Earnest is supposed to look for X-posts related to the content I've written, so I would have thought when Shams Charania announced the award winner, Earnest should have notified me stat.  Not what happened.  Apparently, Earnest thought my *Are We Being Konn-ed* article was about Konnor Griffin.  Who is that you ask?  Apparently, he is a MLB prospect going to the Pirates.  Definitely not the all-time rookie leader in 3-pointers made.  

---

## Draft Night

I want to be honest about what it felt like on draft night after a month of not only building a predictive model, but also building an AI agent to amplify my results. 

I built a script to quickly score picks as they became public, and...  It worked! Picks came across the ticker, I typed *pick("Kenyon Sadiq")*, the pick importance waterfall populated, the boom/bust probability populated, and Earnest had a draft thread in Telegram ready to post to Adam Schefter's and Mel Kiper's X timeline within seconds.  The infrastructure that wasn't even an idea in late-March became something very real on a Thursday night in April. 

I used Sadiq as an example here, because the organizational tax landed exactly where the model said it would.  Players like Sadiq, Cooper, Iheanachor, Rutledge all carried the development penalties we'd documented, and most analysts talk about but have never quantified. The model didn't just run. It *said something*.

---

## So What's Next

The 2027 model has a long wishlist: conference tiers, birth dates sourced at the start of the season instead of patched on draft eve, proper player ID joining instead of name matching across three databases. Structural fixes that would have made this cycle cleaner.

The NBA Playoffs are already generating buzz. The PGA Championship and U.S. Open are just around the corner.  I'll keep posting, and in the background I'll be building a U.S. Open model.  Who knows, maybe I'll even write a WNBA article.  Just kidding, that's in the same bucket as Hockey.  Not gonna happen.

No matter what I write about, somewhere on the Mac Mini in the corner of my office, Earnest will be running his heartbeat check, monitoring for new content, filing journal entries, and routing around the next blocked feature before I ever ask him to.

---

*Earnest Lives! [github.com/merrittocratic/autopilot](https://github.com/merrittocratic/autopilot).*