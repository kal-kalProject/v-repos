---
source_repo: v-cam
source_commit: b220eefe852d7b3dc0db141aed3f46126c486db0
domain: transport
implementations_count: 3
languages_involved: [ts]
---

# Dominio — `transport`

## 1. Definición operativa
Gestiona la carga y el binding de documentos IR hacia el sistema de visualización 3D. Se encarga de transformar los datos abstractos (coordenadas, capas) en entidades concretas del motor de renderizado (Meshes de Babylon.js).

## 2. Implementaciones encontradas

| # | Package                 | Path                                     | Lenguaje | Madurez       | Rol                           |
|---|-------------------------|------------------------------------------|----------|---------------|-------------------------------|
| 1 | `@v-cam/viewer`         | `v-cam-ts/viewer`                        | TS       | maduro-aparente | IR to Scene compiler         |
| 2 | `@v-cam/core`           | `v-cam-ts/core`                          | TS       | beta          | WASM/Processing bridge       |
| 3 | `cnc-studio`            | `cnc-studio/src/app/viewport`            | TS       | beta          | Viewport implementation      |

## 3. Responsabilidades cubiertas

- **Compilación IR -> Babylon Mesh** → `@v-cam/viewer/src/ir-to-scene`
- **Gestión de Memoria (Object Pooling)** → `@v-cam/core/src/objectpool.ts`
- **Binding de Documentos** → `@v-cam/viewer/src/ir-document-binding.ts`

## 4. Contratos y tipos clave
- `IrDocumentContent` en `@v-cam/viewer/src/ir-document-binding.ts` — Clase que mantiene la relación entre un IR cargado y las mallas resultantes.
- `IrBuildContext` en `@v-cam/viewer/src/ir-to-scene/context.ts` — Contexto de compilación de geometría.

## 5. Flujos observados
```
[IRDocument] -> [IrDocumentContent.load()] -> [IrBuildContext] -> [Mesh Builder] -> [Babylon Scene]
```

## 6. Duplicaciones internas al repo
- `@v-cam/viewer` vs `cnc-studio/src/app/viewport`: `cnc-studio` parece estar implementando su propio "viewport engine" que podría estar solapándose con las responsabilidades de `@v-cam/viewer`.

## 7. Observaciones cross-language (si aplica)
- `WasmProcessor` en `@v-cam/core` sugiere que parte del "transporte" o procesamiento de geometría pesada se está delegando a código nativo (posiblemente Rust compilado a WASM).

## 8. Estado global del dominio en este repo
- **Completitud:** parcial
- **Consistencia interna:** consistente en el core, divergente en la aplicación final.
- **Justificación:** La lógica de renderizado está bien aislada en `@v-cam/viewer`, pero las aplicaciones finales tienden a reimplementar partes del flujo para añadir UI específica.

## 9. Sospechas para Fase 2
- `?:` El `WasmProcessor` indica una transición hacia un motor de geometría agnóstico al lenguaje.
- `?:` La dependencia de Babylon.js en `@v-cam/core` es una deuda técnica que impide usar el core en workers sin dependencias pesadas de UI.
