# official-doc/dotnet/

Documentación oficial del rol de **.NET** en la plataforma Vortech.

## Índice

| # | Documento | Estado |
|---|---|---|
| 00 | [Responsabilidad de .NET en la plataforma](00-responsabilidad-de-dotnet.md) | draft v1 |
| 01 | [Cierre de decisiones — .NET](01-cierre-decisiones-dotnet.md) | normativo |

### Detalle por primitiva

Cada documento aterriza una primitiva de la plataforma en términos .NET concretos: forma del contrato, atributos canónicos, runtime, proyección vía codegen, reglas invariantes, qué no es.

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
| 20 | Router       | [20-router.md](20-router.md) |
| 21 | Extension    | [21-extension.md](21-extension.md) |

## Alcance

Estos documentos describen **qué rol juega .NET** dentro del todo:

- Qué primitivas tienen su implementación canónica en .NET.
- Qué no es responsabilidad de .NET (aunque técnicamente pudiera serlo).
- Cómo se relaciona .NET con el resto del ecosistema (TS, Rust, Python, otros).

## Lo que no vive aquí

- Elecciones concretas de librerías (OpenIddict vs Duende, EF vs Dapper, …) → decisiones operativas.
- Topología de despliegue, repos, ramas, versionado → operativo.
- Roadmaps e implementación → `inventory/_analysis-preview/` y `v-mono/analysis/`.
- Código fuente → `repos/`.
