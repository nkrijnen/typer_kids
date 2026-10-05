#!/usr/bin/env bash
set -o pipefail

repo_root="$(CDPATH= cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
log_dir="$repo_root/run-logs"
mkdir -p "$log_dir"
log_file="$log_dir/macos-$(date +%Y%m%d-%H%M%S)-$$.log"

cd "$repo_root"
printf 'Logging macOS run to %s\n' "$log_file"
flutter run -d macos "$@" 2>&1 | tee "$log_file"
