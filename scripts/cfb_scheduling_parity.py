"""Scheduling-parity analysis for the cfb_becoming_nfl article.

Question: if every power-conference team had to play one non-conference
power opponent drawn from a talent-matched pool, how close would those games be
compared with today's non-conference slate?

Run from the repo root (no API calls; reads the cache built by
scripts/cfb_scheduling_fetch.py):
    python3 scripts/cfb_scheduling_parity.py

Outputs (data/cfb_scheduling/):
    nonconf_games.csv      every P4 non-conference game 2016-2026 with spread and talent gap
    spread_by_gap.csv      median absolute spread by talent-gap bin (FBS vs FBS, 2016-2025)
    pools_2026.csv         each P4 team's 12 closest non-conference P4 teams by 5-yr talent
    summary.txt            headline numbers
"""
import json
from pathlib import Path

import numpy as np
import pandas as pd

RAW = Path("data/cfb_scheduling/raw")
OUT = Path("data/cfb_scheduling")
P4_CONFS = {"SEC", "Big Ten", "Big 12", "ACC"}
POOL_SIZE = 12
POOL_YEARS = range(2022, 2027)  # 5-year talent window for the pools


def load(name):
    return json.loads((RAW / f"{name}.json").read_text())


def is_p4(conf, season, team):
    if team == "Notre Dame":
        return True
    if conf in P4_CONFS:
        return True
    return conf == "Pac-12" and season <= 2023  # old Pac-12 only


# --- Talent ------------------------------------------------------------------
talent = pd.concat(pd.DataFrame(load(f"talent_{y}")) for y in range(2015, 2027))
talent["talent"] = pd.to_numeric(talent["talent"])
talent = talent.rename(columns={"year": "season"})

# --- Games + lines -------------------------------------------------------------
rows = []
for y in range(2016, 2027):
    if y == 2020:
        continue
    games = pd.DataFrame(load(f"games_{y}"))
    lines = load(f"lines_{y}")
    spread = {}
    for g in lines:
        vals = [l["spread"] for l in g.get("lines", []) if l.get("spread") is not None]
        if vals:
            spread[g["id"]] = float(np.median(vals))  # home-team spread, median across books
    games["spread"] = games["id"].map(spread)
    rows.append(games)
games = pd.concat(rows, ignore_index=True)
games = games[games["homeClassification"].isin(["fbs", "fcs"]) & games["awayClassification"].isin(["fbs", "fcs"])]
games = games[(games["homeClassification"] == "fbs") | (games["awayClassification"] == "fbs")]

for side in ("home", "away"):
    games[f"{side}P4"] = [is_p4(c, s, t) for c, s, t in
                          zip(games[f"{side}Conference"], games["season"], games[f"{side}Team"])]
    games = games.merge(
        talent.rename(columns={"team": f"{side}Team", "talent": f"{side}Talent"}),
        on=["season", f"{side}Team"], how="left")

games["absSpread"] = games["spread"].abs()
games["talentGap"] = (games["homeTalent"] - games["awayTalent"]).abs()

# --- Spread vs. talent gap (all FBS-vs-FBS games with a line, completed seasons) ---
fbs = games[(games["homeClassification"] == "fbs") & (games["awayClassification"] == "fbs")
            & games["absSpread"].notna() & games["talentGap"].notna() & (games["season"] <= 2025)].copy()
bins = [0, 25, 50, 75, 100, 150, 200, 300, 1000]
fbs["gapBin"] = pd.cut(fbs["talentGap"], bins, right=False)
by_gap = fbs.groupby("gapBin", observed=True)["absSpread"].agg(games="size", median_spread="median").reset_index()
by_gap.to_csv(OUT / "spread_by_gap.csv", index=False)
# Simple linear fit for predicting pool-game spreads: |spread| ~ a + b * gap
b, a = np.polyfit(fbs["talentGap"], fbs["absSpread"], 1)

# --- P4 non-conference games -----------------------------------------------------
nc = games[(games["homeP4"] | games["awayP4"]) & ~games["conferenceGame"].fillna(False).astype(bool)].copy()
nc = nc[nc["homeConference"].fillna("x") != nc["awayConference"].fillna("y")]


def opp_type(r):
    if r["homeP4"] and r["awayP4"]:
        return "P4"
    other = "away" if r["homeP4"] else "home"
    return "FCS" if r[f"{other}Classification"] == "fcs" else "G5"


nc["oppType"] = nc.apply(opp_type, axis=1)
nc.to_csv(OUT / "nonconf_games.csv", index=False)
recent = nc[nc["season"].between(2021, 2025)]

# --- 2026 pools --------------------------------------------------------------------
teams26 = pd.DataFrame(load("teams_fbs_2026"))[["school", "conference"]]
teams26 = teams26[[is_p4(c, 2026, t) for c, t in zip(teams26["conference"], teams26["school"])]]
avg = (talent[talent["season"].isin(POOL_YEARS)].groupby("team")["talent"].mean()
       .rename("talent5yr").reset_index())
teams26 = teams26.merge(avg, left_on="school", right_on="team", how="left").drop(columns="team")
missing = teams26[teams26["talent5yr"].isna()]["school"].tolist()

pool_rows = []
for _, t in teams26.iterrows():
    cands = teams26[teams26["conference"] != t["conference"]].copy()
    if t["school"] == "Notre Dame":
        cands = teams26[teams26["school"] != "Notre Dame"].copy()
    cands["gap"] = (cands["talent5yr"] - t["talent5yr"]).abs()
    cands = cands.nsmallest(POOL_SIZE, "gap")
    for rank, (_, c) in enumerate(cands.iterrows(), 1):
        pool_rows.append({"team": t["school"], "conference": t["conference"],
                          "talent5yr": round(t["talent5yr"], 1), "pool_rank": rank,
                          "opponent": c["school"], "opp_conference": c["conference"],
                          "opp_talent5yr": round(c["talent5yr"], 1), "gap": round(c["gap"], 1)})
pools = pd.DataFrame(pool_rows)
pools["pred_spread"] = (a + b * pools["gap"]).round(1)
pools.to_csv(OUT / "pools_2026.csv", index=False)

# Which 2021-2025 P4-vs-P4 non-con games would already have been pool games?
pairs = set(zip(pools["team"], pools["opponent"]))
p4nc = recent[recent["oppType"] == "P4"]
in_pool = [(h, a_) in pairs or (a_, h) in pairs for h, a_ in zip(p4nc["homeTeam"], p4nc["awayTeam"])]

# --- Summary ---------------------------------------------------------------------
lines_out = []
w = lines_out.append
w(f"P4 teams in 2026: {len(teams26)}; missing talent: {missing}")
w(f"Fit (FBS vs FBS 2016-2025 excl. 2020, n={len(fbs)}): |spread| = {a:.2f} + {b:.4f} * talent gap")
w("\nMedian |spread| by talent gap bin:\n" + by_gap.to_string(index=False))
w("\nP4 non-conference games, 2021-2025, by opponent type:")
s = recent.groupby("oppType").agg(games=("id", "size"), per_season=("id", lambda x: len(x) / 5),
                                   with_line=("absSpread", "count"),
                                   median_spread=("absSpread", "median"),
                                   median_gap=("talentGap", "median"))
w(s.round(1).to_string())
w(f"\nAll P4 non-con games with a line, 2021-2025: median |spread| {recent['absSpread'].median():.1f}")
w(f"Share of P4 non-con games vs. P4 opponents, 2021-2025: {(recent['oppType'] == 'P4').mean():.1%}")
c26 = nc[nc["season"] == 2026]
w(f"2026 P4 non-con games so far: {len(c26)}; vs P4 {(c26['oppType'] == 'P4').sum()}, "
  f"G5 {(c26['oppType'] == 'G5').sum()}, FCS {(c26['oppType'] == 'FCS').sum()}; "
  f"median |spread| {c26['absSpread'].median():.1f}")
w(f"\nPool games (12 per team): median talent gap {pools['gap'].median():.1f}, "
  f"median predicted |spread| {pools['pred_spread'].median():.1f}, "
  f"90th pct predicted {pools['pred_spread'].quantile(0.9):.1f}")
w(f"Actual 2021-2025 P4-vs-P4 non-con games already inside a 2026 pool: {sum(in_pool)} of {len(p4nc)}")
in_pool_spread = p4nc.loc[in_pool, "absSpread"].median()
out_pool_spread = p4nc.loc[[not x for x in in_pool], "absSpread"].median()
w(f"  median |spread| in-pool {in_pool_spread:.1f} vs out-of-pool {out_pool_spread:.1f}")
for team in ["Ohio State", "Kentucky", "LSU", "UCLA", "Indiana"]:
    p = pools[pools["team"] == team]
    w(f"\n{team} (5-yr talent {p['talent5yr'].iloc[0]}): " +
      ", ".join(f"{o} ({g:.0f})" for o, g in zip(p["opponent"], p["gap"])))
(OUT / "summary.txt").write_text("\n".join(lines_out) + "\n")
print("\n".join(lines_out))
