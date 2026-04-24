# Vortech v-repos — Guía para agentes

Este repo (`v-repos`) aloja **clones read-only** de repos a inventariar y los **artefactos de inventario** producidos por agentes. Es el workspace de ejecución de la Fase 1 del proceso definido en `.docs/`.

## Regla número uno

**`.docs/` es la fuente canónica de todas las reglas.** Si algo de este archivo contradice `.docs/`, gana `.docs/`. Antes de cualquier tarea, lee:

- `.docs/README.md` — índice general.
- `.docs/repos-plan/01-estructura-v-repos.md` — estructura de este repo.
- `.docs/repos-plan/02-mitigaciones.md` — riesgos y mitigaciones obligatorias.
- `.docs/inventario/` (tres archivos) — si la tarea es inventariar.
- `.docs/post-inventario/` (tres archivos) — si la tarea es analizar/proponer.

## Reglas transversales (siempre activas)

1. **Solo lectura sobre `repos/`.** Nunca modificar archivos dentro de `repos/<name>/`. Escribir únicamente en `inventory/<name>/`.
2. **Inventario estático.** Prohibido ejecutar `pnpm install`, `npm install`, `yarn`, `cargo build/check/fetch`, `dotnet restore/build`, `pip install`, `cmake --build`, `pio run`, formateadores con auto-fix, o linters con auto-fix. Solo lecturas y greps.
3. **No clonar repos reales sin instrucción explícita.** Las entradas en `repos.json` marcadas `"_example": true` son placeholders — no clonar.
4. **`.gitignore` es inviolable.** Nunca ignorar un patrón que bloquee contaminación por dependencias.
5. **Evidencia sobre intuición.** Toda afirmación cita file:line.
6. **Separación hechos/observación/valoración/hipótesis.** Nunca mezclar.
7. **Anclaje por SHA.** Todo artefacto incluye `source_repo` + `source_commit` coherentes con `_meta/source.md`.
8. **`.docs/` no se edita aquí.** Es copia derivada de `v-mono/.docs/`. Cualquier cambio se hace en `v-mono` y se re-sincroniza con `scripts/sync-docs.sh`.

## Estructura a respetar

```
v-repos/
├── .docs/                  ← copia de v-mono/.docs (no editar)
├── .github/
│   ├── copilot-instructions.md
│   └── agents/
│       ├── inventario.agent.md
│       └── post-inventario.agent.md
├── .vscode/
│   ├── settings.json
│   └── tasks.json
├── .cursor/
│   └── rules/
├── repos/                  ← fuentes (clone | mount | loose)
├── inventory/              ← artefactos del inventario
├── scripts/                ← bash; ver .docs/repos-plan/01 §7
├── repos.json              ← lista canónica de fuentes
├── .gitignore
├── .gitattributes
└── README.md
```

## Agentes disponibles

- `.github/agents/inventario.agent.md` — Fase 1: inventariar un repo siguiendo `.docs/inventario/`.
- `.github/agents/post-inventario.agent.md` — Fase 2: análisis y propuesta de unificación siguiendo `.docs/post-inventario/`.

Para Cursor, ver `.cursor/rules/`.

## Privacidad

`v-repos` es **privado** obligatoriamente, incluso si los repos clonados son públicos. Mezclar código de múltiples repos — aunque sea para análisis — no debe exponerse.
