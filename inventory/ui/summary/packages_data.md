---
kind: package-summary
repo: ui
package_name: "@vortech/data"
package_path: packages/data
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/data

## 1. Identidad

- **Nombre:** `@vortech/data`
- **Path:** `packages/data`
- **Manifest:** `packages/data/package.json`
- **Descripción en manifest:** documentada en docblock de `src/index.ts`
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

Del docblock en `packages/data/src/index.ts`:

> "Hybrid IR: QueryDescriptor + SQL Compiler. AST-based query representation, SQL compilers (PostgreSQL, SQLite), adapters (SQL, Memory, HTTP), pipeline interceptors, reactive queries via atoms, repository pattern, integration with @vortech/core"

### 2.2 Inferido con Evidencia

Capa de acceso a datos con representación intermedia AST de queries. Soporta múltiples backends:

- `ast/` — representación AST de consultas (`QueryDescriptor`)
- `compiler/` — compiladores SQL (PostgreSQL, SQLite)
- `adapter/` — adaptadores: SQL, Memory, HTTP
- `pipeline/` — interceptores de pipeline
- `events/` — sistema de eventos de datos
- `db.ts` — punto de entrada de base de datos
- `errors.ts` — errores tipados
- `keys.ts` — gestión de claves primarias/secundarias
- `feature.ts` — integración como Feature con `@vortech/core`

## 3. Superficie pública

Exports (vía `packages/data/src/index.ts`): toda la API de query, compiladores, adaptadores, pipeline e integración con core. Incluye tipos de `QueryDescriptor`, compiladores específicos por backend, y clases de repositorio.

## 4. Dependencias

### 4.1 Internas

- `@vortech/core` (mencionado explícitamente en la descripción)

### 4.2 Externas

No determinado sin instalación de deps. Posible dependencia de drivers de base de datos (pg, better-sqlite3, etc.).

## 5. Consumidores internos

No determinado. Probable uso por aplicaciones en `projects/` y `demos/`.

## 6. Estructura interna

```
packages/data/
├── package.json
└── src/
    ├── adapter/
    ├── ast/
    ├── compiler/
    ├── db.ts
    ├── errors.ts
    ├── events/
    ├── feature.ts
    ├── index.ts
    ├── keys.ts
    └── pipeline/
```

## 7. Estado

- **Madurez:** beta
- **Justificación:** Descripción exhaustiva en código; implementación multi-backend (PostgreSQL, SQLite, Memory, HTTP); patrón repositorio implementado; integración declarada con `@vortech/core`.
- **Build:** no ejecutado
- **Tests:** no detectados directamente (posibles en `test/` del workspace raíz)
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Acceso a datos / ORM ligero
- Compilación de queries (AST → SQL)
- Reactive data (atoms)
- Múltiples backends: PostgreSQL, SQLite, Memory, HTTP

## 9. Observaciones

- La presencia de un adaptador HTTP (`adapter/http`) sugiere que las queries pueden ejecutarse contra una API REST, no solo contra bases de datos locales.
- "Reactive queries via atoms" indica integración con un sistema reactivo (posiblemente `@vortech/core` signals/atoms).
- `pipeline/` con interceptores recuerda al patrón middleware de frameworks web.

## 10. Hipótesis (?:)

- ?: `QueryDescriptor` puede ser el IR compartido entre el compilador VTL (`@vortech/lang`) y el compilador SQL.
- ?: El adaptador Memory puede usarse para tests unitarios sin base de datos real.

## 11. Preguntas abiertas

- ¿Los compiladores PostgreSQL y SQLite generan SQL estándar o usan dialectos propios?
- ¿Los "atoms" de reactive queries son el mismo concepto que en `@vortech/core` (signals)?
- ¿Existe soporte para migraciones de esquema?
