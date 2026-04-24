---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Data
package_path: kalProject.Data
language: csharp
manifest: kalProject.Data.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.Data

## 1. Identidad

- **Nombre:** kalProject.Data
- **Path:** `kalProject.Data`
- **Lenguaje:** C# (netstandard2.0, LangVersion 12, nullable)
- **Versión declarada:** no sección `Version` en el `.csproj` (evidencia: `kalProject.Data/kalProject.Data.csproj:1-19`)
- **Publicado:** no (biblioteca interna al repo)

## 2. Propósito

### 2.1 Declarado

Sin `README` en el directorio del package; se infiere el rol desde nombres de espacios bajo `src/`.

### 2.2 Inferido

Define abstracciones y modelos de conexión y acceso a datos (interfaces en `src/Abstractions/`) para el dominio de bases Access / cliente.

**Evidencia:**

- `kalProject.Data/src/Abstractions/Connections/IConnection.cs:1` — namespace `kalProject.Data.Abstractions.Connections`
- `kalProject.Data/kalProject.Data.csproj:13-18` — `TargetFramework` netstandard2.0, sin `PackageReference` en el fragmento leído

## 3. Superficie pública

- Interfaces bajo `kalProject.Data.Abstractions.*` (p. ej. conexión y contratos) — listado a partir de nombres de archivos bajo `src/Abstractions/`

## 4. Dependencias

### 4.1 Internas al repo

- Consumida por proyectos de mayor nivel que combinan con `kalProject.MsAccess` (ver referencias de proyecto vía otras unidades, no re-expandido aquí con MSBuild)

### 4.2 Externas

- Ninguna en el `ItemGroup` leído del manifest (el `.csproj` leído no declara `PackageReference`)

## 5. Consumidores internos

- Paquetes `kalProject.MsAccess.*` y posiblemente el cliente/servidor (confirmar con búsqueda de `ProjectReference` en el árbol en Fase 2)

## 6. Estructura interna

```
kalProject.Data/
└── src/
    └── Abstractions/  ← interfaces y modelos
```

## 7. Estado

- **Madurez:** `maduro-aparente` (código estructurado, sin prueba de `dotnet build` en Fase 1)
- **Justificación:** estructura por carpetas y nullable habilitado en el proyecto
- **Build:** no ejecutado
- **Tests:** 0 archivos `*Tests.*` bajo `kalProject.Data/`
- **Último cambio relevante observado:** desconocido (sin `git log` en Fase 1)

## 8. Dominios que toca

- `ms_access` — modelos y contratos de acceso
- `wire` (indirecto) — tipos reutilizados en capas superiores

## 9. Observaciones

Separación nítida de abstracciones; sin documentación de package dedicada

## 10. Hipótesis (`?:`)

- `?:` este paquete podría compartir tipos con `kalProject.MsAccess` vía `ProjectReference` en otros `.csproj` — evidencia a confirmar: grep de `ProjectReference` hacia `kalProject.Data`

## 11. Preguntas abiertas

- Relación exacta con todos los consumidores (lista cerrada vía análisis de solución)
