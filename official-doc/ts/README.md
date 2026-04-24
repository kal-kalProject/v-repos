# official-doc/ts/

Documentación oficial del lado **TypeScript / frontend** de la plataforma Vortech.

## Índice

| # | Documento | Estado |
|---|---|---|
| 00 | [Responsabilidad del frontend en la plataforma](00-responsabilidad-del-frontend.md) | draft v1 |
| 01 | [Cierre de decisiones — TypeScript / frontend](01-cierre-decisiones-ts.md) | normativo |

### Detalle por primitiva (visión frontend)

| # | Primitiva | Documento |
|---|---|---|
| 10 | Provider     | [10-provider.md](10-provider.md) |
| 11 | Driver       | [11-driver.md](11-driver.md) |
| 12 | Capability   | [12-capability.md](12-capability.md) |
| 13 | Agent        | [13-agent.md](13-agent.md) |
| 14 | Wire         | [14-wire.md](14-wire.md) |
| 15 | Bridge       | [15-bridge.md](15-bridge.md) |
| 16 | Host         | [16-host.md](16-host.md) |
| 17 | Identity     | [17-identity.md](17-identity.md) |
| 18 | Data         | [18-data.md](18-data.md) |
| 19 | Scope        | [19-scope.md](19-scope.md) |
| 20 | Router       | [20-router.md](20-router.md) — sección §X abierta a debate |
| 21 | Extension    | [21-extension.md](21-extension.md) |

### Específicos del frontend (no son primitivas)

| # | Tema | Documento |
|---|---|---|
| 22 | Componentes (`@vortech/components`) | [22-components.md](22-components.md) |
| 23 | Shell / Workbench (`@vortech/workbench`) | [23-workbench.md](23-workbench.md) |

## Convenciones

- Paquetes con prefijo `@vortech/*` (sin excepciones).
- Documentos paralelos a los de [`dotnet/`](../dotnet/). Cuando una primitiva tiene implementación canónica en .NET (Host, Identity, Bridge, Agent, Data), aquí se describe su **consumo desde el frontend**, no su implementación.

## Lo que no vive aquí

- Decisiones sobre el sustrato .NET → [`dotnet/`](../dotnet/).
- Plan de migración de los packages actuales (`v-core`, `v-layout`, etc.) al nombre `@vortech/*` y a la arquitectura final → operativo, vive en `v-mono/analysis/` cuando exista.
- Análisis técnico de los repos actuales → [`inventory/_analysis-preview/`](../../inventory/_analysis-preview/).
