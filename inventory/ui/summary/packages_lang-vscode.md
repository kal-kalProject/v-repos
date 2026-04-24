---
kind: package-summary
repo: ui
package_name: "vtl-vscode"
package_path: packages/lang-vscode
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

# vtl-vscode (lang-vscode)

## 1. Identidad

- **Nombre en package.json:** `vtl-vscode`
- **Path:** `packages/lang-vscode`
- **Manifest:** `packages/lang-vscode/package.json`
- **Descripción en manifest:** no declarada explícitamente; nombre implica extensión VS Code para VTL
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

No hay descripción en `package.json`. El nombre `vtl-vscode` indica extensión de VS Code para el lenguaje VTL (Vortech Language).

### 2.2 Inferido con Evidencia

Extensión VS Code para soporte del lenguaje VTL. Funcionalidades inferidas:

- Activación y gestión del servidor de lenguaje (`@vortech/language-server`)
- Compilación de archivos `.vtl` desde la extensión
- Diagnósticos en tiempo real (errores de compilación VTL)
- Posible contribución de: grammar de sintaxis, snippets, comandos

La extensión actúa como host del language server y point-of-entry para el desarrollador que usa VTL en VS Code.

## 3. Superficie pública

No hay API pública en sentido tradicional. La extensión contribuye al IDE a través del `package.json` de VS Code Extension (contribution points):

- Comandos de compilación VTL
- Soporte de archivos `.vtl` (lenguaje registrado)
- Activación del language server LSP

## 4. Dependencias

### 4.1 Internas

- `@vortech/language-server` — servidor de lenguaje que la extensión arranca
- `@vortech/lang` — compilador VTL (para compilación bajo demanda)
- `@vortech/dev-server` — posible uso para comunicación con el servidor de desarrollo

### 4.2 Externas

- `vscode` (peer dep / devDep de VS Code Extension API)
- `vscode-languageclient` — para la comunicación LSP cliente-servidor

No determinado completamente sin instalación de deps.

## 5. Consumidores internos

No tiene consumidores internos; es el punto final de la cadena de tooling VTL.

## 6. Estructura interna

Estructura inferida (path `packages/lang-vscode/`):

```
packages/lang-vscode/
├── package.json          (manifest de extensión VS Code)
└── src/
    ├── extension.ts      (punto de activación de la extensión)
    └── (otros módulos)
```

La estructura interna exacta no fue inspeccionada directamente.

## 7. Estado

- **Madurez:** experimental
- **Justificación:** Extensión VS Code para un lenguaje en desarrollo activo (VTL). Al depender de `@vortech/lang` y `@vortech/language-server`, ambos en estado experimental/beta, la extensión hereda esa inestabilidad. No hay evidencia de publicación en VS Code Marketplace.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- IDE tooling (VS Code Extension)
- Language Server Protocol (cliente LSP)
- Lenguaje VTL
- Developer Experience (DX)

## 9. Observaciones

- El directorio se llama `lang-vscode` pero el nombre en `package.json` es `vtl-vscode`; esta inconsistencia puede causar confusión.
- La extensión es el artefacto final que los desarrolladores de VTL instalarían; su calidad determina la DX del lenguaje.
- Sin grammar TextMate o archivo de extensión `.vscodeignore` detectado; puede estar en desarrollo inicial.

## 10. Hipótesis (?:)

- ?: La extensión puede usar el modo "embedded language server" (arranca el servidor como proceso hijo) en lugar de modo "standalone server" (proceso separado preexistente).
- ?: Puede haber un grammar TextMate para `.vtl` no incluido aún en el inventario.

## 11. Preguntas abiertas

- ¿Está publicada en el VS Code Marketplace?
- ¿El `package.json` incluye `contributes.languages` con soporte para `.vtl`?
- ¿Usa `vscode-languageclient` para la comunicación LSP o implementa la comunicación directamente?
- ¿Hay un archivo de grammar TextMate (`.tmLanguage.json`) para resaltado de sintaxis VTL?
