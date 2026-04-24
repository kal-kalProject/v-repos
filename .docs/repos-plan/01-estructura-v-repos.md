# 01 — Estructura del repo `v-repos`

## 1. Layout

```
v-repos/                              ← repo GitHub privado
├── README.md                         ← qué es, cómo se inicializa, cómo se usa
├── .gitignore                        ← robusto (ver §4)
├── .gitattributes                    ← eol=lf global
│
├── .github/                          ← customización Copilot (ver §12)
│   ├── copilot-instructions.md       ← cargado automáticamente por Copilot Chat
│   └── agents/
│       ├── inventario.agent.md       ← custom agent Fase 1
│       └── post-inventario.agent.md  ← custom agent Fase 2
│
├── .vscode/                          ← integración VS Code (ver §12)
│   ├── settings.json                 ← exclusiones, formato, hint a copilot-instructions
│   └── tasks.json                    ← tareas que envuelven scripts/
│
├── .cursor/                          ← equivalente Cursor (ver §12)
│   └── rules/
│       ├── workspace.mdc             ← alwaysApply: reglas transversales
│       ├── inventario.mdc            ← modo Fase 1
│       └── post-inventario.mdc       ← modo Fase 2
│
├── .docs/                            ← copia de v-mono/.docs (ver §10)
│
├── repos/                            ← fuentes a inventariar (clone | mount | loose — ver §2)
│   ├── vortech/                      ← clone plano
│   │   └── .git/
│   ├── legacy-theming/               ← mount (copia de un subdir de otro repo)
│   └── prototype-2023/               ← loose (sin git)
│
├── inventory/                        ← artefactos producidos por los agentes
│   ├── <repo-1>/                     ← mismo nombre que en repos/
│   │   ├── _meta/
│   │   │   ├── tree.md
│   │   │   ├── classification.md
│   │   │   ├── completion-report.md
│   │   │   ├── errors.md
│   │   │   ├── progress.md
│   │   │   ├── lock.md
│   │   │   └── source.md             ← referencia de origen (ver §5)
│   │   ├── summary/
│   │   │   └── <package-slug>.md
│   │   ├── domains/
│   │   │   └── <domain>.md
│   │   └── status/
│   │       └── <area>.md
│   ├── <repo-2>/
│   └── _global/                      ← consolidación cross-repo
│       ├── domain-overlap.md
│       ├── repos-index.md
│       └── repos-descartados.md      ← registro de repos no inventariados (ver §11)
│
├── scripts/
│   ├── clone-all.sh                  ← idempotente, lee repos.json (solo entradas clone)
│   ├── update-all.sh                 ← git fetch + log resumen (solo clone)
│   ├── snapshot-shas.sh              ← congela source_commit en todos los inventarios
│   ├── gate-no-deps.sh               ← falla si detecta node_modules/target/bin/obj dentro de repos/
│   └── sync-docs.sh                  ← re-sincroniza .docs/ desde v-mono (ver §10)
│
└── repos.json                        ← lista canónica de fuentes (ver §2)
```

## 2. Tipos de fuente en `repos.json`

`v-repos` soporta tres tipos de fuente para adaptarse a distintos orígenes de código. Cada entrada en `repos.json` declara su `source_type`.

| `source_type` | Qué es                                               | Tiene `.git` | `source_commit`               | Cuándo usarlo                                           |
|---------------|------------------------------------------------------|--------------|-------------------------------|---------------------------------------------------------|
| `clone`       | `git clone` completo de un repo GitHub/Git           | sí          | SHA real del HEAD clonado     | Default; repos independientes con origen Git accesible  |
| `mount`       | Copia de un subdirectorio de otro repo ya clonado    | no           | `null` (+ `parent_repo_commit`)| Aislar líneas de trabajo dentro de monorepos            |
| `loose`       | Copia de código sin historia Git (zip, dropbox, etc.)| no           | `null`                        | Backups, prototipos históricos, código huérfano         |

`repos.json` — ejemplo con los tres tipos:

```json
[
  {
    "name": "vortech",
    "source_type": "clone",
    "url": "git@github.com:<owner>/vortech.git",
    "branch": "main",
    "notes": "repo principal actual; Angular + TS + Rust + .NET"
  },
  {
    "name": "legacy-theming",
    "source_type": "mount",
    "mounted_from": "../vortech/platform/legacy/theming",
    "parent_repo": "vortech",
    "parent_repo_commit": "<sha-40-del-padre-al-montar>",
    "notes": "extraído como unidad lógica independiente para inventario aislado"
  },
  {
    "name": "prototype-2023",
    "source_type": "loose",
    "mounted_from": "D:/backups/prototype-2023/",
    "notes": "sin git; se congela copiando el estado actual al momento del mount"
  }
]
```

### Reglas por tipo

**`clone`**
- Script `clone-all.sh` lo procesa.
- `_meta/source.md` registra `source_url`, `source_branch`, `source_commit`, `cloned_at`.
- Es el único tipo donde tiene sentido `update-all.sh` (git fetch).

**`mount`**
- El usuario (o un script dedicado) copia el subdirectorio manualmente antes del inventario.
- El nombre en `v-repos/repos/<name>/` es **distinto** del nombre del repo padre, aunque el código esté físicamente duplicado. Es intencional: se inventaría dos veces desde ángulos distintos.
- Debe registrar `parent_repo` + `parent_repo_commit` para que la Fase 2 pueda detectar el overlap y categorizarlo como `falso-positivo` en vez de `duplicacion-exacta`.
- Los inventarios del mount y del padre se mantienen ambos; la Fase 2 los reconcilia.

**`loose`**
- Sin `git log`, se pierden las señales de actividad reciente.
- **Tope de clasificación de madurez: `maduro-aparente`**. No puede subir a "maduro" ni bajar a "abandonado" automáticamente (no hay señal temporal). Se documenta en el summary.
- Útil para código histórico que el usuario sabe que vale la pena inventariar pero cuyo origen se perdió.

### Convención de nombres

- `repos/<name>/` y `inventory/<name>/` comparten **exactamente** el mismo `<name>`.
- `<name>` = slug lowercase, sin owner, sin `.git`, con `-` como separador.
- Si dos repos tienen el mismo nombre (fork), desambiguar con `<owner>__<name>`.
- Los nombres de `mount` suelen llevar contexto del padre: `legacy-theming`, `vortech-platform-core`, etc.

## 3. Clones planos vs submódulos

Cuando el `source_type` es `clone`, usamos **clones planos**. Razones:

- Los repos inventariados son **read-only conceptualmente**; no se commitea en ellos.
- Submódulos añaden fricción (init/update recursivo, checkout de SHA específico) sin beneficio práctico para inventario.
- La reproducibilidad se logra registrando `source_commit` en cada artefacto (ver §5), no por snapshot del árbol de git.
- Un script simple (`clone-all.sh`) reemplaza la maquinaria de submódulos.

## 4. `.gitignore` crítico

El `.gitignore` de `v-repos` **debe** bloquear contaminación accidental por instalación de dependencias:

```gitignore
# Dependencias (prohibidas por política — ver repos-plan/02-mitigaciones.md)
**/node_modules/
**/bower_components/
**/.pnpm-store/

# Builds
**/dist/
**/build/
**/out/
**/.next/
**/.nuxt/

# .NET
**/bin/
**/obj/
**/packages/
**/*.user

# Rust
**/target/

# C++ / PlatformIO / vcpkg
**/.pio/
**/build-*/
**/vcpkg_installed/
**/CMakeFiles/
**/CMakeCache.txt

# Python
**/__pycache__/
**/.venv/
**/venv/
**/*.egg-info/

# IDE / OS
.vscode/
.idea/
.DS_Store
Thumbs.db

# Logs
*.log
```

Cada patrón está justificado por su toolchain. Si un patrón se relaja, se documenta en `README.md` de `v-repos` con razón explícita.

## 5. Frontmatter `source.md` por repo

En `inventory/<repo>/_meta/source.md` (generado por el script de clonado, el script de mount, o el primer agente para `loose`). La forma varía según `source_type`.

**Para `source_type: clone`:**

```markdown
---
kind: source-reference
repo_name: <name>
source_type: clone
source_url: <git-url>
source_branch: <branch>
source_commit: <sha-40>
cloned_at: <ISO-8601>
parent_repo: null
parent_repo_commit: null
mounted_from: null
mounted_at: null
agent_that_cloned: <agent-id o "script:clone-all">
---

# Referencia de origen — `<repo>`

Este inventario fue producido contra el estado del repo en el commit indicado arriba.
Cualquier afirmación en los artefactos se refiere a ese snapshot.
```

**Para `source_type: mount`:**

```markdown
---
kind: source-reference
repo_name: <name>
source_type: mount
source_url: null
source_branch: null
source_commit: null
cloned_at: null
parent_repo: <parent-name>
parent_repo_commit: <sha-40-del-padre-al-montar>
mounted_from: <path-relativo-dentro-del-padre>
mounted_at: <ISO-8601>
agent_that_cloned: <agent-id o "manual">
---

# Referencia de origen — `<repo>` (mount)

Este es un mount: copia de `<mounted_from>` dentro de `<parent_repo>` en el commit
`<parent_repo_commit>`. Los artefactos de este inventario se refieren a ese subset.
La Fase 2 debe reconciliar con el inventario de `<parent_repo>` para evitar
contabilizar duplicaciones físicas como duplicaciones lógicas.
```

**Para `source_type: loose`:**

```markdown
---
kind: source-reference
repo_name: <name>
source_type: loose
source_url: null
source_branch: null
source_commit: null
cloned_at: null
parent_repo: null
parent_repo_commit: null
mounted_from: <path-original>
mounted_at: <ISO-8601>
agent_that_cloned: <agent-id o "manual">
---

# Referencia de origen — `<repo>` (loose)

Código sin historia Git. No hay `source_commit`. Sin señales temporales (git log)
la clasificación de madurez tope es `maduro-aparente`. Cualquier afirmación
se refiere al estado copiado desde `<mounted_from>` en `<mounted_at>`.
```

Este archivo es **inmutable** una vez creado. Si el repo clonado/montado se actualiza, los agentes que re-inventaríen generan un `source.md` **nuevo**; los inventarios viejos permanecen como histórico en commits previos de `v-repos`.

## 6. Frontmatter en cada artefacto

Todos los `summary/*.md`, `domains/*.md`, `status/*.md` agregan al frontmatter canónico de `inventario/03-plantillas-output.md` los campos:

```yaml
source_repo: <name>
source_type: clone | mount | loose
source_commit: <sha-40> | null   # null si mount/loose
```

Esto permite cross-check automático: ningún artefacto cita un SHA distinto al de su `source.md`, y la Fase 2 sabe inmediatamente si una entrada es `mount`/`loose` para aplicar sus reglas especiales (reconciliación con parent, tope de madurez).

## 7. Scripts

### `clone-all.sh`

- Lee `repos.json`.
- Para cada entrada: si no existe `repos/<name>/`, clona; si existe, reporta y salta.
- Al finalizar, crea/actualiza `inventory/<name>/_meta/source.md` con SHA actual.
- Idempotente. Reejecutarlo nunca pierde trabajo.

### `update-all.sh`

- `git fetch` + `git log HEAD..origin/<branch>` por repo.
- **No** mergea automáticamente. Solo reporta qué cambió.
- Si el usuario decide actualizar, debe hacerlo explícitamente por repo.

### `snapshot-shas.sh`

- Recorre `repos/<name>/` y actualiza `inventory/<name>/_meta/source.md` con SHA actual del checkout.
- Se usa **antes** de empezar una tanda de inventariado para anclar el estado.

### `gate-no-deps.sh`

- Recorre `repos/` y busca cualquier patrón de dependencias instaladas (`node_modules`, `target`, `bin`, `obj`, `.venv`, etc.).
- Si encuentra algo, falla con exit 1 y lista los paths.
- Se ejecuta como pre-commit hook y en CI del repo `v-repos`.

### `sync-docs.sh`

- Re-sincroniza `v-repos/.docs/` desde una ruta local de `v-mono` pasada como argumento.
- Es la única vía aceptada para modificar `v-repos/.docs/`; nunca se edita manualmente (ver §10).
- Registra en el commit message el SHA de `v-mono` desde el que se sincronizó.

## 8. Privacidad del repo

`v-repos` es **privado** obligatoriamente, incluso si algunos de los repos clonados son públicos. Razón: mezclar código de múltiples repos (posiblemente privados) en un único repo — aunque sea solo para análisis — no debe exponerse.

## 9. Ciclo de vida

1. Crear `v-repos` vacío en GitHub (privado).
2. Copiar `v-mono/.docs/` → `v-repos/.docs/` (ver §10).
3. Añadir `.gitignore`, `.gitattributes`, `repos.json` inicial, scripts.
4. Ejecutar `clone-all.sh` → pueblan `repos/` (entradas tipo `clone`) y se crean los `source.md`.
5. Crear manualmente `mount` y `loose` que correspondan; generar sus `source.md`.
6. Registrar en `inventory/_global/repos-descartados.md` los repos que se decidió no inventariar (ver §11).
7. Lanzar agentes de inventario (uno o varios en paralelo) sobre cada `repos/<name>/`, escribiendo en `inventory/<name>/`.
8. Consolidación opcional en `inventory/_global/` antes de Fase 2.
9. Migrar `inventory/` → `v-mono/inventory/` cuando la Fase 1 esté cerrada.
10. `v-repos` permanece como archivo histórico. Nunca se borra; puede archivarse (read-only) una vez migrado a `v-mono`.

## 10. Copia de `v-mono/.docs` como referencia operativa

El primer paso al inicializar `v-repos` es copiar `v-mono/.docs/` → `v-repos/.docs/`.

Razones:
- Los agentes que operan sobre `v-repos` necesitan las instrucciones y plantillas a mano, sin asumir que `v-mono` está accesible.
- Mantiene los dos repos independientemente clonables.

Reglas:
- **Fuente de verdad: `v-mono/.docs/`.** `v-repos/.docs/` es copia derivada. Cualquier ajuste al proceso se hace en `v-mono` y se re-sincroniza.
- `v-repos/.docs/README.md` agrega un bloque al tope:
  ```markdown
  > **Copia** de `v-mono/.docs/` en commit `<sha-de-v-mono>`.
  > Fuente de verdad: repo `v-mono`. No editar aquí.
  > Re-sincronizar con `scripts/sync-docs.sh`.
  ```
- Script `scripts/sync-docs.sh` re-ejecuta la copia (rsync/robocopy) desde una ruta local de `v-mono` pasada como argumento.
- Commits que tocan `v-repos/.docs/` deben ser **solo** el resultado de una sincronización, nunca ediciones manuales.

## 11. Repos descartados sin inventariar

Cuando el usuario sabe de antemano que un repo no vale la pena inventariar (experimento muerto, backup obsoleto, código generado, etc.), puede **no agregarlo** a `repos.json`. Pero la decisión debe quedar registrada.

Archivo: `v-repos/inventory/_global/repos-descartados.md`.

Formato por entrada:

```markdown
## <repo-name>

- **URL / path origen:** <git-url o path local>
- **Último commit conocido:** <sha o fecha>
- **Decisión:** descartado-sin-inventariar
- **Razón:** <2-5 líneas, hechos concretos; no "es viejo" genérico>
- **Evidencia mínima revisada:** <qué se miró antes de decidir: README, 1-2 archivos, tamaño del repo, commits recientes>
- **Quien decide:** usuario | agente-con-aprobación-usuario
- **Fecha:** <ISO-8601>
- **Irrecuperable si se borra el origen:** sí | no (existe en GitHub / backup)
- **Reconsiderable si:** <cláusula de falsabilidad — qué evidencia reabriría la decisión>
```

### Reglas

1. **Descarte con traza es legítimo; descarte en silencio no lo es.** La Fase 2 lee este archivo como parte del contexto global.
2. **Inspección mínima obligatoria antes de descartar:** README + estructura top-level + fecha del último commit. Sin eso, no se puede registrar como descartado — se inventaría.
3. **No se borra el repo origen** (GitHub, backup). Solo no se clona en `v-repos/` o se elimina `repos/<name>/` local.
4. **Un repo descartado puede reabrirse** añadiéndolo a `repos.json`. La entrada previa en `repos-descartados.md` se actualiza con nota "reabierto en <fecha> porque <razón>" pero no se borra.
## 12. Configuración de IDE y customización de agentes

`v-repos` incluye tres capas de customización de agentes y editor. Los archivos **listos para copiar** viven en `v-mono/.docs/repos-plan/templates/` (ver `templates/README.md`).

### 12.1 GitHub Copilot (`.github/`)

- **`.github/copilot-instructions.md`** — cargado automáticamente por Copilot Chat al abrir el workspace. Define reglas transversales (solo lectura sobre `repos/`, inventario estático, anclaje por SHA, separación hechos/valoración).
- **`.github/agents/inventario.agent.md`** — custom agent para Fase 1. Invocable desde el chat de Copilot seleccionando el modo `inventario`.
- **`.github/agents/post-inventario.agent.md`** — custom agent para Fase 2. Invocable como modo `post-inventario`.

Cada `.agent.md` usa frontmatter `name` + `description`, referencia explícitamente los documentos de `.docs/` que debe leer antes de actuar, y replica las reglas no negociables.

### 12.2 VS Code (`.vscode/`)

- **`.vscode/settings.json`** — exclusiones de `search`/`files`, EOL `lf`, trim whitespace, final newline, y `github.copilot.chat.agent.instructions` apuntando a `.github/copilot-instructions.md`.
- **`.vscode/tasks.json`** — envuelve todos los scripts de `scripts/` como tareas ejecutables desde la Command Palette: `clone-all`, `update-all`, `snapshot-shas`, `gate-no-deps`, `sync-docs` (prompt de input), `mount-subdir` (3 prompts), `add-loose` (2 prompts).

### 12.3 Cursor (`.cursor/`)

Equivalente a GitHub Copilot usando Cursor Rules v2 (archivos `.mdc`):

- **`.cursor/rules/workspace.mdc`** — `alwaysApply: true`. Reglas transversales siempre activas (espejo conceptual de `copilot-instructions.md`).
- **`.cursor/rules/inventario.mdc`** — `alwaysApply: false` con `globs: ["inventory/**", "repos/**"]`. Activable contextualmente al trabajar esos directorios o invocable manualmente con `@inventario`.
- **`.cursor/rules/post-inventario.mdc`** — `alwaysApply: false` con `globs: ["inventory/_global/**"]`. Invocable con `@post-inventario`.

### 12.4 Relación con `.docs/`

Estos archivos de customización son un **canal paralelo**: replican y refuerzan las reglas de `.docs/` en el punto de ejecución del agente. La fuente canónica sigue siendo `.docs/`; los archivos de `.github/`, `.vscode/`, `.cursor/` son su instancia operativa en el IDE.

Si una regla entra en conflicto: gana `.docs/`. Los archivos de customización se actualizan editando `v-mono/.docs/repos-plan/templates/` y re-copiando a `v-repos/`.

### 12.5 Sincronización

`scripts/sync-docs.sh` copia únicamente `.docs/`. **No** toca `.github/`, `.vscode/`, `.cursor/` del root de `v-repos` para no pisar customizaciones locales. La copia inicial y las re-sincronizaciones de templates se hacen manualmente desde `v-mono/.docs/repos-plan/templates/` hacia los destinos listados en `templates/README.md`.
