# One Tap to The Herd

---

Fifteen minutes before Wyndham Clark hit a wedge to within five feet of the pin on the par-5 5th hole in Round 1 at Shinnecock Hills, Earnest fired a heater alert.

Clark's strokes-gained number through his opening holes had cleared the 90th-percentile threshold in the field. The model flagged it. Earnest routed it to Telegram. I saw the notification on my phone. Clark then eagled the hole and went on to win the US Open.

This is what the system was built to do. Not predict a specific shot -- nobody does that. Be in position before the moment arrives instead of narrating it after everyone else already has. The alert came first. The eagle came second. That 15-minute gap is the whole argument.

---

## What Earnest Actually Does

Earnest is an OpenClaw agent running on a Mac Mini. His job: detect when a round closes, trigger the model re-score, push the updated leaderboard to Telegram with enough context for a content decision in under 30 seconds. During live rounds he monitors scoring, fires heater and crasher alerts, and handles delays and API freezes. He does not post anything.

Every piece of content that leaves Merrittocracy goes through Telegram with three options: Skip, As-is, or Edited. One tap. Earnest handles the distribution labor. The editorial judgment stays on this side of the screen.

---

## The Tier System Is a Strategy, Not a Directory

The accounts Earnest monitors aren't a curated follower list. They're a map with a destination marked on it.

Tier 1A is the destination: Cowherd, The Herd, Dane Brugler, Zach Lowe. Fast monitor -- every 30 minutes, 5am to 10pm ET. When a Tier 1A account posts something analytically substantive, Earnest drafts a reply in Merrittocracy voice and surfaces it in Telegram. I see it. I tap.

Tier 1B is the credibility layer: Daniel Jeremiah, PFF, The Ringer, No Laying Up. Same fast cadence. Replies here build the track record that makes the Tier 1A play viable. You don't arrive at a national radio show without a body of work the analytical community already takes seriously.

Tier 1C is breaking news -- Schefter, Woj, Shams. When Shams reported Austin Reaves intends to sign a 4-year, $185M max to return to the Lakers, the Telegram draft read: "Reaves is the rare undrafted hit that changes a contender's math, not just its depth chart. Finding a real second-creation guard outside the draft is how teams keep expensive windows alive longer than they should." That is a Merrittocracy take, not a news summary. System surfaces the moment, drafts in voice, I tap. Those accounts often need the manual posting path because API reply timing is unreliable at that volume -- but it's still one decision.

Tier 2 is a broader monitoring set -- beat reporters, golf writers, analytics accounts. Checked every three hours. Daily soft cap is eight surfaced candidates. The cap isn't a bug. It's the discipline that keeps this from looking like a reply-guy operation instead of a publishing one.

---

## The Stated Goal

In two years, I want to be a guest on The Herd.

I'm publishing that because Merrittocracy holds its narratives accountable in public and there's no reason that principle stops at the brand strategy. Cowherd is Tier 1A because his platform converts analytical credibility into mainstream reach. The path: build following through sharp engagement with the analytical community, build a track record of narrative-checks that hold up, show up at The Herd with receipts. Two years from now, either it happened or it didn't.

---

## What Most Operations Get Wrong

The automation isn't the content strategy. It's what makes the content strategy survivable.

Most sports analytics accounts die not because the analysis degrades but because the operational load -- staying present on X, writing long-form, maintaining a model, finding the reply opportunity before the moment passes -- becomes unsustainable for one person. The load compounds. The posting cadence drops. The audience stops growing.

Earnest handles the present. The model handles the receipts. The human handles the argument.

One tap at a time.

---

*Earnest runs on OpenClaw. Code at [github.com/merrittocratic/autopilot](https://github.com/merrittocratic/autopilot). Merrittocracy at [themerrittocracy.substack.com](https://themerrittocracy.substack.com).*
