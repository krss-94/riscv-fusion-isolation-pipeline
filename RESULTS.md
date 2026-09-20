# Results Log

Chronological only, same discipline as research_log.md: append, don't rewrite.
Each entry is either a validation checkpoint (pass/fail, no interpretation) or,
later, an analysis entry — and those two kinds of entry should never be mixed
in the same block. If a validation entry has "no analysis performed" written
under it, that line is load-bearing, not filler: it's there to stop the very
first histogram from turning into three new hypotheses before the logger
itself has been trusted.

## 2026-07-12

Instrumentation build:
PASS — cond_branch_predictor_interface.o and my_cond_branch_predictor.o built
with -DENABLE_ALLOC_LOGGER -DBUILD_TIME_UNIX=1783832405; linked cbp (501728
bytes, vs. 501568-byte unmodified baseline); strings cbp confirms
"AllocationLogger: total allocations logged: %llu" present in the binary.

Binary log:
PASS — results/sample_int.allocations.bin produced. In-process ground-truth
counter (AllocationLogger::allocation_count, printed by terminate() at
simulation end): 435.

Reader:
PASS — read_allocations.py parsed the file with no exceptions.

Records:
435

Header check (magic/version/record_size):
OK — magic=0x414C4C47, version=3, record_size=47 (matches sizeof(AllocationRecord)
exactly: 47 bytes, packed, no padding).

Build fingerprint (nhist/born_tick/uwidth):
nhist=36, born_tick=1024, uwidth=1

File size check (actual vs. header + records*record_size):
OK — actual=20477, expected=20477.

Trace used:
sample_traces/int/sample_int_trace.gz (997301 instructions, 128874 conditional
branches, 0.2049% branch misprediction rate)

Cross-check:
In-process logger count (435) == reader-parsed record count (435). Exact match.

No analysis performed.

## Phase 3: Data Collection (2026-07-12)

Trace scope:
Full 105-trace CBP2025 training set (compress:8, fp:14, infra:16, int:37,
media:4, web:26 — matches reference_results_training_set.csv exactly),
downloaded via gdown from the repo's Google Drive link.

Collection run:
PASS — scripts/run_all.sh, 105/105 traces, zero failures, zero aborts.
Started 2026-07-12 09:42:14 UTC, finished 14:39:50 UTC (~5 hours).
One script bug found and fixed mid-run (bad arithmetic-expansion syntax
in the per-trace timing log line; caused the driver to abort after trace
1 of 105 despite that trace itself completing correctly — fixed and
reran from scratch).

Validation run:
PASS — scripts/validate_logs.py, 105/105 traces PASS, 0 FAIL.
Checks per trace: header magic/version/record_size, file-size math
(actual vs. header + records*record_size), instruction/branch count
parsed from simulator log.

Manifest:
results/manifest.csv — one row per trace: trace_name, instruction_count,
branch_count, allocation_count, nhist, born_tick, uwidth, build_time_unix,
logger_version, status. All 105 rows status=PASS.

No analysis performed.
