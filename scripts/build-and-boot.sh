#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
BUILD_DIR=${BUILD_DIR:-"${REPO_ROOT}-build-release"}
BUILD_LOG=${BUILD_LOG:-"${BUILD_DIR}/build.log"}
ISO_PATH=${ISO_PATH:-"${BUILD_DIR}/bootcd.iso"}
SERIAL_LOG=${SERIAL_LOG:-/tmp/clawos-serial.log}
QEMU_TIMEOUT=${QEMU_TIMEOUT:-60s}
QEMU_MEMORY=${QEMU_MEMORY:-512}

usage() {
    cat <<'EOF'
Usage: build-and-boot.sh [build|boot|all]

Defaults to "all":
  - rebuild bootcd
  - boot the resulting bootcd.iso in QEMU

Environment overrides:
  BUILD_DIR=/path/to/build
  BUILD_LOG=/path/to/build.log
  ISO_PATH=/path/to/bootcd.iso
  SERIAL_LOG=/path/to/serial.log
  QEMU_TIMEOUT=60s
  QEMU_MEMORY=512
EOF
}

mode=${1:-all}
case "$mode" in
    -h|--help|help)
        usage
        exit 0
        ;;
    build|boot|all)
        ;;
    *)
        echo "Unknown mode: $mode" >&2
        usage >&2
        exit 1
        ;;
esac

build_iso() {
    if [[ ! -d "$BUILD_DIR" ]]; then
        echo "Build directory not found: $BUILD_DIR" >&2
        exit 1
    fi

    mkdir -p "$(dirname "$BUILD_LOG")"
    (
        cd "$BUILD_DIR"
        PATH=/usr/bin:/bin:/usr/sbin:/sbin ninja bootcd
    ) 2>&1 | tee -a "$BUILD_LOG"
}

boot_iso() {
    if [[ ! -f "$ISO_PATH" ]]; then
        echo "ISO not found: $ISO_PATH" >&2
        exit 1
    fi

    rm -f "$SERIAL_LOG"
    timeout "$QEMU_TIMEOUT" qemu-system-i386 \
        -m "$QEMU_MEMORY" \
        -cdrom "$ISO_PATH" \
        -boot d \
        -display curses \
        -serial file:"$SERIAL_LOG" \
        -monitor none \
        -no-reboot
}

case "$mode" in
    build)
        build_iso
        ;;
    boot)
        boot_iso
        ;;
    all)
        build_iso
        boot_iso
        ;;
esac
