---
kind: package-summary
repo: vortech
package_name: "fleet-dashboard"
package_path: "system-agent/dashboard"
language: angular
manifest: angular.json
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
source_repo: vortech
source_commit: f55e8e0202c3ef2486d845bb87601c7366d76b90
madurez: beta
---

# fleet-dashboard

## 1. Identidad
- **Nombre:** fleet-dashboard
- **Path:** `system-agent/dashboard`
- **Lenguaje:** angular
- **Versión declarada:** (ver manifest en el repo; inventario estático)
- **Publicado:** desconocido

## 2. Propósito

### 2.1 Declarado
Ver `README` o descripción en el manifest en el snapshot bajo `repos/vortech/`.

### 2.2 Inferido
Package clasificado por manifest `angular.json` en el monorepo Vortech.

**Evidencia:**
- `system-agent/dashboard/src/main.ts:1` — primer fuente local bajo el path (heurística Fase 1).

## 3. Superficie pública
- Revisar entrypoints (`package.json` exports, `index.ts`, `Program.cs`, `src/main.rs`) en el snapshot.

## 4. Dependencias

### 4.1 Internas al repo
- Listar desde el manifest y referencias `workspace:` / paths relativos.

### 4.2 Externas
- Declaradas en el manifest; versiones transitivas no auditadas en Fase 1.

## 5. Consumidores internos
- Búsqueda estática de imports; sin resolución de módulos ni `node_modules`.

## 6. Estructura interna
- Inspeccionar subcarpetas `src/`, `lib/`, `tests/` bajo `system-agent/dashboard`.

## 7. Estado

- **Madurez:** beta
- **Justificación:** criterio estático (Fase 1); tope `maduro-aparente` sin build.
- **Build:** no ejecutado
- **Tests:** (conteo de `*.test.*` / `*.spec.*` por carpeta; no ejecución)
- **Último cambio relevante observado:** desconocido

## 8. Dominios que toca
- Ver `../domains/*.md` para mapeo semántico.

## 9. Observaciones
- Resumen mínimo Fase 1; profundizar en Fase 2.

## 10. Hipótesis (`?:`)
- (ninguna con evidencia adicional mínima)

## 11. Preguntas abiertas
- (ninguna)
