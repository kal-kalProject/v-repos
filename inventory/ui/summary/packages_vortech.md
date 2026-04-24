---
kind: package-summary
repo: ui
package_name: "@vortech/app"
package_path: packages/vortech
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
| name          | `@vortech/app`                                     |
| version       | 0.0.1                                              |
| directorio    | `packages/vortech`                                 |
| type          | module (ESM) — no declarado explícitamente         |
| private       | no especificado                                    |
| entrypoint    | `dist/index.mjs`                                   |
| types         | `dist/index.d.mts`                                 |

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Paquete umbrella/framework de la plataforma Vortech. Integra los bloques fundamentales de la arquitectura:

- **Service decorator**: `@Service` — decorador para marcar clases como servicios inyectables.
- **DI (Dependency Injection)**: `createToken`, `Injector`, `InjectorBuilder`, `using`, `runInInjectionContext`, `InjectionKey` — sistema DI completo.
- **Application lifecycle**: `Application`, `ApplicationBuilder`, `NativeApplicationRef` — composición y arranque de la aplicación.
- **Reactive**: `src/reactive/` — integración del sistema reactivo (posiblemente conecta `@vortech/rx` con el DI).
- **Actions**: `src/action/` — sistema de acciones (command pattern).
- **Features**: `src/features/` — sistema de features/módulos.
- **Metadata**: `src/metadata/` — metadata de decoradores (reflection).
- **Tree nodes**: `src/tree-node/` — árbol de nodos de la aplicación.
- **Builder toolkit**: `src/builder-toolkit/` — herramientas de construcción de aplicaciones.
- **Communication**: `src/comunication/` [typo] — sistema de comunicación entre partes.
- **Angular integration**: export `./angular` — puente con Angular 19+.

Evidencia: `packages/vortech/src/public-api.ts:1-30`; `package.json` peerDependencies.

## 3. Superficie pública

Entry points (campo `exports`):

| Export      | Archivo dist        | sideEffects |
|-------------|---------------------|-------------|
| `.`         | `dist/index.mjs`    | false       |
| `./angular` | `dist/angular.mjs`  | **true**    |

> `./angular` tiene `sideEffects: true` — registra providers/módulos Angular al importarse, comportamiento esperado para integraciones de framework.

Símbolos clave (desde `src/public-api.ts`):

| Categoría          | Símbolos                                                                          |
|--------------------|-----------------------------------------------------------------------------------|
| Service            | `Service`, `ServiceOptions`                                                       |
| DI                 | `createToken`, `Injector`, `InjectorBuilder`, `using`, `runInInjectionContext`, `InjectionKey`, `InjectOptions`, `IInjector` |
| App composition    | `Application`, `ApplicationBuilder`, `NativeApplicationRef`                      |
| src/action/        | (no inspeccionado)                                                                |
| src/features/      | (no inspeccionado)                                                                |
| src/reactive/      | (no inspeccionado)                                                                |

## 4. Dependencias

### 4.1 Internas

| Paquete           | Tipo      | Nota                       |
|-------------------|-----------|----------------------------|
| `@vortech/common` | peerDep   | Requerida                  |

### 4.2 Externas

| Paquete           | Tipo           | Versión      | Nota                          |
|-------------------|----------------|--------------|-------------------------------|
| `@angular/core`   | peerDep (opt.) | >=19.0.0     | Solo para export `./angular`  |
| `@angular/common` | peerDep (opt.) | >=19.0.0     | Solo para export `./angular`  |
| `rxjs`            | peerDep (opt.) | >=7.0.0      | Solo para integración Angular |

Todas las peer deps de Angular y RxJS son **opcionales** — el paquete funciona sin Angular.

## 5. Consumidores internos

Como paquete framework umbrella, es probable que sea consumido por:

- Todos los paquetes de features y servicios que necesiten DI.
- Las aplicaciones Angular del workspace que usen el export `./angular`.
- `vortech-vscode` y otros tooling que necesiten el runtime de Vortech.

No se detectaron referencias directas en `package.json` del workspace en la revisión estática.

## 6. Estructura interna

```
packages/vortech/src/
├── action/           # Sistema de acciones (command pattern)
├── builder-toolkit/  # Herramientas de composición de aplicaciones
├── comunication/     # [typo: falta 'm'] Sistema de comunicación
├── di/               # Implementación DI (Injector, InjectorBuilder, tokens)
├── features/         # Sistema de features/módulos
├── metadata/         # Reflection y metadata de decoradores
├── public-api.ts     # Barrel de la API pública
├── reactive/         # Integración sistema reactivo ↔ DI
├── service/          # Decorator @Service
└── tree-node/        # Árbol de nodos de la aplicación
```

> **Typo confirmado**: `src/comunication/` (falta segunda 'm' en "communication"). Debería ser `communication/`.

## 7. Estado

| Campo          | Valor                                                                                   |
|----------------|-----------------------------------------------------------------------------------------|
| Madurez        | experimental                                                                            |
| Justificación  | v0.0.1, typo en directorio `comunication/`, sin descripción, aunque tiene tests (vitest)|
| Build          | no ejecutado (inventario estático)                                                      |
| Tests          | Configurados (`vitest run`, `vitest --watch`)                                          |
| Último cambio  | desconocido (no se accedió a git log)                                                   |

## 8. Dominios que toca

- Framework / runtime de aplicaciones Vortech
- Inyección de dependencias
- Programación reactiva
- Integración Angular
- Arquitectura de aplicaciones (features, actions, tree)

## 9. Observaciones

- El typo `comunication/` es un defecto menor pero indica que el directorio fue creado sin revisión de spelling — debería corregirse antes de que se establezca como convención.
- La presencia de `vitest` y scripts `test`/`test:watch` lo distingue de la mayoría de otros paquetes del inventario — mayor madurez relativa en este aspecto.
- `BUILD` requiere `NODE_OPTIONS=--max-old-space-size=4096` — el paquete es grande.
- El export `./angular` con sideEffects diferencia claramente el runtime agnóstico del puente Angular — buena arquitectura.
- `NativeApplicationRef` sugiere que hay más de una forma de arrancar una aplicación (Angular vs. nativa).

## 10. Hipótesis

- `InjectorBuilder` es el builder que compone el DI container antes de arrancar la `Application` — similar a `TestBed` de Angular o `NestFactory` de NestJS.
- `tree-node/` implementa el árbol de componentes/módulos de la aplicación que el DI y el sistema de features usan para resolver dependencias.
- `./angular` probablemente expone un `NgModule` o `EnvironmentProviders` que adapta el DI de Vortech al de Angular.
- `comunication/` podría ser el sistema de mensajería interna entre nodos del árbol (eventos, commands).

## 11. Preguntas abiertas

1. ¿`@vortech/common` es otra capa base que debe inventariarse? ¿Qué contiene?
2. ¿El DI de Vortech es compatible con Angular DI o son sistemas paralelos que coexisten?
3. ¿`tree-node/` es el árbol de features/módulos o un árbol DOM virtual?
4. ¿Hay tests que cubran el sistema DI? ¿Qué cobertura tienen?
5. ¿Está previsto corregir el typo `comunication/`?
