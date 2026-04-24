---
kind: package-summary
repo: ui
package_name: "@vortech-presets/lara"
package_path: projects/ui/presets/lara
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

## 1. Identidad

- **Nombre publicado:** `@vortech-presets/lara`
- **Ruta en el repo:** `projects/ui/presets/lara`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Preset de theming "Lara" para el sistema UI de Vortech. Define una variante de tokens de diseño con estética propia diferenciada de Aura — probablemente con una paleta de colores más suave o con diferencias en tipografía y radio de bordes.

## 3. Superficie pública

- `index.ts` — punto de entrada del preset.
- Tokens de diseño específicos de la variante Lara (paleta, escalas, sombras).
- Overrides de componentes en formato consistente con el resto de presets del workspace.

## 4. Dependencias

- Comparte la misma infraestructura de theming base del workspace que `@vortech-presets/aura`.
- No se esperan dependencias externas propias de este preset.

## 5. Consumidores internos

- `projects/ui/demo` — app de demostración donde el preset Lara puede seleccionarse como tema alternativo.
- Cualquier app del workspace que requiera la variante visual "Lara".

## 6. Estructura interna

```
projects/ui/presets/lara/
├── package.json
└── src/
    ├── index.ts
    └── (tokens y componentes de la variante Lara)
```

## 7. Estado

- **Madurez:** beta
- Estructura paralela a `@vortech-presets/aura`; comparte el nivel de madurez beta.
- Sin suite de tests dedicada detectada; validación principalmente visual.

## 8. Dominios que toca

- **UI / Theming** — tokens visuales y estilos de componentes.
- **Design System** — variante de marca intercambiable.

## 9. Observaciones

- Al existir junto a Aura, Nora, Material, etc., el workspace implementa un sistema multi-tema donde cada preset es intercambiable en tiempo de configuración de la app Angular.
- La variante "Lara" podría estar inspirada en el tema Lara de PrimeNG, si la librería base sigue ese linaje.

## 10. Hipótesis

- Los presets Aura, Lara y Nora probablemente comparten una interfaz `IPreset` común que garantiza la intercambiabilidad.
- "Lara" puede representar una estética más clara/luminosa frente a "Nora" (más oscura) o "Aura" (neutra).

## 11. Preguntas abiertas

1. ¿Cuál es la diferencia visual principal entre Lara y Aura? ¿Paleta, tipografía o radio de bordes?
2. ¿El preset Lara está derivado de otro preset base o es completamente independiente?
3. ¿Existe un selector de tema en tiempo de ejecución (runtime) o sólo en tiempo de build?
4. ¿Se mantiene paridad de cobertura de componentes entre todos los presets?
