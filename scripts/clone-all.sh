#!/usr/bin/env bash
set -euo pipefail

# Propósito: Clona los repositorios con source_type=clone definidos en repos.json.
# Inputs: repos.json
# Outputs: Directorios en repos/<name>/ y archivos inventory/<name>/_meta/source.md

if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' no está instalado. Es necesario para procesar repos.json."
    exit 1
fi

REPOS_JSON="repos.json"

# Iterar sobre cada entrada en repos.json
jq -c '.[]' "$REPOS_JSON" | while read -r repo; do
    NAME=$(echo "$repo" | jq -r '.name')
    EXAMPLE=$(echo "$repo" | jq -r '._example // false')
    TYPE=$(echo "$repo" | jq -r '.source_type')

    if [ "$EXAMPLE" = "true" ]; then
        echo "Saltando ejemplo: $NAME"
        continue
    fi

    if [ "$TYPE" != "clone" ]; then
        continue
    fi

    URL=$(echo "$repo" | jq -r '.url')
    BRANCH=$(echo "$repo" | jq -r '.branch')
    REPO_PATH="repos/$NAME"

    if [ -d "$REPO_PATH" ]; then
        echo "El repositorio $NAME ya existe en $REPO_PATH. Saltando."
        continue
    fi

    echo "Clonando $NAME ($BRANCH) desde $URL..."
    mkdir -p "repos"
    git clone --branch "$BRANCH" --single-branch "$URL" "$REPO_PATH"

    # Generar inventory/<name>/_meta/source.md
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
