# templates/ — Archivos listos para copiar a `v-repos/`

Este directorio contiene los archivos de configuración de editor/agente que van copiados **tal cual** dentro del checkout de `v-repos`.

## Mapa de copia

| Origen (aquí en `v-mono/.docs/repos-plan/templates/`) | Destino (en `v-repos/`)                 |
|-------------------------------------------------------|-----------------------------------------|
| `.github/copilot-instructions.md`                     | `.github/copilot-instructions.md`       |
| `.github/agents/inventario.agent.md`                  | `.github/agents/inventario.agent.md`    |
| `.github/agents/post-inventario.agent.md`             | `.github/agents/post-inventario.agent.md` |
| `.vscode/settings.json`                               | `.vscode/settings.json`                 |
| `.vscode/tasks.json`                                  | `.vscode/tasks.json`                    |
| `.cursor/rules/workspace.mdc`                         | `.cursor/rules/workspace.mdc`           |
| `.cursor/rules/inventario.mdc`                        | `.cursor/rules/inventario.mdc`          |
| `.cursor/rules/post-inventario.mdc`                   | `.cursor/rules/post-inventario.mdc`     |

## Notas

- **Los agentes `.agent.md`** siguen la convención GitHub Copilot (frontmatter `name` + `description` + cuerpo markdown con el sistema del rol).
- **Las reglas `.cursor/rules/*.mdc`** son el equivalente en Cursor:
  - `workspace.mdc` con `alwaysApply: true` aplica a toda sesión.
  - `inventario.mdc` y `post-inventario.mdc` usan `globs` para activarse contextualmente, o pueden invocarse manualmente vía `@inventario` / `@post-inventario` en el chat.
- **`settings.json`** apunta a `.github/copilot-instructions.md` vía `github.copilot.chat.agent.instructions` para que Copilot Chat los cargue automáticamente.
- **`tasks.json`** expone todos los scripts como tareas de VS Code con prompts de input donde aplica (`sync-docs`, `mount-subdir`, `add-loose`).

## Sincronización

Estos archivos viven en `v-mono/.docs/repos-plan/templates/` como fuente de verdad. Cuando cambian:

1. Edita aquí en `v-mono/`.
2. En `v-repos/`, ejecuta `scripts/sync-docs.sh <path-a-v-mono>` — sincroniza todo `.docs/` pero **no** toca `.github/`, `.vscode/`, `.cursor/` del root de `v-repos`.
3. Copia manualmente desde `v-repos/.docs/repos-plan/templates/` a sus destinos. O usa un flag futuro `--apply-templates` si se añade a `sync-docs.sh`.

Razón: los archivos dentro de `.github/`, `.vscode/`, `.cursor/` del root de `v-repos` podrían contener customizaciones locales no versionadas en `v-mono`; `sync-docs` no los sobreescribe para no perder esas ediciones.
