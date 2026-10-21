#!/usr/bin/env bash
# Build the KidTag presets from the fork at FORK_REF. Usage: build.sh [env...]
# Env: FORK_URL (default: bstaeheli/firmware), FORK_DIR (existing checkout to use).
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
FORK_URL=${FORK_URL:-https://github.com/bstaeheli/firmware.git}
FORK_DIR=${FORK_DIR:-$root/build/firmware}
ref=$(<"$root/FORK_REF")
version=$(git -C "$root" describe --tags --always 2>/dev/null || echo dev)
envs=("$@")
[ ${#envs[@]} -gt 0 ] || envs=(rak_wismeshtag_kidtag rak_wismeshtag_sos)

[ -d "$FORK_DIR/.git" ] || git clone "$FORK_URL" "$FORK_DIR"
git -C "$FORK_DIR" fetch --tags origin
git -C "$FORK_DIR" checkout -- platformio.ini # idempotent: drop a previous append
git -C "$FORK_DIR" checkout "$ref"
{ echo; cat "$root/config/kidtag.ini"; } >>"$FORK_DIR/platformio.ini"

rm -rf "$root/dist"
mkdir -p "$root/dist"
for e in "${envs[@]}"; do
    (cd "$FORK_DIR" && pio run -e "$e")
    uf2=$(find "$FORK_DIR/.pio/build/$e" -name 'firmware*.uf2' | head -n1)
    [ -n "$uf2" ] || { echo "no UF2 produced for $e" >&2; exit 1; }
    cp "$uf2" "$root/dist/kidtag-$e-$version.uf2"
done
(cd "$root/dist" && shasum -a 256 -- *.uf2 >SHA256SUMS)
