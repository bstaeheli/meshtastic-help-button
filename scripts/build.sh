#!/usr/bin/env bash
# Build the Help Button preset from the fork at FORK_REF. Usage: build.sh [env...]
# Env: FORK_URL (default: bstaeheli/firmware), FORK_DIR (existing checkout to use).
# Custom parameters (all validated): HB_HELP_TEXT, HB_SOS_TEXT, HB_OK_TEXT (1-40 chars of
# A-Za-z0-9.,!?-), HB_HOLD_SECS (1-60), HB_OFF_SECS (2-65, > hold), HB_RATE_SECS (1-3600),
# HB_VERSION (overrides the git-describe version in file names).
set -euo pipefail
shopt -s nullglob

root=$(cd "$(dirname "$0")/.." && pwd)
FORK_URL=${FORK_URL:-https://github.com/bstaeheli/firmware.git}
FORK_DIR=${FORK_DIR:-$root/build/firmware}
ref=$(<"$root/FORK_REF")
version=${HB_VERSION:-$(git -C "$root" describe --tags --always 2>/dev/null || echo dev)}
version=${version#v}
upstream=$(<"$root/UPSTREAM_VERSION")
upstream=${upstream#v}
envs=("$@")
[ ${#envs[@]} -gt 0 ] || envs=(rak_wismeshtag_sos tracker-t1000-e_sos)

help=${HB_HELP_TEXT:-HELP}
sos=${HB_SOS_TEXT:-SOS}
ok=${HB_OK_TEXT:-OK}
hold=${HB_HOLD_SECS:-3}
off=${HB_OFF_SECS:-10}
rate=${HB_RATE_SECS:-30}
die() { echo "error: $*" >&2; exit 2; }
for t in help sos ok; do
    [[ ${!t} =~ ^[A-Za-z0-9.,!?-]{1,40}$ ]] || die "$t text must be 1-40 chars of A-Za-z0-9.,!?-"
done
for n in hold off rate; do
    [[ ${!n} =~ ^[0-9]{1,5}$ ]] || die "$n must be an integer"
done
((hold >= 1 && hold <= 60)) || die "hold_secs must be 1-60"
((off >= 2 && off <= 65)) || die "off_secs must be 2-65"
((hold < off)) || die "hold_secs must be smaller than off_secs"
((rate >= 1 && rate <= 3600)) || die "rate_secs must be 1-3600"
preset=$(<"$root/config/help-button.ini")
preset=${preset//@HELP_TEXT@/$help}
preset=${preset//@SOS_TEXT@/$sos}
preset=${preset//@OK_TEXT@/$ok}
preset=${preset//@HOLD_MS@/$((hold * 1000))}
preset=${preset//@OFF_MS@/$((off * 1000))}
preset=${preset//@RATE_SECS@/$rate}

[ -d "$FORK_DIR/.git" ] || git clone "$FORK_URL" "$FORK_DIR"
git -C "$FORK_DIR" cat-file -e "$ref^{commit}" 2>/dev/null || git -C "$FORK_DIR" fetch --tags origin
git -C "$FORK_DIR" checkout -- platformio.ini # idempotent: drop a previous append
git -C "$FORK_DIR" checkout "$ref"
trap 'git -C "$FORK_DIR" checkout -- platformio.ini' EXIT
{ echo; echo "$preset"; } >>"$FORK_DIR/platformio.ini"

rm -rf "$root/dist"
mkdir -p "$root/dist"
for e in "${envs[@]}"; do
    (cd "$FORK_DIR" && pio run -e "$e")
    uf2=$(find "$FORK_DIR/.pio/build/$e" -name 'firmware*.uf2' | head -n1)
    [ -n "$uf2" ] || { echo "no UF2 produced for $e" >&2; exit 1; }
    cp "$uf2" "$root/dist/help-button-$version-mt$upstream-$e.uf2"
    # nRF52 targets also produce the DFU package for over-the-air updates
    zip=$(find "$FORK_DIR/.pio/build/$e" -maxdepth 1 -name 'firmware*.zip' | head -n1)
    [ -z "$zip" ] || cp "$zip" "$root/dist/help-button-$version-mt$upstream-$e-ota.zip"
done
(cd "$root/dist" && shasum -a 256 -- *.uf2 *.zip >SHA256SUMS)
