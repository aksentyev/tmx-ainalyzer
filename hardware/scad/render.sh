#!/usr/bin/env bash
# Рендер всех деталей в STL (hardware/stl/) и PNG-превью (hardware/stl/preview/).
# Пробки — во всех вариантах зазора из plug_fits (plug_a_f02.stl, plug_a_f04.stl, ...).
# Использование: ./render.sh [имя_детали ...]   (без аргументов — все)
set -euo pipefail
cd "$(dirname "$0")"
out="../stl"; prev="$out/preview"
mkdir -p "$out" "$prev"
OS="openscad --backend Manifold --export-format binstl"

parts=("$@")
if [ ${#parts[@]} -eq 0 ]; then
    parts=(test_rings plug_a plug_b o2_chamber cap_scd30 cap_ze07)
fi

fits=$(openscad -o /dev/stdout --export-format echo -D 'echo(plug_fits);' params.scad 2>/dev/null \
       | sed -n 's/.*ECHO: \[\(.*\)\].*/\1/p' | tr -d ' ' | tr ',' ' ')
[ -n "$fits" ] || fits="0.2 0.4 0.6"

for p in "${parts[@]}"; do
    echo "== $p"
    case "$p" in
        plug_a|plug_b)
            for f in $fits; do
                tag=$(printf 'f%02d' "$(echo "$f*10" | bc | cut -d. -f1)")
                $OS -D "plug_fit=$f" -o "$out/${p}_$tag.stl" "$p.scad"
            done
            ;;
        *)
            $OS -o "$out/$p.stl" "$p.scad"
            ;;
    esac
    openscad --backend Manifold -o "$prev/$p.png" --autocenter --viewall --imgsize=1200,900 \
        --colorscheme Tomorrow "$p.scad"
done
echo "STL: $out/   превью: $prev/"
