---
kind: package-summary
repo: ui
package_name: "@vortech/file-system"
package_path: packages/server-side/file-system
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
| name          | `@vortech/file-system`                             |
| version       | 0.0.1                                              |
| directorio    | `packages/server-side/file-system`                 |
| type          | module (ESM) — no declarado explícitamente en manifest |
| private       | no especificado                                    |
| entrypoint    | `dist/index.mjs`                                   |
| types         | `dist/index.d.mts`                                 |

> Ubicado bajo `packages/server-side/`, lo que establece explícitamente que es un paquete **solo para entornos Node.js** (no browser).

## 2. Propósito

### 2.1 Declarado

Sin campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

Abstracción de sistema de archivos para uso server-side, con operaciones organizadas en cuatro categorías:

- **Read**: `readFile`, `readJsonFile`, `readFiles` — lectura de archivos y JSON.
- **Write**: `writeFile`, `writeJsonFile`, `appendToFile` — escritura y append.
- **Query**: `exists`, `isFile`, `isDirectory`, `getStats`, `existsAll`, `existsAny` — consultas de metadata.
- **Scan**: `scanDirectory`, `getFiles`, `getDirectories`, `findFiles`, `findFile` — traversal y búsqueda.
- **Path**: utilidades de composición de rutas.
- **Services**: `src/services/` — funcionalidades adicionales de servicio (contenido no inspeccionado).

Evidencia: `packages/server-side/file-system/src/index.ts:1-30`.

La peer dependency de `@vortech/platform` indica integración con el sistema de plataforma de Vortech (probablemente DI y contexto de ejecución).

## 3. Superficie pública

Entry points (campo `exports`):

| Export | Archivo dist       |
|--------|--------------------|
| `.`    | `dist/index.mjs`   |

Símbolos exportados desde `src/index.ts`:

| Categoría  | Símbolos                                                               |
|------------|------------------------------------------------------------------------|
| Read       | `readFile`, `readJsonFile`, `readFiles`                               |
| Write      | `writeFile`, `writeJsonFile`, `appendToFile`, `WriteFileOptions`      |
| Query      | `exists`, `isFile`, `isDirectory`, `getStats`, `existsAll`, `existsAny` |
| Scan       | `scanDirectory`, `getFiles`, `getDirectories`, `findFiles`, `findFile`, `ScanOptions`, `ScanEntry` |
| Path       | `join` + otros helpers de paths                                       |

## 4. Dependencias

### 4.1 Internas

| Paquete             | Tipo      |
|---------------------|-----------|
| `@vortech/platform` | peerDep   |

### 4.2 Externas

| Paquete      | Tipo    | Propósito                                |
|--------------|---------|------------------------------------------|
| `fast-glob`  | devDep  | Glob matching para scan (catalog:utilities) |

> `fast-glob` está en `devDependencies` pero probablemente se usa en `src/scan/` como dependencia de runtime (incluida en el bundle por tsup). Esto es un patrón de bundling — la dependencia se treeshakea dentro del output.

## 5. Consumidores internos

No se detectaron dependencias directas en `package.json` del workspace en la revisión estática. Por diseño, es un paquete de infraestructura server-side que debería ser consumido por servicios que necesiten acceso al sistema de archivos.

## 6. Estructura interna

```
packages/server-side/file-system/src/
├── index.ts      # Barrel público
├── path/         # Utilidades de composición de rutas
├── query/        # exists, isFile, isDirectory, getStats, existsAll, existsAny
├── read/         # readFile, readJsonFile, readFiles
├── scan/         # scanDirectory, getFiles, getDirectories, findFiles, findFile
├── services/     # Servicios adicionales (contenido no inspeccionado)
└── write/        # writeFile, writeJsonFile, appendToFile
```

El script `madge` detecta dependencias circulares — señal de que la arquitectura interna se monitorea activamente.

## 7. Estado

| Campo          | Valor                                                                        |
|----------------|------------------------------------------------------------------------------|
| Madurez        | experimental                                                                 |
| Justificación  | v0.0.1, sin descripción, peer dep de plataforma no documentada               |
| Build          | no ejecutado (inventario estático)                                           |
| Tests          | No detectados (`scripts` no incluye `test`)                                 |
| Último cambio  | desconocido (no se accedió a git log)                                        |

## 8. Dominios que toca

- Operaciones de sistema de archivos (Node.js)
- Utilidades de paths
- Escaneo y búsqueda de archivos (glob)
- Integración con plataforma Vortech

## 9. Observaciones

- La peer dependency de `@vortech/platform` requiere inspección: puede implicar que las funciones se registran como servicios de plataforma (DI) o que usan contexto de la plataforma.
- `fast-glob` en devDependencies pero usado internamente es un patrón válido con bundlers — el output del bundle incluye el código de fast-glob.
- La presencia de `madge` en devDependencies y script `madge` sugiere que el equipo verificó activamente que no hay dependencias circulares.
- El scope `server-side/` como directorio es una convención de organización explícita — útil para distinguir de paquetes browser-safe.

## 10. Hipótesis

- `src/services/` probablemente contiene implementaciones que integran las operaciones de archivo con el sistema de plataforma (p.ej. un `FileSystemService` inyectable vía DI).
- Las funciones de path en `src/path/` son wrappers sobre `node:path` con posible normalización cross-platform.
- `readJsonFile` probablemente incluye validación de esquema (similar al patrón de `@vortech/security` con ajv).

## 11. Preguntas abiertas

1. ¿Qué contiene `src/services/`? ¿Un servicio de DI que envuelve las operaciones?
2. ¿La peer dep `@vortech/platform` es opcional o requerida para usar el paquete?
3. ¿`readFiles` hace lectura en paralelo o secuencial?
4. ¿`ScanOptions` incluye soporte para `.gitignore` o globs de exclusión?
