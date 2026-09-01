#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

exec bash "$SCRIPT_DIR/scripts/build-and-boot.sh" "${1:-build}"
cp ../reactos-clawos-build-release/bootcd.iso ~/ecraft/
