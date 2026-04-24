---
kind: domain-inventory
repo: ui
domain: theming
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
implementations_count: 9
languages_involved: [ts]
---

# Dominio — `theming`

## 1. Definición operativa
Sistema de theming de la plataforma UI Vortech — tokens de diseño (design tokens), variables CSS, presets de color/tipografía/componentes, y plugin de integración con Tailwind CSS. El sistema es basado en tokens y permite múltiples temas visuales intercambiables.

## 2. Implementaciones encontradas

| # | Package                       | Path                              | Lenguaje | Madurez      | Rol                                 |
|---|-------------------------------|-----------------------------------|----------|--------------|-------------------------------------|
| 1 | `@vortech/theming`            | `projects/ui/theming`             | ts       | beta         | Engine de theming — design tokens, CSS factory |
| 2 | `@vortech/tailwind`           | `projects/ui/tailwindcss-plugin`  | ts       | experimental | Plugin Tailwind CSS para integración |
| 3 | `@vortech-presets/aura`       | `projects/ui/presets/aura`        | ts       | beta         | Preset "Aura" (preset por defecto)   |
| 4 | `@vortech-presets/lara`       | `projects/ui/presets/lara`        | ts       | beta         | Preset "Lara"                        |
| 5 | `@vortech-presets/nora`       | `projects/ui/presets/nora`        | ts       | beta         | Preset "Nora"                        |
| 6 | `@vortech-presets/material`   | `projects/ui/presets/material`    | ts       | beta         | Preset Material Design               |
| 7 | `@vortech-presets/vscode`     | `projects/ui/presets/vscode`      | ts       | experimental | Preset VS Code dark/light            |
| 8 | `@vortech-presets/studio`     | `projects/ui/presets/studio`      | ts       | experimental | Preset para app Studio               |
| 9 | `@vortech-presets/cnc-monkey` | `projects/ui/presets/cnc-monkey`  | ts       | experimental | Preset oscuro para CNC app           |

## 3. Responsabilidades cubiertas

- **Design token engine** → `@vortech/theming` (ThemeOptions, DesignTokens, ColorScale, CSS factory)
- **Modo oscuro / claro** → `@vortech/theming` (ColorModes, ColorModeTokens)
- **Preset Aura** (default) → `@vortech-presets/aura`
- **Presets alternativos** → lara, nora, material
- **Preset ecosistema VS Code** → `@vortech-presets/vscode`
- **Presets específicos de app** → studio, cnc-monkey
- **Integración CSS utility-first** → `@vortech/tailwind`

## 4. Contratos y tipos clave
- `ThemeOptions`, `StyleOptions`, `DesignTokens`, `ColorScale`, `ColorModes` en `projects/ui/theming/src/index.ts`
- `BaseDesignTokens`, `ExtendedTokens`, `CssFactoryOptions` en theming
- `base-preset.ts`, `base-style-tokens.ts` en `projects/ui/presets/aura/src/` — contrato base de preset

## 5. Flujos observados
```
App Angular
  → configura preset (ej: @vortech-presets/aura)
  → @vortech/theming genera CSS variables a partir de DesignTokens
  → @vortech/ui consume variables CSS para estilizar componentes
  → @vortech/tailwind sincroniza tokens con clases utility Tailwind
```

## 6. Duplicaciones internas al repo
- Todos los presets (aura, lara, nora, material, vscode, studio, cnc-monkey) comparten estructura similar (`base-preset.ts`, `base-style-tokens.ts`, `components/`). El patrón está bien definido pero hay mucha repetición de código de tokens entre presets.

## 7. Observaciones cross-language
Solo TypeScript — el theming es 100% TS, los tokens se compilan a CSS variables en runtime.

## 8. Estado global del dominio en este repo
- **Completitud:** completo (engine + múltiples presets + integración Tailwind)
- **Consistencia interna:** consistente (todos los presets siguen la misma estructura)
- **Justificación:** 7 presets con estructura uniforme indica un sistema maduro. `@vortech/theming` exporta un sistema de tipos rico.

## 9. Sospechas para Fase 2
- `?:` El sistema de theming es análogo al de PrimeNG/PrimeFlex — la estructura de presets (aura, lara, nora, material) son los mismos nombres que PrimeNG — evidencia: `projects/ui/presets/aura`, `lara`, `nora`, `material`.
- `?:` La integración Tailwind (`@vortech/tailwind`) podría colisionar con el sistema de tokens si ambos definen utilidades de color — evidencia: coexistencia de `@vortech/tailwind` y `@vortech/theming`.
