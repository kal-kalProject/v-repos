---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Client
package_path: kalProject.Client
language: csharp
manifest: kalProject.Client.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# kalProject.Client

## 1. Identidad

- **Path:** `kalProject.Client`
- **Lenguaje:** C# (netstandard2.0, LangVersion 8)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (inferido por nombre y namespaces)

### 2.2 Inferido

Biblioteca de transporte en tiempo real con WebSocket hacia el servidor, eventos y reconexión, sobre contratos de `kalProject.Common`.

**Evidencia:**

- `kalProject.Client/kalProject.Client.csproj:9-12` — `System.Net.WebSockets.Client`, `ProjectReference` a `kalProject.Common`
- `kalProject.Client/src/Transport/BridgeWebSocketClient.cs:1` (archivo extenso, ~674 LOC) — lógica de transporte (conteo de LOC en análisis de árbol)

## 3. Superficie pública

- `BridgeWebSocketClient` y tipos de evento en `src/Events/`

## 4. Dependencias

### 4.1 Internas

- `kalProject.Common`

### 4.2 Externas

- `System.Net.WebSockets.Client` 4.3.2

## 5. Consumidores internos

- `kalProject.Client.App` (consola de demostración)

## 6. Estructura interna

```
kalProject.Client/
└── src/
    ├── Transport/
    └── Events/
```

## 7. Estado

- **Madurez:** `beta` (biblioteca extensa, sin pruebas automatizadas listadas)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `wire` — WebSocket
- (puente) con `host` vía el servidor

## 9. Observaciones

Tamaño del archivo de transporte sugiere concentración de lógica (posible oportunidad de modularizar en Fase 2, observación, no requisito)

## 10. Hipótesis

- `?:` reutilizable por un futuro `Clients/angular-client` a través de un binding distinto (no soportado hoy con el mismo lenguaje)

## 11. Preguntas abiertas

- Política de resiliencia y timeouts — revisión en profundidad fuera de Fase 1
