---
kind: package-summary
repo: ui
package_name: "angular-demo"
package_path: projects/ui/angular-app
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `angular-demo` (Angular project dentro de `angular.json`, ruta física `angular-app`)
- **Ruta en el repo:** `projects/ui/angular-app`
- **Manifiesto:** `angular.json`
- **Lenguaje principal:** Angular / TypeScript

## 2. Propósito

Aplicación Angular de demo secundaria — app de referencia Angular para integración. Sirve como proyecto de prueba o sandbox para experimentos de integración que no encajan en la app demo principal (`projects/ui/demo`). Puede funcionar como punto de partida para nuevas features o como testbed de integración.

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable.
- App Angular mínima o de referencia para pruebas de integración.

## 4. Dependencias

- La librería de componentes UI de Vortech.
- Angular 17+ (standalone presumiblemente).
- Presets del workspace (según el caso de prueba que implemente).

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de testbed/sandbox.
- Usada por el equipo para experimentos de integración Angular.

## 6. Estructura interna

```
projects/ui/angular-app/
└── src/
    └── (app Angular mínima de referencia)
```

## 7. Estado

- **Madurez:** experimental
- Probablemente sin puerto dedicado fijo o usando el puerto por defecto de Angular (4200), dada su naturaleza de sandbox.
- No hay indicios de suite de tests específica.

## 8. Dominios que toca

- **UI / Angular** — integración y referencia Angular.
- **Testing / Sandbox** — experimentación de integración.

## 9. Observaciones

- La coexistencia de `angular-app` (ruta) y `angular-demo` (nombre de proyecto) puede generar confusión; el doble nombre puede ser un artefacto de refactoring.
- Como app "secundaria", puede tener menor mantenimiento activo que `projects/ui/demo`.
- Su existencia junto a 4 apps más completas sugiere que sirve un propósito específico de integración o bootstrapping.

## 10. Hipótesis

- `angular-app` puede haber sido la primera app del workspace, luego renombrada/reemplazada por `demo` como referencia principal.
- Alternativamente, puede ser la app que prueba integraciones específicas de Angular (formularios reactivos, lazy loading, guards) sin mezclarlas en el showcase de componentes.

## 11. Preguntas abiertas

1. ¿Cuál es el caso de uso específico que diferencia esta app de `projects/ui/demo`?
2. ¿Está activamente mantenida o es un artefacto legado?
3. ¿El nombre `angular-app` vs `angular-demo` responde a un renaming incompleto?
4. ¿Hay tests de integración específicos asociados a esta app?
