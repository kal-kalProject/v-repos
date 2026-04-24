# 03 — Plantilla de propuesta final

Tres plantillas de los artefactos críticos que produce la Fase 2.

---

## §1 — `PROPUESTA-UNIFICACION.md`

Documento único de alto nivel que consolida los hallazgos y decisiones de toda la Fase 2.

Archivo: `v-mono/analysis/PROPUESTA-UNIFICACION.md`

```markdown
---
kind: unification-proposal
generated_at: <ISO-8601>
agent_id: <agent-id>
analyzed_repos: [<repo-A>, <repo-B>, ...]
analyzed_domains: <n>
status: borrador | revision-humana | aprobado
---

# Propuesta de unificación global → `v-mono`

## 1. Resumen ejecutivo

<3-6 párrafos que capturan:>
- <Qué se analizó>
- <Hallazgos clave>
- <Decisiones propuestas a alto nivel>
- <Riesgos principales>
- <Qué necesita decisión humana antes de ejecutar>

## 2. Repos analizados

| Repo          | Path / URL             | Packages | Dominios tocados | Madurez general |
|---------------|------------------------|----------|------------------|-----------------|
| `<repo-A>`    | <path/url>             | <n>      | <n>              | <valoración>    |

## 3. Inventario global consolidado

| Métrica                              | Valor      |
|--------------------------------------|------------|
| Packages inventariados total         | <n>        |
| Dominios únicos detectados           | <n>        |
| Implementaciones por dominio (media) | <n>        |
| Duplicaciones confirmadas            | <n>        |
| Duplicaciones descartadas (falso pos)| <n>        |
| Implementaciones `maduro`            | <n>        |
| Implementaciones `abandonado`        | <n>        |

## 4. Decisiones por dominio

Tabla compacta — detalle completo en `canonical-proposals/<domain>.md`.

| Dominio       | Decisión                    | Origen canónico           | Lenguajes destino | Riesgo |
|---------------|-----------------------------|---------------------------|-------------------|--------|
| `identity`    | preservar-con-adaptacion    | <repo>/<package>          | ts, csharp        | medio  |
| `wire`        | hibrido                     | <repo>/<pkg-A> + <pkg-B>  | ts, csharp, rust  | alto   |
| `theming`     | preservar-con-adaptacion    | <repo>/<package>          | ts, angular       | medio  |
| `layout`      | nuevo-desde-cero            | —                         | ts, angular       | medio  |
| `di`          | hibrido                     | <repo>/<pkg-A> + <pkg-B>  | ts, csharp        | alto   |
| ...           | ...                         | ...                       | ...               | ...    |

**Leyenda decisiones:**
- `preservar-existente` / `preservar-con-adaptacion` / `hibrido` / `nuevo-desde-cero` / `archivar-sin-reemplazar` / `obsoleto`.

## 5. Grafo de dependencias entre dominios

<diagrama textual o referencia a `_graphs/domain-dependency-graph.md`>

```
fundacionales:
  common, contracts, runtime

capa base:
  di → common
  theming → common, runtime
  wire → common, identity

capa media:
  transport → wire
  commands → di
  layout → di, runtime, theming

capa alta:
  plugin-host → di, commands, layout, wire
  ui-kit → theming, runtime
```

## 6. Plan de migración en waves

| Wave | Dominios                                    | Precondición            | Resultado esperado       |
|------|---------------------------------------------|-------------------------|--------------------------|
| 0    | infra monorepo + contracts base + tooling   | ninguna                 | `v-mono` vacío + CI verde|
| 1    | common, runtime                             | wave 0                  | bases fundacionales      |
| 2    | di, theming, wire                           | wave 1                  | capa base                |
| 3    | transport, commands, layout                 | wave 2                  | capa media               |
| 4    | plugin-host, ui-kit                         | wave 3                  | capa alta                |
| 5    | apps específicas                            | wave 4                  | apps funcionales         |
| 6    | cleanup: archivar repos origen              | wave 5                  | v-mono como único vivo   |

Detalle completo en `migration-plan.md`.

## 7. Riesgos globales

| Riesgo                                            | Severidad | Mitigación                          |
|---------------------------------------------------|-----------|-------------------------------------|
| Divergencia contratos entre lenguajes al migrar   | alta      | Tests de contrato cross-language en CI |
| Consumidores de packages legacy que se pierden    | media     | Grep cross-repo antes de archivar  |
| Perder lógica al "adaptar estructuralmente"       | alta      | Diff semántico + tests de regresión |
| Migración parcial que deja v-mono mitad híbrido   | alta      | Gate: no entrar a wave N+1 hasta N cerrada |
| Decisiones arbitrarias por empates                | media     | Lista explícita de empates pendientes § 9 |

## 8. Convenciones que `v-mono` adopta

Confirmar/ajustar las de `v-mono/.docs/repo/03-convenciones-cross-language.md` con base en los hallazgos del análisis.

- <confirmación o ajuste 1>
- <confirmación o ajuste 2>

## 9. Decisiones que requieren input humano

Cada punto lista una decisión que el agente no puede tomar solo.

### 9.1 <tema>

**Contexto:** <2-4 líneas>
**Opciones:**
- A — <opción>
- B — <opción>
- C — <opción>

**Recomendación tentativa:** A, confianza: medium
**Esta recomendación cambiaría si:** <cláusula de falsabilidad>

## 10. Siguiente paso

<Una acción concreta. Ejemplo:>
Revisar §9 con el usuario. Una vez resueltas las decisiones pendientes, ejecutar Wave 0 del plan de migración.
```

---

## §2 — Comparación por dominio

Archivo: `v-mono/analysis/comparisons/<domain>.md`

```markdown
---
kind: domain-comparison
domain: <domain-name>
analyzed_at: <ISO-8601>
implementations_count: <n>
repos_involved: [<repo-A>, <repo-B>, ...]
languages_involved: [ts, csharp, rust, ...]
---

# Comparación — dominio `<domain>`

## 1. Definición unificada del dominio

<3-6 líneas describiendo qué significa este dominio a nivel cross-repo, consolidando las definiciones de cada `inventory/<repo>/domains/<domain>.md`>

## 2. Matriz de implementaciones

| # | Repo          | Package              | Lenguaje | Madurez       | Consumidores | Tests  | LOC    |
|---|---------------|----------------------|----------|---------------|--------------|--------|--------|
| 1 | <repo-A>      | `<package>`          | ts       | maduro        | 5            | 70%    | 1200   |
| 2 | <repo-A>      | `<package>`          | csharp   | beta          | 2            | 30%    | 800    |
| 3 | <repo-B>      | `<package>`          | ts       | experimental  | 0            | 0%     | 400    |

## 3. Responsabilidades comparadas

| Capability                          | Impl 1 | Impl 2 | Impl 3 |
|-------------------------------------|--------|--------|--------|
| <capability A>                      | ✅     | ✅     | ❌     |
| <capability B>                      | ✅     | ⚠️     | ❌     |
| <capability C>                      | ❌     | ✅     | ✅     |
| <capability D>                      | ✅     | ❌     | ❌     |

Leyenda: ✅ cubierta / ⚠️ parcial / ❌ no cubierta.

## 4. Divergencias semánticas
<donde el mismo concepto se modela distinto>

- **<aspecto>:** Impl 1 lo modela como <X>, Impl 2 como <Y>, Impl 3 como <Z>.
  **Implicación:** <qué significa para la unificación>.

## 5. Contratos observados

### 5.1 Tipos/interfaces comunes
<los que aparecen en múltiples implementaciones (aunque con nombres distintos)>

- <Concepto>: Impl 1 lo llama `<T1>`, Impl 2 lo llama `<T2>`.

### 5.2 Tipos únicos por implementación

- Impl 1 aporta `<T>` — no existe en otras.
- Impl 2 aporta `<T>` — no existe en otras.

## 6. Uso real cross-repo

<qué packages de otros dominios consumen cada implementación>

- Impl 1 → consumida por `<pkg-X>`, `<pkg-Y>`.
- Impl 2 → consumida por `<pkg-Z>`.
- Impl 3 → sin consumidores.

## 7. Aplicación de criterios de unificación

Referencia: `v-mono/.docs/post-inventario/02-criterios-unificacion.md §2`.

| Criterio                   | Impl 1 | Impl 2 | Impl 3 | Observación               |
|----------------------------|--------|--------|--------|---------------------------|
| 1. Completitud             | <n>    | <n>    | <n>    | <nota>                    |
| 2. Madurez                 | 4      | 3      | 2      |                           |
| 3. Uso real                | 5      | 2      | 0      |                           |
| 4. Tests                   | 3      | 1      | 0      |                           |
| 5. Alineación estructural  | <n>    | <n>    | <n>    |                           |
| 6. Coherencia contratos    | n/a    | n/a    | n/a    |                           |
| 7. Costo migración         | bajo   | alto   | n/a    |                           |
| 8. Aislamiento contexto    | alto   | medio  | alto   |                           |

## 8. Propuesta preliminar
<Sugerencia para `canonical-proposals/<domain>.md` — no es la decisión final, es input>

- Decisión sugerida: `<categoría>`.
- Origen canónico: Impl 1.
- Adaptaciones requeridas: <lista breve>.
- Piezas específicas a tomar de Impl 2: <lista con archivos>.

## 9. Preguntas pendientes

- <pregunta 1>
- <pregunta 2>
```

---

## §3 — Plan de migración

Archivo: `v-mono/analysis/migration-plan.md`

```markdown
---
kind: migration-plan
generated_at: <ISO-8601>
agent_id: <agent-id>
total_waves: <n>
total_domains_in_scope: <n>
---

# Plan de migración → `v-mono`

## 1. Principios del plan

- Ningún dominio se migra hasta que sus dependencias estén migradas.
- Los contratos se establecen antes que las implementaciones.
- Cada wave tiene criterios de aceptación explícitos.
- Los repos origen se mantienen vivos hasta que el canónico sustituya completamente.
- Cada wave es un branch de larga duración en `v-mono` mergeado al cerrar.

## 2. Prerequisitos transversales (Wave 0)

Antes de migrar cualquier dominio:

- [ ] Monorepo `v-mono` creado con estructura de `v-mono/.docs/repo/01-estructura-propuesta.md`.
- [ ] Todos los archivos de config del root (`02-workspace-configs.md`) en su sitio.
- [ ] Scripts de orquestación cross-language funcionales.
- [ ] CI por toolchain configurado y verde con proyectos vacíos.
- [ ] Tooling de codegen funcional para generar desde `contracts/`.
- [ ] Convenciones (`03-convenciones-cross-language.md`) enforced vía linters.

## 3. Waves de migración

### Wave <N> — <título>

**Precondición:** <wave(s) previos cerrados>.
**Dominios en esta wave:** <lista>.

#### Wave <N>.1 — `<domain-a>`

**Canónico:** `<repo>/<package>` (según `canonical-proposals/<domain-a>.md`).
**Destino en `v-mono`:**
- `contracts/<domain-a>/`
- `ts/packages/<package-name>/`
- `dotnet/src/V.<Domain>.<Role>/`
- `rust/crates/v-<domain>-<role>/` (si aplica)

**Pasos:**

1. [ ] Crear `contracts/<domain-a>/<domain-a>.schema.json` extrayendo tipos/eventos del canónico.
2. [ ] Configurar codegen para los lenguajes destino.
3. [ ] Migrar implementación canónica adaptando estructura (ref: decisión en `canonical-proposals/`).
4. [ ] Migrar tests; añadir tests de contrato nuevos donde falten.
5. [ ] Proyectar a lenguajes adicionales si aplica.
6. [ ] Redirigir consumidores internos al canónico nuevo.
7. [ ] Marcar packages legacy como `status: deprecated` en sus READMEs (en el repo origen).

**Criterios de aceptación:**
- [ ] Build verde en `v-mono` para el dominio.
- [ ] Tests de contrato verdes en todos los lenguajes destino.
- [ ] Al menos un consumidor real usando el canónico.
- [ ] Zero imports desde consumidores hacia implementaciones legacy.
- [ ] `inventory/` actualizado con el nuevo estado.

**Rollback:**
- <qué hacer si se detecta un defecto post-migración>.

---

### Wave <N+1> — ...

<mismo formato>

## 4. Cleanup final (última wave)

- [ ] Todos los consumidores históricos apuntan a `v-mono`.
- [ ] Repos legacy archivados (read-only) o eliminados con backup.
- [ ] `v-mono` es el único repo activo de la plataforma.
- [ ] Documentación de arquitectura actualizada en `v-mono/.docs/` con el estado final.
- [ ] Lecciones aprendidas documentadas en `v-mono/.docs/retrospective.md`.

## 5. Métricas de progreso

| Métrica                                  | Baseline | Target | Actual |
|------------------------------------------|----------|--------|--------|
| Dominios en `v-mono`                     | 0        | <n>    | <n>    |
| Repos legacy archivados                  | 0        | <n>    | <n>    |
| Packages con contrato canónico           | <n>      | <n>    | <n>    |
| Duplicaciones activas                    | <n>      | 0      | <n>    |
| Tests de contrato cross-language verdes  | 0        | 100%   | <%>    |
| Build total verde cross-toolchain        | —        | sí     | <s/n>  |

## 6. Decisiones que bloquean el plan si quedan abiertas

<lista de items de `PROPUESTA-UNIFICACION.md §9` que deben resolverse antes de ciertas waves>

- Decisión pendiente <X> bloquea Wave <N> porque <razón>.
- Decisión pendiente <Y> bloquea Wave <N+1>.

## 7. Notas del agente
<comentarios relevantes>
```

---

## Meta: uso de estas plantillas

- Los agentes de Fase 2 las usan **tal cual**. Los headers, los nombres de sección, el frontmatter son **obligatorios** — permiten que herramientas futuras parseen automáticamente los artefactos.
- Si una sección no aplica a un dominio concreto, se incluye igual con contenido `N/A — <razón>`.
- Nuevas secciones pueden añadirse pero **nunca** renombrarse ni eliminarse.
