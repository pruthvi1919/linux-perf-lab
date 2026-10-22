#!/usr/bin/env bash
set -euo pipefail
awk '/ERROR/' data/search_data.txt > /dev/null
