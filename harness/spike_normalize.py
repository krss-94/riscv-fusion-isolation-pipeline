#!/usr/bin/env python3
"""Normalize a spike --log-commits raw trace, or an RTL trace in the same
'core 0: N 0xPC (0xINSTR) x19 0xVAL' / '... mem 0xADDR 0xVAL' commit-line
format, down to FINAL architectural state: the last committed value for
each register and each memory address, in commit order. Compared this way
(not commit-by-commit) the check is invariant to how many discrete commits
it took either implementation to get there -- which matters now that RTL
fuses some LUI+ADDI pairs (fewer commits than Spike) but NOT others, exactly
when its hazard interlock conservatively blocks fusion (correct, in-flight-
write-safety behavior) -- replicating that interlock's exact conditions
purely from a trace, to keep per-commit comparison alive, proved fragile
and produced repeated one-off desyncs. Final-state comparison sidesteps the
question of *how many* commits happened and only asks whether both
implementations reached the same result.
"""
import sys, re

path = sys.argv[1]
lines = open(path).read().splitlines()

COMMIT_RE = re.compile(r'^core\s+0:\s+\d+\s+0x[0-9a-f]+\s+\(0x[0-9a-f]+\)\s+(.*)$')
TOK_RE = re.compile(r'(x[0-9]+) +0x([0-9a-f]+)|mem 0x([0-9a-f]+) 0x([0-9a-f]+)')

started = False
final = {}  # key -> value, insertion order not needed since we print sorted by key type then by first-seen order of key
order = []  # to keep a stable, deterministic print order: first time each key appears

for line in lines:
    if not started:
        if line.startswith('core   0: 0x80000000 (') or line.startswith('core   0: 3 0x80000000 ('):
            started = True
        else:
            continue
    cm = COMMIT_RE.match(line)
    if not cm:
        continue
    tail = cm.group(1)
    for m in TOK_RE.finditer(tail):
        if m.group(1):
            key = m.group(1)
            val = int(m.group(2), 16)
        else:
            key = f"mem {m.group(3)}"
            val = int(m.group(4), 16)
        if key not in final:
            order.append(key)
        final[key] = val

for key in order:
    print(f"{key} 0x{final[key]:x}")
