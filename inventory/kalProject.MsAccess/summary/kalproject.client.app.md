---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.Client.App
package_path: kalProject.Client.App
language: csharp
manifest: kalProject.Client.App.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: beta
---

# kalProject.Client.App

## 1. Identidad

- **Path:** `kalProject.Client.App`
- **Lenguaje:** C# (net9, `OutputType` Exe)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (entrada de consola o demo para `kalProject.Client`)

### 2.2 Inferido

Ejecutable de demostración que instancia y opera el `BridgeWebSocketClient` del paquete hermano.

**Evidencia:**

- `kalProject.Client.App/kalProject.Client.App.csproj:7-10` — `ProjectReference` a `../kalProject.Client`
- `kalProject.Client.App/src/Program.cs:1` — punto de entrada (presente bajo `src/`)

## 3. Superficie pública

- Proceso local; no expone ensamblado como refuerzo de terceros

## 4. Dependencias

### 4.1 Internas

- `kalProject.Client` únicamente (según manifest leído)

### 4.2 Externas

- Ninguna en el `ItemGroup` de referencias (bloque de proyectos visto en lectura de disco)

## 5. Consumidores internos

- No; es hoja (terminal)

## 6. Estructura interna

```
kalProject.Client.App/
└── src/
    └── Program.cs
```

## 7. Estado

- **Madurez:** `beta` (herramienta de demo)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `wire` — interacción con el servidor

## 9. Observaciones

Paridad con `Server.App` como binarios de acompañamiento del diseño

## 10. Hipótesis

- `?:` se usa con `Server.App` o `MsAccess.Server` levantado localmente (documentación a enlazar con `README.md` raíz

## 11. Preguntas abiertas

- Ninguna Fase 1
