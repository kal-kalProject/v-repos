#!/usr/bin/env bash
set -euo pipefail

# Propósito: Helper para crear una entrada source_type=loose.
# Uso: ./scripts/add-loose.sh --from <path-absoluto> --as <name>

FROM=""
AS=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --from) FROM="$2"; shift 2 ;;
        --as) AS="$2"; shift 2 ;;
        *) echo "Opción desconocida: $1"; exit 1 ;;
    esac
done

if [ -z "$FROM" ] || [ -z "$AS" ]; then
    echo "Uso: $0 --from <path-absoluto> --as <name>"
    exit 1
fi

TARGET_PATH="repos/$AS"
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Agregando loose repo $AS desde $FROM..."
mkdir -p "$TARGET_PATH"
cp -r "$FROM/." "$TARGET_PATH/"

# Generar source.md
META_DIR="inventory/$AS/_meta"
mkdir -p "$META_DIR"

cat <<EOF > "$META_DIR/source.md"
---
kind: source-reference
repo_name: $AS
source_type: loose
source_url: null
source_branch: null
source_commit: null
cloned_at: null
parent_repo: null
parent_repo_commit: null
mounted_from: $FROM
mounted_at: $NOW
agent_that_cloned: "manual"
---

# Referencia de origen — $AS (loose)

Código sin historia Git. Copiado desde $FROM el $NOW.
EOF

# Emitir JSON por stdout
echo "--- COPIA ESTO EN repos.json ---"
cat <<EOF
{
  "name": "$AS",
  "source_type": "loose",
  "mounted_from": "$FROM",
  "notes": "Código loose copiado desde $FROM"
}
EOF
