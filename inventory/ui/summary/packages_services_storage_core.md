---
kind: package-summary
repo: ui
package_name: "@vortech/storage"
package_path: packages/services/storage/core
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                              |
|---------------|----------------------------------------------------|
| name          | `@vortech/storage`                                 |
| version       | 0.0.1                                              |
| directorio    | `packages/services/storage/core`                   |
| type          | module (ESM) — no declarado explícitamente         |
| private       | no especificado                                    |
| entrypoint    | `dist/index.mjs`                                   |
| types         | `dist/index.d.mts`                                 |

> Ubicado bajo `packages/services/storage/core` — el sufijo `/core` indica que es la abstracción base de un sistema de storage más amplio (con posibles proveedores en subdirectorios hermanos).

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Abstracción agnóstica de almacenamiento con **provider pattern**:

- **Provider interface**: `StorageProvider` — contrato que cualquier backend de storage debe implementar.
- **Storage tree**: `storage-tree.ts` — estructura jerárquica de contenedores y endpoints de almacenamiento.
- **Tipos de entradas**: `StorageEntryKind`, `ContainerData`, `EndpointData`, `StorageEntryData` — nodos del árbol.
- **Eventos**: `StorageEventType`, `StorageEvent`, `StorageEventListener` — sistema de eventos para cambios.
- **Operaciones**: `ListOptions`, `EntryStats`, `StorageContent`, `WriteOptions`, `ReadOptions`, `CopyOptions`, `MoveOptions` — CRUD completo.
- **Path utilities**: `PATH_SEPARATOR` y helpers de rutas de almacenamiento.
- **Guards**: `isContainer`, `isEndpoint` — discriminación de tipos de nodo.

Evidencia: `packages/services/storage/core/src/index.ts:1-30`.

El diseño es similar a un virtual file system (VFS) pero orientado a storage de aplicación, donde los "containers" son colecciones/buckets y los "endpoints" son archivos/blobs.

## 3. Superficie pública

Entry points (campo `exports`):

| Export | Archivo dist       |
|--------|--------------------|
| `.`    | `dist/index.mjs`   |

Símbolos clave exportados desde `src/index.ts`:

| Categoría     | Símbolos                                                                               |
|---------------|----------------------------------------------------------------------------------------|
| Tipos         | `StorageEntryKind`, `ContainerData`, `EndpointData`, `StorageEntryData`, `StorageEventType`, `StorageEvent`, `StorageEventListener`, `ListOptions`, `EntryStats`, `StorageContent`, `WriteOptions`, `ReadOptions`, `CopyOptions`, `MoveOptions`, `ResolveResult` |
| Guards        | `isContainer`, `isEndpoint`                                                           |
| Provider      | `StorageProvider` (interface)                                                         |
| Path          | `PATH_SEPARATOR` + helpers                                                            |
| Storage tree  | Probablemente `StorageTree` o similar desde `storage-tree.ts`                        |

## 4. Dependencias

### 4.1 Internas

| Paquete           | Tipo    |
|-------------------|---------|
| `@vortech/common` | runtime |

### 4.2 Externas

Ninguna (solo devDependencies de tooling).

## 5. Consumidores internos

Como paquete core de storage con provider pattern, debe ser consumido por:

- Implementaciones de providers (p.ej. `packages/services/storage/local/`, `packages/services/storage/s3/`).
- Servicios que necesitan persistencia agnóstica de backend.
- Probablemente `@vortech/app` o paquetes de features que almacenan datos de usuario.

No se detectaron referencias directas en `package.json` del workspace en la revisión estática.

## 6. Estructura interna

```
packages/services/storage/core/src/
├── index.ts        # Barrel público
├── path.ts         # Utilidades de paths de storage
├── provider.ts     # Interface StorageProvider
├── providers/      # Posibles providers incluidos en core
├── storage-tree.ts # Estructura jerárquica Container/Endpoint
└── types.ts        # Todos los tipos de datos
```

## 7. Estado

| Campo          | Valor                                                                               |
|----------------|-------------------------------------------------------------------------------------|
| Madurez        | experimental                                                                        |
| Justificación  | v0.0.1, sin descripción, arquitectura bien definida pero sin implementaciones visibles de providers |
| Build          | no ejecutado (inventario estático)                                                  |
| Tests          | No detectados (`scripts` no incluye `test`)                                        |
| Último cambio  | desconocido (no se accedió a git log)                                               |

## 8. Dominios que toca

- Almacenamiento de datos (abstracción)
- Provider pattern / plugin system
- Virtual file system (VFS-like)
- Gestión de recursos persistentes

## 9. Observaciones

- `CopyOptions` y `MoveOptions` indican operaciones de gestión de archivos (no solo CRUD básico).
- `StorageEventListener` sugiere un sistema observable — los consumidores pueden reaccionar a cambios en el storage.
- El campo `providers/` en `src/` puede contener providers in-memory o de test para facilitar el desarrollo sin dependencias de backend reales.
- La dependencia de `@vortech/common` es la única dependencia interna — sugiere que `@vortech/common` contiene tipos base o utilidades compartidas entre múltiples paquetes de servicios.

## 10. Hipótesis

- El sistema de storage tree (Container/Endpoint) es un modelo unificado para diferentes backends: filesystem local, S3, base de datos, etc.
- `providers/` en `src/` probablemente contiene un `MemoryStorageProvider` para testing.
- El path system de storage usa separador propio (`PATH_SEPARATOR`) para ser independiente del filesystem del OS.
- `ResolveResult` probablemente mapea rutas de storage virtuales a locaciones físicas del backend.

## 11. Preguntas abiertas

1. ¿Existen paquetes hermanos en `packages/services/storage/` (p.ej. `local/`, `s3/`, `sqlite/`)?
2. ¿`StorageProvider` define operaciones sync o async (promesas)?
3. ¿`StorageTree` permite storage nesting (containers dentro de containers)?
4. ¿Los eventos de storage (`StorageEvent`) se integran con el sistema reactivo de `@vortech/rx`?
