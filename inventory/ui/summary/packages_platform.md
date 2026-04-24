---
kind: package-summary
repo: ui
package_name: "@vortech/platform"
package_path: packages/platform
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/platform

## 1. Identidad
- **Nombre:** `@vortech/platform`
- **Path:** `packages/platform`
- **Lenguaje:** TypeScript
- **Versión declarada:** 0.0.1
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado
Sin descripción en `package.json`.

### 2.2 Inferido
Capa de plataforma Vortech: DI avanzado, sistema reactivo (Atom), scopes de ejecución, context, features (feature flags), builders, actions, y adaptadores específicos de plataforma (Angular, Node). Es el sucesor funcional de `@vortech/core` con mayor scope.

**Evidencia:**
- `packages/platform/src/index.ts` — exporta tipos de `common` (Nullable, VoidListener, Guid variants), sistema de IDs (guid, nanoid, uuid, shortId, timestampId, base32Id), sistema Atom completo (atom, derived, watch, createScope), y más.
- `packages/platform/src/` — subdirectorios: `action/`, `api/`, `app/`, `builder-toolkit/`, `common/`, `context/`, `feature/`, `injection/`, `internal.ts`, `metadata/`, `platform-angular/`, `platform-node/`, `reactive/`, `scope/`.

## 3. Superficie pública
- Sistema de IDs: `guid`, `nanoid`, `uuid`, `shortId`, `timestampId`, `base32Id` (y variantes)
- Sistema reactivo: `atom`, `derived`, `watch`, `createScope`, `withScope`, `batch`
- DI: tipos de scope, context, metadata
- Plataformas: `platform-angular/`, `platform-node/` — setup por entorno
- Features: `feature/` — feature flags
- Actions: `action/` — command pattern

## 4. Dependencias

### 4.1 Internas al repo
- `@vortech/common` — globals polyfill (evidencia: `packages/platform/src/index.ts:1`)

### 4.2 Externas
No detectadas en `package.json` (requiere inspección del dependencies completo).

## 5. Consumidores internos
- `packages/core` — posible consumidor (o sucesor que lo reemplaza)
- `packages/vortech` — app builder probablemente depende de platform

## 6. Estructura interna
```
src/
├── action/          ← command/action pattern
├── api/             ← APIs internas
├── app/             ← configuración de aplicación
├── builder-toolkit/ ← builders encadenables
├── common/          ← tipos comunes de plataforma
├── context/         ← contextos de ejecución
├── feature/         ← feature flags
├── injection/       ← DI container avanzado
├── internal.ts      ← API interna
├── metadata/        ← metadata de decoradores
├── platform-angular/← integración Angular
├── platform-node/   ← integración Node.js
├── reactive/        ← sistema reactivo (Atom)
├── scope/           ← scopes de DI
└── index.ts
```

## 7. Estado
- **Madurez:** beta
- **Justificación:** API pública amplia y bien estructurada, integración multi-plataforma (Angular + Node), pero sin consumidores confirmados por grep estático. No se detectan tests.
- **Build:** no ejecutado
- **Tests:** no detectados en exploración estática
- **Último cambio relevante observado:** desconocido

## 8. Dominios que toca
- `domain/di` — DI avanzado con scopes
- `domain/runtime` — sistema reactivo Atom, scopes
- `domain/hosting` — platform-node, platform-angular setup
- `domain/commands` — actions system

## 9. Observaciones
Parece ser la biblioteca "umbrella" que combina lo que antes estaba separado en `@vortech/common` (atom) y `@vortech/core` (DI, runtime). Su campo `sideEffects` apunta a `platform-angular/app/setup.ts`, confirmando que tiene efectos de registro en Angular.

## 10. Hipótesis
- `?:` `@vortech/platform` es el sucesor unificado de `@vortech/core` + sistema reactivo de `@vortech/common` — evidencia: overlapping en subdirectorios y exportaciones comentadas en `packages/common/src/index.ts`.

## 11. Preguntas abiertas
- ¿Cuál es la relación final entre `@vortech/core` y `@vortech/platform`?
