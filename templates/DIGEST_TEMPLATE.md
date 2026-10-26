# Daily X narrative digest · {{date}}
Timezone: {{timezone}} · originals only (self-quotes count, badge only) · ≥{{min_views}} views (★ ≥{{star_views}})

## Ping (send verbatim from `digests/<D>/PING.txt`, built by `pipeline/ping.py`)

English (`"lang": "en"`):

```
X digest {{dd.mm}}: N hits ≥5k (S ★)[ (self-quotes: X)]; +K outsiders.
X keywords 24h (sample): top-5 kw1 12.3K ↑, kw2 9.8K →, ...
TOP-10: x/10 (y%) matched trends · trend a, visual b, ...
Experiment @{{handle}} {{start}}..{{end}}: n posts; trend n=.. 1.4x vs non-trend n=.. 1.1x · +27%   (or "· sample too small")
Board: {{your_board_url}}
```

Russian (`"lang": "ru"`):

```
X digest за {{dd.mm}}: N хитов ≥5k (S ★)[ (из них самоцитат: X)]; +K outsiders.
Ключи X 24ч (выборка): top-5 ...
Топ-10: x/10 (y%) совпали с трендами · ...
Эксперимент @{{handle}} {{start}}..{{end}}: ...
Борд: {{your_board_url}}
```

- The self-quote part is omitted when X = 0. Self-quotes count as hits everywhere and only carry a badge.
- `+K outsiders` excludes `trend_input_only` accounts.
- The experiment line appears only when `experiment.enabled` is true.
- Never recompute the numbers by hand. Never say "today" for content day D (it is yesterday).

## Watchlist hits · {{hit_count}}

### N. {{display_name}} · `@{{handle}}` · **{{views}} views** [TOP-10 · #n] [self-quote]
🔗 {{url}}

**Hook:** {{hook}}

**Why it hit:** {{trend_match}}% trend match · {{verdict}} · {{matched_keywords}}

**Original**

{{original}}

**Draft · EN** (TOP-10 only, Draft rules v4)

{{draft}}

keywords: {{keywords_used}} · overlap 4-gram {{g4}}%

**video_tip:** {{video_tip}}

---

## Trends and post ideas

- **TOP-10:** {{top10_line}}
- **Summary:** {{headline}}
- **Takeaway:** {{takeaway}}
- **Trends 24-48h:** {{topics}}
- **X keywords 24h vs previous 24h (sample of up to 25 posts per search):** {{x_keywords_top}}
- **Post ideas (5-8):** topic + hook + visual + keywords
- **Article ideas (2-3):** title + thesis + outline

## No-hits
{{no_hits}}

## Keyword / pattern brief
{{patterns}}

## Outsiders
{{outsiders}}
