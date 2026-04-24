#!/usr/bin/env bash
set -euo pipefail

# Propósito: Helper para crear una entrada source_type=mount.
# Uso: ./scripts/mount-subdir.sh --parent <parent-name> --from <path-relativo> --as <new-name>

PARENT=""
FROM=""
AS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --parent) PARENT="$2"; shift 2 ;;
        --from) FROM="$2"; shift 2 ;;
        --as) AS="$2"; shift 2 ;;
        *) echo "Opción desconocida: $1"; exit 1 ;;
    esac
done

if [ -z "$PARENT" ] || [ -z "$FROM" ] || [ -z "$AS" ]; then
    echo "Uso: $0 --parent <parent-repo-name> --from <subdir-relativo-en-parent> --as <nuevo-name>"
    exit 1
fi

PARENT_PATH="repos/$PARENT"
TARGET_PATH="repos/$AS"

if [ ! -d "$PARENT_PATH" ]; then
    echo "Error: El repo padre $PARENT_PATH no existe."
    exit 1
fi

SHA=$(git -C "$PARENT_PATH" rev-parse HEAD)
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Montando $AS desde $PARENT/$FROM..."
mkdir -p "$TARGET_PATH"
cp -r "$PARENT_PATH/$FROM/." "$TARGET_PATH/"

# Generar source.md
META_DIR="inventory/$AS/_meta"
mkdir -p "$META_DIR"

cat <<EOF > "$META_DIR/source.md"
---
kind: source-reference
repo_name: $AS
source_type: mount
source_url: null
source_branch: null
source_commit: null
cloned_at: null
parent_repo: $PARENT
parent_repo_commit: $SHA
mounted_from: $FROM
mounted_at: $NOW
agent_that_cloned: "manual"
---

# Referencia de origen — $AS (mount)

Este es un mount: copia de $FROM dentro de $PARENT en el commit $SHA.
EOF

# Emitir JSON por stdout
echo "--- COPIA ESTO EN repos.json ---"
cat <<EOF
{
  "name": "$AS",
  "source_type": "mount",
  "mounted_from": "$FROM",
  "parent_repo": "$PARENT",
  "parent_repo_commit": "$SHA",
  "notes": "Montado desde $PARENT subdirectorio $FROM"
}
EOF
