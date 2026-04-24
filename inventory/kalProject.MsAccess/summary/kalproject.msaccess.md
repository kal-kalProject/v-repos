---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.MsAccess
package_path: kalProject.MsAccess
language: csharp
manifest: kalProject.MsAccess.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.MsAccess

## 1. Identidad

- **Nombre:** kalProject.MsAccess
- **Path:** `kalProject.MsAccess`
- **Lenguaje:** C# (netstandard2.0, LangVersion 12, PlatformTarget x64)
- **Versión declarada:** interna al repositorio
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

`README.md` a nivel de repo indica intención de puentes con SignalR/gRPC/JSON entre runtimes; no README exclusivo de este ensamblado

### 2.2 Inferido

Capa de modelado del dominio Microsoft Access: aplicaciones, base de datos, relaciones, consultas, documentos y concretaciones “in-memory” que lanzan excepciones en rutas aún no implementadas (evidencia de intencionalidad documentada con `NotSupportedException`).

**Evidencia:**

- `kalProject.MsAccess/src/Abstractions/Access/Application/IAccessApplication.cs:1` — abstrae la aplicación Access
- `kalProject.MsAccess/src/Database/Relations/Relation.cs:60` — `NotSupportedException` con texto “in-memory relation definition”

## 3. Superficie pública

- Interfaces y tipos bajo `kalProject.MsAccess.*` (aplicación, base de datos, relaciones, consultas, documentos, etc.)

## 4. Dependencias

### 4.1 Internas

- `ProjectReference` desde `kalProject.MsAccess.Bridge`, `kalProject.MsAccess.Client` y `kalProject.MsAccess.Extensions` (leer manifests respectivos en el repo)

### 4.2 Externas

- No listadas en el fragmento leído de `kalProject.MsAccess.csproj:1-20`

## 5. Consumidores internos

- Bridge, Client, Extensions, Server hacia la API común (referencias cruzadas de proyecto)

## 6. Estructura interna

```
kalProject.MsAccess/
└── src/
    ├── Abstractions/Access/
    ├── Database/ (Documents, QueryDefinitions, Relations, ...)
    └── ...
```

## 7. Estado

- **Madurez:** `maduro-aparente` (cobertura amplia de la superficie con rutas aún `NotSupported` explícitas)
- **Build:** no ejecutado
- **Tests:** 0
- **Último cambio:** desconocido

## 8. Dominios que toca

- `ms_access` — núcleo del dominio
- `codegen` (límite) — no genera aquí, pero alinea con contrato proto en otros package

## 9. Observaciones

Patrón frecuente: propiedades de solo lectura vía excepción en setters (DAO) en el paquete de extensiones, no en este, pero se relacionan conceptualmente

## 10. Hipótesis (`?:`)

- `?:` la intención es sustituir gradualmente excepciones de “in-memory” por conducción a COM/DAO reales vía el bridge

## 11. Preguntas abiertas

- Mapa completo de `ProjectReference` salientes entre todos los `kalProject.MsAccess.*` (Fase 2 con tooling)
