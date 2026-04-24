---
kind: domain-inventory
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
domain: client_sdks
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 4
languages_involved: [csharp, javascript, typescript, embedded-cpp]
---

# Dominio — `client_sdks`

## 1. Definición operativa

Aplicaciones y **bibliotecas de cliente de ejemplo** en múltiples ecosistemas: consola .NET (net9 y net48), Node.js, PlatformIO, TypeScript, además de `MsAccess.Console.Examples` que ancla el acceso in-process al stack Access.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | kalProject.Client.App | `kalProject.Client.App` | C# (net9) | beta | EXE de demostración WebSocket (según resumen) |
| 2 | MsAccess.Console.Examples | `MsAccess.Console.Examples` | C# (net48) | experimental | Conecta a `MsAccess.Client` in-process (Access/DAO) |
| 3 | KalProject.NetFramework48.Client | `Clients/netframework48-client` | C# (net48) | beta | WebSocket + Newtonsoft, sin `ProjectReference` a `kalProject.*` |
| 4 | (multicliente) | `Clients/*` (resto) | mezcla | mezclada | Node, Pio, Angular fragment — ver resúmenes `clients_*.md` |

## 3. Responsabilidades cubiertas

- **Demostrar** la matriz "un servidor, múltiples lenguaje de cliente" descrita a nivel repositorio (`README.md:3-9` aprox., referencia cruzada con `REALTIME_PLATFORM_README.md` en Fase 2)

## 4. Contratos y tipos clave

- Depende de lo definido bajo el dominio `wire` (ProtocolEnvelope / Broadcast) y, para consola Access, de las APIs bajo el dominio `ms_access` y `interop`

## 5. Flujos observados

- **net9 y net48 en paralelo** para C#: dos vías de prueba, ver `summary/clients_netframework48-client.md` y `summary/kalproject.client.app.md`
- **Embebido** bajo `Clients/platformio-client` → cableado de red, no a ensamblados C# (fuera de resolución de módulo)

## 6. Duplicaciones internas al repo

- **C# duplicado legado (net48) vs. moderno (net9/netstandard)** con propósito similar: cliente WebSocket hacia un mismo servicio, sin conclusión de reemplazo (observación)

## 7. Observaciones cross-language (si aplica)

El dominio cruza cinco lenguaje-stacks: ver tabla en `summary/` para cada one

## 8. Estado global del dominio en este repo

- **Completitud:** parcial: abundan entradas, falta alinear documentación (Angular sin `package.json` en clon, ver `summary/clients_angular-client.md`)
- **Consistencia interna:** riesgo de desviación de protocolo entre pares, no comprobable sin pruebas
- **Justificación:** presencia de `Clients/` llena de `README` y códigos de arranque

## 9. Sospechas para Fase 2

- `?:` priorizar 1-2 clientes oficiales (p. ej. C#+TS) y marcar el resto como "community samples" para reducir carga de mantenimiento
