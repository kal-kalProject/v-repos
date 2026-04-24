---
source_repo: v-cam
source_commit: b220eefe852d7b3dc0db141aed3f46126c486db0
---

# Estado — platform

## Bugs

| # | Severidad | Ubicación | Descripción | Evidencia |
|---|-----------|-----------|-------------|-----------|
| 1 | medio | v-cam-ts/viewer/src/viewer-proxy.ts | Referencia comentada a viewer-direct. | export { default as Viewer_Proxy } |

## Duplicaciones internas

- **Modelo IR:** El directorio cnc-studio/src/app/core/ir/ duplica manualmente las interfaces de @v-cam/common.

## Incompletitud

- **WASM:** Los scripts de build:wasm en v-cam-ts/core apuntan a fuentes no encontradas en este clon.

## Deuda

- **Acoplamiento:** @v-cam/core depende de Babylon.js, lo que impide uso headless.

## Tests

- **Estado:** Inventario estático; tests detectados pero no ejecutados. Ver summary/ para detalles por package.
