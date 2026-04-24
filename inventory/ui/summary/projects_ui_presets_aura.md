---
kind: package-summary
repo: ui
package_name: "@vortech-presets/aura"
package_path: projects/ui/presets/aura
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/aura`
- **Ruta en el repo:** `projects/ui/presets/aura`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "Aura" para el sistema UI de Vortech. Provee tokens de diseño (colores, tipografías, espaciados) y estilos de componentes bajo el paradigma de temas intercambiables, junto con extensiones CSS adicionales para cubrir casos no estándar.

## 3. Superficie pública

- `base-preset.ts` — configuración raíz del preset (paleta, escalas)
- `base-style-tokens.ts` — mapa de tokens de diseño base
- `extended-css.ts` — clases y utilidades CSS extendidas
- `index.ts` — punto de entrada que reexporta todo lo anterior
- `components/` — overrides de estilos por componente UI

## 4. Dependencias

- Depende de la infraestructura de theming del paquete central del workspace (`@vortech/ui` o equivalente).
- No se detectan dependencias externas de runtime más allá del workspace; no requiere instalación de módulos de terceros propios.

## 5. Consumidores internos

- `projects/ui/demo` — app de demostración que aplica este preset para mostrar componentes.
- `projects/mcp-servers/vortech-docs` — posiblemente referencia tokens para documentación generada.
- Cualquier app del workspace que seleccione el tema "Aura" en su configuración de Angular.

## 6. Estructura interna

```
projects/ui/presets/aura/
├── package.json
├── src/
│   ├── index.ts
│   ├── base-preset.ts
│   ├── base-style-tokens.ts
│   ├── extended-css.ts
│   └── components/       ← overrides por componente
```

## 7. Estado

- **Madurez:** beta
- El preset cubre los componentes principales de la librería; puede cambiar su API de tokens sin garantía de semver estricto hasta llegar a `stable`.
- No se observa suite de tests dedicada; la validación es visual a través de `projects/ui/demo`.

## 8. Dominios que toca

- **UI / Theming** — sistema de diseño y tokens visuales.
- **Design System** — preset intercambiable para personalización de marca.

## 9. Observaciones

- Es uno de los presets más maduros del conjunto (beta vs experimental en otros).
- El fichero `extended-css.ts` sugiere que los tokens base no cubren todos los casos de uso, forzando extensiones ad-hoc.
- El directorio `components/` puede crecer linealmente con cada nuevo componente incorporado a la librería.

## 10. Hipótesis

- El modelo de "preset" probablemente sigue el patrón de PrimeNG/PrimeFaces, donde cada preset es un objeto JS con la configuración completa del tema.
- `base-preset.ts` y `base-style-tokens.ts` podrían ser redundantes si los tokens migran a un formato CSS-variables estándar en el futuro.

## 11. Preguntas abiertas

1. ¿Existe versionado semántico activo para este paquete o se consume siempre desde workspace?
2. ¿Los tokens de `base-style-tokens.ts` se generan automáticamente o son escritos a mano?
3. ¿Qué criterio separa lo que va en `base-preset.ts` de lo que va en `base-style-tokens.ts`?
4. ¿Está prevista una validación de contraste de color (a11y) en los tokens?
