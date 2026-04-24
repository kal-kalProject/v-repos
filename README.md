# v-repos

Repositorio privado de inventario de código de Vortech.

## Qué es v-repos
`v-repos` es un workspace de ejecución para la Fase 1 del proceso de inventario. Aloja clones **read-only** de los repositorios a inventariar (sin dependencias instaladas) junto con sus artefactos de inventario generados por agentes de IA.

Para más detalles, consulta [.docs/repos-plan/README.md](.docs/repos-plan/README.md).

## Estructura
El repositorio se organiza siguiendo las especificaciones en [.docs/repos-plan/01-estructura-v-repos.md](.docs/repos-plan/01-estructura-v-repos.md):
- `repos/`: Fuentes a inventariar (`clone`, `mount`, o `loose`).
- `inventory/`: Artefactos producidos por los agentes de IA.
- `scripts/`: Herramientas bash para gestión de clones y validación.
- `repos.json`: Lista canónica de fuentes.

## Flujo de Trabajo
1. **Configuración:** Edita [repos.json](repos.json) eliminando las entradas de ejemplo y agregando los repositorios reales.
2. **Obtención:** Ejecuta `scripts/clone-all.sh` para clonar repositorios, o usa los helpers `scripts/mount-subdir.sh` / `scripts/add-loose.sh`.
3. **Validación:** Verifica que no haya contaminación de dependencias con `scripts/gate-no-deps.sh`.
4. **Inventario:** Lanza los agentes de IA siguiendo las instrucciones en [.docs/inventario/02-instrucciones-agentes.md](.docs/inventario/02-instrucciones-agentes.md).
5. **Cierre:** Al finalizar la Fase 1, los contenidos de `inventory/` se migran a `v-mono/inventory/`.

## Requisitos Locales
- `git`
- `bash` (Git Bash en Windows es suficiente)
- `jq` (para el procesamiento de `repos.json`)
- `rsync` (opcional, para `scripts/sync-docs.sh`)

Los toolchains específicos de los repositorios (`pnpm`, `cargo`, `dotnet`, etc.) **no son necesarios** en este entorno por diseño.

## Privacidad
**IMPORTANTE:** Este repositorio debe ser **PRIVADO** obligatoriamente, independientemente de si los repositorios clonados son públicos o privados.

