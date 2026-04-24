#!/usr/bin/env bash
set -euo pipefail

# Propósito: Actualiza source_commit en inventory/<name>/_meta/source.md con el SHA actual del HEAD.
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
    SOURCE_MD="inventory/$NAME/_meta/source.md"

    if [ ! -d "$REPO_PATH" ]; then
        echo "Advertencia: repos/$NAME no existe, saltando."
        continue
    fi

    SHA=$(git -C "$REPO_PATH" rev-parse HEAD)
    echo "Actualizando SHA para $NAME: $SHA"

    if [ -f "$SOURCE_MD" ]; then
        # Actualiza el campo source_commit en el frontmatter existente
        sed -i "s/source_commit: .*/source_commit: $SHA/" "$SOURCE_MD"
    else
        # Crea source.md si no existe
        URL=$(json_get "$repo" "url" "")
        BRANCH=$(json_get "$repo" "branch" "main")
        NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
        META_DIR="inventory/$NAME/_meta"
        mkdir -p "$META_DIR"
        cat <<EOF > "$SOURCE_MD"
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
agent_that_cloned: "script:snapshot-shas"
---

# Referencia de origen — $NAME

Este inventario fue producido contra el estado del repo en el commit indicado arriba.
Cualquier afirmación en los artefactos se refiere a ese snapshot.
EOF
        echo "Creado source.md para $NAME"
    fi
done
