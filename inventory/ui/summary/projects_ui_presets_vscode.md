---
kind: package-summary
repo: ui
package_name: "@vortech-presets/vscode"
package_path: projects/ui/presets/vscode
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/vscode`
- **Ruta en el repo:** `projects/ui/presets/vscode`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "VS Code" para el sistema UI de Vortech. Replica el design system de Visual Studio Code — colores oscuros característicos, tipografía monospace, paneles con contraste reducido — para construir herramientas de desarrollo con aspecto nativo de editor.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens que emulan las variables de color de VS Code (`editor.background`, `sideBar.background`, etc.) mapeados al sistema Vortech.
- Overrides de componentes con estética de editor de código.

## 4. Dependencias

- Infraestructura de theming del workspace.
- Potencial alineación con la paleta de temas de VS Code (Dark+, One Dark, etc.).

## 5. Consumidores internos

- `projects/ui/ai-chat` — app de chat IA que posiblemente usa este preset dado su integración con Monaco Editor.
- `projects/devtools` — herramientas de desarrollo con aspecto de editor.
- `projects/ui/demo` — como opción de tema en el showcasing.

## 6. Estructura interna

```
projects/ui/presets/vscode/
├── package.json
└── src/
    ├── index.ts
    └── (tokens de color y overrides estilo VS Code)
```

## 7. Estado

- **Madurez:** experimental
- Cobertura de componentes probablemente parcial; la estética VS Code puede no tener sentido para todos los componentes UI generales.

## 8. Dominios que toca

- **UI / Theming** — tokens visuales estilo editor.
- **Developer Tools** — interfaz de herramientas de desarrollo.
- **Design System** — variante especializada para tooling interno.

## 9. Observaciones

- El hecho de tener un preset VS Code sugiere que Vortech construye al menos una herramienta de desarrollo con interfaz estilo editor (posiblemente `ai-chat` o `devtools`).
- Mantener la coherencia con los cambios visuales de VS Code puede ser costoso si se actualiza frecuentemente.

## 10. Hipótesis

- El preset está diseñado principalmente para `projects/ui/ai-chat` y `projects/devtools`, no para apps de usuario final.
- Los tokens probablemente son un subconjunto de las variables CSS que VS Code expone públicamente.

## 11. Preguntas abiertas

1. ¿El preset incluye variantes light y dark de VS Code?
2. ¿Se usan las variables CSS reales de VS Code o se hardcodean los valores?
3. ¿Tiene sentido aplicar este preset en una app Angular standalone fuera del contexto de un webview de VS Code?
4. ¿Hay plan de elevar a beta una vez que `ai-chat` o `devtools` alcancen mayor madurez?
