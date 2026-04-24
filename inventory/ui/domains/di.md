---
kind: domain-inventory
repo: ui
domain: di
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `di`

## 1. Definición operativa
Sistema de inyección de dependencias (Dependency Injection) propio de la plataforma Vortech — independiente del sistema DI de Angular, orientado a servicios de plataforma y módulos de feature.

## 2. Implementaciones encontradas

| # | Package             | Path                    | Lenguaje | Madurez      | Rol                                         |
|---|---------------------|-------------------------|----------|--------------|---------------------------------------------|
| 1 | `@vortech/platform` | `packages/platform`     | ts       | beta         | `injection/` — InjectionToken, Injector, Provider, Scope |
| 2 | `@vortech/core`     | `packages/core`         | ts       | experimental | `injection/` — Service decorator, ServiceContainer |
| 3 | `@vortech/app`      | `packages/vortech`      | ts       | beta         | `di/` — integración DI con la plataforma app |

## 3. Responsabilidades cubiertas

- **InjectionToken y Injector** → `@vortech/platform/src/injection/`
- **Provider types** (useClass, useValue, useFactory) → `@vortech/platform/src/injection/providers/`
- **Scopes de inyección** → `@vortech/platform/src/injection/scopes/`
- **@Service decorator** → `@vortech/core/src/injection/`
- **ServiceContainer** → `@vortech/core/src/injection/`
- **Integración con app Vortech** → `@vortech/app/src/di/`

## 4. Contratos y tipos clave
- `InjectionToken<T>`, `Injector`, `Provider` → `packages/platform/src/injection/`
- `@Service()` decorator → `packages/core/src/injection/`
- `ServiceContainer` → `packages/core/src/injection/`
- `createInjector()`, `provideValue()`, `provideClass()` → `packages/platform/src/injection/`

## 5. Flujos observados
```
App
  → Platform.boot({ providers: [provideClass(MyService)] })
  → Injector resuelve dependencias (InjectionToken lookup)
  → @Service() registra clases como providers auto-detectados
  → ServiceContainer mantiene instancias por scope
  → @vortech/app/di integra esto con lifecycle de la app
```

## 6. Duplicaciones internas al repo
- Dos implementaciones de DI container: `@vortech/platform/src/injection/` y `@vortech/core/src/injection/` — no está claro si son la misma versión en distintos stages de madurez, o si uno usa al otro.
- `@vortech/app/di` podría ser sólo un wrapper sobre `@vortech/platform`.

## 7. Observaciones cross-language
Solo TypeScript. El sistema DI es un concepto análogo al de Angular DI o InversifyJS pero propio.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — dos implementaciones paralelas no integradas explícitamente
- **Consistencia interna:** inconsistente — mismo concepto en dos packages con distintas APIs
- **Justificación:** `packages/platform/src/injection/` y `packages/core/src/injection/` son ambos directorios separados con su propio InjectionToken/Injector sin clear cross-reference visible desde grep estático.

## 9. Sospechas para Fase 2
- `?:` El sistema DI de `@vortech/platform` podría ser el definitivo y `@vortech/core` el experimental — evidencia: `@vortech/platform` es `beta` y `@vortech/core` es `experimental`.
- `?:` La duplicación DI podría resolverse con una unificación en v-mono — es candidato alto para consolidación.
