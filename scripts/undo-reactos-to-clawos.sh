#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BACKUP_ROOT=${BACKUP_ROOT:-"$REPO_ROOT/.backups/reactos-to-clawos-20260901-104825"}

if [[ ! -d "$BACKUP_ROOT" ]]; then
    echo "Backup directory not found: $BACKUP_ROOT" >&2
    exit 1
fi

restored=0
while IFS= read -r -d '' backup_file; do
    rel_path=${backup_file#"$BACKUP_ROOT"/}
    target_path="$REPO_ROOT/$rel_path"
    mkdir -p "$(dirname "$target_path")"
    cp -p "$backup_file" "$target_path"
    restored=$((restored + 1))
done < <(find "$BACKUP_ROOT" -type f -print0)

printf 'Restored %s files from %s\n' "$restored" "$BACKUP_ROOT"
