# 04 — Prompt de inicialización de `v-repos`

Prompt listo para entregar a un agente (Copilot, Claude, Gemini, Codex, etc.) que opere dentro de un checkout de `v-repos` ya creado y con `v-repos/.docs/` copiado desde `v-mono/.docs/`.

El agente debe crear la estructura base, los scripts, y un `repos.json` de ejemplo con una entrada de cada `source_type` — pero **no** debe clonar nada ni agregar repos reales. Eso lo hace el usuario después.

---

## Cómo usar este prompt

1. Abrir el workspace `v-repos/` en el IDE.
2. Iniciar una sesión con el agente.
3. Copiar el bloque "PROMPT PARA EL AGENTE" de abajo literal.
4. Revisar los archivos creados. Ajustar `repos.json` con los repos reales.
5. Ejecutar `scripts/clone-all.sh` cuando el `repos.json` esté listo.

---

## PROMPT PARA EL AGENTE

> **Rol:** eres un agente de setup. Operas dentro de un checkout de `v-repos` vacío (salvo `.docs/` ya copiado desde `v-mono/.docs/`). Tu tarea es crear la estructura base siguiendo exactamente lo especificado en `.docs/repos-plan/01-estructura-v-repos.md` y `.docs/repos-plan/02-mitigaciones.md`.
>
> **Reglas no negociables:**
> 1. **Lee primero** `.docs/repos-plan/01-estructura-v-repos.md` y `.docs/repos-plan/02-mitigaciones.md` completos antes de crear nada. Si hay contradicción entre este prompt y esos docs, gana el doc.
> 2. **No clones ningún repo real.** Solo creas estructura, scripts y un `repos.json` con entradas de ejemplo claramente marcadas.
> 3. **No instales dependencias de nada.** Ni pnpm, ni cargo, ni nada.
> 4. **No ejecutes los scripts que creas.** Solo los dejas listos para que el usuario los ejecute.
> 5. **Todos los scripts son bash (`.sh`)** con shebang `#!/usr/bin/env bash`, `set -euo pipefail`, y compatibilidad Windows vía Git Bash / WSL. Si necesitas utilidades Windows-nativas paralelas (`.ps1`), créalas como opcionales con nombre `.ps1` pero el default son los `.sh`.
> 6. **No crees ni sobrescribas los archivos de customización de IDE/agentes** listados en la sección "Archivos provistos por el usuario" de abajo. Solo verificas su existencia y avisas si faltan.
> 7. **Confirmación al final:** termina listando todos los archivos creados con su propósito en una línea, el estado de los archivos provistos por el usuario, y las 3 acciones que el usuario debe hacer a continuación.
>
> **Archivos provistos por el usuario (NO crear, NO sobrescribir):**
>
> Los siguientes archivos los copia el usuario manualmente desde `.docs/repos-plan/templates/` (ver `.docs/repos-plan/templates/README.md`). Tu tarea con ellos es únicamente **verificar que existen** y reportar su estado. Si faltan, **no los crees**: avisa al usuario que los copie desde `templates/`.
>
> - `.github/copilot-instructions.md`
> - `.github/agents/inventario.agent.md`
> - `.github/agents/post-inventario.agent.md`
> - `.vscode/settings.json`
> - `.vscode/tasks.json`
> - `.cursor/rules/workspace.mdc`
> - `.cursor/rules/inventario.mdc`
> - `.cursor/rules/post-inventario.mdc`
>
> Razón: estos archivos son fuente de verdad en `v-mono/.docs/repos-plan/templates/` y tienen contenido ya aprobado. Regenerarlos desde cero introduciría drift respecto a la fuente canónica.
>
> **Archivos a crear:**
>
> ### Raíz
>
> - `README.md` — introducción breve (qué es `v-repos`, referencia a `.docs/repos-plan/`), resumen del flujo (1. editar `repos.json`, 2. ejecutar `clone-all.sh`, 3. lanzar agentes de inventario), privacidad (repo privado obligatorio), y punteros a `.docs/repos-plan/README.md` para detalles.
> - `.gitignore` — exactamente el bloque de patrones de `.docs/repos-plan/01-estructura-v-repos.md §4`, sin adiciones ni omisiones, con comentarios por toolchain.
> - `.gitattributes` — una sola regla: `* text=auto eol=lf`.
> - `repos.json` — array JSON con **tres entradas de ejemplo** (una por `source_type`), cada una marcada como ejemplo con un campo `"_example": true` y un `"notes"` explicando qué hace. Ver sección "Contenido de `repos.json`" más abajo.
>
> ### Directorios vacíos con `.gitkeep`
>
> - `repos/.gitkeep`
> - `inventory/.gitkeep`
> - `inventory/_global/.gitkeep`
>
> No crear subdirectorios de inventario por adelantado (se crean cuando cada repo se inventaría).
>
> ### `scripts/`
>
> Cada script con shebang, `set -euo pipefail`, comentarios de cabecera explicando propósito, inputs y outputs. Idempotentes.
>
> - `scripts/clone-all.sh` — lee `repos.json`, filtra entradas con `"_example": true` (las salta con warning), para cada `source_type: clone` real: si `repos/<name>/` no existe, clona; si existe, reporta y salta. Al terminar cada clone exitoso, genera/actualiza `inventory/<name>/_meta/source.md` con el formato de `.docs/repos-plan/01-estructura-v-repos.md §5` para `source_type: clone`. Usa `jq` para parsear JSON — si `jq` no está instalado, falla con mensaje claro.
> - `scripts/update-all.sh` — para cada `source_type: clone` real en `repos.json`: `git fetch` en `repos/<name>/`, luego `git log --oneline HEAD..origin/<branch>`. Solo reporta; no mergea.
> - `scripts/snapshot-shas.sh` — para cada `source_type: clone` real, lee el SHA actual del HEAD de `repos/<name>/` y actualiza el campo `source_commit` de `inventory/<name>/_meta/source.md`. Si el archivo no existe, lo crea.
> - `scripts/gate-no-deps.sh` — recorre `repos/` y busca cualquier ocurrencia de los patrones: `node_modules`, `target`, `bin`, `obj`, `.venv`, `venv`, `.pio`, `vcpkg_installed`, `dist`, `build`, `out`, `.next`, `.nuxt`, `__pycache__`. Si encuentra alguno (excluyendo falsos positivos obvios como `src/bin/mod.rs` — chequea solo directorios, no archivos), falla con exit 1 listando los paths. Exit 0 si todo limpio.
> - `scripts/sync-docs.sh` — recibe como argumento una ruta local a un checkout de `v-mono`. Copia `<v-mono-path>/.docs/` → `v-repos/.docs/` con rsync (o robocopy en Windows). Antes de copiar, lee el SHA de `v-mono` (`git -C <v-mono-path> rev-parse HEAD`) y lo inyecta en el bloque de cabecera de `v-repos/.docs/README.md` según el formato de `.docs/repos-plan/01-estructura-v-repos.md §10`. Valida que el argumento apunte a un repo cuyo remote sea `v-mono` (heurística simple: existe `<path>/.docs/repos-plan/`).
> - `scripts/mount-subdir.sh` — helper para crear entradas `source_type: mount`. Argumentos: `--parent <parent-repo-name>`, `--from <subdir-relativo-en-parent>`, `--as <nuevo-name>`. Copia `repos/<parent>/<subdir>/` → `repos/<nuevo-name>/`, genera `inventory/<nuevo-name>/_meta/source.md` con el frontmatter `source_type: mount`, y emite por stdout un bloque JSON para pegar en `repos.json`. No edita `repos.json` directamente (el usuario lo hace).
> - `scripts/add-loose.sh` — helper para crear entradas `source_type: loose`. Argumentos: `--from <path-absoluto>`, `--as <name>`. Copia el directorio, genera `source.md` con frontmatter `loose`, emite JSON para pegar.
>
> ### `.github/workflows/` (opcional pero recomendado)
>
> - `.github/workflows/verify.yml` — workflow que corre `scripts/gate-no-deps.sh` en cada push y PR. Único job.
>
> ### Contenido de `repos.json` (ejemplo)
>
> Array con tres entradas, cada una con `"_example": true` para que `clone-all.sh` las salte:
>
> ```json
> [
>   {
>     "_example": true,
>     "name": "ejemplo-clone",
>     "source_type": "clone",
>     "url": "git@github.com:<owner>/<repo>.git",
>     "branch": "main",
>     "notes": "EJEMPLO. Reemplazar por un repo real o eliminar esta entrada. source_type=clone es el caso default."
>   },
>   {
>     "_example": true,
>     "name": "ejemplo-mount",
>     "source_type": "mount",
>     "mounted_from": "../ejemplo-clone/platform/sub-area",
>     "parent_repo": "ejemplo-clone",
>     "parent_repo_commit": "0000000000000000000000000000000000000000",
>     "notes": "EJEMPLO. Se usa scripts/mount-subdir.sh para generar esta entrada real. Útil para aislar subdirs de un monorepo como unidad de inventario independiente."
>   },
>   {
>     "_example": true,
>     "name": "ejemplo-loose",
>     "source_type": "loose",
>     "mounted_from": "D:/backups/algun-prototipo-sin-git/",
>     "notes": "EJEMPLO. Se usa scripts/add-loose.sh para generar esta entrada real. Útil para código huérfano sin historia Git. Madurez tope: maduro-aparente."
>   }
> ]
> ```
>
> Añadir en `repos.json` un comentario explicativo **no es posible** (JSON no admite comentarios). En su lugar, el `README.md` de la raíz explica la estructura y semántica de cada campo.
>
> ### Contenido de `README.md` de la raíz
>
> Secciones mínimas, sin relleno:
>
> 1. **Qué es `v-repos`:** repo privado que aloja clones read-only de los repos a inventariar (sin dependencias instaladas) + sus artefactos de inventario. Referencia a `.docs/repos-plan/README.md`.
> 2. **Estructura:** breve resumen con link a `.docs/repos-plan/01-estructura-v-repos.md`.
> 3. **Flujo:**
>    1. Editar `repos.json` eliminando las entradas `_example` y agregando las reales.
>    2. Ejecutar `scripts/clone-all.sh` para clones, o los helpers para `mount`/`loose`.
>    3. Verificar estado con `scripts/gate-no-deps.sh`.
>    4. Lanzar agentes de inventario siguiendo `.docs/inventario/02-instrucciones-agentes.md`.
>    5. Al cerrar Fase 1, migrar `inventory/` a `v-mono/inventory/`.
> 4. **Requisitos locales:** `git`, `bash` (Git Bash en Windows es suficiente), `jq`, `rsync` (opcional, para `sync-docs.sh`). Los toolchains de los repos clonados (`pnpm`, `cargo`, `dotnet`, etc.) **no son necesarios** aquí por diseño.
> 5. **Privacidad:** repo privado obligatorio, incluso si los repos clonados son públicos.
>
> ---
>
> **Al terminar, imprime:**
>
> 1. Lista de archivos creados (una línea por archivo, con su propósito).
> 2. **Estado de los archivos provistos por el usuario:** para cada uno de los 8 archivos listados en "Archivos provistos por el usuario", reporta `presente` o `FALTA` con un checklist. Si alguno falta, indica el path de origen en `.docs/repos-plan/templates/` del cual el usuario debe copiarlo.
> 3. Los 3 siguientes pasos para el usuario:
>    - Copiar archivos faltantes desde `.docs/repos-plan/templates/` si los hay.
>    - Editar `repos.json` con los repos reales.
>    - Ejecutar `scripts/clone-all.sh` y confirmar con `scripts/gate-no-deps.sh`.
> 4. Cualquier duda/ambigüedad detectada durante la creación (si no hay, dilo explícitamente).

---

## Nota para el usuario

- Revisa cada script antes de ejecutarlo. El agente puede introducir pequeñas variaciones; usa los docs de `.docs/repos-plan/` como árbitro.
- Si el agente intenta clonar repos reales, instalar dependencias, o ejecutar los scripts: interrumpe. Es violación directa del prompt.
- Si el agente pregunta "¿qué repos quieres clonar?" antes de completar la estructura: respóndele que no es su tarea, debe generar solo las entradas `_example` y terminar.
