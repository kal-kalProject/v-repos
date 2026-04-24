---
kind: package-summary
repo: ui
package_name: "@vortech-demos/sqlite-demo"
package_path: demos/sqlite-demo
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech-demos/sqlite-demo`
- **Ruta en el repo:** `demos/sqlite-demo`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Demo de integración SQLite con Vortech — muestra cómo usar SQLite como capa de persistencia local en el ecosistema Vortech. Valida la integración de SQLite (posiblemente `better-sqlite3`, `sql.js` o `@electric-sql/pglite`) con los paquetes del workspace.

## 3. Superficie pública

- No tiene API pública exportada; es una demo ejecutable.
- Ejemplo de operaciones CRUD con SQLite usando paquetes Vortech.

## 4. Dependencias

- Una librería SQLite para Node.js (`better-sqlite3`, `sql.js`, `Bun:sqlite` o similar).
- Paquetes del workspace Vortech con capacidades de persistencia.
- TypeScript runtime para ejecución.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de demostración.
- Relevante como referencia para `packages/ai-assistant` que usa ChromaDB (basado en SQLite).

## 6. Estructura interna

```
demos/sqlite-demo/
├── package.json
└── src/
    └── (código de demostración SQLite)
```

## 7. Estado

- **Madurez:** experimental
- Dependiente de qué librería SQLite se use y de la evolución del soporte SQLite en el workspace.

## 8. Dominios que toca

- **Persistencia Local** — almacenamiento SQLite embebido.
- **Demos / Ejemplos** — integración de base de datos local.
- **Data Layer** — capa de datos para apps Vortech.

## 9. Observaciones

- La demo SQLite conecta conceptualmente con `packages/ai-assistant` que usa ChromaDB sobre SQLite para búsqueda semántica local.
- SQLite embebido es una tecnología clave para el enfoque "sin servidores externos" que se menciona en `ai-assistant`.
- La existencia de esta demo sugiere que la persistencia local es un requisito relevante para al menos alguna app del ecosistema Vortech.

## 10. Hipótesis

- La demo puede usar `better-sqlite3` (Node.js) o `Bun:sqlite` (si Bun es el runtime preferido para el backend).
- Puede servir como prueba de concepto para una capa de datos local que eventualmente se integre en la app CNC Monkey o Studio.

## 11. Preguntas abiertas

1. ¿Qué librería SQLite se usa (`better-sqlite3`, `sql.js`, `Bun:sqlite`, otra)?
2. ¿La demo incluye migraciones de schema o solo operaciones básicas?
3. ¿Está relacionada con la capa SQLite que usa ChromaDB en `packages/ai-assistant`?
4. ¿Hay intención de usar SQLite como base de datos embebida en alguna de las apps de producción?
