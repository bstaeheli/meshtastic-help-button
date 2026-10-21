#!/usr/bin/env bash
# Rebase the fork branch onto a new upstream tag. Does not push.
# Usage: rebase.sh <new-upstream-tag>   Env: FORK_DIR, FORK_BRANCH
set -euo pipefail

[ $# -eq 1 ] || { echo "usage: $0 <new-upstream-tag>" >&2; exit 2; }
root=$(cd "$(dirname "$0")/.." && pwd)
FORK_DIR=${FORK_DIR:-$root/build/firmware}
FORK_BRANCH=${FORK_BRANCH:-feature/user-button-actions}
new=$1
old=$(<"$root/UPSTREAM_VERSION")

git -C "$FORK_DIR" remote get-url upstream >/dev/null 2>&1 ||
    git -C "$FORK_DIR" remote add upstream https://github.com/meshtastic/firmware.git
git -C "$FORK_DIR" fetch upstream --tags
git -C "$FORK_DIR" checkout "$FORK_BRANCH"
if ! git -C "$FORK_DIR" rebase --onto "$new" "$old" "$FORK_BRANCH"; then
    echo "Conflicts in:" >&2
    git -C "$FORK_DIR" diff --name-only --diff-filter=U >&2
    echo "Resolve in $FORK_DIR, then 'git rebase --continue'." >&2
    exit 1
fi
echo "Rebased onto $new. Update UPSTREAM_VERSION and FORK_REF, then push manually."
