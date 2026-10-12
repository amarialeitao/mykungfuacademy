#!/usr/bin/env bash
# Build a delivery report: tools/report/build.sh D1
# Converts deliveries/<Dx>/report/report.md to report.pdf and prints the page count.
set -euo pipefail
D="${1:?usage: build.sh D1|D2|D3|D4}"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT/deliveries/$D/report"
pandoc report.md -o report.pdf \
  --pdf-engine=xelatex \
  --number-sections \
  --include-in-header="$ROOT/tools/report/header.tex" \
  -V geometry:a4paper,margin=1.8cm \
  -V fontsize=10pt \
  -V mainfont="DejaVu Serif" -V monofont="DejaVu Sans Mono" \
  -V colorlinks=true -V linkcolor=blue
if command -v pdfinfo >/dev/null; then
  echo "Pages: $(pdfinfo report.pdf | awk '/^Pages:/ {print $2}') (limit 10)"
fi
