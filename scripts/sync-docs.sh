#!/usr/bin/env bash
set -euo pipefail

# Propósito: Sincroniza .docs/ desde v-mono.
# Uso: ./scripts/sync-docs.sh <ruta-v-mono>

if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <ruta-absoluta-a-v-mono>"
    exit 1
fi

V_MONO_PATH="$1"

if [ ! -d "$V_MONO_PATH/.docs/repos-plan" ]; then
    echo "Error: La ruta provista no parece ser un checkout de v-mono válido."
    exit 1
fi

SHA=$(git -C "$V_MONO_PATH" rev-parse HEAD)
NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Sincronizando .docs desde $V_MONO_PATH (SHA: $SHA)..."

# rsync es preferible, si no está disponible se podría usar cp -r
if command -v rsync &> /dev/null; then
    rsync -av --delete "$V_MONO_PATH/.docs/" ".docs/"
else
    echo "rsync no encontrado, usando cp..."
    rm -rf .docs/
    cp -r "$V_MONO_PATH/.docs/" ".docs/"
fi

# Inyectar SHA en .docs/README.md
# Se asume formato especificado en .docs/repos-plan/01-estructura-v-repos.md §10
# (Este script debe adaptarse si el formato exacto de inyección cambia)

HEADER_BLOCK="<!-- sync-meta -->\n- **Source:** v-mono\n- **Source Commit:** $SHA\n- **Synced At:** $NOW\n<!-- /sync-meta -->"

# Intentar insertar o reemplazar el bloque de cabecera en .docs/README.md
# Por simplicidad en este setup, lo añadimos al principio si no existe o lo reemplazamos.
if grep -q "<!-- sync-meta -->" .docs/README.md; then
    # Reemplazo multilínea con sed es complejo; usamos un approach más directo
    perl -i -0777 -pe "s/<!-- sync-meta -->.*?<!-- \/sync-meta -->/$(echo -e $HEADER_BLOCK)/gs" .docs/README.md
else
    echo -e "$HEADER_BLOCK\n\n$(cat .docs/README.md)" > .docs/README.md
fi

echo "Sincronización completa."
