# 03 — Plantillas de output

**Audiencia:** agentes que producen los artefactos del inventario.

Cada plantilla incluye frontmatter YAML obligatorio y secciones fijas. Los agentes **respetan el orden y los nombres de sección** para que los artefactos sean mecánicamente comparables en la Fase 2.

---

## §1 — Plantilla: Resumen por package

Archivo: `v-mono/inventory/<repo>/summary/<package-slug>.md`

```markdown
---
kind: package-summary
repo: <repo-name>
package_name: <nombre del package tal como aparece en el manifest>
package_path: <path relativo al root del repo>
language: ts | angular | csharp | fsharp | rust | cpp | embedded-cpp | python | other
manifest: <nombre del manifest, e.g. package.json>
inventoried_at: <ISO-8601>
inventoried_by: <agent-id>
madurez: maduro | beta | experimental | abandonado | indeterminado
---

# <package_name>

## 1. Identidad
- **Nombre:** `<package_name>`
- **Path:** `<package_path>`
- **Lenguaje:** <language>
- **Versión declarada:** <si aplica>
- **Publicado:** sí | no | desconocido

## 2. Propósito

### 2.1 Declarado
<texto del README/description, o "sin declaración">

### 2.2 Inferido
<propósito deducido del código en 2-4 líneas>

**Evidencia:**
- `<file:line>` — <qué muestra>
- `<file:line>` — <qué muestra>

## 3. Superficie pública
<lista de exports principales / types / funciones / clases exportadas desde el entry point>

- `<symbol>` (<kind>) — <una línea>

## 4. Dependencias

### 4.1 Internas al repo
- `<package>` — <razón>

### 4.2 Externas
- `<pkg@version>` — <uso principal>

## 5. Consumidores internos
<packages del mismo repo que importan este package>

- `<package>` — <qué usa>

## 6. Estructura interna
<árbol resumido de `src/` con una línea por carpeta>

```
src/
├── <dir>/   ← <propósito>
├── <dir>/   ← <propósito>
└── index.*
```

## 7. Estado

- **Madurez:** <valor del frontmatter>
- **Justificación:** <1-3 líneas con evidencia>
- **Build:** verde | rojo | no ejecutado | no aplica
- **Tests:** <cantidad detectada> | sin tests
- **Último cambio relevante observado:** <fecha o "desconocido">

## 8. Dominios que toca
<lista referenciada al inventario de dominios>

- `domain/<domain>` — <rol que juega este package en ese dominio>

## 9. Observaciones
<patrones detectados, peculiaridades, advertencias>

## 10. Hipótesis (`?:`)
<suposiciones no verificadas; cada una lleva prefijo `?:`>

- `?:` <hipótesis> — evidencia: `<file:line>`

## 11. Preguntas abiertas
<cosas que el agente no pudo determinar>

- <pregunta>
```

---

## §2 — Plantilla: Inventario por dominio

Archivo: `v-mono/inventory/<repo>/domains/<domain>.md`

```markdown
---
kind: domain-inventory
repo: <repo-name>
domain: <domain-name>
inventoried_at: <ISO-8601>
inventoried_by: <agent-id>
implementations_count: <n>
languages_involved: [ts, csharp, rust, ...]
---

# Dominio — `<domain>`

## 1. Definición operativa
<1-3 líneas describiendo qué significa este dominio en este repo, según la evidencia del código>

## 2. Implementaciones encontradas

| # | Package                 | Path                       | Lenguaje | Madurez       | Rol                           |
|---|-------------------------|----------------------------|----------|---------------|-------------------------------|
| 1 | `<package-name>`        | `<path>`                   | <lang>   | <madurez>     | <contract / impl / client / ...> |
| 2 | `<package-name>`        | `<path>`                   | <lang>   | <madurez>     | ...                           |

## 3. Responsabilidades cubiertas

Lista de capabilities que el dominio implementa en este repo, con mapping a packages:

- **<Capability A>** → `<package-1>`, `<package-2>`
- **<Capability B>** → `<package-3>`
- **<Capability C>** → no implementada en este repo

## 4. Contratos y tipos clave
<principales interfaces/types/traits/protocols que caracterizan el dominio>

- `<SymbolName>` en `<package>/<file>` — <qué modela>

## 5. Flujos observados
<uno o más diagramas textuales o descripciones de cómo fluyen las llamadas entre las implementaciones>

```
<flujo>
```

## 6. Duplicaciones internas al repo
<dos o más packages implementan la misma capability con código distinto>

- `<capability>`: `<package-A>` vs `<package-B>` — diferencias observadas en <evidencia>

## 7. Observaciones cross-language (si aplica)
<cuando el dominio aparece en varios lenguajes dentro del mismo repo>

- Lenguaje A vs Lenguaje B: <diferencias de modelado / superficie / semántica>

## 8. Estado global del dominio en este repo

- **Completitud:** completo | parcial | esquemático | solo-tipos
- **Consistencia interna:** consistente | inconsistente | contradictorio
- **Justificación:** <2-4 líneas con evidencia>

## 9. Sospechas para Fase 2
<anclas para el análisis cross-repo; cada punto sirve como input a `post-inventario`>

- `?:` <sospecha> — evidencia: <paths>
```

---

## §3 — Plantilla: Reporte de estado

Archivo: `v-mono/inventory/<repo>/status/<area>.md`

`<area>` puede ser el repo completo (`repo.md`) o subdivisiones grandes (`platform.md`, `packages.md`, `dotnet.md`, etc.).

```markdown
---
kind: status-report
repo: <repo-name>
area: <area>
inventoried_at: <ISO-8601>
inventoried_by: <agent-id>
---

# Estado — `<area>`

## 1. Bugs

| # | Severidad    | Ubicación              | Descripción                     | Evidencia            |
|---|--------------|------------------------|---------------------------------|----------------------|
| 1 | crítico      | `<path>:<line>`        | <qué está mal>                  | <cita / comentario>  |
| 2 | alto/medio/bajo | `<path>:<line>`     | <qué está mal>                  | ...                  |

**Severidad:**
- **crítico:** build roto, crash, pérdida de datos.
- **alto:** feature core no funciona como documenta.
- **medio:** incorrectitud en caso no-core.
- **bajo:** inconsistencia menor, edge case.

## 2. Duplicaciones

| # | Concepto         | Ubicación A              | Ubicación B              | Diferencias      |
|---|------------------|--------------------------|--------------------------|------------------|
| 1 | <concepto>       | `<path-A>`               | `<path-B>`               | <texto breve>    |

## 3. Incompletitud

| # | Tipo                      | Ubicación              | Descripción                    |
|---|---------------------------|------------------------|--------------------------------|
| 1 | interfaz-sin-impl         | `<path>`               | <qué falta>                    |
| 2 | handler-vacío             | `<path>:<line>`        | <contexto>                     |
| 3 | todo-estructural          | `<path>:<line>`        | <texto del TODO>               |
| 4 | import-roto               | `<path>:<line>`        | import a path inexistente      |

## 4. Deuda técnica estructural

| # | Categoría                 | Ubicación              | Observación                    |
|---|---------------------------|------------------------|--------------------------------|
| 1 | archivo-monolítico        | `<path>` (<LOC> líneas)| excede convención >500 LOC     |
| 2 | múltiples-exports-publicos| `<path>`               | <n> tipos públicos en un archivo |
| 3 | patrón-obsoleto           | `<path>:<line>`        | <qué patrón>                   |
| 4 | inconsistencia-convención | `<path>`               | choca con `v-mono/.docs/repo/03-convenciones-cross-language.md §<n>` |

## 5. Tests

- **Packages sin tests:** <lista>
- **Packages con tests rotos:** <lista + evidencia>
- **Cobertura estimada:** <si se puede medir>

## 6. Configuración / toolchain

Problemas observados en manifests, configs, scripts de build:

- `<archivo>` — <problema>

## 7. Resumen ejecutivo del área
<2-5 líneas que capturan el estado global del área con honestidad>

## 8. Riesgos para la unificación
<aspectos de esta área que complicarán la migración a v-mono>

- <riesgo>
```

---

## §4 — Plantilla: Árbol de descubrimiento

Archivo: `v-mono/inventory/<repo>/_meta/tree.md`

```markdown
---
kind: discovery-tree
repo: <repo-name>
scanned_at: <ISO-8601>
agent_id: <agent-id>
root_path: <absolute path>
---

# Árbol — `<repo>`

## Top-level

| Path              | Tipo               | Lenguajes detectados         |
|-------------------|--------------------|------------------------------|
| `ts/`             | workspace          | ts, angular                  |
| `dotnet/`         | workspace          | csharp                       |
| ...               | ...                | ...                          |

## Manifests detectados

- `<path>` — <tipo>
- `<path>` — <tipo>

## Directorios excluidos del análisis
<con razón>

- `node_modules/` — deps externas
- `dist/` — build output
```

---

## §5 — Plantilla: Clasificación

Archivo: `v-mono/inventory/<repo>/_meta/classification.md`

```markdown
---
kind: classification
repo: <repo-name>
classified_at: <ISO-8601>
total_packages: <n>
---

# Clasificación — `<repo>`

## Por lenguaje

### TypeScript / JavaScript (<n>)
| Path                           | Package name     | Tipo          |
|--------------------------------|------------------|---------------|
| `ts/packages/foo`              | `@v/foo`         | library       |

### Angular (<n>)
...

### .NET (<n>)
...

### Rust (<n>)
...

### C++ (<n>)
...

### Embedded / PlatformIO (<n>)
...

### Python (<n>)
...

## Packages no clasificados
<paths con manifest ambiguo o sin manifest pero con código>

- `<path>` — razón
```

---

## §6 — Plantilla: Completion report

Archivo: `v-mono/inventory/<repo>/_meta/completion-report.md`

```markdown
---
kind: completion-report
repo: <repo-name>
generated_at: <ISO-8601>
agent_id: <agent-id>
complete: true | false
---

# Completion Report — `<repo>`

## Checklist (ref: `01-proposito-y-alcance.md §8`)

- [x|~] Cada package tiene `summary/*.md`
- [x|~] Cada dominio detectado tiene `domains/*.md`
- [x|~] Existe al menos un `status/*.md`
- [x|~] Frontmatter válido en todos los docs
- [x|~] Sin paths sin clasificar
- [x|~] Cross-references internos válidos

## Estadísticas

- Packages inventariados: <n>
- Dominios documentados: <n>
- Bugs detectados: <n>
- Duplicaciones detectadas: <n>
- Incompletitudes detectadas: <n>

## Pendientes (si complete=false)

- <pendiente 1>
- <pendiente 2>

## Notas del agente
<cualquier comentario relevante para Fase 2>
```

---

## §7 — Plantilla: Errors log

Archivo: `v-mono/inventory/<repo>/_meta/errors.md`

```markdown
---
kind: errors-log
repo: <repo-name>
---

# Errores durante el inventario

| Timestamp           | Agente            | Tipo              | Detalle                   | Ubicación    |
|---------------------|-------------------|-------------------|---------------------------|--------------|
| <ISO-8601>          | <agent-id>        | read-failed       | <mensaje>                 | <path>       |
| <ISO-8601>          | <agent-id>        | manifest-corrupt  | <mensaje>                 | <path>       |
```

---

## §8 — Convenciones de formato transversales

- **Paths** siempre relativos al root del repo inventariado, con `/` como separador.
- **Fechas** en ISO-8601 con timezone (`2026-04-24T15:30:00Z`).
- **Referencias a línea** en formato `path:line` o `path:line-line`.
- **Enlaces markdown** entre documentos del inventario usan paths relativos: `[ver summary](../summary/foo.md)`.
- **Tablas** sin alinear manualmente (las herramientas formatean).
- **Sin emojis** en los documentos.
- **Sin marketing.** Texto descriptivo, técnico, verificable.
