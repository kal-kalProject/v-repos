---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: platformio-esp32dev
package_path: Clients/platformio-client
language: embedded-cpp
manifest: platformio.ini
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# Clients/platformio-client (esp32)

## 1. Identidad

- **Path:** `Clients/platformio-client`
- **Lenguaje:** C++ (Arduino/ESP32, PlatformIO)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

`platformio.ini:1-8` fija plataforma `espressif32`, placa `esp32dev`, y dependencias de librerías bblanchon/ArduinoJson y WebSockets (segunda línea de `lib_deps`).

### 2.2 Inferido

Firmware embebido que reutiliza WebSockets + JSON, coherente con el planteamiento “protocolo común” descrito a nivel repositorio.

**Evidencia:**

- `Clients/platformio-client/platformio.ini:6-8` — `lib_deps` a ArduinoJson 7+ y `links2004/WebSockets`
- `Clients/platformio-client/src/main.cpp:1` — (presente) punto de firmware

## 3. Superficie pública

- Firmware flasheado al dispositivo, sin API pública reutilizable para otros módulos del repo (salvo reutilizar patrones a mano)

## 4. Dependencias

### 4.1 Internas

- Ninguna

### 4.2 Externas (PlatformIO)

- Declaradas en `platformio.ini` (librerías pio, no clonadas en Fase 1)

## 5. Consumidores internos

- No (dispositivo físico conecta al servidor, fuera del árbol de código C#)

## 6. Estructura interna

```
Clients/platformio-client/
├── platformio.ini
└── src/
    └── main.cpp
```

## 7. Estado

- **Madurez:** `beta` (mismo stack inalámbrico que el resto de la demo; no flasheable sin toolchain)
- **Build:** no ejecutado (`pio run` prohibido)
- **Tests:** 0

## 8. Dominios

- `embedded` — plataforma ESP32
- `wire` — WebSockets/JSON
- (puente) con `host` vía red

## 9. Observaciones

`.pio/` y builds ignorados; sin bins en el repositorio

## 10. Hipótesis

- `?:` requiere al WiFi/URI del servidor alineado con `BridgeWebSocket` / endpoints documentados bajo `docs/` o `REALTIME_PLATFORM_README.md`

## 11. Preguntas abiertas

- Validación de buffer/colas en dispositivo memoria mínima — análisis Fase 2
