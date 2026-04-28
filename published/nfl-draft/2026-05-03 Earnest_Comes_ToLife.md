# Earnest Goes to the Draft

--
I know, I know...  Not another super technical article.  I promise this will be the last one for awhile, and we can move onto the NBA playoffs and the Golf majors, but first you gotta meet this guy!

## Hello World, Earnest

In the last article, we talked alot about how "*we*" built the model to predict boom/bust in the NFL Draft.  I deliberately used the word "*we*" alot in that article, and it's time I tell you why.  Meet Earnest!

[IMAGE: IMG_6168.PNG]

He is an AI automation agent, built on OpenClaw, running on the aforementioned Mac Mini.  He has one job, extend Merrittocracy's reach without replacing my voice.  "It's what he does, it's all he does."  Unlike the terminator though, he actually can be reasoned with.  Whether he's monitoring for new Substack articles, drafting X threads in my voice, or surfacing reply opportunities, Earnest routes everything back to me through Telegram for approval before anything leaves the friendly confines of Merrittocracy. 

We actually go back and forth quite a bit, though he does think all of my ideas are brilliant, so I need to tune him to not be such a yes man.  The approval loop is the whole point. Earnest doesn't publish. He proposes. Every draft goes through Telegram, every post requires an explicit yes, every irreversible action has a "*human in the loop*".  He also files his own journal entries when something significant happens, which would normally be great, but man, my ego is taking a beating seeing all of the mistakes I've made along the way.  

Earnest went live for the first time during draft week. Getting him there was its own project, with its own set of challenges to overcome. More on that later. For now, he exists, he works, he has a soul, and he's a character in this story, not just a tool in the stack.

Wait, did you say soul?  Yes I did, and it's one of the cooler things about OpenClaw.  During the onboarding process, you develop a set of instructions that end up becoming the agent's "soul", and the file is called SOUL.md.  It's why he responds like this...



---

## So wait, is this all just AI?

In a word, NO!  I've always considered myself a better editor than initiator.  So, yes every draft article does start as a back and forth with either Earnest of Claude, by Antrhopic. But, that is not what lands in your inbox.  My writing process is *"unique"*.  I guess this is where my nerd takes over.  The draft that I create with AI drops into a content folder in a version control software system.  This system tracks every change I make with the draft, and it is posted online.  

What is displayed in the software is called the *diff* and the *diff* is the receipt. Anyone who wants to ask "is this just AI?" can go look at the answer on that site, and look at my history of changes for each article. The gap between what AI produces and what I publish is where the editorial judgment lives, and that gap is the whole argument for why AI as a force multiplier works. It's not replacing my voice. It's handling the scaffolding so my voice can focus on what it actually does.

No AI would ever title an article *The Big Arch vs. The Mendoza Line* or *F*** Them Picks*.

--

## The Infrastructure That Didn't Survive First Contact

Getting Earnest operational was a separate build with its own set of plans that looked right until they weren't.

The original secrets management approach: store everything in 1Password, inject credentials at startup using the 1Password CLI. Clean, secure, well-designed. It lasted approximately 24 hours. The 1Password CLI requires an interactive session to authenticate. Background services have no interactive session. These two facts cannot be reconciled. The fix was macOS Keychain — scoped to a single service, encrypted at rest, headless by design. Twelve secrets migrated. The new approach was more robust than the original. It also required throwing out the original entirely.

Getting the X API working produced its own chapter. The first live post hit an error immediately — the R HTTP library had no native OAuth 1.0a support, despite that function appearing in multiple examples online. Switched implementations. Same error. Switched again. All of them returned error code 32: "Could not authenticate you."

Error code 32 looks like a signing bug. It isn't. It means the credentials are the problem, not the code. The diagnostic: test the Bearer token in isolation. A 403 "Unsupported Authentication" response — not a 401 Unauthorized — confirms the API key pair is valid and the access token is the failure point. Root cause: the tokens were generated before the app's permissions were upgraded to "Read and Write." Old tokens inherit the permission level at generation. They can't be retroactively upgraded. Regenerate in the developer portal, update the environment, and the first post goes through clean.

Two hours debugging authentication code. Fixed by a button click in a dashboard.

The Telegram notification system hit its own wall — a cron gateway authentication error that wouldn't resolve. Earnest didn't wait for a fix. He checked for pending drafts during his existing heartbeat cycle and sent notifications from within the agent session instead. The cron auth problem became irrelevant. He routed around it without being asked, which is exactly the kind of thing you want from a system you're depending on during a live draft.

---

## Draft Night

Draft night came fast and furious.  I had to figure out a wayThe *draft_night_helper.R* script does one thing: type *pick("Player Name")* and receive a full player card — boom probability, bust probability, predicted z-score, athleticism percentile, program pipeline note — plus the exact file path to the SHAP waterfall chart, ready to copy to Telegram.

Earnest receives the file path, pulls the waterfall, drafts the X thread in Merrittocracy voice, and routes it back for approval. The whole chain — pick announced, model re-scored with the actual drafting team, waterfall regenerated, content drafted, approval requested — under ten minutes.

I want to be honest about what that felt like after months of building toward it.

It worked. Picks came across the ticker, I typed *pick("Kenyon Sadiq")*, the waterfall populated, Earnest had a draft thread in Telegram before the next commercial break. The infrastructure that had been a theoretical exercise for weeks became a real thing at a specific moment on a Thursday night in April. That's a different feeling than passing a unit test.

And when the organizational tax landed exactly where the model said it would — Sadiq, Cooper, Iheanachor, Rutledge, all carrying the development penalties we'd documented — that was something closer to vindication. The model didn't just run. It *said something* that turned out to be true.

Pre-draft snapshots were preserved separately, so the diff between "what we predicted before the pick" and "what the model thinks now that we know the team" is a content angle in its own right. Ty Simpson was a model favorite before the Rams took him. The Rams' development environment is one of the few that doesn't hurt that projection. The model and the narrative disagreed, and the honest version required holding both. That tension is exactly what Merrittocracy is supposed to produce.

---

## What's Next

The 2027 model has a long wishlist: conference tier (NA all cycle, never caught until too late), birth dates sourced at the start of the season instead of patched on draft eve, proper player ID joining instead of name matching across three databases. Structural fixes that would have made this cycle cleaner.

The NBA Playoffs are already generating narrative debt. Victor Wembanyama is playing at a level that demands historical context — the Kareem precedent is genuinely instructive about what elite young bigs need to sustain a championship window. That piece is next.

And somewhere on the Mac Mini in the corner of a home office, Earnest is running his heartbeat check, monitoring for new content, filing journal entries, routing around the next blocked feature before anyone asks him to.

The cellar is stocked. The tap is open.

---

*Earnest Lives! [github.com/merrittocratic/autopilot](https://github.com/merrittocratic/autopilot).*