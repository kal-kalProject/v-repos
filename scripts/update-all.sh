#!/usr/bin/env bash
set -euo pipefail

# Propósito: git fetch + log resumen en todos los repos real clone.
# No mergea automáticamente.

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' no está instalado."
    exit 1
fi

jq -c '.[]' repos.json | while read -r repo; do
    NAME=$(echo "$repo" | jq -r '.name')
    EXAMPLE=$(echo "$repo" | jq -r '._example // false')
    TYPE=$(echo "$repo" | jq -r '.source_type')

    if [ "$EXAMPLE" = "true" ] || [ "$TYPE" != "clone" ]; then
        continue
    fi

    REPO_PATH="repos/$NAME"
    BRANCH=$(echo "$repo" | jq -r '.branch')

    if [ -d "$REPO_PATH" ]; then
        echo "--- Actualizando $NAME ---"
        git -C "$REPO_PATH" fetch
        DIFF_COUNT=$(git -C "$REPO_PATH" rev-list --count HEAD..origin/"$BRANCH")
        if [ "$DIFF_COUNT" -gt 0 ]; then
            echo "Hay $DIFF_COUNT commits nuevos en origin/$BRANCH:"
            git -C "$REPO_PATH" log --oneline HEAD..origin/"$BRANCH"
        else
            echo "Al día."
        fi
    fi
done
