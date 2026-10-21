#!/usr/bin/env bash
# Regenerate patches/ from the fork checkout (FORK_DIR, default build/firmware).
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
FORK_DIR=${FORK_DIR:-$root/build/firmware}

rm -f "$root"/patches/*.patch
git -C "$FORK_DIR" format-patch -o "$root/patches" "$(<"$root/UPSTREAM_VERSION")..$(<"$root/FORK_REF")"
