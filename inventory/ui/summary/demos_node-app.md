---
kind: package-summary
repo: ui
package_name: "@vortech-demos/node-app"
package_path: demos/node-app
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `@vortech-demos/node-app`
- **Ruta en el repo:** `demos/node-app`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript

## 2. Propósito

Demo de aplicación Node.js con la plataforma Vortech — muestra cómo integrar y usar los paquetes de Vortech en un contexto de servidor Node.js o CLI, fuera del entorno Angular/browser. Valida la compatibilidad de los paquetes Vortech con el runtime Node.js.

## 3. Superficie pública

- No tiene API pública exportada; es una demo ejecutable.
- Ejemplo de integración de paquetes Vortech en contexto Node.js.

## 4. Dependencias

- Paquetes del workspace Vortech compatibles con Node.js (posiblemente `@vortech/common` u otros).
- Node.js runtime (versión compatible con el workspace).
- TypeScript / ts-node o tsx para ejecución directa.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de demostración y validación.
- Usada para verificar que los paquetes Vortech funcionan correctamente en Node.js.

## 6. Estructura interna

```
demos/node-app/
├── package.json
└── src/
    └── (aplicación Node.js de demostración)
```

## 7. Estado

- **Madurez:** experimental
- Demo de compatibilidad; el mantenimiento depende de los cambios en los paquetes Vortech que consume.

## 8. Dominios que toca

- **Node.js / Backend** — uso de paquetes Vortech en contexto servidor.
- **Demos / Ejemplos** — validación de compatibilidad con Node.js.
- **Interoperabilidad** — prueba de que los paquetes no son exclusivamente browser.

## 9. Observaciones

- La existencia de esta demo junto a `bun/demo` sugiere que Vortech está evaluando múltiples runtimes de JavaScript (Node.js y Bun).
- El hecho de que sea una demo (no un proyecto de producción) indica que el uso en Node.js puede no estar completamente validado para todos los paquetes.

## 10. Hipótesis

- La demo probablemente importa paquetes clave de Vortech y ejecuta funcionalidades básicas para verificar que no hay dependencias exclusivas de browser (`window`, `document`, etc.).
- Puede servir como smoke test de compatibilidad Node.js en el pipeline de CI.

## 11. Preguntas abiertas

1. ¿Qué paquetes Vortech se demuestran específicamente en esta demo?
2. ¿La demo valida ausencia de código browser-only en los paquetes Node.js?
3. ¿Hay alguna diferencia funcional entre `demos/node-app` y `bun/demo` además del runtime?
4. ¿Se ejecuta en CI como parte del proceso de validación?
