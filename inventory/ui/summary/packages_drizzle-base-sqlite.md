---
kind: package-summary
repo: ui
package_name: "@vortech/drizzle-base-sqlite"
package_path: packages/drizzle-base-sqlite
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                              |
|---------------|----------------------------------------------------|
| name          | `@vortech/drizzle-base-sqlite`                     |
| version       | 0.0.1                                              |
| directorio    | `packages/drizzle-base-sqlite`                     |
| type          | module (ESM)                                       |
| private       | true                                               |
| entrypoint    | `dist/index.js`                                    |
| types         | `dist/index.d.ts`                                  |

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Abstracción base sobre **Drizzle ORM** para SQLite con `better-sqlite3`, que agrega:

- **Cache**: capa de caché sobre consultas SQLite (`src/cache/`).
- **Batch**: ejecución de sentencias en lote (`src/batch.ts`).
- **Aliasing**: mapeo de nombres de columnas/tablas (`src/alias.ts`).
- **Column builders**: construcción tipada de columnas (`src/column.ts`, `src/column-builder.ts`).
- **Entity system**: abstracción de entidades (`src/entity.ts`).
- **Error handling**: errores tipados para SQLite (`src/errors.ts`).
- **Casing**: normalización de nombres (snake_case ↔ camelCase) (`src/casing.ts`).
- **Gel core**: `src/gel-core/` — núcleo del sistema, probablemente tipos base o generadores.

El nombre "drizzle-base-sqlite" indica que es la **capa base** que extiende Drizzle ORM, no un wrapper completo.

Evidencia: estructura de `src/` provista en el inventario; `package.json` con peer dependency `better-sqlite3`.

## 3. Superficie pública

Entry points (campo `exports`):

| Export            | Archivo dist              | Propósito                           |
|-------------------|---------------------------|-------------------------------------|
| `.`               | `dist/index.js`           | API principal                       |
| `./sqlite-core`   | `dist/sqlite-core.js`     | Core SQLite de Drizzle (reexportado)|
| `./better-sqlite3`| `dist/better-sqlite3.js`  | Binding better-sqlite3              |

Los tres exports separados permiten que los consumidores importen solo lo que necesitan según su driver SQLite.

## 4. Dependencias

### 4.1 Internas

Ninguna.

### 4.2 Externas

| Paquete          | Tipo          | Versión      | Propósito                        |
|------------------|---------------|--------------|----------------------------------|
| `better-sqlite3` | peerDep (opt.)| >=9.0.0      | Driver SQLite síncrono para Node |

> La peer dependency es **opcional** (`peerDependenciesMeta.better-sqlite3.optional: true`), lo que sugiere que el paquete puede funcionar con otros drivers SQLite en el futuro. Las dependencias de Drizzle ORM (`drizzle-orm`) no están declaradas explícitamente — probablemente gestionadas por los consumidores o incluidas vía `gel-core/`.

## 5. Consumidores internos

No se detectaron referencias directas a `@vortech/drizzle-base-sqlite` en los `package.json` del workspace en la revisión estática. Probable consumo desde paquetes de servicios de datos (`services/storage/`, proyectos que persisten datos).

## 6. Estructura interna

```
packages/drizzle-base-sqlite/src/
├── alias.ts          # Mapeo/aliasing de nombres
├── batch.ts          # Ejecución en lote
├── better-sqlite3/   # Integración con driver better-sqlite3
├── cache/            # Capa de caché
├── casing.ts         # Normalización snake_case ↔ camelCase
├── column.ts         # Definición de columnas
├── column-builder.ts # Builder pattern para columnas
├── entity.ts         # Sistema de entidades
├── errors.ts         # Errores tipados
└── gel-core/         # Núcleo base (tipos, generadores)
```

## 7. Estado

| Campo          | Valor                                                                        |
|----------------|------------------------------------------------------------------------------|
| Madurez        | experimental                                                                 |
| Justificación  | v0.0.1 private, sin descripción, sin tests, nombre de directorio `gel-core/` no documentado |
| Build          | no ejecutado (inventario estático)                                           |
| Tests          | No detectados (`scripts` no incluye `test`)                                 |
| Último cambio  | desconocido (no se accedió a git log)                                        |

## 8. Dominios que toca

- Persistencia de datos (SQLite)
- ORM (Drizzle ORM)
- Caché de base de datos
- Abstracción de esquema

## 9. Observaciones

- El directorio `src/gel-core/` es inusual — "gel" podría referirse a un framework interno o a un renaming de "drizzle core". Requiere inspección para entender si es código propio o derivado de Drizzle.
- La peer dep optional de `better-sqlite3` es una buena práctica para paquetes base — permite futuros drivers como `bun:sqlite` o `node:sqlite`.
- Sin dependencias explícitas de `drizzle-orm` en el manifest — puede que esté incluido vía catalogo de workspace o en `gel-core/`.
- No tiene `scripts.type:check` ni `scripts.watch` además del build — desarrollo mínimo.

## 10. Hipótesis

- `gel-core/` contiene código derivado o adaptado de `drizzle-orm/sqlite-core` con extensiones propias de Vortech.
- La capa de caché (`src/cache/`) implementa memoización de queries frecuentes para evitar lecturas repetidas en SQLite síncrono.
- El paquete es la base sobre la que se construyen los repositorios de datos de servicios específicos (p.ej. `@vortech/storage`).

## 11. Preguntas abiertas

1. ¿Qué contiene `src/gel-core/`? ¿Es código propio o fork de Drizzle?
2. ¿Por qué no está declarada `drizzle-orm` como peer o dependency?
3. ¿El sistema de caché es en memoria o con persistencia secundaria?
4. ¿Existen otros drivers SQLite previstos además de `better-sqlite3`?
