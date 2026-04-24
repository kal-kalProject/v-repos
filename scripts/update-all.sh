#!/usr/bin/env bash
set -euo pipefail

# Propósito: git fetch + log resumen en todos los repos real clone.
# No mergea automáticamente.
# Dependencias: git, python

json_get() {
    python -c "
import json, sys
obj = json.loads(sys.argv[1])
val = obj.get(sys.argv[2])
print(val if val is not None else sys.argv[3])
" "$1" "$2" "${3:-}"
}

mapfile -t REPOS < <(python -c "
import json, sys
data = json.load(open(sys.argv[1]))
for item in data:
    print(json.dumps(item, ensure_ascii=False))
" repos.json)

for repo in "${REPOS[@]}"; do
    NAME=$(json_get "$repo" "name" "")
    EXAMPLE=$(json_get "$repo" "_example" "false")
    TYPE=$(json_get "$repo" "source_type" "")

    if [ "$EXAMPLE" = "true" ] || [ "$TYPE" != "clone" ]; then
        continue
    fi

    REPO_PATH="repos/$NAME"
    BRANCH=$(json_get "$repo" "branch" "main")

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
