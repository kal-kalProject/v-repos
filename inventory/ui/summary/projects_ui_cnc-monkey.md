---
kind: package-summary
repo: ui
package_name: "cnc-monkey"
package_path: projects/ui/cnc-monkey
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `cnc-monkey` (Angular project dentro de `angular.json`)
- **Ruta en el repo:** `projects/ui/cnc-monkey`
- **Manifiesto:** `angular.json`
- **Lenguaje principal:** Angular / TypeScript (con SSR)

## 2. Propósito

Aplicación Angular SSR (Server-Side Rendering) "CNC Monkey" — software de CNC Studio para mecanizado. Provee la interfaz de usuario para control, monitoreo y gestión de máquinas CNC. El SSR sugiere necesidad de tiempo de primer render rápido (posiblemente en hardware embebido) o indexación de contenido. Sirve en puertos 4300 (desarrollo) y 4182 (servidor SSR).

## 3. Superficie pública

- No tiene API pública exportada; es una aplicación ejecutable con servidor SSR.
- Interfaz de control CNC (posición de ejes, estado de máquina, G-code, alarmas).
- Servidor Angular Universal/SSR para pre-renderizado.

## 4. Dependencias

- `@vortech-presets/cnc-monkey` — preset oscuro industrial que define su identidad visual.
- La librería de componentes UI de Vortech.
- Angular SSR / Angular Universal (o el nuevo `@angular/ssr`).
- Posiblemente WebSocket o protocolos de comunicación en tiempo real con hardware CNC.

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de producto.
- Desplegada en entornos de taller de mecanizado.

## 6. Estructura interna

```
projects/ui/cnc-monkey/
└── src/
    ├── (app Angular con rutas de control CNC)
    └── (configuración SSR / server.ts)
```

## 7. Estado

- **Madurez:** experimental
- Puertos: 4300 (dev) / 4182 (SSR server).
- El SSR añade complejidad de configuración y despliegue respecto a las otras apps del workspace.

## 8. Dominios que toca

- **CNC / Manufactura** — control y monitoreo de máquinas CNC.
- **UI / Angular SSR** — renderizado server-side para rendimiento en primer carga.
- **Hardware Integration** — interfaz hacia hardware físico de mecanizado.

## 9. Observaciones

- Es la única app del workspace con SSR habilitado, lo que la distingue técnicamente del resto.
- El uso de dos puertos (4300 dev, 4182 SSR) es consistente con la arquitectura Angular Universal donde el cliente Angular y el servidor Node.js corren separados.
- El contexto de uso (taller CNC) puede implicar requisitos de UX específicos: pantallas táctiles, guantes, visualización de alertas críticas.

## 10. Hipótesis

- El SSR puede estar motivado por la necesidad de mostrar estado inicial de la máquina CNC sin esperar a la hidratación del cliente.
- La app probablemente se comunica con un backend de control CNC (GRBL, LinuxCNC, Mach3 o similar) via WebSocket o REST.

## 11. Preguntas abiertas

1. ¿Qué backend de control CNC se integra (GRBL, LinuxCNC, Mach3, otro)?
2. ¿El SSR es para rendimiento en hardware embebido o para indexación web?
3. ¿Cómo se gestiona la comunicación en tiempo real (WebSocket) con el servidor SSR de Angular?
4. ¿Hay consideraciones de seguridad especiales dado que controla hardware físico?
