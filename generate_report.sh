#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

python - <<'PY'
import csv
from pathlib import Path

def load_csv(path):
    with open(path, newline="") as f:
        return list(csv.DictReader(f))

def find_row(rows, keyword):
    for row in rows:
        if keyword in row["command"]:
            return row
    raise ValueError(f"Missing benchmark: {keyword}")

def summarize(title, rows, first, second):
    a = find_row(rows, first)
    b = find_row(rows, second)

    ta = float(a["mean"])
    tb = float(b["mean"])

    faster_name, faster_time = (
        (first, ta) if ta <= tb else (second, tb)
    )
    slower_name, slower_time = (
        (second, tb) if ta <= tb else (first, ta)
    )

    speedup = slower_time / faster_time
    reduction = (slower_time - faster_time) / slower_time * 100

    return f"""## {title}

| Method | Mean (ms) | Std. deviation (ms) |
|---|---:|---:|
| {first} | {ta * 1000:.3f} | {float(a['stddev']) * 1000:.3f} |
| {second} | {tb * 1000:.3f} | {float(b['stddev']) * 1000:.3f} |

- Faster method: **{faster_name}**
- Speedup: **{speedup:.2f}x**
- Reduction in mean execution time: **{reduction:.2f}%**
"""

generation = load_csv("benchmark_results.csv")
search = load_csv("results/search_benchmark_v2.csv")

report = """# Linux Performance Benchmark Toolkit

## Environment

System details are recorded in `system_info.txt`.

""" + summarize("Text Generation", generation, "printf", "awk") \
  + summarize("File Searching", search, "grep", "awk") + """
## Methodology and limitations

- Benchmarks use Hyperfine with repeated runs and warmups.
- Output equivalence is checked separately using `diff`.
- Measurements include helper-script startup overhead.
- Background activity and filesystem caching can affect results.
- Results apply to the tested workloads, not all Linux workloads.
"""

Path("benchmark_report.md").write_text(report)
print(report)
print("Report saved to benchmark_report.md")
PY
