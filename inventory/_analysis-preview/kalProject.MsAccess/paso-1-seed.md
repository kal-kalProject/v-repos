---
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
kind: post-inventario
step: 1
scope: seed-consolidacion
generated_at: 2026-04-24T20:30:00Z
generated_by: cursor
---

# Paso 1 (semilla) — `kalProject.MsAccess` hacia análisis global

Fragmento mínimo del workflow en `.docs/post-inventario/01-instrucciones-analisis.md` §2 **Consolidación**, limitado a **un** repo. Sirve de entrada cuando se amplíe a `vortech` / `v-rust` y demás. No reemplaza `v-mono/analysis/_index/*.md` definitivos.

## Dominios (desde Fase 1)

| Dominio (archivo) | Lenguajes (Fase 1) | Paquetes o artefacto clave (resumen) | Madurez máx. observada (summary) | Nota |
|-------------------|--------------------|--------------------------------------|----------------------------------|------|
| `transport` | C#, Protobuf | Bridge gRPC, Server cliente gRPC, `proto/access_bridge.proto` | maduro-aparente | Código en `Generated/` duplicado (riesgo) |
| `host` | C# | `kalProject.Server`, `Server.App`, `MsAccess.Server` | maduro-aparente a beta | Varias “apps” host; riesgo de solapar plantillas |
| `ms_access` | C# | `kalProject.MsAccess`, `Extensions`, `Data`, `Client` | maduro-aparente a beta | `NotSupported` explícito en ruta in-memory (hecho) |
| `wire` | C#, JS, TS, C++ | `Common` + `Client` + clientes bajo `Clients/*` | beta / experimental (Angular) | Múltiples runtimes, contrato a alinear |
| `interop` | C# | `Extensions`, `Bridge`, `Originals/**`, `Libs` | mezclada (PIA masivo) | Peso y licenciamiento PIA/TLB |
| `client_sdks` | varios | Consolas, Node, Pio, TS parcial, net48 | beta / experimental | Paridad net48 vs. net9 sin `ProjectReference` compartida |

Evidencia detallada: `inventory/kalProject.MsAccess/domains/<domain>.md` y `summary/*.md` con el mismo `source_commit` que en este frontmatter.

## Duplicaciones (volcado Fase 1, sin re-categorizar aún)

Copia útil de `status/repo.md` para el paso 3 del workflow (detección de duplicación real en post-inventario). La categoría (`duplicacion-exacta`, `poliglota-legitimo`, etc.) **se decide en Fase 2** con `02-criterios-unificacion.md`.

1. gRPC/Protobuf: `MsAccess.Bridge/Generated` vs. `MsAccess.Server/Generated` (mismo proto).
2. Bloques de referencia COM: `MsAccess.Extensions` vs. `MsAccess.Bridge` hacia `Libs/`.
3. Cliente WebSocket: `kalProject.Client` (SDK) vs. `Clients/netframework48-client` (MSBuild + packages).

Citas de línea: ver tablas bajo `inventory/kalProject.MsAccess/status/repo.md` (Bugs, Duplicaciones, Incompletitud).

## Decisiones a preparar (no cerradas; falsabilidad requerida en post-inventario)

| Tema | Qué probar / evidencia que invalidaría la decisión tentativa |
|------|----------------------------------------------------------------|
| Orquestación gRPC: un solo paso de generación compartido | Falso si ambos `Generated` divergen hoy bajo un mismo `protoc` y MSBuild: comparar diffs; si son idénticos post-build, riesgo bajo, sigue el tema de orquestación en CI. |
| Angular client sin `package.json` | Falso si se añade manifest y el árbol compila: completitud sube. |
| Unificar pistas a `Libs/` en un `Directory.Build.props` o props compartida | Falso si las DLLs deben quedar con hints distintos por runtime (raro). |
| Canónico “wire” en C# (`kalProject.Common` + `BridgeWebSocket*`) y proyecciones a TS/JS por schema | Falso si se demuestra que el servidor ya es ancla OpenAPI/JSON distinta: comparar pares C# vs. TS (Fase 2, diff de campos en `ProtocolEnvelope` / `BroadcastPayload`). |

## Conexión con otros inventarios (cuando toque unificación)

- `wire` y `sockets` en `inventory/vortech/domains/`: leer y contrastar; **cross-language** puede ser `poliglota-legitimo` (regla 4, `01-instrucciones-analisis.md`) si los contratos se alinean sin fusionar repositorio.
- No hay conclusión de canónico aquí: solo anclas a evidencia bajo `inventory/`.

## Montajes / mounts

- `kalProject.MsAccess` en `source.md` declara `mounted_from: null` (típico). Si un futuro análisis duplica con otro path, reconciliar con `02-criterios` §3 en post-inventario (overlap-mount-parent).
