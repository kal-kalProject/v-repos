# 02 — Mitigaciones al enfoque "sin dependencias instaladas"

Clonar los repos sin instalar sus deps (ver `01-estructura-v-repos.md §4`) ahorra espacio y evita contaminar el repo, pero introduce riesgos para el inventario. Este documento enumera cada riesgo y la mitigación obligatoria.

## Matriz riesgo/mitigación

| # | Riesgo                                                                 | Impacto sobre el inventario                                | Mitigación obligatoria                                                                                               | Enforcement                         |
|---|------------------------------------------------------------------------|------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------|-------------------------------------|
| 1 | Sin resolución de módulos, el agente puede confundir "package no usado" con "package cuyas deps faltan" | Falsos positivos en `duplicaciones`, `abandonado`         | "Uso real" se mide por **grep estático de imports** a lo largo del árbol fuente, **nunca** por resolución de módulos | `inventario/02 §3`                  |
| 2 | Sin `tsc` / `cargo check` / `dotnet build`, no se puede verificar que compile | Clasificación `maduro` pierde su señal más fuerte         | Compensar con señales estáticas: cobertura de tipos, presencia de tests, `git log`, densidad de TODOs. Etiquetar como `maduro-aparente` si falta build verification | `inventario/02 §3.2`                |
| 3 | Sin tests ejecutados, no se sabe si pasan                              | No se puede reportar "tests rotos"                         | Reportar solo **presencia** de tests y conteo, **no** estado de ejecución. Marcar explícitamente como no verificado | `inventario/02 §2 Paso 6`           |
| 4 | Repo clonado puede desincronizarse con origen mientras dura el inventario | Artefactos quedan citando código que ya cambió             | Registrar `source_commit` en frontmatter de **todo** artefacto. El agente valida coherencia contra `_meta/source.md` | `repos-plan/01 §6`                  |
| 5 | Mezclar código ajeno con artefactos produce confusión de scope         | Riesgo de commits accidentales en `repos/<name>/`          | Separación física `repos/` vs `inventory/`. Principio "solo lectura" reforzado: el agente **nunca** escribe en `repos/` | `inventario/02 §1.1` + hook         |
| 6 | Si alguien instala deps por accidente, el repo crece en GB              | Repo inservible, contamina PRs                             | `.gitignore` robusto (§4 del doc anterior) + `gate-no-deps.sh` como pre-commit hook y en CI                          | script + CI                         |
| 7 | Repos públicos mezclados con privados en un único repo `v-repos`       | Exposición no intencionada                                 | `v-repos` es **privado** siempre                                                                                      | convención + revisión al crear      |
| 8 | Paths symlinked o con case-sensitivity distinta entre OS                | Artefactos inconsistentes entre Windows/Mac/Linux          | `.gitattributes` con `text eol=lf`; rutas relativas siempre con `/`, nunca `\`                                        | convención + `.gitattributes`       |
| 9 | Agente intenta ejecutar `pnpm install` / `cargo build` "para ayudar"   | Contamina el repo, viola el principio de inventario estático | Instrucción explícita al agente: **prohibido** ejecutar comandos de instalación o build                              | `inventario/02 §1.7` (nuevo)        |
| 10| Monorepos con workspaces (pnpm, cargo, dotnet) pueden tener packages definidos en el manifest raíz que no son directorios físicos obvios | Packages saltados en el inventario                         | Paso 1 del workflow debe **leer** los manifests de workspace (`pnpm-workspace.yaml`, `Cargo.toml` virtual, `.sln`, `.slnx`) y expandir sus globs antes de clasificar | `inventario/02 §2 Paso 1` (refuerzo)|
| 11| Un repo con deps privadas no resueltas puede tener imports a packages que **no existen en repos/**, pareciendo "imports rotos" | Falso positivo de `incompletitud`                          | El agente distingue: import a package **del mismo repo** ausente = incompletitud; import a dependencia externa = no-señal | `inventario/02 §3.4`                |
| 12| Sin `package-lock.json` / `Cargo.lock` actualizado, el análisis de versiones de deps no es confiable | Afirmaciones sobre versiones pueden ser incorrectas        | El inventario **no** intenta analizar versiones transitivas. Solo versiones declaradas en manifests                  | `inventario/02 §3` (regla nueva)    |

## Principios derivados

1. **El inventario es estático.** No ejecuta builds, no instala, no corre tests.
2. **Lo que no se puede medir estáticamente se reporta como no verificado, no se infiere.**
3. **La ausencia de `node_modules`/`target`/`bin` es intencional**, y cualquier agente que "quiera arreglarlo" está violando la política.
4. **`source_commit` es el anclaje temporal** de toda afirmación.

## Hook pre-commit (recomendado)

En `v-repos/.husky/pre-commit` o equivalente:

```bash
#!/usr/bin/env bash
set -e
./scripts/gate-no-deps.sh
```

En CI (`v-repos/.github/workflows/verify.yml`):

```yaml
name: verify
on: [push, pull_request]
jobs:
  no-deps:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: ./scripts/gate-no-deps.sh
```

## Regla añadida a los agentes

Nueva regla en el principio operativo de `inventario/02 §1`:

> **Prohibido ejecutar comandos que modifiquen el árbol de `repos/<name>/`.** Esto incluye `pnpm install`, `npm install`, `yarn`, `cargo build/check/fetch`, `dotnet restore/build`, `pip install`, `cmake --build`, `pio run`, cualquier formateador (`prettier --write`, `dotnet format`, `cargo fmt`), y cualquier linter con auto-fix. Lecturas y greps son libres.

Esta regla se documenta explícitamente en `inventario/02-instrucciones-agentes.md`.
