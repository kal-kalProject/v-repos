---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: transport
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 2
languages_involved: [csharp]
---

# Dominio — `transport`

## 1. Definición operativa
Canales de transporte de alto nivel: WebSocket y TCP, implementados como proyectos bajo `vortech/transport/`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | vortech-transport-ws | `vortech/transport/ws` | C# | maduro-aparente | `vortech/transport/ws/vortech-transport-ws.csproj` |
| 2 | vortech-transport-tcp | `vortech/transport/tcp` | C# | maduro-aparente | `vortech/transport/tcp/vortech-transport-tcp.csproj` |

## 3. Responsabilidades cubiertas
- **Transporte TCP** y **WebSocket** como assemblies separados, consumidos por el stack broker/host (referencias a explorar vía `ProjectReference` en Fase 2).

## 4. Contratos y tipos clave
- `WsChannel*`, `TcpChannel*` (nombres de archivo en `vortech/transport/ws/src` y `.../tcp/src`).

## 5. Flujos observados
```
Broker / host in-process ↔ transporte (Ws/Tcp) ↔ peer remoto
```

## 6. Duplicaciones internas al repo
- No se listó otra capa de transporte duplicada bajo el mismo nombres en `vortech-2026` (no detectado bajo búsqueda de carpetas `transport` en 2026 en este snapshot).

## 7. Observaciones cross-language
- Solo C# en este dominio bajo el snapshot analizado.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (solo bajo `vortech/transport`).
- **Consistencia interna:** estructura simétrica `ws`/`tcp` sugiere patrón común; sin lectura de interfaces en Fase 1.
- **Justificación:** existencia de dos proyectos hermanos con fuentes bajo `src/`.

## 9. Sospechas para Fase 2
- `?:` Alinear con requisitos de conectividad de `vortech-2026` si el transporte vive allí bajo otro nombre.
