---
kind: status-report
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
area: repo
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
---

# Estado — `repo` (kalProject.MsAccess)

## Bugs

Ninguno detectado. Justificación: Fase 1 no ejecuta la aplicación ni pruebas; no hay acta de regresión frente a una especificación concreta. Varios usos de `NotSupportedException` bajo clases in-memory o setters de solo lectura se interpretan como **diseño explícito** (comportamiento documentado en fuente), no como defecto, con evidencia en `kalProject.MsAccess/src/Database/QueryDefinitions/QueryDefinition.cs:103-138` y un ejemplo de setter en el paquete de extensiones: `kalProject.MsAccess.Extensions/src/Database/QueryDefinitions/DaoQueryDefinition.cs:58-65` (métodos con `set` que arrojan)

## Duplicaciones internas

| # | Concepto | Ubicación A | Ubicación B | Nota |
|---|----------|-------------|-------------|------|
| 1 | Código gRPC/Protobuf autogenerado a partir de `access_bridge.proto` | `kalProject.MsAccess.Bridge/Generated/AccessBridge.cs:1-4` (cabecera autogenerada) | `kalProject.MsAccess.Server/Generated/AccessBridge.cs:1-4` (cabecera análoga) | Mismo encabezado y namespace generado; distintos `GrpcServices` (Server vs. Client) en los `.csproj` respectivos; riesgo de desincronía al regenerar |
| 2 | Pistas a DLLs de Office/ADODB en bloques de referencia | `kalProject.MsAccess.Extensions/kalProject.MsAccess.Extensions.csproj:24-26` (primer `Reference` ADODB) | `kalProject.MsAccess.Bridge/kalProject.MsAccess.Bridge.csproj:16-18` (primer `Reference` ADODB) | Bloques con las mismas `HintPath` hacia `..\\Libs\\...` (duplicación de mantenimiento) |
| 3 | Cliente WebSocket en C# moderno y legado | `kalProject.Client/kalProject.Client.csproj:9-12` (`ProjectReference` a Common + paquetes) | `Clients/netframework48-client/NetFramework48Client.csproj:30-38` (referencias a `System.Net.WebSockets*`, `Newtonsoft.Json` por HintPath) | Dos pilas sin `ProjectReference` compartida hacia un único módulo C# reutilizable; posible desviación de contrato (observación) |

## Incompletitud

| # | Tipo | Ubicación | Descripción |
|---|------|------------|-------------|
| 1 | manifest ausente (Angular) | `Clients/angular-client/README.md:1-19` (feature list) vs. ausencia de `package.json` bajo un listado de directorio al 2026-04-24 | Proyecto TypeScript/Angular de ejemplo en estado incompleto para build reproducible sin añadir manifest o paquetes |
| 2 | solución .slnx | `kalProject.MsAccess.slnx:1-14` (12 proyectos listados) vs. proyectos presentes p. ej. `Clients/netframework48-client/NetFramework48Client.csproj:1` y `Originals/Microsoft.Office.Core/office.csproj:1` (existen en disco; no listados en el fragmento de solución) | Apertura en IDE con árbol parcial respecto al disco; no es import roto, es omisión de inclusión en la solución |
| 3 | documentación a medio migrar | `README.md:3-9` (propuesta) | Plan a nivel de repositorio expuesto como hipótesis; alineación con el código gRPC+ASP.NET a validar (no se marca como `TODO` en fuente) |

**Imports internos** no auditados vía análisis de módulo del compilador. No se añadieron filas concretas de "import a path faltante" salvo riesgo explícito en nota (2) sobre apertura de la solución.

## Deuda

| # | Categoría | Ubicación | Observación |
|---|------------|------------|-------------|
| 1 | archivo-monolítico (C#) | `kalProject.Client/src/Transport/BridgeWebSocketClient.cs:1` (mismo archivo, elevado nº de LOC en conteo estático) | Densidad de lógica en un solo tipo de transporte; oportunidad de modularizar |
| 2 | archivo-monolítico (C#) | `kalProject.MsAccess.Bridge/src/Services/AccessBridgeService.cs:1` (mismo archivo, cientos de LOC) | Gran handler de servicio; revisión de SRP en Fase 2 |
| 3 | archivos masivos bajo PIA/TLB (vendor-like) | `Originals/Microsoft.Office.Interop.Access/FormClass.cs:1` (clase de miles de LOC) | Interop no apto para edición humana, peso y coste de merge |
| 4 | múltiples plataformas de cliente a mantener | `Clients/nodejs-client/client.js:1`; `Clients/platformio-client/src/main.cpp:1`; `Clients/angular-client/src/kalproject-client.ts:1` (muestras multi-lenguaje bajo `Clients/`) | Carga de mantenimiento: varios lenguaje-stacks; contratos a alinear en Fase 2 |

Criterio >500 LOC aplicado a fuentes bajo análisis de conteo; interop bajo `Originals` a menudo supera ampliamente el umbral, sin citar más allá de los ejemplos

## Tests

- **Archivos `*Tests.cs`:** 1 coincidencia de patrón de nombre, con evidencia de archivo: `Originals/Microsoft.Office.Core/PropertyTests.cs:1` (puede no ser un suite xUnit) — búsqueda de nombre, sin clasificación del framework de prueba sin inspección adicional
- **Archivos `*.test.*` / `*.spec.*`:** 0 a nivel de búsqueda de nombre bajo el repo
- **`#[test]` (Rust) / otros:** 0, no aplica
- **Estado de ejecución:** no verificado; Fase 1 no corre test runners. No se atribuye "tests verdes" ni "rojos" a este snapshot

**Resumen de tests:** tracción baja: la mayoría de los paquetes no exponen pruebas automatizadas bajo nombres convencionales; validación futura requiere `dotnet test` o equivalente, prohibido en Fase 1
