# 01 — Propósito y alcance del inventario

**Objetivo:** establecer **qué** debe producir la Fase 1, **para qué** sirve, y **qué queda fuera** del inventario.

---

## 1. Por qué se hace un inventario antes de unificar

El usuario tiene **múltiples repos** con implementaciones en Node.js, Angular, .NET, .NET Framework, Rust, C++, PlatformIO y Python, con varios intentos parciales hacia la misma meta (plataforma Vortech end-to-end). Antes de proponer unificación se necesita:

1. **Visibilidad completa** de qué existe, dónde, en qué estado.
2. **Evidencia** de duplicaciones, divergencias, implementaciones maduras vs. experimentos abandonados.
3. **Trazabilidad**: cada decisión de unificación debe poder apuntar a artefactos concretos del inventario.
4. **Memoria institucional** persistente — no basada en memoria humana ni en una sola lectura del código.

Sin inventario, cualquier propuesta de unificación es especulación. El inventario convierte la intuición en evidencia.

---

## 2. Qué produce la Fase 1

Por cada repo analizado, los agentes producen tres **artefactos obligatorios**:

### 2.1 Resumen por package (`summary/`)

Un documento markdown **por cada package/proyecto/crate/módulo** detectado. Cada documento describe:
- Identidad del package (nombre, path, lenguaje, manifest).
- Propósito declarado (del README/description) y **propósito inferido** (del código).
- Dependencias internas y externas.
- Puntos de entrada públicos.
- Estado de madurez observado.

Plantilla exacta en `03-plantillas-output.md §1`.

### 2.2 Inventario por dominio (`domains/`)

Un documento por **dominio semántico** (identity, wire, layout, theming, di, runtime, transport, etc.) que agrupa todas las implementaciones que tocan ese dominio, **incluso si están en packages con nombres distintos**.

Este artefacto es el que permite detectar duplicaciones: si tres packages implementan "dependency injection" con nombres distintos, aparecen los tres en `domains/di.md`.

Plantilla en `03-plantillas-output.md §2`.

### 2.3 Reporte de estado (`status/`)

Un documento por repo (o por área grande dentro del repo) que enumera:
- Bugs detectados (con evidencia: archivo, línea, descripción).
- Duplicaciones (internas al repo y sospechas cross-repo).
- Código incompleto (TODOs, funciones vacías, interfaces sin implementación, rutas sin handler).
- Deuda técnica observable (archivos monolíticos, patrones obsoletos, inconsistencias con las convenciones de `v-mono/.docs/repo/`).
- Tests ausentes o rotos.

Plantilla en `03-plantillas-output.md §3`.

---

## 3. Qué **NO** hace el inventario

El inventario es **lectura, no escritura**. Los agentes:

- ❌ **No modifican código** en los repos analizados.
- ❌ **No crean branches** ni hacen commits en los repos analizados.
- ❌ **No ejecutan** el código salvo para verificar build/test status (y solo si el agente es local con permiso explícito).
- ❌ **No proponen cambios** — solo describen lo que encuentran. Las propuestas son Fase 2.
- ❌ **No deciden** qué implementación es canónica. Eso es Fase 2.
- ❌ **No descartan** código por "parecer malo". Documentan hechos; las valoraciones van en campos específicos (§4).

---

## 4. Separación hechos vs. valoraciones

Los artefactos de inventario separan explícitamente:

| Tipo          | Qué es                                              | Dónde va                              |
|---------------|-----------------------------------------------------|---------------------------------------|
| **Hechos**    | Path, nombre, LOC, deps declaradas, exports         | Cualquier sección del documento       |
| **Observación** | Patrón detectado, duplicación aparente, bug       | Sección explícita `Observaciones`     |
| **Valoración** | "Maduro" / "Experimental" / "Abandonado"           | Campo `madurez` con justificación     |
| **Hipótesis** | "Probablemente reemplaza a X"                       | Sección `Hipótesis` con prefijo `?:`  |

Toda valoración e hipótesis debe citar evidencia (archivo:línea o commit) — si no se puede citar, no se escribe.

---

## 5. Alcance por repo

El inventario cubre, para cada repo listado por el usuario:

- Todo el código fuente (excluyendo `node_modules`, `dist`, `build`, `target`, `.pio`, `.next`, vendored deps, generated).
- Todos los manifests (`package.json`, `*.csproj`, `Cargo.toml`, `CMakeLists.txt`, `platformio.ini`, `pyproject.toml`).
- Documentación existente (`README.md`, `docs/`, comentarios doc en código).
- Scripts de build y CI (`.github/workflows`, `scripts/`, etc.).
- Archivos de configuración estructuralmente relevantes (`tsconfig.json`, `angular.json`, `Directory.*.props`).

**No cubre:**
- Historial detallado de commits (solo fechas de última modificación por archivo si el agente las extrae baratas).
- Issues/PRs del repo.
- Código dentro de dependencias externas.

---

## 6. Repos previstos

Los repos a inventariar incluyen **este repo (`e:\Projects\vortech`)** y los demás mencionados por el usuario. Cada repo recibe su propio subdirectorio:

```
v-mono/inventory/
├── vortech/               ← este repo
│   ├── summary/
│   ├── domains/
│   └── status/
├── <repo-2>/
│   ├── summary/
│   ├── domains/
│   └── status/
└── <repo-N>/...
```

Nombres exactos de los repos se resuelven al ejecutar el inventario (el usuario proveerá la lista o el agente cloud detectará los repos de la cuenta).

---

## 7. Ciclo y actualización

- El inventario es **vivo**: si un repo cambia, se re-inventaria.
- Cada artefacto lleva frontmatter con `inventoried_at: <ISO-8601>` y `inventoried_by: <agent-id>`.
- Cambios en el inventario se commitean con mensajes `inventory: <repo>/<scope> — <summary>`.
- La comparación entre inventarios sucesivos es input para detectar regresiones o reemergencias de duplicación.

---

## 8. Criterio de "inventario completo" por repo

Un repo está completamente inventariado cuando:

1. ✅ Cada package/proyecto/crate/módulo tiene su `summary/*.md`.
2. ✅ Cada dominio detectado tiene su `domains/*.md`.
3. ✅ Existe al menos un `status/*.md` con bugs, duplicaciones, incompletitudes.
4. ✅ El frontmatter en todos los docs es válido (fechas, agent-id, repo-path).
5. ✅ No quedan paths del repo sin clasificar en ningún `summary`.
6. ✅ Los cross-references internos (un summary que menciona otro summary) son enlaces markdown válidos.

El agente que realiza el inventario emite al final un `_meta/completion-report.md` con el checklist verificado.
