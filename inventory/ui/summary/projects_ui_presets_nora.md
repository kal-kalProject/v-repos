---
kind: package-summary
repo: ui
package_name: "@vortech-presets/nora"
package_path: projects/ui/presets/nora
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/nora`
- **Ruta en el repo:** `projects/ui/presets/nora`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "Nora" para el sistema UI de Vortech. Representa una tercera variante visual del design system, con su propia paleta de tokens diferenciada de Aura y Lara — probablemente con estética más estructurada o minimalista.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens de diseño específicos de la variante Nora.
- Overrides de componentes en formato consistente con el sistema de presets del workspace.

## 4. Dependencias

- Comparte la misma infraestructura de theming base del workspace que los otros presets.
- Sin dependencias externas propias detectadas.

## 5. Consumidores internos

- `projects/ui/demo` — app de demostración donde Nora es una opción de tema.
- Cualquier app del workspace que requiera la variante visual "Nora".

## 6. Estructura interna

```
projects/ui/presets/nora/
├── package.json
└── src/
    ├── index.ts
    └── (tokens y componentes de la variante Nora)
```

## 7. Estado

- **Madurez:** beta
- Nivel de madurez equivalente a Aura y Lara; forma parte del conjunto de presets "estables" frente a los experimentales (vscode, studio, cnc-monkey).

## 8. Dominios que toca

- **UI / Theming** — tokens visuales y estilos de componentes.
- **Design System** — variante de marca intercambiable.

## 9. Observaciones

- El conjunto Aura + Lara + Nora constituye el núcleo beta del sistema de presets; los tres comparten estado de madurez y probablemente se desarrollan de forma coordinada.
- El nombre "Nora" sigue el patrón de PrimeNG themes, lo que refuerza la hipótesis de linaje PrimeNG.

## 10. Hipótesis

- Nora podría ser la variante con menor densidad visual (más espacio en blanco, menos decoración) dentro del trío beta.
- La distinción entre presets puede reducirse a diferencias en radios de borde, peso tipográfico y saturación de paleta.

## 11. Preguntas abiertas

1. ¿Nora tiene una variante dark como la tiene Aura o Lara?
2. ¿Los tres presets beta (Aura, Lara, Nora) se publican juntos en cada release?
3. ¿Qué proceso de QA diferencia un preset "beta" de uno "stable"?
4. ¿Existe documentación visual comparativa de los tres presets en la app demo?
