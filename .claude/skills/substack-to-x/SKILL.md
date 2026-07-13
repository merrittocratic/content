---
name: substack-to-x
description: Drafts an X (Twitter) post under 280 characters in Merrittocracy's voice, always including a Substack link. Works two ways — repurposing an existing Merrittocracy Substack post/draft, or building an original take from scratch off a topic or prompt with no existing written piece, using web search to gather the supporting facts. Use when the user asks to "post this to X," "tweet this," "make this a tweet," or gives a take/topic and asks for an X post about it.
---

# X Post Composer

## What this does
Produces a single X post (or a short thread, when the argument genuinely
needs it) in Merrittocracy's X voice, always including a Substack link, with
real room to spare inside the 280-character limit. Handles two input modes:

- **Mode A — repurposing:** source is an existing Substack post or draft.
  The claim and most of the supporting facts already exist; the job is
  picking the sharpest one and tightening it into the voice.
- **Mode B — standalone prompt:** source is just a topic, take, or question
  from the user, no existing written piece. The job includes building the
  factual basis from scratch via web search, since there's no prior research
  to draw on.

## Character budget (hard math, not a guideline)
- X wraps every URL in its t.co shortener. Any link, short or long, costs
  exactly 23 characters. This is fixed and not worth re-deriving per post.
- The link always goes on its own final line, never inline mid-sentence.
  Reserve 24 characters for that line: 1 for the newline + 23 for the link.
- That leaves 256 characters for the post body. Target 220-240 so there's a
  visible gap, not a razor's edge — a post that's exactly 279 characters
  reads as "we ran out of room," not confident.
- **Which link:** Mode A uses that specific article's URL, since that's what
  the post is actually promoting. Mode B has no specific article, so it
  defaults to the root Substack domain (themerrittocracy.substack.com)
  unless the user points to a specific piece the take should tie back to.

## Process

**Mode A — repurposing an existing piece:**
1. Identify the single sharpest claim or data point in the source. One
   argument, not a summary of the whole piece. If several candidates exist,
   pick the one least likely to already be conventional wisdom.
2. Run 1-3 targeted web searches to sharpen it: verify time-sensitive
   numbers are still current, and look for one corroborating or contrasting
   data point that makes the claim land harder. If nothing found beats what
   the source already has, don't force it in — an empty search is a valid
   outcome.
3. Draft the post per the Voice rules below.
4. Count characters against the budget before returning the draft.

**Mode B — standalone prompt, no existing piece:**
1. Treat the user's prompt as the take, not the finished argument. Figure
   out what claim it implies and what evidence would actually support it.
2. Run enough web searches to build that evidence from scratch, typically
   more than Mode A's 1-3, since there's no prior research to lean on. Verify
   the core fact independently rather than taking the prompt's framing at
   face value — if the prompt assumes something that turns out to be wrong
   or outdated, flag it rather than writing around it.
3. Draft the post per the Voice rules below, using the root Substack link
   per the budget section above.
4. Count characters against the budget before returning the draft.

In both modes: lead with the claim itself, never a preamble like "New post:"
or "Wrote about X" — that burns characters and reads like an ad, not a take.

## Voice
Calibrated against real posts, not inherited from Substack/LinkedIn. X is
where the brand is bluntest and least explained.

- **Short, blunt sentences. Fragments are fine** and often land harder than
  a complete sentence would.
- **Signature device — parallel build to a turn**: stack 2-4 short parallel
  clauses, then land a contrast. "Kane delivered. Haaland delivered. Messi
  delivered. Mbappé delivered. Our biggest star keeps coming up small." Use
  this when the source has a comparable set (several players, several
  examples) instead of just stating the point flatly.
- **Signature device — negate-then-assert closer**: state what something
  isn't, then what it is, in two short hits. "That's not a record chase.
  That's a fix." This is the default way to land the final claim of a post,
  not just an occasional flourish. The second half needs to name the actual,
  concrete stakes, not a vague stand-in for them. "That's one shot to save
  the year" gestures at the stakes; "That's one week to win a major or
  finish the year without one" states them. If the closer could apply to
  five different situations without changing a word, it's too vague.
- **Deep-cut comps get zero explanation.** A name-drop like "Josh Selby" or
  "fell to #3 to the Bulls" lands with no footnote. This is a harder version
  of the Substack "trust the reference" rule — on X, over-explaining a
  reference kills it outright rather than just softening it.
- **No dashes, period.** Not even the double hyphens allowed elsewhere in
  house style. Rhythm comes from short sentences and hard stops, never a
  dash-set-off clause.
- **Casual, spoken-register openers are fine here**, unlike LinkedIn.
  "I feel like maybe we should talk about..." is a real opener, not a hedge
  to tighten up. X doesn't need a headline-style hook the way Substack or
  LinkedIn does.
- **Contractions always. No hedging on opinion takes.** The brand's
  "uncertainty as a range, never a point estimate" rule is for model
  probabilities specifically (boom rates, win probabilities). A subjective
  take ("that's a fix") gets stated flat, no softening.
- No hashtags, no emoji.

Note: none of the calibration posts included a link, since they're organic
reactions, not article promos. The sentence-level voice above still fully
applies to skill-generated posts; the link-on-every-post requirement is a
separate, deliberate layer for this skill's specific job of repurposing an
article, not a contradiction of the voice.

## Output format
Return:
1. The post text, ready to paste, link on its own final line.
2. One line on what the web search added, or "nothing beat the source."
3. Character count against 280.

## Flag, don't guess silently
- If the argument genuinely can't fit in 280 with the link included without
  gutting the number that makes it, say so and offer a 2-3 post thread
  instead of quietly weakening the claim to make it fit.
- If a web search turns up something that contradicts the source article's
  number, stop and flag the discrepancy rather than silently picking one.
