# Draft rules v4

Drafts are written by the agent and checked by code (`pipeline/drafts.py check`). The script never writes prose.

## Scope: TOP-10 only

- Write drafts **only** for the 10 most-viewed posts on the board: watchlist hits + outsiders ranked together by latest views, minus `trend_input_only` accounts. Self-quotes count. The list comes from `pipeline/drafts.py top10 <D>` (or `pipeline/run_day.sh prepare <D>`).
- Those cards get a **TOP-10 · #n** badge. Every other card shows the original text and "why it hit", with no draft.
- `digests/<D>/_parts/drafts_v4.json`: `{"<post id>": {"draft_en": "...", "keywords_used": ["...", ...]}}`, exactly those 10 ids.

## The rules

1. **Real rewrite.** Same meaning and facts, new wording **and** new structure: reorder points, merge or split lines, a new hook line, your own transitions. Never paste sentences or lists in the original order with light edits. Quotes inside the original get paraphrased with attribution. Commands, code, URLs and handles stay exact.
2. **Facts locked.** No numbers, names, claims, results or promises that are not in the original. A truncated original is rewritten only as far as it goes, never with an invented ending. Every number stays exactly as given.
3. **Trend keywords (most important).** From `digests/<D>/_parts/trend_keywords.json` (ranked last-24h keywords) weave in as many as fit the **meaning**, usually 3-6, minimum 1. A keyword fits only if the sentence stays true to the original. Never add a product, model or person the post is not about. No stuffing, no hashtag lists. List exactly the keywords used in `keywords_used`, spelled as they appear in the draft.
4. **Your own post.** Every draft is a standalone post for the operator's account, never a reply, quote-reply or comment to the author ("great thread", "@author ...", "this!" are rejected). Outsider posts belong to other people: rewrite them as your own take and never copy first-person facts ("my delivery", "I tested") unless reframed truthfully. Keep the original's CTA type if it has one.
5. **Style.** English, human, a bit punchy, not AI-sounding (no "In today's fast-paced world", "game-changer", "delve", "unlock", "Here's the thing", emoji walls). **Short hyphen `-` only**, never em or en dashes. Drop slurs and vulgarity unless they are the whole point.
6. **Code gate.** `pipeline/drafts.py check <D>` rejects a draft when:
   - word 4-gram overlap with the original is **> 30%**
   - any copied run of **≥ 7** consecutive words
   - content-word overlap is > 75% (long drafts)
   - an em/en dash is present
   - a `keywords_used` entry is missing from the draft or not in `trend_keywords.json`
   - fewer than 1 keyword
   - a number is not in the original
   - it opens like a reply
   Rewrite every REJECT and re-run until `rejected=0`. Target: 4-gram ≤ 15%, longest run ≤ 6.
7. **Board.** Each TOP-10 draft shows `keywords:` chips, "overlap 4-gram N%" and a collapsible "Original · EN". The **Trend keywords · 24h** section lists the ranked keywords. The radar summary adds a line: **"TOP-10: x/10 (y%) matched trends"**.
8. **Emergency only.** `pipeline/run_day.sh <D> --skip-drafts` publishes without drafts. Say so in the ping.

## Ideas (trend radar) follow the same style

Post ideas and article ideas in `radar_inputs.json` use the same rules: English hook, short hyphen only, standalone posts, no invented facts. Every idea carries a visual (video, screencast, image, meme or carousel). Text-only ideas are rejected.
