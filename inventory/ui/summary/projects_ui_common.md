---
kind: package-summary
repo: ui
package_name: "@vortech/common-old"
package_path: projects/ui/common
language: angular
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: abandonado
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/common-old` (nombre npm con sufijo "-old" indicando deprecación explícita)
- **Ruta:** `projects/ui/common/`
- **Manifest:** `projects/ui/common/package.json`
- **Tipo:** librería Angular (legacy)

## 2. Propósito

Versión legacy de la librería `@vortech/common` para Angular. Contiene código que existía antes de la reorganización del monorepo y que no ha sido migrado a los paquetes actuales. Su presencia sirve de referencia histórica y como paso intermedio para consumidores que aún no han migrado.

## 3. Superficie pública

No verificable en inventario estático sin leer el contenido de los archivos. El nombre "-old" sugiere que la surface es un subconjunto (potencialmente completo o parcial) de lo que hoy existe en otros paquetes como `@vortech/ui-core`, `@vortech/common` (si existe) u otros.

**Advertencia:** No consumir en código nuevo. Los exports de este paquete están en proceso de migración o abandono.

## 4. Dependencias

Probables (versión legacy):
- Angular Core, Common
- Posible: dependencias antiguas que ya no existen en las versiones actuales de otros paquetes

## 5. Consumidores internos

- Posibles consumidores legacy dentro del monorepo que aún no han migrado
- No debe haber consumidores nuevos; cualquier referencia nueva a este paquete es deuda técnica

## 6. Estructura interna

No detallada. La ruta `projects/ui/common/` contiene el código legacy sin estructura documentada en este inventario.

```
projects/ui/common/
├── package.json    # nombre: "@vortech/common-old"
└── src/
    └── [código legacy sin estructura detallada]
```

## 7. Estado

**Abandonado.** El sufijo "-old" en el nombre npm es una señal explícita e inequívoca de deprecación. No recibe mantenimiento activo. Cualquier bug encontrado debe resolverse migrando el consumidor, no corrigiendo este paquete.

## 8. Dominios que toca

- Utilidades Angular comunes (dominio original desconocido sin lectura de fuentes)
- Código legacy en proceso de extinción

## 9. Observaciones

- La convención de renombrar a "-old" en lugar de eliminarlo directamente es una estrategia de migración incremental: permite que los consumidores vean el deprecado en sus imports y lo migren gradualmente.
- La presencia de este paquete en el monorepo es deuda técnica activa: mientras exista, el monorepo mantiene dos versiones de la misma funcionalidad.
- **Riesgo:** Si alguna funcionalidad de "-old" no tiene equivalente en los paquetes actuales, existe riesgo de pérdida de funcionalidad al eliminar este paquete.

## 10. Hipótesis

- El código en `projects/ui/common/` fue el paquete `@vortech/common` original antes de que se separara en módulos más específicos (`@vortech/ui-core`, `@vortech/platform`, etc.).
- Puede contener utilidades de Angular (pipes, directives, services) que fueron distribuidas entre otros paquetes durante la refactorización.

## 11. Preguntas abiertas

- ¿Hay consumidores activos de `@vortech/common-old` dentro del monorepo?
- ¿Existe un plan de migración documentado con deadline para eliminar este paquete?
- ¿Toda la funcionalidad de "-old" tiene equivalente en paquetes actuales?
- ¿Cuándo fue renombrado de `@vortech/common` a `@vortech/common-old`?
