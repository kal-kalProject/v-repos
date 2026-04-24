# 02 — Instrucciones para agentes de inventario

**Audiencia:** agentes locales (Copilot, Continue, Cline) y agentes cloud (Copilot Cloud, Codex, Claude en GitHub) que ejecutan la Fase 1.

**Precondición:** leer `01-proposito-y-alcance.md` y `03-plantillas-output.md`.

---

## 1. Principios operativos del agente

Estos principios **no son sugerencias**. El agente los respeta siempre.

1. **Solo lectura.** El agente no modifica el repo inventariado. Escribe únicamente en `inventory/<repo>/` del workspace de ejecución (`v-repos/inventory/<repo>/` durante Fase 1, migrado a `v-mono/inventory/<repo>/` al cierre).
2. **Evidencia sobre intuición.** Toda afirmación cita archivo y (cuando aplica) línea.
3. **Completitud sobre interpretación.** Es preferible documentar que algo "no se entendió" que inventar un propósito.
4. **No descarte prematuro.** Código "feo" o "viejo" se documenta igual que código limpio. La Fase 2 decide qué descartar.
5. **Separación hechos/valoración.** Usa las secciones explícitas; no mezcla.
6. **Determinismo.** Dado el mismo repo en el mismo estado, el inventario debe ser consistente entre corridas.
7. **Inventario estático — prohibido ejecutar comandos que modifiquen el repo.** No `pnpm install`, `npm install`, `yarn`, `cargo build/check/fetch`, `dotnet restore/build`, `pip install`, `cmake --build`, `pio run`, `prettier --write`, `dotnet format`, `cargo fmt`, ni ningún linter con auto-fix. El repo clonado **no tiene dependencias instaladas** por diseño (ver `repos-plan/02-mitigaciones.md`). Lecturas y greps son libres. Si un análisis requiere algo que no se puede hacer estáticamente, se reporta como no verificado; **no** se instala nada para "habilitarlo".
8. **Anclaje temporal por SHA.** Todo artefacto incluye en su frontmatter `source_repo` y `source_commit` coherentes con `_meta/source.md`. El agente valida esta coherencia antes de escribir.

---

## 2. Workflow obligatorio

### Paso 1 — Descubrimiento

El agente lista el árbol del repo (respetando `.gitignore` y excluyendo `node_modules`, `dist`, `build`, `target`, `.pio`, `.next`, `vendor`, `generated`, `bin`, `obj`). Produce un **mapa inicial** en `inventory/<repo>/_meta/tree.md` con:

- Todos los directorios top-level y su tipo inferido (workspace, package, app, tooling, docs).
- Todos los manifests detectados con su path.

**Expansión de workspaces obligatoria.** Antes de clasificar, el agente lee los manifests raíz que definen workspaces y expande sus globs:

- `pnpm-workspace.yaml` → lista de packages TS/JS.
- `package.json` con campo `workspaces` → idem.
- `Cargo.toml` virtual (con `[workspace] members = [...]`) → lista de crates.
- `*.sln` / `*.slnx` → lista de proyectos .NET.
- `angular.json` → lista de proyectos Angular y sus roots.
- `CMakePresets.json` / `CMakeLists.txt` con `add_subdirectory(...)` → subproyectos C++.
- `platformio.ini` con secciones `[env:*]` → entornos embebidos.
- `pyproject.toml` con grupos / subpackages → idem.

Un package definido en un manifest de workspace cuenta aunque no tenga una estructura de directorios "obvia".

### Paso 2 — Clasificación por lenguaje

Para cada directorio que contiene un manifest, el agente determina:

| Manifest                            | Tipo               | Lenguaje            |
|-------------------------------------|--------------------|---------------------|
| `package.json`                      | package TS/JS      | TypeScript o JavaScript |
| `package.json` + `angular.json` ref | package Angular    | TypeScript (Angular)|
| `*.csproj` / `*.vbproj` / `*.fsproj`| proyecto .NET      | C# / VB / F#        |
| `Cargo.toml`                        | crate Rust         | Rust                |
| `CMakeLists.txt` + sin `.ini`       | proyecto C++       | C++                 |
| `platformio.ini`                    | env embebido       | C++ / Arduino       |
| `pyproject.toml`, `setup.py`        | package Python     | Python              |

Guarda la clasificación en `_meta/classification.md`.

### Paso 3 — Resumen por package

Por cada entrada clasificada en Paso 2, genera un `summary/<package-path-slug>.md` según la plantilla de `03-plantillas-output.md §1`.

**Slug del nombre:** path relativo con `/` → `_`, lowercase. Ejemplo: `platform/v-common` → `platform_v-common.md`.

### Paso 4 — Detección de dominios

El agente detecta dominios semánticos buscando en nombres de directorios, nombres de archivos, y comentarios iniciales:

**Dominios conocidos** (lista canónica — el agente los usa si aplica, y propone nuevos cuando detecta lógica que no encaja):

- `identity` — autenticación, autorización, JWT, sesiones.
- `wire` — canal de comunicación entre procesos/hosts.
- `transport` — implementaciones concretas de transporte (ws, tcp, http, bridge).
- `provider` / `driver` — patrón provider/driver de la plataforma.
- `host` / `hosting` — orquestación de procesos.
- `di` — inyección de dependencias / scopes / tokens.
- `layout` — layout tipo VS Code (activity bar, side bar, editor area, panel).
- `theming` — tokens de diseño, presets, variables CSS, modo oscuro.
- `ui-kit` — componentes UI genéricos reutilizables.
- `runtime` — runtime común (signals, reactivity, lifecycle).
- `plugin` / `extension` — sistema de extensiones.
- `commands` — command registry, keybindings, context keys.
- `http-client` — cliente HTTP.
- `sockets` — websocket, socket.io.
- `codegen` — generación de código (v-gen, scaffolding).
- `lsp` — language server.
- `devtools` — herramientas de desarrollo, VS Code extension, MCP.
- `agents` — agentes autónomos (discovery, watchdog).
- `rust-core` — núcleo Rust.
- `desktop` — app de escritorio.
- `embedded` — firmware / PlatformIO.

Si un package cubre varios dominios, aparece en varios `domains/*.md`.

### Paso 5 — Inventario por dominio

Por cada dominio con al menos una implementación, genera `domains/<dominio>.md` según la plantilla de `03-plantillas-output.md §2`.

### Paso 6 — Reporte de estado

Por cada área grande del repo (o por repo si es pequeño), genera `status/<area>.md` con:

- **Bugs:** evidencia concreta (file:line + explicación).
- **Duplicaciones internas:** dos o más implementaciones del mismo concepto dentro del mismo repo.
- **Incompletitud:** interfaces sin implementación, handlers vacíos, TODOs estructurales (no cosméticos).
- **Deuda:** archivos >500 LOC, tipos anidados en el mismo archivo, inconsistencias con `v-mono/.docs/repo/03-convenciones-cross-language.md`.
- **Tests:** packages con y sin tests, **conteo** de archivos de test. **No se reporta estado de ejecución** (verde/rojo) porque los tests no se ejecutan en Fase 1. Tests "rotos" solo se reportan si la rotura es evidente por inspección estática (por ejemplo, un test que importa un símbolo que ya no existe en el mismo repo).

Ver plantilla en `03-plantillas-output.md §3`.

### Paso 7 — Completion report

Genera `_meta/completion-report.md` verificando los criterios de `01-proposito-y-alcance.md §8`. Lista packages no clasificados, dominios sospechados pero no documentados, archivos anómalos.

---

## 3. Heurísticas de detección

### 3.1 Propósito inferido

Para inferir propósito cuando el README no es suficiente:
1. Leer el(los) `index.*` del package.
2. Leer los 3 archivos más grandes por LOC.
3. Leer los nombres de directorios hijos.
4. Inspeccionar qué importa el package de otros packages del mismo repo.
5. Inspeccionar qué packages del mismo repo importan este.

### 3.2 Madurez

**Importante:** el inventario es estático (ver §1.7). El agente **no ejecuta** `tsc`, `cargo check`, `dotnet build` ni tests. Por tanto la señal "build verde" se sustituye por señales estáticas:

- Cobertura de tipos aparente (pocos `any`, `unknown`, `object` en TS; uso de `Result<T,E>` idiomático en Rust; nullable reference types en C#).
- Presencia y densidad de tests (archivos `*.test.*`, `*.spec.*`, `#[test]`, `*Tests.cs`, etc.).
- Actividad reciente en `git log` del package (último commit, frecuencia).
- Densidad de `TODO`/`FIXME`/`XXX`/`HACK`.
- Existencia de README útil y ejemplos.
- Consumidores dentro del mismo repo (vía grep de imports, no vía resolución de módulos — ver §3.3).

Clasificación obligatoria, una de:

| Valor              | Criterios                                                                      |
|--------------------|--------------------------------------------------------------------------------|
| `maduro-aparente`  | Tests >0, uso por otros packages, README útil, git log activo, tipos coherentes |
| `beta`             | Tests escasos o ninguno, al menos un consumidor, git log razonable             |
| `experimental`     | Sin consumidores claros, TODOs altos, tipos débiles o README ausente           |
| `abandonado`       | Último commit >6 meses, sin consumidores, TODOs estructurales sin atender      |
| `indeterminado`    | Evidencia insuficiente                                                         |

Se usa `maduro-aparente` y no `maduro` para hacer explícito que **no** hay build verification. La Fase 2 puede confirmar a `maduro` ejecutando builds si se estima necesario.

**Tope por `source_type`.** Si `_meta/source.md` declara `source_type: loose`, la clasificación de madurez no puede superar `maduro-aparente`, y tampoco puede ser `abandonado`. Razón: sin `git log` no hay señal temporal fiable en ninguna dirección. Se documenta esta limitación en el summary con una nota explícita.

Cada clasificación incluye 1-3 líneas de justificación con evidencia.

### 3.3 Detección de duplicación y uso real

**Uso real se mide por grep estático, no por resolución de módulos.** El agente no tiene `node_modules`/`target`/`bin` disponibles; intentar resolver módulos daría siempre "no encontrado" y produciría falsos positivos de "package no usado". En su lugar:

- Grep cross-árbol de `from '<package-name>'`, `import '<package-name>'`, `require('<package-name>')`, `using V.<Domain>`, `use v_<domain>`, `#include <v/<domain>>`, etc.
- Se cuentan ocurrencias, se listan los paths consumidores.
- Si el count es 0, se reporta como **observación** "sin consumidores detectados estáticamente", no como conclusión "no usado".

Indicadores cruzados para duplicación:
- Dos packages con nombres similares (`ui-kit` y `v-ui`, `theming` y `v-theming`).
- Dos packages que exportan símbolos con el mismo nombre.
- Dos packages que tienen la misma estructura de directorios interna.
- Dos packages cuyos READMEs describen el mismo propósito con palabras distintas.

Cuando hay sospecha, se documenta como **observación** (no como conclusión) y se lista en el `status/*.md`.

### 3.4 Detección de incompletitud

- Funciones con cuerpo vacío o `throw new Error("not implemented")`.
- `TODO`, `FIXME`, `XXX`, `HACK` con contenido estructural (no "mejorar naming").
- Interfaces/abstract classes sin implementación en el mismo repo.
- Handlers registrados que apuntan a funciones inexistentes.
- Imports de paths que no existen **dentro del mismo repo**.

**Distinción crítica respecto a dependencias externas.** Un import a un package que no existe en `repos/<name>/` **no es** necesariamente incompletitud:

- Import a un package **del mismo repo/workspace** que no está presente → incompletitud (se reporta).
- Import a una dependencia externa (npm, crates.io, NuGet, PyPI, vcpkg) → **no es señal** de nada. Las deps no están instaladas por diseño. Se ignora.

El agente identifica si el target de un import es "interno" o "externo" consultando el manifest del package (`dependencies` vs `devDependencies` vs workspace-local) antes de reportar.

### 3.5 Cross-language duplication (sospechas)

Cuando el agente detecta un concepto en múltiples lenguajes (ej. `V.Identity.Client` en C# y `@v/identity-client` en TS), lo reporta como **observación cross-language** en el `domains/<domain>.md`. **No** concluye unificación — eso es Fase 2.

---

## 4. Manejo de errores y ambigüedad

- Si un archivo no se puede leer (permisos, encoding), se loguea en `_meta/errors.md` y se continúa.
- Si un manifest está corrupto, el package se marca con `madurez: indeterminado` y observación explícita.
- Si el agente no entiende un package, escribe `proposito_inferido: no_determinado` con sección `preguntas_abiertas` enumerando qué información falta.
- El agente **no adivina**. Si no hay evidencia, lo dice.

---

## 5. Performance y cuotas

- El agente prioriza breadth (cubrir todo) sobre depth (analizar exhaustivo).
- Un primer pass cubre todo el repo en trazo grueso; passes sucesivos profundizan en áreas marcadas como complejas.
- Si el repo es grande (>1000 packages), el agente puede producir inventario incremental con checkpoints en `_meta/progress.md`.

---

## 6. Coordinación entre múltiples agentes

Si varios agentes trabajan en paralelo sobre el mismo repo:

1. El primero crea `_meta/lock.md` listando su scope (directorios asignados).
2. Los siguientes leen el lock y eligen scopes no tomados.
3. Al terminar, cada agente libera su scope en el lock.
4. El `_meta/completion-report.md` solo se genera cuando no queda scope pendiente.

Si los agentes son cloud con distinta sesión, el lock funciona por commits: cada agente commitea su batch antes de pedir el siguiente.

---

## 7. Salida mínima aceptable

Un inventario mínimo válido por repo contiene:
- `_meta/tree.md`, `_meta/classification.md`, `_meta/completion-report.md`.
- Al menos un `summary/*.md` por cada package detectado.
- Al menos un `domains/*.md` por cada dominio con implementación encontrada.
- Al menos un `status/*.md` para el repo.

Si alguno falta, el inventario no está completo.

---

## 8. Prompt inicial para el agente

Cuando se invoca al agente para inventariar un repo, recibe como contexto:

1. Este documento (`02-instrucciones-agentes.md`).
2. Las plantillas (`03-plantillas-output.md`).
3. Las mitigaciones de ejecución (`v-mono/.docs/repos-plan/02-mitigaciones.md`).
4. El path raíz del repo a inventariar (típicamente `v-repos/repos/<repo-name>/`).
5. El path destino (típicamente `v-repos/inventory/<repo-name>/`).
6. El `source_commit` actual del repo, leído de `_meta/source.md`.
7. El id del agente (`copilot-local-vscode`, `codex-cloud`, `claude-gh-action`, `gemini-flash-session-<n>`, etc.).

El agente arranca con:

> Voy a inventariar `<repo>` según `v-mono/.docs/inventario/` y las mitigaciones de `v-mono/.docs/repos-plan/02-mitigaciones.md`. El inventario es estático: no instalo dependencias, no ejecuto builds, no ejecuto tests, no formateo código. Todo artefacto cita `source_commit=<sha>` tomado de `_meta/source.md`. Comienzo por el paso 1 (descubrimiento + expansión de workspaces) produciendo `_meta/tree.md` y `_meta/classification.md`. Luego avanzo secuencialmente por los pasos 3-7. Todo lo que escribo va bajo `inventory/<repo>/`. No modifico nada en `repos/<repo>/`.
