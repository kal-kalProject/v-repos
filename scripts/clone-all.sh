#!/usr/bin/env bash
set -euo pipefail

# Propósito: Clona los repositorios con source_type=clone definidos en repos.json.
# Inputs: repos.json
# Outputs: Directorios en repos/<name>/ y archivos inventory/<name>/_meta/source.md
# Dependencias: git, python (para parsear JSON)

REPOS_JSON="repos.json"

# Extrae campos de un objeto JSON usando python (sin jq).
json_get() {
    local json="$1" field="$2" default="${3:-}"
    python -c "
import json, sys
obj = json.loads(sys.argv[1])
val = obj.get(sys.argv[2])
print(val if val is not None else sys.argv[3])
" "$json" "$field" "$default"
}

# Lee cada objeto del array como una línea JSON.
mapfile -t REPOS < <(python -c "
import json, sys
data = json.load(open(sys.argv[1]))
for item in data:
    print(json.dumps(item, ensure_ascii=False))
" "$REPOS_JSON")

for repo in "${REPOS[@]}"; do
    NAME=$(json_get "$repo" "name" "")
    EXAMPLE=$(json_get "$repo" "_example" "false")
    TYPE=$(json_get "$repo" "source_type" "")

    if [ "$EXAMPLE" = "true" ]; then
        echo "Saltando ejemplo: $NAME"
        continue
    fi

    if [ "$TYPE" != "clone" ]; then
        continue
    fi

    URL=$(json_get "$repo" "url" "")
    BRANCH=$(json_get "$repo" "branch" "main")
    REPO_PATH="repos/$NAME"

    if [ -d "$REPO_PATH" ]; then
        echo "El repositorio $NAME ya existe en $REPO_PATH. Saltando."
        continue
    fi

    echo "Clonando $NAME ($BRANCH) desde $URL..."
    mkdir -p "repos"
    git clone --branch "$BRANCH" --single-branch "$URL" "$REPO_PATH"

    SHA=$(git -C "$REPO_PATH" rev-parse HEAD)
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    META_DIR="inventory/$NAME/_meta"
    mkdir -p "$META_DIR"

    cat <<EOF > "$META_DIR/source.md"
---
kind: source-reference
repo_name: $NAME
source_type: clone
source_url: $URL
source_branch: $BRANCH
source_commit: $SHA
cloned_at: $NOW
parent_repo: null
parent_repo_commit: null
mounted_from: null
mounted_at: null
agent_that_cloned: "script:clone-all"
---

# Referencia de origen — $NAME

Este inventario fue producido contra el estado del repo en el commit indicado arriba.
Cualquier afirmación en los artefactos se refiere a ese snapshot.
EOF

    echo "Finalizado: $NAME en commit $SHA"
done
