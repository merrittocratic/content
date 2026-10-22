---
name: article-to-note
description: Turns a Merrittocracy article from published/ into a Substack Note: the article title, a 60-80 word summary, and a placeholder for the article link. Use when the user asks for a "note," "Substack note," "note for this article," "promo note," or says "article to note" about a piece in published/ -- even if they just name the article's slug or say "the new one."
---

# Article to Note

## What this does
Reads one article from `published/<topic>/YYYY-MM-DD <slug>.md` and writes a
Substack Note: the article's title on the first line, a 60-80 word summary,
then a link placeholder on its own line. The Note promotes the article, so it should make
a reader want the full piece, not replace it.

## Pick the article
- If the user names a file, slug or title, use that one.
- If they say "the new one" or name nothing, use the most recent file
  (by the date prefix) in `published/<active topic>/`, where the active topic
  is the first non-blank, non-`#` line of `.current_project`. Say which file
  you picked.
- Read the whole article, including the `---`-separated closing paragraph,
  which usually states the verdict. Skip the YAML frontmatter and the italic
  Method/data footnote.
- If more than one file could match, ask rather than guess.

## Write the Note
1. **First line is the article's title**, copied exactly from the first
   `# ` header in the .md (without the `# `), on its own line, followed by a
   blank line. Never take the title from the filename; slugs often differ
   from titles, and that's fine.
2. **Open the summary with the article's central question or premise, framed as the
   take.** No preamble like "New post:" or "This week I wrote about..."
3. **Cover each main section in a sentence or two**, keeping the one number
   per section that carries the argument. Don't try to fit every stat.
4. **Land on the article's verdict**, as the article states it. If the
   article corrects a premise ("bad, not historic"), the correction is the
   payoff, so keep it.
5. **End with the link placeholder on its own final line:**
   `[ARTICLE LINK]`

### Rules
- **60-80 words for the body.** The title line and the placeholder line
  don't count. Don't repeat the title verbatim inside the summary. Count
  the words before returning and revise until it's in range.
- **Only facts that are in the article.** Never add a stat, rank or claim
  that isn't in the source, and never round a number differently than the
  article does.
- **Full player names** ("Jameson Williams", never "J. Williams"), per
  CLAUDE.md.
- **Every rank names its measure in the same sentence** ("31st in net
  EPA"), never a bare "(31st)", per CLAUDE.md.
- **Model numbers keep their framing.** Start chances stay as chances and
  ranks stay "against consensus"; market lines stay attributed to the
  market. Don't turn a probability into a prediction.
- **Brand name:** "TheMerrittocracy" as one word only in a byline or
  header; in a sentence it's "The Merrittocracy". Notes rarely need it.
- **Voice:** Steve's, conversational and confident. Contractions are fine.
  No hashtags, no emoji. Plain ASCII only: straight quotes, and no em or en
  dashes (use commas, colons or periods instead).
- Keep the article's section headings (`## `) out of the Note unless one
  reads naturally as a sentence.

## Output format
Return, in chat (don't write a file unless asked):
1. The Note, ready to paste: title line, blank line, summary, blank line,
   `[ARTICLE LINK]`.
2. The article file it came from.
3. Body word count (e.g. "72 words, title and link lines excluded").

## Flag, don't guess
- If the article is too thin or too sprawling to summarize honestly in 80
  words, say so and offer either a two-sentence Note on its strongest
  section or a slightly longer version, instead of silently dropping the
  verdict.
- If the article and its draft/ copy disagree, use the published version
  and mention the mismatch.
