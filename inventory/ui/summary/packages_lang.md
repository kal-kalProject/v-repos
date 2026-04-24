---
kind: package-summary
repo: ui
package_name: "@vortech/lang"
package_path: packages/lang
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: beta
---

# @vortech/lang

## 1. Identidad

- **Nombre:** `@vortech/lang`
- **Path:** `packages/lang`
- **Manifest:** `packages/lang/package.json`
- **Descripción:** "VTL – Vortech Language: TypeScript superset transpiler with attributes, primitives, and interface metadata"
- **Lenguaje:** TypeScript

## 2. Propósito

### 2.1 Declarado

"VTL – Vortech Language: TypeScript superset transpiler with attributes, primitives, and interface metadata"

### 2.2 Inferido con Evidencia

Compilador/transpilador de VTL (Vortech Template Language / Vortech Language), un superconjunto de TypeScript. La cadena de compilación está completa:

- `preprocessor/` — preprocesado del source VTL
- `parser/` — análisis sintáctico a AST
- `compiler/` — transformación del AST
- `emitter/` — generación de código TypeScript/JS de salida
- `engine/` — orquestación del pipeline completo
- `cli.ts` — CLI de línea de comandos
- `ts-plugin.ts` — plugin para el servidor TypeScript (LSP)
- `meta-types.ts` — tipos de metadatos (AttributeMeta, InterfaceMeta, EnumMeta)
- `primitives.ts` / `primitives/` — primitivos del lenguaje (DateOnly, TimeOnly, etc.)
- `demos/` — ejemplos de uso

## 3. Superficie pública

Exports (vía `packages/lang/src/index.ts`):

| Símbolo | Descripción |
|---|---|
| `compile` | Función principal de compilación |
| `CompileOptions` | Opciones de compilación |
| `CompileResult` | Resultado de compilación |
| `CompileDiagnostic` | Diagnóstico/error de compilación |
| `AttributeMeta` | Metadato de atributo VTL |
| `InterfaceMeta` | Metadato de interfaz VTL |
| `EnumMeta` | Metadato de enum VTL |
| `getAttribute` | Obtener atributo de metadato |
| `hasAttribute` | Comprobar presencia de atributo |
| `VtlCompileError` | Error de compilación tipado |
| `PrimitiveRegistry` | Registro de primitivos |
| `DateOnlyDescriptor` | Descriptor de tipo DateOnly |
| `TimeOnlyDescriptor` | Descriptor de tipo TimeOnly |

## 4. Dependencias

### 4.1 Internas

No determinado. Probable dependencia de `@vortech/utils` o `@vortech/common`.

### 4.2 Externas

Posible dependencia de `typescript` (API del compilador TypeScript). No determinado sin instalación de deps.

## 5. Consumidores internos

- `packages/language-server` — usa el compilador VTL para diagnósticos LSP
- `packages/dev-server` — usa el compilador para transpilación en tiempo de desarrollo
- `packages/lang-vscode` — extensión VS Code para VTL

## 6. Estructura interna

```
packages/lang/
├── package.json
└── src/
    ├── cli.ts
    ├── compiler/
    ├── demos/
    ├── emitter/
    ├── engine/
    ├── index.ts
    ├── meta-types.ts
    ├── parser/
    ├── preprocessor/
    ├── primitives.ts
    ├── primitives/
    └── ts-plugin.ts
```

## 7. Estado

- **Madurez:** beta
- **Justificación:** Pipeline completo implementado (preprocessor → parser → compiler → emitter); CLI; plugin TypeScript; primitivos tipados. Presencia de `demos/` sugiere uso activo.
- **Build:** no ejecutado
- **Tests:** no detectados directamente
- **Último cambio:** no determinado (requiere `git log`)

## 8. Dominios que toca

- Compilación de lenguajes / transpilación
- TypeScript (superconjunto)
- LSP / herramientas de desarrollo
- Sistema de tipos extendido (primitivos, atributos, metadatos)

## 9. Observaciones

- La presencia de `ts-plugin.ts` indica integración con el TypeScript Language Server, lo que habilita type-checking en IDEs sin ejecutar la compilación explícita.
- Los primitivos `DateOnly` y `TimeOnly` son análogos a los tipos de .NET (`DateOnly`, `TimeOnly`), sugiriendo influencia del ecosistema .NET (consistente con `v-gen` en el workspace).
- `demos/` dentro del paquete source es inusual; posiblemente son archivos `.vtl` de ejemplo.

## 10. Hipótesis (?:)

- ?: VTL puede compilar a TypeScript estándar, por lo que el output puede usarse sin dependencia de runtime en VTL.
- ?: `AttributeMeta` / `InterfaceMeta` pueden usarse para generar código en `@vortech/sdk` (AST manipulation).

## 11. Preguntas abiertas

- ¿VTL es un superconjunto de TS (como TypeScript lo es de JS) o transforma a un dialecto diferente?
- ¿`ts-plugin.ts` es el mismo plugin que consume `packages/language-server`?
- ¿Los `PrimitiveRegistry` y descriptores son serializables para uso en `@vortech/data`?
