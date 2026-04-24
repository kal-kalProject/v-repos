---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Common
package_path: kalProject.Common
language: csharp
manifest: kalProject.Common.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.Common

## 1. Identidad

- **Nombre:** kalProject.Common
- **Path:** `kalProject.Common`
- **Lenguaje:** C# (netstandard2.0, LangVersion 8)
- **Versión declarada:** empaquetado vía SDK; `Newtonsoft.Json` 13.0.4 en manifest
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

No hay `README` en el directorio; rol inferido de namespaces en `src/`.

### 2.2 Inferido

Protocolo y cargas (broadcast) compartidas entre cliente y servidor, serialización JSON hacia pares que usen el mismo esquema.

**Evidencia:**

- `kalProject.Common/kalProject.Common.csproj:9-11` — `PackageReference` Newtonsoft.Json
- `kalProject.Common/src/Protocols/BroadcastPayload.cs:1` — namespace `kalProject.Common.Protocols`

## 3. Superficie pública

- Tipos bajo `kalProject.Common.Protocols` (p. ej. `BroadcastPayload` y DTOs relacionados)

## 4. Dependencias

### 4.1 Internas al repo

- Referenciado por `kalProject.Client` y consumido indirectamente vía el servidor (evidencia: `kalProject.MsAccess.Server/src/Program.cs:3-4` importa `kalProject.Common.Protocols`)

### 4.2 Externas

- `Newtonsoft.Json` 13.0.4

## 5. Consumidores internos

- `kalProject.MsAccess.Server` — import de protocolos
- `kalProject.Client` — `ProjectReference` en el `.csproj` del cliente

## 6. Estructura interna

```
kalProject.Common/
└── src/
    └── Protocols/   ← DTOs y mensajes
```

## 7. Estado

- **Madurez:** `maduro-aparente`
- **Justificación:** dependencia clara y uso visible desde el host ASP.NET
- **Build:** no ejecutado
- **Tests:** 0 detectado bajo `kalProject.Common/`
- **Último cambio relevante:** desconocido

## 8. Dominios que toca

- `wire` — contratos de mensajería en tiempo real
- `host` (indirecto) — usado al construir el pipeline del servidor

## 9. Observaciones

Cuello de coherencia para compatibilidad entre WebSocket (JSON) y posibles otras fronteras

## 10. Hipótesis (`?:`)

- `?:` versiones de contrato alineadas con el handshake WebSocket bajo `kalProject.Server` — ver handlers de sesión

## 11. Preguntas abiertas

- Ninguna crítica para Fase 1
