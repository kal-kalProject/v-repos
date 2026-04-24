---
kind: domain-inventory
repo: ui
domain: runtime
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 5
languages_involved: [ts, rust]
---

# Dominio — `runtime`

## 1. Definición operativa
Sistema de runtime reactivo basado en el primitivo `Atom` — átomos observables de estado con cómputo derivado, notificación push, composición y control de efectos. Incluye también un prototipo de runtime TypeScript basado en Rust/QuickJS.

## 2. Implementaciones encontradas

| # | Package                | Path                           | Lenguaje | Madurez      | Rol                                       |
|---|------------------------|--------------------------------|----------|--------------|-------------------------------------------|
| 1 | `@vortech/common`      | `packages/common`              | ts       | beta         | `Atom<T>`, `ComputedAtom`, `EffectAtom`, `AtomEffect` |
| 2 | `@vortech/platform`    | `packages/platform`            | ts       | beta         | `Platform` — runtime host, lifecycle, boot |
| 3 | `@vortech/core`        | `packages/core`                | ts       | experimental | `CompositeAtom`, `RuntimeManager`         |
| 4 | `@vortech/rx`          | `packages/public/rx`           | ts       | experimental | `rx()` — API funcional sobre Atom         |
| 5 | `ts-runtime`           | `rust-ts-runtime`              | rust     | experimental | TypeScript runtime Rust+QuickJS (prototipo)|

## 3. Responsabilidades cubiertas

- **Átomo observable** → `@vortech/common` (`Atom<T>`, `atom()`, `computed()`, `effect()`)
- **Cómputo derivado** → `@vortech/common` (`ComputedAtom`) y `@vortech/core` (`CompositeAtom`)
- **Runtime host / boot** → `@vortech/platform` (`Platform.boot()`, `Platform.create()`, lifecycle)
- **API funcional rx** → `@vortech/rx` (operadores: map, filter, merge, combine, debounce, etc.)
- **Runtime TS nativo** → `ts-runtime` (Rust + rquickjs — ejecuta TS sin Node.js)

## 4. Contratos y tipos clave
- `Atom<T>`, `ComputedAtom<T>`, `EffectAtom<T>`, `AtomEffect` → `packages/common/src/atom/`
- `Platform`, `PlatformOptions`, `PlatformRef` → `packages/platform/src/`
- `RuntimeManager` → `packages/core/src/runtime/`
- `rx()`, operadores rx → `packages/public/rx/src/`

## 5. Flujos observados
```
App
  → Platform.boot({ providers })
  → plataforma crea Atom (state primitivo)
  → @vortech/rx expone API funcional sobre Atom
  → @vortech/core gestiona CompositeAtom y RuntimeManager
  → efectos reaccionan a cambios en Atom tree
```

## 6. Duplicaciones internas al repo
- `@vortech/common` y `@vortech/core` ambos tienen primitivos de Atom — posible overlap entre `ComputedAtom` y `CompositeAtom`.
- `@vortech/platform` y `@vortech/core` ambos tienen un concepto de "runtime" — `PlatformRef` vs `RuntimeManager`.
- `ts-runtime` (Rust) es un prototipo independiente que replica la capa de ejecución TS — duplica el propósito de Node.js runtime de la plataforma.

## 7. Observaciones cross-language
- La implementación principal es TypeScript. El prototipo Rust (`ts-runtime`) usa QuickJS (rquickjs) para ejecutar TS nativo — independiente del sistema Atom de TS.
- No hay bridge Rust↔TS en este dominio — son implementaciones paralelas sin integración visible.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial — hay duplicaciones entre @vortech/common, @vortech/core y @vortech/platform sin separación clara
- **Consistencia interna:** inconsistente — 3 packages definen primitivos de runtime con responsabilidades solapadas
- **Justificación:** `@vortech/common/src/index.ts` tiene exports masivos comentados (evidencia de refactoring en proceso). La coexistencia de `@vortech/platform/src/runtime/` y `@vortech/core/src/runtime/` sin integración clara sugiere migración en curso.

## 9. Sospechas para Fase 2
- `?:` El sistema Atom podría ser una reimplementación de Angular Signals o NgRx Signals — la API (`atom()`, `computed()`, `effect()`) es idéntica — evidencia: nombres en `packages/common/src/atom/`.
- `?:` `@vortech/common` y `@vortech/core` podrían fusionarse — si `@vortech/core` es la versión V2 de `@vortech/common`, hay migración en curso — evidencia: `@vortech/common-old` package explícitamente deprecated.
