---
kind: package-summary
repo: ui
package_name: "@vortech/core"
package_path: packages/core
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

# @vortech/core

## 1. Identidad
- **Nombre:** `@vortech/core`
- **Path:** `packages/core`
- **Lenguaje:** TypeScript
- **Versión declarada:** 0.0.1
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado
Sin descripción en `package.json`.

### 2.2 Inferido
Núcleo de la plataforma Vortech: inyección de dependencias, runtime de aplicación y middlewares. La surface pública es mínima — solo expone `IApplicationMiddleware`, `ApplicationBuilder` y `Service`.

**Evidencia:**
- `packages/core/src/index.ts:4-6` — solo exporta `IApplicationMiddleware`, `ApplicationBuilder` (runtime), `Service` (injection).
- `packages/core/src/index.ts:3` — importa `@vortech/common/globals` (globals polyfill).
- `packages/core/src/` — subdirectorios: `action/`, `adapter/`, `api/`, `atom/`, `builder/`, `communication/`, `injection/`, `metadata/`, `pipeline/`, `runtime/`, `serialization/`, `template/`, `translation/`, `tree-node/`.

## 3. Superficie pública
- `ApplicationBuilder` (class) — builder para configurar la aplicación
- `IApplicationMiddleware` (interface) — contrato para middlewares
- `Service` (decorator) — decorador de servicio para inyección

## 4. Dependencias

### 4.1 Internas al repo
- `@vortech/common` — polyfills globals

### 4.2 Externas
No detectadas en el `package.json` leído.

## 5. Consumidores internos
- `packages/platform` — probablemente consume `@vortech/core` (mismo scope)

## 6. Estructura interna
```
src/
├── action/         ← sistema de acciones
├── adapter/        ← adaptadores
├── api/            ← APIs internas
├── atom/           ← sistema reactivo (atom local)
├── builder/        ← builder toolkit
├── communication/  ← comunicación inter-módulo
├── core-events.ts  ← eventos del core
├── injection/      ← DI container
├── metadata/       ← metadata de clases/decoradores
├── pipeline/       ← pipeline de procesamiento
├── runtime/        ← runtime de aplicación
├── serialization/  ← serialización
├── template/       ← sistema de templates
├── translation/    ← internacionalización
├── tree-node/      ← árbol de nodos
└── index.ts        ← barrel mínimo
```

## 7. Estado
- **Madurez:** experimental
- **Justificación:** La API pública exportada es mínimamente estable (solo 3 símbolos). La gran cantidad de subdirectorios con lógica no exportada sugiere trabajo en curso o refactorización activa.
- **Build:** no ejecutado
- **Tests:** no detectados
- **Último cambio relevante observado:** desconocido

## 8. Dominios que toca
- `domain/di` — inyección de dependencias (`injection/`, `Service`)
- `domain/runtime` — runtime de aplicación (`runtime/`, `ApplicationBuilder`)
- `domain/provider` — adaptadores y builders

## 9. Observaciones
Surface pública muy reducida para la complejidad interna. Posiblemente en proceso de consolidación con `@vortech/platform`.

## 10. Hipótesis
- `?:` `@vortech/core` y `@vortech/platform` podrían estar duplicando responsabilidades de DI y runtime — evidencia: ambos tienen subdirectorios `injection/` y `runtime/`.

## 11. Preguntas abiertas
- ¿Está `@vortech/core` siendo deprecado en favor de `@vortech/platform`?
