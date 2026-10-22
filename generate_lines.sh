#!/usr/bin/env bash
set -euo pipefail

method="${1:-printf}"
output="test_output.txt"

case "$method" in
  printf)
    for ((i=1; i<=10000; i++)); do
      printf 'Garuda Linux line %d\n' "$i"
    done > "$output"
    ;;
  awk)
    awk 'BEGIN {
      for (i=1; i<=10000; i++)
        printf "Garuda Linux line %d\n", i
    }' > "$output"
    ;;
  *)
    echo "Usage: $0 [printf|awk]" >&2
    exit 1
    ;;
esac
