---
source_repo: v-rust
source_commit: dfb2bdc3ace105d04d66c6439bd2aa8818919629
kind: domain-inventory
repo: v-rust
domain: data
inventoried_at: 2026-04-24T16:20:00Z
inventoried_by: cursor-agent
implementations_count: 6
languages_involved: [csharp, rust]
---

# Dominio — `data`

## 1. Definición operativa
Modelo de esquemas, proveedores de datos, agentes de acceso (SQLite, MS Access) y drivers paralelos en Rust (`v-gate`, `v-gate-sqlite`).

## 2. Implementaciones encontradas (muestra representativa)
| # | Package | Path | Lenguaje | Madurez | Rol |
|---|---------|------|----------|---------|-----|
| 1 | vortech-data-core | `vortech/data/core` | C# | maduro-aparente | `vortech/data/core/vortech-data-core.csproj:1` |
| 2 | vortech-data-provider | `vortech/data/provider` | C# | maduro-aparente | ejecutable/host de datos en subárbol |
| 3 | vortech-data-agents-* | `vortech/data/agents/sqlite`, `msaccess` | C# | maduro-aparente | agentes por motor |
| 4 | Vortech.Data* | `vortech-dotnet/Data/*` | C# | maduro-aparente | capa Data reutilizable |
| 5 | (2026) | `vortech-2026/data/*` | C# | maduro-aparente | `data/core`, `data/provider`, `drivers/sqlite` |
| 6 | v-gate / v-gate-sqlite | `crates/v-gate`, `crates/v-gate-sqlite` | Rust | maduro-aparente | gating y SQLite en Rust |

## 3. Responsabilidades cubiertas
- **Esquemas y mensajes** (`vortech/data/core` — tipos bajo `Schema/` en el árbol).
- **Proveedores** en C# y en Rust para SQLite/ODBC u otros.
- **Duplicación conceptual** C# (vortech, vortech-dotnet, vortech-2026) + Rust (gate).

## 4. Contratos y tipos clave
- `CollectionSchema`, campos, aislamiento: `vortech/data/core/src/Schema/CollectionSchema.cs` (línea 1+ del archivo presente bajo el snapshot).

## 5. Flujos observados
```
Aplicación / broker → data provider C# o gate Rust → almacenamiento (SQLite, MS Access, etc., según agente o crate).
```

## 6. Duplicaciones internas al repo
- Tres “familias” de Data (vortech, vortech-dotnet, vortech-2026) más Rust `v-gate*`: riesgo de lógica duplicada de validación o esquemas.

## 7. Observaciones cross-language
- C# (data layer) vs Rust (gate): posible alineación de políticas de acceso o cortafuegos de datos en Fase 2.

## 8. Estado global del dominio en este repo
- **Completitud:** parcial (múltiples evoluciones paralelas del mismo concepto).
- **Consistencia interna:** inconsistente (naming y númer de proyectos se solapan).
- **Justificación:** listado de paths en `classification.md` bajo múltiples raíces `data/`.

## 9. Sospechas para Fase 2
- `?:` Elegir una implementación de esquemas y migrar consumidores. Evidencia: paths duplicados `vortech-2026/data` vs `vortech/data`.
