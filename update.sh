#!/usr/bin/env bash

set -uo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ONLY=()
EXCLUDE=()

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Update Docker Compose services found in subdirectories.

Options:
  --only SERVICE...       Update only the specified services
  --exclude SERVICE...    Exclude the specified services
  -h, --help              Show this help

Examples:
  $(basename "$0")
  $(basename "$0") --only immich
  $(basename "$0") --only immich media
  $(basename "$0") --exclude media
  $(basename "$0") --exclude media ai
EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --only)
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                ONLY+=("$1")
                shift
            done
            ;;
        --exclude)
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                EXCLUDE+=("$1")
                shift
            done
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
done

contains() {
    local needle="$1"
    shift

    local item
    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done

    return 1
}

has_compose_file() {
    local dir="$1"

    [[ -f "$dir/compose.yml" ]] ||
    [[ -f "$dir/compose.yaml" ]] ||
    [[ -f "$dir/docker-compose.yml" ]] ||
    [[ -f "$dir/docker-compose.yaml" ]]
}

updated=()
failed=()
skipped=()

echo "Discovering Docker Compose projects in:"
echo "  $ROOT_DIR"
echo

for dir in "$ROOT_DIR"/*/; do
    [[ -d "$dir" ]] || continue

    service="$(basename "$dir")"

    # Ignore directories without a Compose file
    if ! has_compose_file "$dir"; then
        continue
    fi

    # --only filtering
    if (( ${#ONLY[@]} > 0 )) && ! contains "$service" "${ONLY[@]}"; then
        skipped+=("$service")
        continue
    fi

    # --exclude filtering
    if (( ${#EXCLUDE[@]} > 0 )) && contains "$service" "${EXCLUDE[@]}"; then
        skipped+=("$service")
        continue
    fi

    echo "============================================================"
    echo "Updating: $service"
    echo "============================================================"

    if (
        cd "$dir" &&
        docker compose pull &&
        docker compose up -d --remove-orphans
    ); then
        updated+=("$service")
        echo
        echo "✓ $service updated successfully"
    else
        failed+=("$service")
        echo
        echo "✗ $service FAILED" >&2
    fi

    echo
done

echo "============================================================"
echo "Summary"
echo "============================================================"

if (( ${#updated[@]} > 0 )); then
    echo "Updated: ${updated[*]}"
fi

if (( ${#skipped[@]} > 0 )); then
    echo "Skipped: ${skipped[*]}"
fi

if (( ${#failed[@]} > 0 )); then
    echo "Failed:  ${failed[*]}"
    exit 1
fi

echo
echo "All selected projects updated successfully."
