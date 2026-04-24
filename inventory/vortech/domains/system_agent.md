---
kind: domain-inventory
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
repo: vortech
domain: system_agent
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
implementations_count: 6
languages_involved: [ts, csharp, angular]
---

# Dominio — `system_agent`

## 1. Definición operativa
Agente de sistema, contrato compartido, fleet, dashboard: paquetes bajo `system-agent/` (TypeScript, .NET, Angular) con solución en `Vortech.sln`.

## 2. Implementaciones encontradas

| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | @system-agent/contract | `system-agent/contract` | ts | maduro-aparente | contrato TS |
| 2 | SystemAgent.Contract | `system-agent/contract/cs` | csharp | maduro-aparente | ensamblado .NET compartido |
| 3 | @system-agent/fleet-manager | `system-agent/fleet-manager` | ts | maduro-aparente | gestor flota |
| 4 | fleet-dashboard (Angular) | `system-agent/dashboard` | angular | maduro-aparente | UI (sin `package.json` local) |
| 5 | Agent (servicio) | `system-agent/agents/dotnet` | csharp | maduro-aparente | servicio (NativeAOT option en csproj) |
| 6 | (instalación) | `system-agent/install` | — | indeterminado | scripts/instalación sin inventario detallado aquí |

## 3. Responsabilidades cubiertas
- **Contrato multi-lenguaje** (TS y C#) con `ProjectReference` en `system-agent/agents/dotnet/Agent.csproj:37` a `SystemAgent.Contract`.

## 4. Contratos y tipos clave
- `SystemAgent.Contract` — evidencia: `system-agent/contract/cs/SystemAgent.Contract.csproj:1`
- `Agent` — evidencia: `system-agent/agents/dotnet/Agent.csproj:1`

## 5. Flujos observados
```
Agent .NET → SQLite / hosting extensions → contract compartido → clientes TS (fleet / dashboard)
```

## 6. Duplicaciones internas al repo
- Ninguna clara: TS “contract” y C# “Contract” forman pares, no duplicación.

## 7. Observaciones cross-language
- Mismo concepto de contrato en C# y TypeScript: Fase 2 deberá validar alineación de versiones y serialización (JSON / sourcegen mencionado en comentario en `Agent.csproj:10-20`).

## 8. Estado global del dominio en este repo
- **Completitud:** rica; varios lenguajes
- **Consistencia interna:** a validar bajo AOT/serialización (comentarios en .csproj)

## 9. Sospechas para Fase 2
- Pruebas de integración entre `fleet-manager` (TS) y `Agent` (C#) no inventariadas en detalle (sin test run).
