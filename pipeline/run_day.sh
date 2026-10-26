#!/usr/bin/env bash
# X Virality Score - daily trend layer for content day D (after the agent has built board/data.json for D).
# Read-only on X: the agent does every fetch with the x MCP connector and saves RAW outputs; this script only
# reads/writes local JSON. It never posts, likes, replies, follows or DMs.
#
#   pipeline/run_day.sh prepare <D>     # trend-input split, trend keywords, X keyword request, experiment request,
#                                       # prints the TOP-10 posts that need v4 drafts
#   pipeline/run_day.sh <D>             # gates + apply: drafts v4 check/apply -> X keyword ingest -> radar -> experiment
#                                       # -> PING.txt   (exit 3 = fix drafts_v4.json / radar_inputs.json and re-run)
#   pipeline/run_day.sh <D> --skip-drafts   # emergency: no drafts / ideas gate (say so in the ping)
#
# Then publish board/index.html + board/data.json to YOUR Pages repo (board/publish-pages.example.sh).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PY="python3"
exp_enabled() { $PY -c "import sys; sys.path.insert(0,'$HERE'); from common import load_config; sys.exit(0 if (load_config().get('experiment') or {}).get('enabled') else 1)"; }

if [ "${1:-}" = "prepare" ]; then
  D="${2:?usage: run_day.sh prepare <D>}"
  $PY "$HERE/trend_input.py" "$D"
  $PY "$HERE/drafts.py" keywords "$D"
  $PY "$HERE/xkw.py" request "$D"
  if exp_enabled; then $PY "$HERE/experiment.py" request "$D" >/dev/null && echo "experiment request written (1 read)"; fi
  $PY "$HERE/drafts.py" top10 "$D"
  echo "PREPARE done: fetch the X keyword searches + experiment timeline, write _parts/drafts_v4.json (TOP-10 only)"
  echo "and _parts/radar_inputs.json, then: pipeline/run_day.sh $D"
  exit 0
fi

D="${1:?usage: run_day.sh <D> [--skip-drafts]}"; shift
DRAFTS=1
for a in "$@"; do case "$a" in --skip-drafts) DRAFTS=0 ;; *) echo "unknown arg $a" >&2; exit 2 ;; esac; done
DAY="$($PY -c "import sys; sys.path.insert(0,'$HERE'); from common import day_dir; print(day_dir('$D'))")"

$PY "$HERE/trend_input.py" "$D"
if [ "$DRAFTS" = 1 ]; then
  [ -s "$DAY/_parts/trend_keywords.json" ] || { echo "missing $DAY/_parts/trend_keywords.json - run prepare" >&2; exit 3; }
  $PY "$HERE/drafts.py" check "$D" || { echo "DRAFTS v4 REJECTED/MISSING - rewrite $DAY/_parts/drafts_v4.json (templates/DRAFT_RULES.md)" >&2; exit 3; }
  $PY "$HERE/drafts.py" apply "$D"
else
  echo "WARNING: --skip-drafts - no v4 drafts this run"
fi
if ls "$DAY"/_xkw/*__24h.json >/dev/null 2>&1; then
  $PY "$HERE/xkw.py" ingest "$D"
elif [ "$DRAFTS" = 1 ]; then
  echo "XKW: no $DAY/_xkw/*__24h.json - run the searches from $DAY/_xkw/request.json" >&2; exit 3
fi
if [ "$DRAFTS" = 1 ]; then
  $PY "$HERE/radar.py" build "$D" || { echo "RADAR REJECTED - fix $DAY/_parts/radar_inputs.json" >&2; exit 3; }
else
  $PY "$HERE/radar.py" build "$D" --no-ideas-ok || echo "WARNING: radar build failed (skip mode)"
fi
if exp_enabled; then $PY "$HERE/experiment.py" build "$D"; fi
echo "--- PING ($DAY/PING.txt)"
$PY "$HERE/ping.py" "$D"
