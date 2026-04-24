---
source_repo: v-gen
source_type: clone
source_commit: b7bfd02cc94b7417068e5fd3465225a41b466575
---

# Domain Inventory - Developer Experience (LSP & Tooling)

## Propósito
Conjunto de herramientas y servicios destinados a mejorar la productividad del desarrollador al trabajar con plantillas vGen, incluyendo integraciones con IDEs, CLI y servicios de lenguaje.

## Componentes Clave (Evidence pointers)
- **LSP Host:** `src/vGen.LanguageServer/LspHost.cs` — Punto de anclaje del servidor.
- **Handlers de Inteligencia:** Carpeta `src/vGen.LanguageServer/Features/` — Implementaciones de `CompletionProvider.cs`, `HoverProvider.cs` y `DiagnosticsProvider.cs`.
- **CLI Command Suite:** Carpeta `src/vGen.Cli/Commands/` — Lógica de los comandos `render`, `scaffold` y `lsp`.
- **VS Code Integration:** Carpeta `editors/vscode/src/` — Implementación de la extensión, incluyendo el `VGenLanguageClient.ts`.
- **Preview en Vivo:** `src/vGen.LanguageServer/CustomProtocol/RenderPreviewParams.cs` — Protocolo personalizado para sincronización de vista previa entre el editor y el motor.

## Observaciones Técnicas
- **Workspaces:** El LSP gestiona un estado de workspace (`vGenWorkspace.cs`) para resolver dependencias entre plantillas y archivos C#.
- **Integración con Roslyn:** El servidor de lenguaje aprovecha `vGen.Compiler` para proporcionar diagnósticos de compilación en tiempo real para los archivos `.v-gen.cs`.
- **UX del Editor:** Uso de decoraciones de archivos en la extensión VS Code para indicar el estado de renderizado.

## Riesgos y Deuda
- **Compatibilidad del Binario:** El LSP requiere que el binario de `vGen.LanguageServer` sea compatible con el entorno del usuario (mencionado en el `package.json` de la extensión como configurable).
- **Acoplamiento vGen-VSCode:** Aunque el core es LSP, muchas funcionalidades (como el preview) parecen estar altamente optimizadas para el cliente de VS Code.
