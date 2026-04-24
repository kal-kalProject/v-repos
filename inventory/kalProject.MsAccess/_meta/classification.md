---
kind: classification
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
classified_at: 2026-04-24T20:00:00Z
total_packages: 17
---

# Clasificación — `kalProject.MsAccess`

Cada fila es un **package o cliente** a inventariar. La **columna Path** (slug del resumen) va en **texto plano**; si contiene barra, no uses backticks en esa celda, para no duplicar entradas que el contador del validador extrae al buscar pares (además de la columna **Evidencia**). Deje **una** ruta hacia un archivo bajo el clon en backticks por fila, solo en la columna Evidencia, relativa al root del repositorio inventariado (en el monorepo vive bajo el directorio de clon con el mismo nombre que el repo). El slug del nombre de archivo en resumen: path lógico del package con barra reemplazada por guión bajo y en minúsculas, bajo el directorio de resúmenes del inventario

| Path (slug, sin backticks) | Nombre (manifest) | Lenguaje | Tipo resumido | Evidencia |
|------|-------------------|----------|---------------|----------|
| kalProject.Data | kalProject.Data | csharp | biblioteca (netstandard2) | `kalProject.Data/src/Abstractions/Connections/IConnection.cs` |
| kalProject.MsAccess.Client | kalProject.MsAccess.Client | csharp | cliente (net48, COM) | `kalProject.MsAccess.Client/src/Client.cs` |
| kalProject.MsAccess.Extensions | kalProject.MsAccess.Extensions | csharp | extensión DAO y COM (net48) | `kalProject.MsAccess.Extensions/src/Database/DaoEngine.cs` |
| kalProject.MsAccess | kalProject.MsAccess | csharp | abstracción dominio Access (netstandard2) | `kalProject.MsAccess/src/Abstractions/Access/Application/IAccessApplication.cs` |
| MsAccess.Console.Examples | MsAccess.Console.Examples | csharp | consola de ejemplo (net48) | `MsAccess.Console.Examples/Properties/AssemblyInfo.cs` |
| kalProject.MsAccess.Bridge | kalProject.MsAccess.Bridge | csharp | servicio gRPC hacia Access (net48) | `kalProject.MsAccess.Bridge/src/Services/AccessBridgeService.cs` |
| kalProject.MsAccess.Server | kalProject.MsAccess.Server | csharp | host ASP.NET gRPC/HTTP (net9) | `kalProject.MsAccess.Server/src/Program.cs` |
| kalProject.Common | kalProject.Common | csharp | DTOs y protocolo compartido (netstandard2) | `kalProject.Common/src/Protocols/BroadcastPayload.cs` |
| kalProject.Client | kalProject.Client | csharp | cliente WebSocket (netstandard2) | `kalProject.Client/src/Transport/BridgeWebSocketClient.cs` |
| kalProject.Server | kalProject.Server | csharp | host ASP.NET Core común (net9) | `kalProject.Server/src/Sessions/BridgeWebSocketSession.cs` |
| kalProject.Server.App | kalProject.Server.App | csharp | app web (net9) | `kalProject.Server.App/src/Handlers/SampleBridgeMessageHandler.cs` |
| kalProject.Client.App | kalProject.Client.App | csharp | consola consumidora (net9) | `kalProject.Client.App/src/Program.cs` |
| Clients/netframework48-client | KalProject.NetFramework48.Client | csharp | cliente de ejemplo (net48) | `Clients/netframework48-client/Program.cs` |
| Originals/Microsoft.Office.Core | office | csharp | shims interop office (net20) | `Originals/Microsoft.Office.Core/Adjustments.cs` |
| Clients/nodejs-client | kalproject-nodejs-client | javascript | cliente WebSocket (Node) (manifest: package.json) | `Clients/nodejs-client/client.js` |
| Clients/platformio-client | entorno pio (esp32dev) | embedded-cpp y arduino | firmware ejemplo (manifest: platformio.ini en el directorio) | `Clients/platformio-client/src/main.cpp` |
| Clients/angular-client | sin name en package.json (pendiente) | typescript | fuente de cliente (sin package.json) | `Clients/angular-client/src/kalproject-client.ts` |

## Packages no clasificados

- Directorio "docs" en la raíz del repo: solo documentación, sin manifest de build.
- Directorio "Libs" con DLL: ensamblados referenciados por proyectos, no un package con manifiesto de código fuente.
- Directorio "proto" con el contrato compartido; resumido vía proyectos kalProject.MsAccess.Bridge y kalProject.MsAccess.Server que importan el archivo access_bridge.proto; ver en disco kalProject.MsAccess.Server, archivo kalProject.MsAccess.Server.csproj, líneas 20-22, para el ítem Protobuf.
