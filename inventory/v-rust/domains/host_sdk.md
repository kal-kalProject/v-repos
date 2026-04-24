---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: host_sdk
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 4
languages_involved: [csharp]
---

# Dominio — `host_sdk`

## 1. Definición operativa
Alojamiento de broker (`vortech-broker-host`), integración con transporte (`host/src/HostedServices/TransportHostedService.cs` en el árbol), SDK de agente y proveedor.

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | vortech-broker-host | `vortech/host` | C# | maduro-aparente | host ASP.NET/Generic Host según `vortech/host/vortech-broker-host.csproj` |
| 2 | vortech-broker | `vortech/broker` | C# | maduro-aparente | lógica broker |
| 3 | vortech-sdk-agent | `vortech/sdk/agent` | C# | maduro-aparente | `vortech-sdk-agent.csproj:1` |
| 4 | vortech-sdk-provider | `vortech/sdk/provider` | C# | maduro-aparente | `vortech-sdk-provider.csproj:1` |

## 3. Responsabilidades cubiertas
- **Orquestación** de servicios, **SDK** de agente/proveedor, **puntos de unión** con transporte.

## 4. Contratos y tipos clave
- `ProviderHost`, `AgentHost`, `BrokerHostOptions` bajo nombres de archivos en `vortech/sdk` y `vortech/host/src`.

## 5. Flujos observados
```
Host → servicios alojados → transporte (ws/tcp) y wire → agentes
```

## 6. Duplicaciones internas al repo
- `vortech-2026` incluye `sdk/*` y `common` (paralelismo a `vortech/sdk`); riesgo de API duplicada. Evidencia: paths bajo `vortech-2026/sdk/`.

## 7. Observaciones cross-language
- Principalmente C#; integración con Rust (desktop o wire) a través de bridges no verificada en Fase 1.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (dos “eras” 2025 y 2026 bajo nombres similares).
- **Consistencia interna:** posible superposición con `Vortech.Core` (vortech-dotnet) — hipótesis a validar.
- **Justificación:** múltiples `sdk` bajo el mismo repositorio.

## 9. Sospechas para Fase 2
- `?:` Mapeo de `vortech-2026/sdk` frente a `vortech/sdk` para unificación o deprecación.
