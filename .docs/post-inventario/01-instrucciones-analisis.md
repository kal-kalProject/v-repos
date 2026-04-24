# 01 — Instrucciones de análisis post-inventario

**Audiencia:** agentes (locales o cloud) que ejecutan la Fase 2.

**Precondición:** Fase 1 completa en `v-mono/inventory/`. Todos los repos objetivo tienen `_meta/completion-report.md` con `complete: true`.

**Objetivo:** convertir la evidencia cruda del inventario en una propuesta de unificación global hacia `v-mono`.

---

## 1. Principios del análisis

1. **Nada se descarta sin evidencia citada del inventario.** Cada afirmación apunta a un artefacto concreto de `v-mono/inventory/`.
2. **Se analiza por dominio, no por repo.** La unidad de comparación es el dominio cross-repo cross-language, no un package individual.
3. **Madurez y completitud pesan más que estética.** Un package "feo" pero funcional y usado supera a un package "elegante" experimental.
4. **Cross-language no es duplicación.** Si el mismo dominio existe en TS y C#, puede ser legítimo (plataforma poliglota) o duplicación accidental — se distingue con criterios del `02-criterios-unificacion.md`.
5. **Se proponen decisiones, no se toman.** La propuesta final va a revisión humana antes de ejecutarse.
6. **Cada hipótesis es falsable:** se documenta qué evidencia la cambiaría.

---

## 2. Workflow obligatorio

### Paso 1 — Consolidación

Leer todos los `inventory/<repo>/domains/*.md` y construir un índice consolidado:

```
v-mono/analysis/_index/domains.md
```

Por cada dominio único cross-repo:
- Lista de repos donde aparece.
- Lista de packages/lenguajes implementándolo.
- Madurez máxima observada y en qué package.
- Cantidad total de implementaciones.

Archivos a generar en este paso:
- `v-mono/analysis/_index/domains.md` — índice de dominios global.
- `v-mono/analysis/_index/packages-by-language.md` — vista transversal.
- `v-mono/analysis/_index/duplications-raw.md` — dump de todas las duplicaciones reportadas por Fase 1.

### Paso 2 — Comparación por dominio

Para cada dominio con ≥2 implementaciones (en cualquier combinación de repo/lenguaje), generar:

```
v-mono/analysis/comparisons/<domain>.md
```

Siguiendo la plantilla en `03-plantilla-propuesta-final.md §2`. Cada comparación incluye:

- **Matriz de implementaciones** (eje: repo × lenguaje × package).
- **Responsabilidades cubiertas por cada implementación**.
- **Divergencias semánticas** (no solo de naming).
- **Reutilización** (qué implementación usan otros packages).
- **Robustez** (madurez + presencia de tests + evidencia de uso real).

### Paso 3 — Detección de duplicación real

Categorizar cada par "A vs B" reportado como sospecha en la Fase 1:

| Categoría                         | Significado                                                       | Acción sugerida                      |
|-----------------------------------|-------------------------------------------------------------------|--------------------------------------|
| `duplicacion-exacta`              | Mismo propósito, mismo lenguaje, lógica equivalente               | Consolidar en uno                    |
| `duplicacion-divergente`          | Mismo propósito, mismo lenguaje, semánticas distintas             | Elegir canónico, migrar consumidores |
| `poliglota-legitimo`              | Mismo dominio en lenguajes distintos por diseño                   | Mantener + alinear contratos         |
| `falso-positivo`                  | Parecían duplicados pero cubren concerns distintos                | Documentar diferencia y cerrar       |
| `evolucion`                       | Versión vieja + versión nueva del mismo código                    | Retirar versión vieja                |
| `experimento-aislado`             | Prueba de concepto que nunca llegó a producción                   | Archivar o descartar                 |

**Reconciliación obligatoria de mounts.** Antes de categorizar cualquier par, el agente lee `repos.json` y los `_meta/source.md` de los repos involucrados. Si un par (A, B) es tal que uno es `source_type: mount` y el otro es su `parent_repo` (o un mount del mismo padre solapando el mismo path), la duplicación es **física** (mismo código copiado dos veces para inventariarlo desde ángulos distintos), no **lógica**. Se categoriza automáticamente como `falso-positivo` con nota `overlap-mount-parent` y no cuenta para métricas de duplicación real.

Salida: `v-mono/analysis/duplications/<domain>.md` con cada par categorizado y justificado.

### Paso 4 — Propuesta de canónico por dominio

Para cada dominio, el agente propone **qué implementación es canónica** y **cómo se proyecta a cada lenguaje necesario** en `v-mono`.

La implementación canónica NO es necesariamente una de las existentes: puede ser:
- **Existente sin cambios** — cuando una implementación ya cumple los criterios.
- **Existente con adaptaciones** — preservar lógica, refactor estructural.
- **Híbrido** — tomar piezas de varias implementaciones con justificación pieza-por-pieza.
- **Nueva desde cero** — solo si ninguna existente sirve y hay justificación fuerte.

Criterios completos en `02-criterios-unificacion.md`.

Salida: `v-mono/analysis/canonical-proposals/<domain>.md` con:
- Decisión propuesta (una de las 4 opciones).
- Piezas a preservar íntegramente (con paths de origen).
- Piezas a adaptar (con qué adaptación).
- Piezas a descartar (con justificación citada).
- Proyección a cada lenguaje en `v-mono` (ts, csharp, rust, cpp, embedded, python, según corresponda).
- Paths destino en `v-mono` (usando la estructura de `v-mono/.docs/repo/01-estructura-propuesta.md`).

### Paso 5 — Grafo de dependencias cross-domain

Construir un grafo global de dependencias entre dominios basado en lo observado:

```
v-mono/analysis/_graphs/domain-dependency-graph.md
```

Con:
- Nodos = dominios.
- Aristas = "dominio A consume dominio B" (basado en evidencia de inventarios).
- Detección de ciclos.
- Identificación de dominios fundacionales (sin dependencias hacia otros dominios de la plataforma).
- Identificación de dominios hoja (consumidos por pocos o ninguno).

Este grafo es input clave para el orden de migración (Paso 7).

### Paso 6 — Análisis de riesgo

Para cada dominio, evaluar riesgo de migración en 3 ejes:

- **Acoplamiento:** cuántos consumidores tiene en los repos actuales.
- **Divergencia semántica:** qué tan distintas son las implementaciones existentes.
- **Incompletitud:** qué piezas faltan vs. lo prometido.

Salida: `v-mono/analysis/_risk/risk-matrix.md` con score por dominio y justificación.

### Paso 7 — Plan de migración consolidado

Combinar:
- Grafo de dependencias (Paso 5).
- Riesgos (Paso 6).
- Propuestas canónicas (Paso 4).

En un plan secuenciado con fases y waves:

```
v-mono/analysis/migration-plan.md
```

Siguiendo la plantilla en `03-plantilla-propuesta-final.md §3`. El plan define:

- **Orden de migración** — fundacionales primero, hoja al final.
- **Agrupación en waves** — qué se migra en paralelo vs. en serie.
- **Criterios de aceptación por dominio** — cuándo se considera migrado.
- **Rollback strategy** — qué pasa si algo sale mal.
- **Packages/repos legacy que se archivan** (no se borran hasta que el canónico esté productivo).

### Paso 8 — Propuesta final integrada

Un documento único de alto nivel en:

```
v-mono/analysis/PROPUESTA-UNIFICACION.md
```

Plantilla en `03-plantilla-propuesta-final.md §1`. Resume:
- Hallazgos clave.
- Dominios y su estado.
- Decisiones propuestas con justificación.
- Plan de migración resumido.
- Riesgos globales.
- Decisiones que requieren input humano explícito.

---

## 3. Artefactos de entrada y salida

### Entrada (producido por Fase 1)

```
v-mono/inventory/
├── <repo-A>/
│   ├── summary/*.md
│   ├── domains/*.md
│   ├── status/*.md
│   └── _meta/*.md
├── <repo-B>/...
└── <repo-N>/...
```

### Salida (producida por Fase 2)

```
v-mono/analysis/
├── _index/
│   ├── domains.md
│   ├── packages-by-language.md
│   └── duplications-raw.md
├── comparisons/
│   └── <domain>.md
├── duplications/
│   └── <domain>.md
├── canonical-proposals/
│   └── <domain>.md
├── _graphs/
│   └── domain-dependency-graph.md
├── _risk/
│   └── risk-matrix.md
├── migration-plan.md
└── PROPUESTA-UNIFICACION.md
```

---

## 4. Reglas de honestidad intelectual

Estas reglas existen para prevenir las fallas típicas de análisis superficial:

1. **No descartar por nombre.** Un package llamado `legacy-*` puede tener lógica robusta. Se lee el código, no solo el nombre.
2. **No confundir duplicación estructural con duplicación semántica.** Dos tipos con shape similar pueden modelar conceptos distintos.
3. **Citar evidencia siempre.** Si no hay paths ni líneas, el argumento no se acepta.
4. **Distinguir "malo para `v-mono`" de "malo en sí".** Código que no encaja en la nueva estructura puede ser código excelente en su contexto original.
5. **No proponer rewrite total cuando hay migración viable.** Cada "rewrite" debe justificarse contra la alternativa de "preservar y adaptar".
6. **Reconocer incertidumbre.** Si el agente no puede decidir entre A y B, lo declara como "pendiente decisión humana" en lugar de elegir arbitrariamente.
7. **No dejar afirmaciones sin falsabilidad.** Cada hipótesis incluye "qué evidencia la cambiaría".

---

## 5. Reglas operativas del agente

1. Solo escribe en `v-mono/analysis/`.
2. Nunca modifica `v-mono/inventory/` (inmutable excepto cuando se re-inventaria).
3. Nunca modifica los repos inventariados.
4. Mantiene checkpoints en `v-mono/analysis/_meta/progress.md` si el trabajo es largo.
5. Al terminar, genera `v-mono/analysis/_meta/analysis-report.md` con:
   - Dominios analizados.
   - Decisiones propuestas.
   - Decisiones pendientes de humano.
   - Gaps del inventario detectados durante el análisis.

---

## 6. Cuándo devolver control al humano

El agente detiene el análisis y pide input humano cuando:

- Un dominio tiene >3 implementaciones de madurez similar sin criterio claro para elegir canónico.
- Hay conflicto semántico irreconciliable entre implementaciones (contradicen comportamiento).
- El grafo de dependencias tiene ciclos no resolubles automáticamente.
- Una implementación candidata viola un principio estructural del `v-mono/.docs/repo/`.
- Faltan partes del inventario (gaps detectados en Paso 1).

El agente escribe las preguntas en `v-mono/analysis/_meta/questions-for-human.md` agrupadas por dominio, cada una con:
- Contexto mínimo para responder.
- Opciones A/B/C que el agente consideró.
- Recomendación tentativa (con confianza low/medium/high).
