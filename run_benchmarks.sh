#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "===================================="
echo " Linux Performance Benchmark Toolkit"
echo "===================================="

for cmd in fastfetch hyperfine python diff; do
    command -v "$cmd" >/dev/null 2>&1 || {
        echo "Missing dependency: $cmd" >&2
        exit 1
    }
done

mkdir -p results

echo "[1/5] Collecting system information..."
fastfetch --pipe > system_info.txt

echo "[2/5] Verifying text-generation output..."
./generate_lines.sh printf
cp test_output.txt printf_output.txt
./generate_lines.sh awk
diff -s printf_output.txt test_output.txt

echo "[3/5] Benchmarking text generation..."
hyperfine \
    --warmup 3 \
    --runs 15 \
    --export-csv benchmark_results.csv \
    './generate_lines.sh printf' \
    './generate_lines.sh awk'

echo "[4/5] Verifying file-search output..."
grep 'ERROR' data/search_data.txt > results/grep_matches.txt
awk '/ERROR/' data/search_data.txt > results/awk_matches.txt
diff -s results/grep_matches.txt results/awk_matches.txt

echo "Benchmarking file search..."
hyperfine \
    -N \
    --warmup 3 \
    --runs 20 \
    --export-csv results/search_benchmark_v2.csv \
    './search_grep.sh' \
    './search_awk.sh'

echo "[5/5] Generating existing benchmark report..."
./generate_report.sh

echo
echo "All benchmark experiments completed!"
echo "Text generation: benchmark_results.csv"
echo "File search: results/search_benchmark_v2.csv"
echo "System information: system_info.txt"
