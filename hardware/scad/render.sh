#!/usr/bin/env bash
# Рендер всех деталей в STL (hardware/stl/) и PNG-превью (hardware/stl/preview/).
# Использование: ./render.sh [имя_детали ...]   (без аргументов — все)
set -euo pipefail
cd "$(dirname "$0")"
out="../stl"; prev="$out/preview"
mkdir -p "$out" "$prev"

parts=("$@")
if [ ${#parts[@]} -eq 0 ]; then
    parts=(test_rings plug_a plug_b o2_chamber cap_scd30 cap_ze07)
fi

for p in "${parts[@]}"; do
    echo "== $p"
    openscad --backend Manifold -o "$out/$p.stl" "$p.scad"
    openscad --backend Manifold -o "$prev/$p.png" --autocenter --viewall --imgsize=1200,900 \
        --colorscheme Tomorrow "$p.scad" 2>/dev/null
done
echo "STL: $out/   превью: $prev/"
