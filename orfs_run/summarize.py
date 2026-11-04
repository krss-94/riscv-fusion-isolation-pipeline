#!/usr/bin/env python3
"""Collect WNS / area from ORFS reports, print mean+-sd per config."""
import sys, re, glob, os, csv, statistics as st
flow, out = sys.argv[1], sys.argv[2]
rows = []
for rpt in glob.glob(f"{flow}/reports/nangate45/*/*/6_finish.rpt"):
    parts = rpt.split("/"); name, tag = parts[-3], parts[-2]
    t = open(rpt, errors="ignore").read()
    wns = re.search(r"worst slack max\s+(-?[\d.]+)", t)
    area = re.search(r"Design area\s+([\d.]+)\s+u\^2", t)
    rows.append(dict(config=name, run=tag,
                     wns_ns=float(wns.group(1)) if wns else None,
                     area_um2=float(area.group(1)) if area else None))
with open(out, "w", newline="") as f:
    w = csv.DictWriter(f, fieldnames=["config", "run", "wns_ns", "area_um2"])
    w.writeheader(); w.writerows(rows)
print(f"{len(rows)} runs -> {out}")
for c in sorted({r["config"] for r in rows}):
    for k in ("wns_ns", "area_um2"):
        v = [r[k] for r in rows if r["config"] == c and r[k] is not None]
        if len(v) > 1:
            print(f"{c:24s} {k:9s} n={len(v):2d} mean={st.mean(v):9.3f} sd={st.stdev(v):7.3f} "
                  f"min={min(v):9.3f} max={max(v):9.3f}")
