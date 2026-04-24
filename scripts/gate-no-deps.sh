#!/usr/bin/env bash
set -euo pipefail

# Propósito: Busca directorios de dependencias o builds prohibidos en repos/.
# Retorna exit 1 si encuentra contaminación real.
#
# Regla: un directorio con nombre "prohibido" (p.ej. build/, dist/, target/) solo
# es violación si NO está trackeado por git. Si git lo trackea, es fuente
# legítima del repo (muchos proyectos usan build/ para scripts MSBuild,
# dist/ para artefactos versionados, etc.).
#
# Para repos sin .git/ (source_type: mount | loose) se reporta siempre
# porque no hay forma estática de distinguir source de contaminación.
# Esos casos se anotan en inventory/<name>/_meta/source.md si son intencionales.

echo "Verificando limpieza de dependencias en repos/..."

FORBIDDEN=(
    "node_modules" "target" "bin" "obj" ".venv" "venv"
    ".pio" "vcpkg_installed" "dist" "build" "out"
    ".next" ".nuxt" "__pycache__"
)

FOUND=()

# is_git_tracked_dir <repo-root> <dir-abs-path>
# Devuelve 0 si el directorio contiene al menos un archivo trackeado por git.
is_git_tracked_dir() {
    local repo_root="$1"
    local dir="$2"
    local rel="${dir#"$repo_root"/}"
    if [ -d "$repo_root/.git" ] || [ -f "$repo_root/.git" ]; then
        local tracked
        tracked=$(git -C "$repo_root" ls-files -- "$rel" 2>/dev/null | head -n1)
        if [ -n "$tracked" ]; then
            return 0
        fi
    fi
    return 1
}

# find_repo_root <path>
# Devuelve "repos/<name>" para cualquier path dentro de un repo clonado.
find_repo_root() {
    local p="$1"
    p="${p#./}"
    local rest="${p#repos/}"
    local first="${rest%%/*}"
    echo "repos/$first"
}

for pattern in "${FORBIDDEN[@]}"; do
    while IFS= read -r -d '' dir; do
        if [[ "$dir" == *"src/bin"* ]]; then
            continue
        fi

        repo_root=$(find_repo_root "$dir")

        if is_git_tracked_dir "$repo_root" "$dir"; then
            continue
        fi

        FOUND+=("$dir")
    done < <(find repos -type d -name "$pattern" -print0 2>/dev/null)
done

if [ ${#FOUND[@]} -gt 0 ]; then
    echo "ERROR: Se encontraron directorios prohibidos (no trackeados por git):"
    for f in "${FOUND[@]}"; do
        echo "  - $f"
    done
    echo
    echo "Si alguno de estos es fuente legitima de un repo source_type=mount o loose,"
    echo "documenta la excepcion en inventory/<name>/_meta/source.md y ajusta este script."
    exit 1
fi

echo "Limpieza validada. OK."
exit 0
