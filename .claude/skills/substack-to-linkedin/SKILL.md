---
name: substack-to-linkedin
description: Converts a Merrittocracy Substack post (draft or published) into a LinkedIn post for the sports-analytics / data-science professional audience. Use this whenever the user asks to "repurpose," "turn into a LinkedIn post," "LinkedIn version," "cross-post," or shares/pastes a Merrittocracy article and mentions LinkedIn — even if they just drop a file path from content/drafts/ or published/ and say "LinkedIn."
---

# Substack → LinkedIn Converter

## What this does
Takes a full Merrittocracy Substack post and produces a shorter, more overtly
technical/professional LinkedIn version, with the X and Substack links in the
post body per the Links section below.

## Why the platforms differ
- **Substack**: full narrative-check, methodology tucked at the end for readers
  who want it.
- **X**: punchy, one data point, methodology hidden entirely, contrarian hook
  leads.
- **LinkedIn**: professional/technical audience (data scientists, sports
  analytics peers, media/industry contacts). Comfortable seeing the method
  named up front, but still wants a clear finding, not an abstract. Dial
  formality UP from X, dial flippancy DOWN from Substack, keep the confidence.

## Process
1. Read the source post in full.
2. Identify: (a) the narrative being checked or the core argument, (b) the
   single sharpest data point or concrete example, (c) the model/technique
   behind it, (d) the takeaway.
3. Draft per the template below.
4. End the post with both links in the body, each on its own line, per the
   Links section below.

## Post template (~200-300 words)
1. **Hook (1-2 lines)** — the professional-register version of the hook.
   Still first person, still "our model" where relevant — but pitched like a
   practitioner talking to peers, not a bar-stool aside.
2. **The finding (2-3 lines)** — the data point or example, with a range,
   never a point estimate (same rule as Substack/X).
3. **The method, named once (1-2 lines)** — name the actual technique
   (LightGBM, brms stacking, hierarchical Bayesian, EPA/opportunity
   decomposition, OpenClaw agent architecture, whatever's relevant). LinkedIn
   is the one platform where this belongs in the body, not a footnote.
4. **The takeaway (1-2 lines)** — why it matters beyond this one player/event.
   The "so what" a fellow practitioner or hiring manager would want.
5. **Sign-off (2 lines)** — both links, on their own lines. See Links below.

## Formatting rules
- **No dash-as-interrupter constructions** (e.g. "X -- Y" or "X — Y" used to
  set off a clause). But don't just swap the problem for a semicolon/colon
  stack either — "X, Y, Z: outcome" reads just as robotic as the dash it
  replaced. Write the sentence the way you'd actually say it out loud to a
  peer: plain subject-verb-object, an occasional aside, and reach for
  punctuation second, not first. Colons and semicolons should show up because
  a sentence naturally wants one, not as a default fix.
- **Personality carries over, just dialed down, not off.** Same brand brain —
  dry, confident, a little wry — pointed at a work conversation instead of a
  bar. That means no profanity and no X-level edge (the "F*** Them Picks"
  register belongs on X, not here), but it does not mean flat or robotic.
  If a draft could've been written by a corporate comms account, it's wrong.
- **Preserve the numbers that carry the argument, cut the ones that are just
  color.** A stat is load-bearing if the claim falls apart without it (bust
  rates, contract figures, sample sizes, anything the "so what" depends on).
  A stat is color if it's supporting texture (a box score line, a family
  lineage detail, a secondary example). On a numbers-light source this means
  keep everything. On a stats-dense source, it means picking the 3-5 figures
  doing the real work and cutting the rest rather than force-fitting all of
  them or blowing past the word count. When in doubt about which bucket a
  number falls into, keep it — the failure mode to avoid is summarizing a
  load-bearing stat into vague language like "a strong signal."
- Short paragraphs (1-2 sentences), blank line between each — LinkedIn's feed
  rewards scannability more than Substack's longer paragraphs.
- No bullet points, no hashtags, no "thoughts?" engagement bait. LinkedIn is a
  one-way publishing channel here, not a place we're fishing for comments.
- Preserve pop-culture references or wordplay only if they survive the
  formality bump without reading cute. Cut if in doubt.

## Links
Both links go directly in the post body, each on its own line at the end:
- X: x.com/Merrittocratic (plain follow pointer, not a repost link)
- Substack: the full article URL

Note: this trades off against the reach-protection convention used elsewhere
(keeping outbound links out of the body to avoid algorithmic suppression).
That tradeoff is intentional here per Merrittocracy's call, not an oversight —
don't silently revert to a first-comment link even though that's the pattern
used on X and was this skill's original v1 approach.

## Output format
Return the LinkedIn post as ready-to-paste text, links included in the body
as specified above. No separate first-comment block needed.

## Flag, don't guess silently
- If the source post has no single standout data point (some are strategy
  essays, not stat-driven), flag it and ask whether to lead with the
  structural/strategic argument instead of forcing a data hook.
- If 200-300 words feels wrong for a given piece (e.g. a methodology deep-dive
  might warrant 400-600), say so and offer the longer version as an
  alternative instead of force-fitting the short template.
