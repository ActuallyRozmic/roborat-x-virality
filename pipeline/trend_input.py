#!/usr/bin/env python3
"""Move posts by trend-input-only accounts out of the board lanes (run after data.json is built for D).

  trend_input.py <D>

Config (config/watchlist.json):  "trend_input_only": ["big_aggregator_account"]
Those accounts are still fetched (e.g. an outsider search `from:<handle>`), but their posts are used ONLY
as trend input: keyword ranking (drafts.py keywords) and the radar corpus (radar.py). They are removed
from hits, virals/outsiders, day_roster, no_hits and leaderboard entries, and kept in
data.json["trend_input_only_posts"] so the trend scripts can read them. Idempotent.
"""
from __future__ import annotations

import sys

from common import canon, load_config, load_data, save_data, trend_input_only


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    D = sys.argv[1]
    cfg = load_config()
    tio = trend_input_only(cfg)
    d = load_data()
    if d.get("date") != D:
        sys.exit(f"data.json date {d.get('date')} != {D}")
    kept = {p.get("url") or p.get("id"): p for p in d.get("trend_input_only_posts") or []}
    moved = 0
    for key in ("hits", "virals", "outsiders", "excluded_hits"):
        lst = d.get(key)
        if not isinstance(lst, list):
            continue
        keep = []
        for r in lst:
            if canon(r.get("handle")) in tio:
                kept[r.get("url") or r.get("id")] = r
                moved += 1
            else:
                keep.append(r)
        d[key] = keep
    for key in ("day_roster", "no_hits"):
        if isinstance(d.get(key), list):
            d[key] = [r for r in d[key] if canon(r.get("handle")) not in tio]
    for scope in ("week", "month", "all_time"):
        b = (d.get("leaderboards") or {}).get(scope)
        if isinstance(b, dict) and isinstance(b.get("entries"), list):
            b["entries"] = [r for r in b["entries"] if canon(r.get("handle")) not in tio]
    d["trend_input_only_posts"] = list(kept.values())
    d["trend_input_only"] = sorted("@" + h for h in tio)
    d["hits_count"] = len(d.get("hits") or [])
    lane = d.get("virals") if d.get("virals") else d.get("outsiders") or []
    d["outsiders_count"] = len(lane)
    save_data(d)
    print(f"trend_input_only {sorted(tio) or '-'}: moved {moved} records -> trend_input_only_posts "
          f"(now {len(kept)}); hits={d['hits_count']} outsiders={d['outsiders_count']}")


if __name__ == "__main__":
    main()
