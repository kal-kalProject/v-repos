---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: orchestration
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 3
languages_involved: [csharp]
---

# Dominio — `orchestration`

## 1. Definición operativa
Orquestación de procesos y agentes CNC bajo el subárbol `orquesta/`: protocolo, host, agente de puente.

## 2. Implementaciones encontradas
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | Orchestrator.Protocol | `orquesta/src/Orchestrator.Protocol` | C# | maduro-aparente | `orquesta/src/Orchestrator.Protocol/Orchestrator.Protocol.csproj:1` |
| 2 | Orchestrator.Host | `orquesta/src/Orchestrator.Host` | C# | maduro-aparente | `Orchestrator.Host.csproj:1` |
| 3 | Orchestrator.Agents.CncBridge | `orquesta/src/Orchestrator.Agents.CncBridge` | C# | maduro-aparente | `Orchestrator.Agents.CncBridge.csproj:1` |

## 3. Responsabilidades cubiertas
- **Protocolo** orquestador, **host** y **puente a CNC** como agente dedicado (según nombre del proyecto).

## 4. Contratos y tipos clave
- Nombres de ensamblado `Orchestrator.*` (rutas bajo `orquesta/src/` en el clon actual).

## 5. Flujos observados
```
Host de orquestación → protocolo → agente CNC (bridge) ↔ sistema externo
```

## 6. Duplicaciones internas al repo
- Solapamiento conceptual con `vortech-broker` y con `vortech/sdk/agent` (orquestar agentes) sin análisis de reutilización en Fase 1.

## 7. Observaciones cross-language
- Solo C# bajo el snapshot; integración con firmware/CNC (si existe) aún no mapeada.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (un stack autocontenido bajo `orquesta/`).
- **Consistencia interna:** no evaluada con build.
- **Justificación:** existencia de `Orchestrator.sln` y tres ensamblados de aplicación de dominio claro (protocol/host/agent).

## 9. Sospechas para Fase 2
- `?:` Alinear modelos de agente con `vortech` broker para evitar dos “mundos de orquestación”.
