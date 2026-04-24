# repos-plan — Estrategia de ejecución del inventario

Este directorio documenta **cómo** se materializa físicamente la Fase 1 del flujo de `v-mono/.docs/`: dónde viven los repos a inventariar, cómo se clonan, cómo se aíslan, y cómo los agentes producen artefactos sobre ellos sin contaminar el código fuente.

Es complementario a `inventario/`: `inventario/` define **qué** producir; `repos-plan/` define **dónde y cómo** ejecutar.

## Contenido

- `01-estructura-v-repos.md` — estructura y convenciones del repo `v-repos/` que aloja los clones + artefactos de inventario.
- `02-mitigaciones.md` — riesgos del enfoque "clonar sin instalar deps" y mitigaciones obligatorias en las instrucciones de los agentes.
- `03-modelo-y-costo.md` — elección de modelo AI (Gemini 2.5 Flash/Pro) para Fase 1 y Fase 2, estimación de costo.
- `04-prompt-inicializacion.md` — prompt listo para entregar a un agente que crea la estructura base de `v-repos` (scripts, `repos.json` de ejemplo, `.gitignore`, `.gitattributes`, `README.md`).
- `templates/` — archivos listos para copiar a `v-repos/`: `.github/copilot-instructions.md`, `.github/agents/*.agent.md`, `.vscode/settings.json`, `.vscode/tasks.json`, `.cursor/rules/*.mdc`. Ver `templates/README.md` para el mapa de copia.

## Decisión de alto nivel

- **`v-repos/`** = repo GitHub **privado**, separado de `v-mono`.
- Contiene los clones de todos los repos a inventariar en `v-repos/repos/<repo>/`.
- **Nunca** se instalan dependencias dentro (no `pnpm install`, no `dotnet restore`, no `cargo fetch`, etc.). Solo código fuente + `.git`.
- Los artefactos de inventario viven en `v-repos/inventory/<repo>/` con la misma estructura canónica que define `inventario/01-proposito-y-alcance.md §3`.
- Una vez completa la Fase 1, los artefactos de `v-repos/inventory/` se copian/migran a `v-mono/inventory/` para servir como input de Fase 2.

## Por qué `v-repos` existe

- Aísla el ruido operativo (múltiples clones, branches locales, experiencias por agente) del repo final `v-mono`, que debe quedar limpio.
- Permite paralelizar agentes distintos sobre repos distintos sin conflicto.
- Mantiene trazabilidad exacta: cada artefacto cita el `source_commit` del repo clonado.
- No fuerza al usuario a instalar toolchains de todos los lenguajes en una única máquina.
