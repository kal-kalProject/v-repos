---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: kalProject.MsAccess.Extensions
package_path: kalProject.MsAccess.Extensions
language: csharp
manifest: kalProject.MsAccess.Extensions.csproj
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: maduro-aparente
---

# kalProject.MsAccess.Extensions

## 1. Identidad

- **Path:** `kalProject.MsAccess.Extensions`
- **Lenguaje:** C# (net48, x64, unsafe)
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

— (README de package no requerido en inventario; inferido)

### 2.2 Inferido

Implementación DAO/Office sobre el modelo abstracto: tablas, recordsets, campos, motor, etc., enlazada a DLLs de interop bajo `Libs/`.

**Evidencia:**

- `kalProject.MsAccess.Extensions/kalProject.MsAccess.Extensions.csproj:20-22` y `24-35` — `ProjectReference` a `kalProject.MsAccess` y referencias COM (`ADODB`, `Interop.Microsoft.Office.Interop.Access*`, `office`)
- `kalProject.MsAccess.Extensions/src/Database/DaoEngine.cs:1` (ubicación inferida) — clases de tamaño considerable (L533 reportado vía análisis de LOC en Fase 1)

## 3. Superficie pública

- Implementaciones bajo `kalProject.MsAccess.Extensions` (subespacio de base de datos DAO)

## 4. Dependencias

### 4.1 Internas

- `kalProject.MsAccess`

### 4.2 Externas (COM)

- DLLs en `Libs\` (HintPath en el `.csproj`)

## 5. Consumidores internos

- `kalProject.MsAccess.Client` (vía `ProjectReference`)

## 6. Estructura interna

```
kalProject.MsAccess.Extensions/
└── src/Database/   (Tables, Recordsets, Fields, DaoEngine, ...)
```

## 7. Estado

- **Madurez:** `maduro-aparente` (código extenso y referencias COM explícitas; sin prueba de registro de COM en Fase 1)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `ms_access` — implementación concreta
- `interop` — capa de interoperabilidad nativa

## 9. Observaciones

Fichero `DaoTable.cs` y similares superan 400 LOC: deuda estructural posible bajo criterio >500 (ver conteo en paquetes hermanos; varios bajo 500)

## 10. Hipótesis

- `?:` toda la pila de Office se considera requisito de máquina con Access instalado

## 11. Preguntas abiertas

- Validar binarios bajo `Libs/` (presencia, licencia) — análisis legal fuera de Fase 1
