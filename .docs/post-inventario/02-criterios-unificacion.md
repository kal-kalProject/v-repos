# 02 — Criterios de unificación

**Objetivo:** definir reglas objetivas para elegir qué implementación se convierte en canónica en `v-mono`, y cómo se proyecta a los lenguajes que la necesiten.

Estos criterios se aplican durante la Fase 2 (análisis) a cada dominio que tiene múltiples implementaciones candidatas.

---

## 1. Regla maestra

> **Preservar antes que reescribir. Adaptar antes que reimplementar. Reescribir solo cuando ninguna opción existente sirva y haya evidencia de por qué.**

Cualquier propuesta de rewrite total debe justificarse contra al menos las opciones de "preservar + adaptar" con evidencia citada.

---

## 2. Criterios para elegir implementación canónica

Cuando hay múltiples implementaciones del mismo dominio, se aplican **en orden**:

### Criterio 1 — Completitud funcional

Cuánto de las responsabilidades del dominio cubre la implementación, según los `domains/<domain>.md` de cada repo.

- Score: porcentaje de capabilities cubiertas vs. el total observado cross-repo.
- Peso: **alto**. Una implementación 90% completa supera a una 30% completa salvo que la 30% cubra capabilities críticas que la otra no toca.

### Criterio 2 — Madurez

Según `madurez:` declarado en el inventario:

| Madurez         | Score |
|-----------------|-------|
| `maduro`        | 4     |
| `beta`          | 3     |
| `experimental`  | 2     |
| `abandonado`    | 1     |
| `indeterminado` | 0     |

Peso: **alto**. `maduro` con tests supera a `experimental` sin tests.

### Criterio 3 — Uso real

Cantidad de consumidores internos observados en los inventarios (sección §5 del package summary).

- Implementación con ≥3 consumidores supera una con 0 consumidores.
- Peso: **alto**. Reemplazar algo usado es costoso; reemplazar algo no usado es barato.

### Criterio 4 — Tests

Existencia y cobertura de tests.

- Score: binario + bonus.
  - Sin tests: 0.
  - Tests presentes: 2.
  - Tests + cobertura >50%: 3.
  - Tests + cobertura >70% + casos edge: 4.
- Peso: **medio**.

### Criterio 5 — Alineación estructural

Qué tan cerca está la implementación de las convenciones de `v-mono/.docs/repo/03-convenciones-cross-language.md`.

- Archivos modulares (no monolíticos): +1.
- Un tipo público por archivo: +1.
- Exports via `index.*`: +1.
- Naming acorde al estándar: +1.
- Sin patrones obsoletos en reporte de estado: +1.

Peso: **medio**. Una implementación con mala estructura pero buena semántica **sí se puede preservar** — se adapta estructuralmente sin reescribir la lógica.

### Criterio 6 — Coherencia con contratos del dominio

Si existe un `.schema.json` o contrato de referencia (de cualquier repo), qué tan fielmente la implementación lo respeta.

- Peso: **alto** cuando hay contrato declarado. Neutro cuando no lo hay.

### Criterio 7 — Costo de migración de consumidores

Si la implementación se convierte en canónica, cuántos cambios deben hacer sus consumidores actuales.

- Peso: **medio**. Una implementación ligeramente inferior pero con migración trivial puede superar a una superior con migración costosa.

### Criterio 8 — Aislamiento de contexto

Implementaciones que dependen fuertemente de un framework específico (ej. Angular inyectado en la lógica) pierden puntos si el dominio debe vivir en múltiples lenguajes.

- Peso: **medio a alto** para dominios poliglotas.

---

## 3. Matriz de decisión

Por cada dominio con implementaciones candidatas, el agente llena:

| Criterio              | Peso | Impl A | Impl B | Impl C |
|-----------------------|------|--------|--------|--------|
| 1. Completitud        | 3    | 4/5    | 3/5    | 2/5    |
| 2. Madurez            | 3    | 4/4    | 3/4    | 2/4    |
| 3. Uso real           | 3    | 5 cons.| 1 cons.| 0 cons.|
| 4. Tests              | 2    | 70%    | 0%     | 30%    |
| 5. Alineación estruct.| 2    | 3/5    | 5/5    | 4/5    |
| 6. Coherencia contr.  | 3    | n/a    | n/a    | n/a    |
| 7. Costo migración    | 2    | bajo   | alto   | n/a    |
| 8. Aislamiento contx. | 2    | alto   | medio  | alto   |

La matriz no produce un score numérico mecánico — el agente interpreta y justifica en texto. Los pesos son guía, no fórmula.

---

## 4. Categorías de decisión

Aplicando los criterios, cada dominio resulta en una de estas decisiones:

### 4.1 `preservar-existente`

Una implementación cumple los criterios sin necesidad de cambios estructurales. Se mueve a `v-mono/` con paths actualizados y namespace estándar, pero el código fuente es esencialmente el mismo.

**Ejemplo de caso:** un helper Rust maduro, aislado, bien testeado.

### 4.2 `preservar-con-adaptacion`

La lógica de una implementación se preserva íntegra pero se adapta estructuralmente:
- Splits de archivos monolíticos.
- Rename de símbolos al estándar.
- Migración de DI manual a `provide*` functions.
- Extracción del contrato a `contracts/<domain>/`.

**Ejemplo de caso:** `platform/legacy/theming` — motor de tokens robusto que se preserva, accessor global + StyleInjector se reemplazan, API pública se refactoriza a signals.

### 4.3 `hibrido`

Se combinan piezas de 2+ implementaciones. Cada pieza se documenta con origen y justificación de por qué se elige esa sobre las otras.

**Ejemplo de caso:** dominio `di` donde una implementación tiene el mejor contenedor y otra el mejor sistema de scopes.

### 4.4 `nuevo-desde-cero`

Ninguna implementación existente sirve como base — se diseña desde cero. Se documenta **por qué** ninguna existente sirve y se referencia qué piezas de las existentes se consultaron como inspiración.

**Ejemplo de caso:** un dominio que nunca fue implementado completamente en ningún repo.

### 4.5 `archivar-sin-reemplazar`

El dominio existía como experimento pero no es prioritario para `v-mono`. Se archiva referenciado pero no se migra inmediatamente.

### 4.6 `obsoleto`

Funcionalidad reemplazada por otra más general. Se descarta explícitamente con justificación.

---

## 5. Reglas duras de unificación

Se aplican siempre, sin excepción:

1. **Un dominio = un contrato canónico.** Si un dominio existe en 3 lenguajes, los 3 usan el mismo `contracts/<domain>/` como fuente.
2. **Ningún dominio queda con implementaciones divergentes activas post-migración.** Al terminar la migración de un dominio, todas sus implementaciones antiguas quedan archivadas o eliminadas.
3. **Un dominio no se migra hasta que sus dependencias estén migradas.** Orden topológico obligatorio.
4. **Los contratos se versionan antes que las implementaciones.** Si el `schema.json` de un dominio cambia, bumpa major.
5. **Cross-language se valida con tests de contrato** — cada lenguaje que implementa un dominio ejecuta tests derivados del contrato, no tests arbitrarios por lenguaje.
6. **La elección de implementación canónica por lenguaje puede diferir de la elección cross-language.** Ejemplo: dominio `wire` puede tener su contrato canónico en C# (más maduro) y su implementación canónica en TS (más usada), siempre que ambos proyecten al mismo contrato.

---

## 6. Proyección a lenguajes

Una vez elegida la implementación canónica por dominio, el agente decide en qué lenguajes debe existir en `v-mono`:

| Criterio                                              | Resultado                        |
|-------------------------------------------------------|----------------------------------|
| Dominio con consumidores solo en TS                   | solo TS                          |
| Dominio con consumidores en TS + C#                   | TS + C# (contratos compartidos)  |
| Dominio fundacional de la plataforma                  | todos los lenguajes del monorepo |
| Dominio de UI                                         | TS/Angular                       |
| Dominio embebido (firmware)                           | C++ + embedded                   |
| Dominio de comunicación inter-proceso                 | todos los lenguajes necesarios   |
| Dominio de tooling interno                            | el lenguaje de la tooling        |

---

## 7. Resolución de empates

Cuando dos implementaciones son comparables según los criterios:

1. Preferir la que minimiza el costo de migración de consumidores.
2. Preferir la que mejor se proyecta a otros lenguajes (si el dominio es poliglota).
3. Preferir la que está en un repo con mejor salud general según los `status/*.md`.
4. **En último caso: escalar a decisión humana.** No inventar desempate arbitrario.

---

## 8. Qué **NO** es criterio válido

- "Se ve mejor."
- "Es más moderno."
- "Usa la tecnología X de moda."
- "El nombre me gusta más."
- "Fue escrito más recientemente" (sin evidencia de mejora real).
- "Parece más limpio" (sin métrica concreta).

Si un argumento no cabe en los criterios §2, no se usa para decidir.

---

## 9. Falsabilidad obligatoria

Cada decisión propuesta incluye una cláusula de falsabilidad:

> **Esta decisión cambiaría si:** <condición concreta, verificable>.

Ejemplos:
- "Esta decisión cambiaría si se encuentra evidencia de que la implementación B tiene tests de integración que no aparecen en su `summary/*.md`."
- "Esta decisión cambiaría si el usuario confirma que el repo C está deprecado."

Sin cláusula de falsabilidad, la decisión no se acepta como propuesta final.
