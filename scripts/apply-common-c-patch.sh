#!/bin/sh
# Applies the custom streaming port override patch to the moonlight-common-c
# submodule. See patches/README.md for details.
#
# This is idempotent: if the patch is already applied, it does nothing.

set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
SUBMODULE_DIR="$REPO_ROOT/moonlight-common-c/moonlight-common-c"
PATCH_FILE="$REPO_ROOT/patches/moonlight-common-c-custom-ports.patch"

if [ ! -d "$SUBMODULE_DIR/src" ]; then
    echo "error: moonlight-common-c submodule not initialized." >&2
    echo "Run: git submodule update --init --recursive" >&2
    exit 1
fi

if [ ! -f "$PATCH_FILE" ]; then
    echo "error: patch file not found at $PATCH_FILE" >&2
    exit 1
fi

# If the patch already applies in reverse, it's already present.
if git -C "$SUBMODULE_DIR" apply --reverse --check "$PATCH_FILE" >/dev/null 2>&1; then
    echo "Custom ports patch already applied to moonlight-common-c."
    exit 0
fi

echo "Applying custom ports patch to moonlight-common-c..."
git -C "$SUBMODULE_DIR" apply "$PATCH_FILE"
echo "Done."
