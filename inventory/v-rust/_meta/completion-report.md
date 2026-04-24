---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: completion-report
repo: v-rust
generated_at: 2026-04-24T16:35:00Z
agent_id: cursor-agent
complete: true
---

# Completion Report — `v-rust`

## Checklist (ref: `01-proposito-y-alcance.md` §8)

- [x] Cada package tiene `summary/*.md` (comprobado: 71 resúmenes >= 71 entradas en `classification.md`)
- [x] Cada dominio con implementación significativa listado bajo `domains/*.md` (10 archivos)
- [x] Existe al menos un `status/*.md` con las cinco secciones obligatorias
- [x] Frontmatter coherente con `_meta/source.md` en artefactos generados (ver `scripts/validate-inventory.sh v-rust` exit 0)
- [x] Paths con manifest o fragmentos documentados; “no package” anotado para `mach4/`, `nada-que-ver/`, `examples/`
- [x] Referencias cruzadas relativas donde aplica (`summary` ↔ `domains`)

## Estadísticas

- Packages inventariados: 71
- Dominios documentados: 10
- Bugs con evidencia de runtime (Fase 1): 0
- Duplicaciones internas (tabla en `status/repo.md`): 4 filas
- Incompletitudes puntuales (muestras con `archivo:línea`): 2+ (TODO, carpetas sin `Cargo.toml`)

## Paquetes no clasificados

- `mach4/`, `nada-que-ver/`, `examples/`: no tienen en la raíz del subárbol un `package.json` / `Cargo.toml` / `.csproj` adoptado como manifest único; quedan fuera de la tabla de clasificación salvo la nota al pie de `classification.md`.

## Dominios no documentados explícitamente (intencionales o solapados)

- **CNC / firmware:** solo referencia indirecta vía `Orchestrator.Agents.CncBridge` (C#). Sin un dominio “embedded” en este entregable (queda cubierto bajo `orchestration.md`).
- **Contracts:** `contracts/gen/ContractGen` ya está en `summary/`; dominio de “contratos de código” podría extraerse en Fase 2 si hace falta un `domains/` dedicado.

## Archivos o patrones anómalos

- `test.db`, `test.db-shm`, `test.db-wal` en la raíz: restos de ejecución local, no módulo de producto.
- `crates/v-ttm/src/eval/tests.rs` de tamaño excepcional; ver `status/repo.md` §Deuda.
- Carpetas TTM con `ttm.json` y sin `Cargo.toml`: anomalía de empaquetado respecto al resto de `crates/`.

## Notas adicionales para Fase 2

- Añadir búsqueda cruzada de `ProjectReference` y dependencias de workspace Rust cuando se permita `dotnet`/`cargo` en un entorno controlado.
- Profundizar en resúmenes generados: muchos cuerpos son plantilla mínima para cumplir Fase 1 a escala; citar módulos y API real en iteración posterior.
