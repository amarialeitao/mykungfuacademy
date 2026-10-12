#!/usr/bin/env bash
# Build the submission zip for a delivery: tools/package.sh D1
# Output: dist/IBD2627_<Dx>_Group12.zip, containing only the files the brief requires.
set -euo pipefail
D="${1:?usage: package.sh D1|D2|D3|D4}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NAME="IBD2627_${D}_Group12"
SRC="$ROOT/deliveries/$D"
case "$D" in
  D1) FILES=("report/report.pdf" "er/model.drawio") ;;
  *)  echo "Package list for $D not defined yet" >&2; exit 1 ;;
esac
STAGE="$(mktemp -d)"; trap 'rm -rf "$STAGE"' EXIT
mkdir -p "$STAGE/$NAME" "$ROOT/dist"
for f in "${FILES[@]}"; do
  [ -f "$SRC/$f" ] || { echo "Missing required file: $SRC/$f" >&2; exit 1; }
  cp "$SRC/$f" "$STAGE/$NAME/"
done
mv "$STAGE/$NAME/report.pdf" "$STAGE/$NAME/${NAME}_report.pdf"
mv "$STAGE/$NAME/model.drawio" "$STAGE/$NAME/${NAME}_ER.drawio"
rm -f "$ROOT/dist/$NAME.zip"
(cd "$STAGE" && python3 -c "import shutil,sys; shutil.make_archive(sys.argv[1], 'zip', '.', sys.argv[2])" "$ROOT/dist/$NAME" "$NAME")
echo "Built dist/$NAME.zip:"; python3 -m zipfile -l "$ROOT/dist/$NAME.zip"
