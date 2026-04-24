---
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
kind: post-inventario-prep
scope: repos-excluidos-y-estado
generated_at: 2026-04-24T20:30:00Z
generated_by: cursor
---

# Repositorios: descartes, pendientes e inventario

Este archivo cumple la precondición de `post-inventario.mdc`: documentar **repos no inventariados** o **requisitos** antes de un análisis Fase 2 unificado bajo `v-mono`. Referencia de lista: `e:/v-repos/repos.json`.

## Hechos (meta-repo `v-repos`)

- Los seis nombres en `repos.json` tienen ruta bajo `repos/<name>/` e inventario bajo `inventory/<name>/` (presencia de carpetas en el arbol de trabajo, no re-auditoría de completitud hoy de cada `completion-report.md`).
- Ninguno figura explícitamente como **excluido** de análisis por decisión de producto: no hay “descarte” fijo documentado de negocio en este registro.
- `kalProject.MsAccess` está verificado con `complete: true` (validación `bash scripts/validate-inventory.sh kalProject.MsAccess` con exit 0, 2026-04-24).

## Requisito para análisis global (Fase 2 “grande”)

- Antes de consolidar en `v-mono/analysis/`, comprobar **cada** `inventory/<repo>/_meta/completion-report.md` con `complete: true` y un SHA alineado con `repos/<repo>` si se aplica un gate de coherencia.
- Si un repo queda excluido a propósito (p. ej. obsoleto o sustituido), añadir aquí fila: **repo**, **motivo**, **evidencia/enlace**, **fecha**.

## Próxima acción (cuando el humano cierre el alcance)

- Si solo interesa alinear con `kalProject.MsAccess`, seguir con `inventory/_analysis-preview/kalProject.MsAccess/`; no hace falta “descartar” otros repos, solo fijar **scope** de la tarea.
- Unificación con `vortech` u otros: ampliar a comparación **por dominio** (`wire`, `host`, `transport`, etc.) con lectura de `inventory/vortech/domains/*.md` y los de `kalProject.MsAccess`.
