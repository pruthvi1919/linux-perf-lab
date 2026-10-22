# Linux Performance Benchmark Toolkit

A Bash-based benchmarking toolkit for Garuda Linux that uses
Fastfetch and Hyperfine to collect system information, compare
command-line implementations, and generate performance reports.

## Features

- Collects system information using Fastfetch.
- Benchmarks command execution using Hyperfine.
- Compares Bash text generation with AWK.
- Compares grep and AWK for searching text files.
- Verifies equivalent output using diff.
- Exports benchmark results to CSV.
- Generates a Markdown performance report.

## Requirements

- Garuda Linux or another compatible Linux distribution
- Bash
- Python 3
- Fastfetch
- Hyperfine
- grep, AWK, diff, and standard command-line utilities

## Usage

Clone or download this repository, then enter its directory.

Run the complete benchmark suite:

```bash
./run_benchmarks.sh

## Benchmark results

The initial experiments on Garuda Linux showed:

- Text generation: AWK was faster than the Bash loop for the
  tested 10,000-line workload.
- File searching: grep was faster than AWK for the tested
  500,000-record dataset.

Exact timings vary by system and execution conditions.
See benchmark_report.md for the locally generated report.

## Reproduce the experiments

Run the benchmark suite:

    ./run_benchmarks.sh

Requirements include Bash, Python 3, Fastfetch, Hyperfine,
AWK, grep, and standard Linux command-line utilities.

## Limitations

These experiments compare specific implementations and workloads.
They do not demonstrate a general improvement to Linux system
performance. Benchmark results can vary with background load,
filesystem caching, software versions, and hardware.

## License

No license has been selected yet. Add a license before
redistributing the project.
