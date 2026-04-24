# 01 — Estructura propuesta del monorepo `v-mono`

**Objetivo:** definir la disposición física del monorepo universal que aloja implementaciones en Node.js, Angular, .NET (SDK + Framework), Rust, C++, PlatformIO y Python, con el mínimo acoplamiento y el máximo reuso semántico entre lenguajes.

---

## 1. Layout raíz

```
v-mono/
├── .docs/                              ← esta documentación
├── .github/                            ← CI/CD unificado (matrix por toolchain)
├── .vscode/                            ← settings, tasks, launch compartidos
├── .editorconfig
├── .gitattributes
├── .gitignore
│
├── package.json                        ← root pnpm workspace
├── pnpm-workspace.yaml
├── pnpm-lock.yaml
├── tsconfig.base.json                  ← tsconfig raíz heredado por todos los TS/JS
├── tsconfig.json                       ← references a todos los TS workspaces
├── angular.json                        ← workspace Angular global (apps Angular)
│
├── Directory.Build.props               ← .NET global props (target, lang version, analyzers)
├── Directory.Packages.props            ← Central Package Management (.NET)
├── global.json                         ← pin SDK .NET
├── nuget.config
├── v-mono.sln                          ← solución .NET "paraguas" (incluye SDK-style)
├── v-mono.slnx                         ← solución XML (VS 2026+)
│
├── Cargo.toml                          ← workspace Rust (virtual manifest)
├── rust-toolchain.toml
├── rustfmt.toml
├── clippy.toml
│
├── CMakeLists.txt                      ← C++ umbrella (opcional) o build por subdir
├── CMakePresets.json
├── vcpkg.json                          ← manifest vcpkg si aplica
│
├── platformio.ini                      ← PlatformIO workspace (multi-env)
│
├── pyproject.toml                      ← workspace Python (uv / hatch / pdm)
├── uv.lock
│
├── LICENSE
└── README.md
│
├── contracts/                          ← FUENTE ÚNICA DE VERDAD POR DOMINIO
│   └── <domain>/
│       ├── <domain>.contract.md        ← descripción semántica del dominio
│       ├── <domain>.schema.json        ← tipos/eventos/acciones en JSON Schema
│       ├── <domain>.proto              ← (opcional) contratos gRPC/proto
│       └── generated/                  ← salidas por lenguaje (gitignored o trackeadas)
│           ├── ts/
│           ├── csharp/
│           ├── rust/
│           ├── cpp/
│           └── python/
│
├── ts/                                 ← workspaces TypeScript / JavaScript / Node.js
│   ├── packages/                       ← libs publicables (@v/...)
│   ├── apps/                           ← apps Node.js / CLIs
│   ├── angular/                        ← apps Angular (referenciadas desde angular.json)
│   └── tooling/                        ← scripts, codegen, build helpers en TS
│
├── dotnet/                             ← workspaces .NET
│   ├── src/                            ← proyectos SDK-style (.NET 10+)
│   ├── apps/                           ← entry points (WPF, ASP.NET, servicios)
│   ├── netfx/                          ← .NET Framework 4.x (aislado, propio sln)
│   │   ├── v-mono.netfx.sln
│   │   └── src/
│   └── tests/
│
├── rust/                               ← miembros del workspace Cargo
│   ├── crates/
│   ├── apps/
│   └── tools/
│
├── cpp/                                ← C++ nativo (no embebido)
│   ├── libs/
│   ├── apps/
│   └── cmake/                          ← toolchains, módulos
│
├── embedded/                           ← PlatformIO / firmware
│   ├── platformio/                     ← envs, boards, libs
│   ├── libs/                           ← bibliotecas compartibles entre envs
│   └── apps/                           ← firmwares
│
├── python/                             ← paquetes Python
│   ├── packages/
│   ├── apps/
│   └── tools/
│
├── inventory/                          ← salida de Fase 1 (agentes) — versionado
│   ├── <repo-name>/
│   │   ├── summary/                    ← un md por package
│   │   ├── domains/                    ← inventarios por dominio
│   │   └── status/                     ← reportes estado (bugs, dup, incompleto)
│   └── _consolidated/                  ← merge cross-repo (generado post-inventario)
│
└── analysis/                           ← salida de Fase 2 — versionado
    ├── comparisons/                    ← mismo dominio en múltiples lenguajes/repos
    ├── duplications/                   ← matrices de duplicación
    ├── canonical-proposals/            ← qué implementación es canónica por dominio
    └── migration-plan.md               ← plan consolidado de migración a v-mono
```

---

## 2. Principios estructurales

### 2.1 Un lenguaje = un top-level folder

Cada lenguaje vive en su propio directorio top-level (`ts/`, `dotnet/`, `rust/`, `cpp/`, `embedded/`, `python/`). Esto permite que **cada toolchain vea su raíz natural** (Cargo ve `rust/`, pnpm ve `ts/`, .NET ve `dotnet/`) sin que un lenguaje contamine el otro.

No se mezclan lenguajes dentro de un mismo package aunque conceptualmente pertenezcan al mismo dominio. Si el dominio `identity` necesita TS + C# + Rust, vive en tres lugares físicos coordinados por `contracts/identity/`.

### 2.2 `contracts/` es la columna vertebral

Todo dominio tiene su definición semántica en `contracts/<domain>/`. Desde ahí se **generan** los artefactos por lenguaje (tipos, clientes, schemas) vía pipeline de codegen. La regla dura:

> Si dos lenguajes implementan el mismo dominio con contratos divergentes, **uno de los dos está mal** (o el contrato está mal). No hay "implementaciones paralelas que se parecen".

### 2.3 Aislamiento de .NET Framework

`dotnet/netfx/` tiene su propia solución (`v-mono.netfx.sln`) y sus propios targets. No se mezcla en `v-mono.sln` principal para evitar que el MSBuild moderno (.NET 10 SDK-style) choque con `packages.config` / project system legacy.

### 2.4 PlatformIO es workspace, no submódulos

`embedded/platformio.ini` declara múltiples `[env:*]` — uno por board/firmware. Bibliotecas compartibles en `embedded/libs/` se referencian con `lib_extra_dirs`. No se crean `platformio.ini` anidados porque PlatformIO no maneja bien el nested config.

### 2.5 Angular convive con packages TS

`angular.json` en la raíz lista proyectos bajo `ts/angular/*`. Los packages consumibles (libs Angular publicables) viven en `ts/packages/` con naming `@v/ng-*` y se registran tanto en `angular.json` como en `pnpm-workspace.yaml`. **No** se crea un `angular-workspace/` separado: una sola vista.

### 2.6 `inventory/` y `analysis/` son parte del repo

Los artefactos producidos por los agentes (Fase 1) y el análisis (Fase 2) se commitean al repo. No son "resultados efímeros" — son memoria institucional. Se versionan con el código y evolucionan con él.

---

## 3. Naming por lenguaje

| Lenguaje    | Namespace / prefix               | Ejemplo               |
|-------------|----------------------------------|-----------------------|
| TypeScript  | `@v/<domain>-<role>`             | `@v/identity-client`  |
| Angular lib | `@v/ng-<domain>`                 | `@v/ng-layout`        |
| .NET        | `V.<Domain>.<Role>`              | `V.Identity.Client`   |
| Rust        | `v-<domain>-<role>`              | `v-identity-client`   |
| C++         | `v::<domain>::<role>` + `v_<..>` | `v::identity::client` |
| Python      | `v_<domain>_<role>`              | `v_identity_client`   |

**Regla dura:** el mismo dominio usa el mismo nombre de dominio en todos los lenguajes. `identity` es `identity` en TS, C#, Rust, C++, Python — nunca `auth` en uno y `identity` en otro.

---

## 4. Qué **NO** está en este layout

- **Submódulos git.** Si una dependencia externa debe vivir dentro, se vendoriza bajo `vendor/<lang>/<name>/` con `VENDOR.md` que documenta versión y razón.
- **Scripts shell sueltos en raíz.** Todo script va a `tooling/` del lenguaje correspondiente. La raíz solo tiene configs de workspaces.
- **Documentación dispersa.** Toda la doc de diseño vive en `v-mono/.docs/` (este directorio). La doc de usuario final vive en `docs/` (si aplica).
- **Builds orquestados por Make / bash.** La orquestación cross-language se hace con una herramienta explícita (propuesta en §02-workspace-configs).

---

## 5. Migración de los repos actuales a este layout

Mapeo preliminar (se refina en Fase 2):

| Origen actual                              | Destino en `v-mono`                       |
|--------------------------------------------|-------------------------------------------|
| `platform/legacy/*`                        | análisis en Fase 1 → piezas a `ts/packages/`, `contracts/theming/` |
| `platform/v-common`                        | `ts/packages/v-common` (tras review)      |
| `platform/core`                            | partir por dominio → `contracts/*` + implementaciones TS |
| `packages/*`                               | reagrupar por dominio en `ts/packages/`   |
| `apis/http-client`                         | `ts/packages/http-client` + `contracts/http/` |
| `connections/*`                            | `ts/packages/connections-*`               |
| `host/*`, `system-agent/*`                 | split: dominio → `contracts/`, impl → `dotnet/src/` y/o `ts/packages/` |
| `rust-workspace/*`                         | `rust/crates/*` + `rust/apps/*`           |
| `sokectio/*`                               | análisis previo — candidato a `ts/packages/socket-*` |
| `devtools/*`                               | `ts/packages/devtools-*` + `tooling/`     |
| `metaquest/*`                              | evaluar separación (podría quedar fuera)  |

Esta tabla **no es ejecutable todavía** — es una hipótesis que la Fase 1 (inventario) debe validar con evidencia antes de convertirse en plan.
