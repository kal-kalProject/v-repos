# 03 — Modelo AI y estimación de costo

## Decisión

- **Fase 1 (inventario):** Gemini 2.5 Flash por default; Gemini 2.5 Pro para repos grandes o ambiguos.
- **Fase 2 (análisis y propuesta):** Gemini 2.5 Pro por default; cross-check opcional con Claude Opus 4.7 o GPT-5 para 1-2 dominios críticos.

## Justificación

### Por qué Gemini

1. **Context window 1M-2M tokens.** Un repo mediano (100-500k tokens) cabe entero en una sola llamada. Reduce orquestación drásticamente: un agente puede "leer todo el repo" vs. la alternativa de chunking por archivo.
2. **Precio por 1M tokens extremadamente competitivo** frente a Opus 4.7 / GPT-5 para el volumen de tokens que mueve un inventario.
3. **Calidad suficiente en tareas estructuradas con output rígido** (YAML frontmatter + secciones fijas), que es exactamente el formato de las plantillas de `inventario/03-plantillas-output.md`.

### Limitación conocida y cómo se mitiga

Gemini tiende a "proponer una respuesta limpia" en lugar de decir "no sé" cuando hay ambigüedad. Las plantillas ya fuerzan honestidad vía:

- Separación **hechos / observación / valoración / hipótesis** (ver `inventario/01 §4`).
- Campo obligatorio `preguntas_abiertas` en cada summary.
- Cláusulas de falsabilidad obligatorias en Fase 2 (`post-inventario/02 §10`).

Estas estructuras son no negociables precisamente porque compensan la tendencia del modelo a sobreafirmar.

## Estimación de costo — Fase 1

Supuestos:
- ~10 repos a inventariar.
- Tamaño medio por repo: ~300k tokens de código + contexto.
- Por repo: ~2M tokens input (múltiples pasadas + contexto acumulado) y ~100k tokens output (artefactos markdown).

| Modelo              | Input (price/1M) | Output (price/1M) | Costo/repo | Costo total (~10 repos) |
|---------------------|------------------|-------------------|------------|--------------------------|
| Gemini 2.5 Flash    | bajo             | bajo              | ~$1-3      | ~$10-30                 |
| Gemini 2.5 Pro      | medio            | medio             | ~$5-15     | ~$50-150                |

Mezcla recomendada (Flash default, Pro para repos complejos): **~$20-60** para Fase 1 completa.

## Estimación de costo — Fase 2

Supuestos:
- ~10-15 dominios a analizar.
- Por dominio: input ~500k tokens (artefactos de Fase 1 consolidados), output ~30k tokens.

| Modelo              | Costo/dominio | Costo total                 |
|---------------------|---------------|------------------------------|
| Gemini 2.5 Pro      | ~$2-5         | ~$20-75                      |
| Opus 4.7 (cross-check de 2 dominios) | ~$5-10  | +$10-20                    |

**Fase 2 total:** ~$30-95.

## Costo total esperado del ciclo completo

**$50-155** usando Gemini como motor principal.

Esto es ~5-10x más barato que la ruta Opus/GPT-5 pura, con calidad suficiente dadas las mitigaciones estructurales ya incorporadas en las plantillas.

## Vehículos de consumo posibles

| Vehículo                             | Comentario                                                                 |
|--------------------------------------|----------------------------------------------------------------------------|
| **API directa Google AI Studio**     | Más barato, control total, ideal para scripts de batch                     |
| **Vertex AI (GCP)**                  | Si requieres compliance / data residency / logging centralizado            |
| **OpenRouter**                       | Útil si quieres probar Gemini y alternar a Claude/GPT sin cambiar de key   |
| **IDE con Gemini integrado** (Gemini Code Assist, Cursor, etc.) | Útil para inventariado interactivo |

## Flags prácticos del proceso

- Tempertura baja (~0.2) para inventariado determinista.
- Temperatura media (~0.4) para Fase 2 (razonamiento comparativo).
- Desactivar tool use agresivo cuando el repo ya está cargado en context — evita llamadas redundantes.
- Sesión por repo en Fase 1; sesión por dominio en Fase 2. No mezclar contextos entre sesiones.

## Escalamiento si el volumen crece

Si el número de repos sube a >20 o los repos son mucho más grandes que lo asumido:

- Pasar a batch processing vía API con paralelización.
- Considerar modelos locales (Qwen3-Coder, DeepSeek-V3) para las tareas mecánicas (generar `_meta/tree.md`, extraer listas de exports) — costo marginal cero si hay GPU disponible.
- Mantener Gemini solo para las tareas que requieren razonamiento cross-archivo.

## Cláusula de revisión

Los precios de modelos cambian rápido. Esta recomendación está anclada a abril 2026. Antes de ejecutar Fase 1, confirmar precios vigentes; si Claude Haiku / GPT-5 nano / modelo X son más baratos con calidad comparable, reconsiderar.
