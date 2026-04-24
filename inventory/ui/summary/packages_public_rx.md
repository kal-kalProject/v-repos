---
kind: package-summary
repo: ui
package_name: "@vortech/rx"
package_path: packages/public/rx
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
| name          | `@vortech/rx`                                      |
| version       | 0.0.1                                              |
| directorio    | `packages/public/rx`                               |
| type          | module (ESM) — no declarado explícitamente         |
| private       | no especificado                                    |
| entrypoint    | `dist/index.mjs`                                   |
| types         | `dist/index.d.mts`                                 |

> Ubicado bajo `packages/public/`, lo que indica que está diseñado para ser consumido por múltiples partes del workspace (browser y/o server).

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Sistema reactivo propio de Vortech basado en **atoms** (señales reactivas), similar a Signals de Angular, Jotai o Solid.js:

- **Primitivas reactivas**: `atom` (estado mutable), `derived` (estado derivado), `watch` (efecto reactivo), `batch` (agrupación de cambios), `flushSync` (flush síncrono).
- **Scheduler**: `scheduler` — control del scheduling de actualizaciones reactivas.
- **Scoping**: `AtomScope`, `createScope`, `withScope` — scopes para aislar árboles de estado.
- **Error handling**: `AtomError`, `CircularDependencyError`, `DerivedEvaluationError`, `WatchExecutionError`, `DisposedScopeError` — errores tipados del sistema reactivo.
- **Devtools**: export separado `./devtools` para herramientas de debugging.
- **Async**: export separado `./async` para utilidades async sobre atoms.

El paquete es un thin re-export de `@vortech/apis/rx` — la implementación real reside en `@vortech/apis`.

Evidencia: `packages/public/rx/src/index.ts:1-30`.

## 3. Superficie pública

Entry points (campo `exports`):

| Export       | Archivo dist         | Propósito                       |
|--------------|----------------------|---------------------------------|
| `.`          | `dist/index.mjs`     | Primitivas reactivas principales|
| `./devtools` | `dist/devtools.mjs`  | Herramientas de debugging       |
| `./async`    | `dist/async.mjs`     | Utilidades asíncronas           |

Símbolos clave (re-exportados desde `@vortech/apis/rx`):

| Categoría         | Símbolos                                                                         |
|-------------------|----------------------------------------------------------------------------------|
| Primitivas        | `atom`, `watch`, `derived`, `untracked`, `batch`, `flushSync`                   |
| Tipos             | `Atom`, `WritableAtom`, `CreateAtomOptions`, `CreateDerivedOptions`, `CreateWatchOptions`, `WatchRef` |
| Guards            | `isAtom`, `isWritableAtom`, `isInReactiveContext`                               |
| Error handling    | `watchWithErrorBoundary`, `derivedWithFallback`                                 |
| Scheduler         | `scheduler`                                                                      |
| Scoping           | `AtomScope`, `createScope`, `withScope`                                         |
| Errores           | `AtomError`, `CircularDependencyError`, `DerivedEvaluationError`, `WatchExecutionError`, `DisposedScopeError` |

## 4. Dependencias

### 4.1 Internas

| Paquete          | Tipo    |
|------------------|---------|
| `@vortech/apis`  | runtime |

### 4.2 Externas

Ninguna.

## 5. Consumidores internos

`@vortech/rx` es el wrapper público del sistema reactivo. Probable consumo desde:

- `@vortech/app` — el paquete umbrella usa primitivas reactivas.
- Paquetes de features que implementan estado reactivo.
- Paquetes Angular que usan atoms como alternativa a RxJS.

No se detectaron referencias directas en `package.json` del workspace en la revisión estática.

## 6. Estructura interna

```
packages/public/rx/src/
├── index.ts      # Re-export de @vortech/apis/rx (primitivas principales)
├── async.ts      # Utilidades async para atoms
└── devtools.ts   # Herramientas de debugging reactivo
```

Surface mínima — 3 archivos. El paquete es principalmente una **fachada** sobre `@vortech/apis`.

## 7. Estado

| Campo          | Valor                                                                               |
|----------------|-------------------------------------------------------------------------------------|
| Madurez        | experimental                                                                        |
| Justificación  | v0.0.1, surface mínima (3 archivos), sin descripción, sin tests, dependencia total de `@vortech/apis` |
| Build          | no ejecutado (inventario estático)                                                  |
| Tests          | No detectados (`scripts` no incluye `test`)                                        |
| Último cambio  | desconocido (no se accedió a git log)                                               |

## 8. Dominios que toca

- Programación reactiva / signals
- Gestión de estado
- Debugging de estado reactivo

## 9. Observaciones

- El paquete es un **proxy/fachada** — no contiene lógica propia, solo re-exporta desde `@vortech/apis/rx`. Esto tiene sentido para controlar la API pública independientemente de la implementación interna.
- Los tres exports separados (`.`, `./devtools`, `./async`) siguen el patrón de tree-shaking — devtools y async solo se incluyen si se importan explícitamente.
- La existencia de `CircularDependencyError` y `DisposedScopeError` indica un sistema reactivo con gestión de ciclo de vida no trivial.
- El patrón de scoping (`AtomScope`, `createScope`, `withScope`) es compatible con inyección de dependencias — los scopes de atoms pueden coincidir con los scopes del DI de `@vortech/app`.

## 10. Hipótesis

- `@vortech/apis/rx` contiene la implementación concreta del motor reactivo; `@vortech/rx` es la API pública estable.
- `./async` probablemente incluye utilidades como `fromPromise`, `resource` o similar para integrar promesas/observables con atoms.
- `./devtools` probablemente expone un DevtoolsAdapter para integración con browser devtools o el sistema de devtools de Vortech.

## 11. Preguntas abiertas

1. ¿Por qué la implementación está en `@vortech/apis/rx` en lugar de directamente en `@vortech/rx`?
2. ¿`./async` tiene utilidades como `asyncAtom` o `resource` al estilo de TanStack Query?
3. ¿`./devtools` se integra con las Chrome DevTools Extensions o con el panel de Vortech DevTools (`vortech-vscode`)?
4. ¿El scheduler es configurable (sync/async/microtask)?
