"""Fetch and cache CFBD data for the scheduling-parity analysis.

Run from the repo root:
    op run --env-file=.env -- python3 scripts/cfb_scheduling_fetch.py

Caches raw JSON under data/cfb_scheduling/raw/ so re-runs cost no API calls.
Reads CFBD_API_KEY from the environment only.
"""
import json
import os
import sys
import time
from pathlib import Path

import requests

BASE = "https://api.collegefootballdata.com"
RAW = Path("data/cfb_scheduling/raw")
GAME_YEARS = range(2016, 2026)      # completed seasons for the spread analysis (2020 dropped later)
TALENT_YEARS = range(2015, 2027)    # talent composite, incl. current season
TEAM_YEARS = range(2016, 2027)      # conference membership by season


def get(endpoint, params, name):
    out = RAW / f"{name}.json"
    if out.exists():
        return
    key = os.environ.get("CFBD_API_KEY")
    if not key:
        sys.exit("CFBD_API_KEY not set; run via op run --env-file=.env --")
    r = requests.get(f"{BASE}{endpoint}", params=params,
                     headers={"Authorization": f"Bearer {key}"}, timeout=60)
    r.raise_for_status()
    out.write_text(json.dumps(r.json()))
    print(f"fetched {name}: {len(r.json())} rows")
    time.sleep(0.5)


def main():
    RAW.mkdir(parents=True, exist_ok=True)
    for y in TALENT_YEARS:
        get("/talent", {"year": y}, f"talent_{y}")
    for y in TEAM_YEARS:
        get("/teams/fbs", {"year": y}, f"teams_fbs_{y}")
    for y in GAME_YEARS:
        get("/games", {"year": y, "seasonType": "regular"}, f"games_{y}")
        get("/lines", {"year": y, "seasonType": "regular"}, f"lines_{y}")
    # Current season schedule, to show what 2026 non-conference slates looked like
    get("/games", {"year": 2026, "seasonType": "regular"}, "games_2026")
    get("/lines", {"year": 2026, "seasonType": "regular"}, "lines_2026")


if __name__ == "__main__":
    main()
