# 02 — Configuración de workspaces del root

**Objetivo:** listar los archivos de configuración del root de `v-mono`, su propósito, y cómo coexisten sin pisarse entre toolchains.

---

## 1. Tabla maestra

| Archivo                         | Toolchain        | Scope                                | Notas clave                                      |
|---------------------------------|------------------|--------------------------------------|--------------------------------------------------|
| `pnpm-workspace.yaml`           | pnpm             | Todos los paquetes TS/JS/Angular     | Único gestor TS permitido                        |
| `package.json`                  | pnpm / Node      | Root — scripts orquestadores + deps de tooling | `"private": true`                       |
| `pnpm-lock.yaml`                | pnpm             | Lockfile TS                          | Commit obligatorio                               |
| `tsconfig.base.json`            | TS               | Compiler options compartidas         | Heredado con `extends`                           |
| `tsconfig.json`                 | TS               | `references` a todos los TS projects | Habilita solution-style build                    |
| `angular.json`                  | Angular CLI      | Apps y libs Angular                  | Paths apuntan a `ts/angular/*` y `ts/packages/`  |
| `v-mono.sln` / `v-mono.slnx`    | .NET / MSBuild   | Proyectos SDK-style (.NET 10+)       | Excluye `dotnet/netfx/`                          |
| `Directory.Build.props`         | MSBuild          | Target framework, langversion, analyzers, nullable | Heredado por todos los `.csproj` SDK-style |
| `Directory.Packages.props`      | MSBuild CPM      | Versiones centralizadas de NuGet     | `ManagePackageVersionsCentrally=true`            |
| `global.json`                   | .NET SDK         | Pin versión SDK .NET                 | Evita drift entre devs                           |
| `nuget.config`                  | NuGet            | Feeds (nuget.org + privados)         | `packageSourceMapping` explícito                 |
| `Cargo.toml`                    | Cargo            | Virtual workspace Rust               | `members = ["rust/crates/*", "rust/apps/*"]`     |
| `rust-toolchain.toml`           | rustup           | Pin de toolchain                     | Channel estable fijo                             |
| `rustfmt.toml`, `clippy.toml`   | Rust             | Estilo y lints                       | Idéntico en CI y local                           |
| `CMakePresets.json`             | CMake            | Presets de configuración y build     | Un preset por target (desktop, embedded-host)    |
| `CMakeLists.txt` (root, opcional)| CMake           | Umbrella que incluye `cpp/libs`, `cpp/apps` | Opcional si cada subdir es autónomo      |
| `vcpkg.json`                    | vcpkg            | Manifest de deps C++                 | Solo si se usa vcpkg                             |
| `platformio.ini`                | PlatformIO       | Envs para firmware                   | Cada firmware = un `[env:*]`                     |
| `pyproject.toml`                | uv / hatch / pdm | Workspace Python                     | `[tool.uv.workspace] members = ["python/**"]`    |
| `uv.lock`                       | uv               | Lockfile Python                      | Commit obligatorio                               |
| `.editorconfig`                 | editor           | Indent, line endings, charset        | Aplica a todo                                    |
| `.gitattributes`                | git              | `* text=auto eol=lf`, binary rules   | Evita drift CRLF/LF                              |

---

## 2. `pnpm-workspace.yaml`

```yaml
packages:
  - 'ts/packages/*'
  - 'ts/packages/**/package.json'
  - 'ts/apps/*'
  - 'ts/angular/**'
  - 'ts/tooling/*'
  - 'contracts/*/generated/ts'
```

Notas:
- Se incluye `contracts/*/generated/ts` para que los tipos generados sean consumibles como packages locales (`@v/contracts-<domain>`).
- No se usa `packages: ['**']` porque explota en monorepos grandes y atrae `node_modules` de subrepos vendorizados.

---

## 3. `tsconfig.base.json`

Base estricta, heredada por **todo** package TS:

```jsonc
{
  "compilerOptions": {
    "target": "ES2023",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noFallthroughCasesInSwitch": true,
    "isolatedModules": true,
    "skipLibCheck": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "useDefineForClassFields": true
  }
}
```

`tsconfig.json` raíz solo contiene `references` (build solution-style) — **no** compila archivos.

---

## 4. `angular.json`

Registra apps y libs Angular. Paths apuntan a `ts/angular/<app>` y `ts/packages/ng-*`. No duplica lo que `pnpm-workspace.yaml` ya declara — solo añade la vista del Angular CLI.

Regla:
- **Una** `angular.json` — no se permiten workspaces Angular anidados.
- `defaultProject` no se usa; cada comando especifica proyecto.

---

## 5. .NET — dos soluciones

### 5.1 `v-mono.sln` / `v-mono.slnx` (moderno)

Incluye todo bajo `dotnet/src/`, `dotnet/apps/`, `dotnet/tests/`. Todos los proyectos son SDK-style, .NET 10+.

### 5.2 `dotnet/netfx/v-mono.netfx.sln` (legacy)

Incluye proyectos .NET Framework 4.x. Completamente separado:
- Propio `Directory.Build.props` bajo `dotnet/netfx/`.
- No referenciado por la solución principal.
- Solo buildeable en Windows con MSBuild clásico.

### 5.3 `Directory.Build.props` (raíz)

```xml
<Project>
  <PropertyGroup>
    <TargetFramework>net10.0</TargetFramework>
    <LangVersion>latest</LangVersion>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
    <AnalysisLevel>latest-recommended</AnalysisLevel>
  </PropertyGroup>
</Project>
```

Se neutraliza dentro de `dotnet/netfx/` con otro `Directory.Build.props` que sobrescribe `TargetFramework`.

### 5.4 `Directory.Packages.props` — Central Package Management

Una sola versión por paquete NuGet, en toda la solución SDK-style. Proyectos declaran `<PackageReference Include="X" />` sin versión.

---

## 6. Rust — workspace virtual

`Cargo.toml` raíz:

```toml
[workspace]
resolver = "2"
members = ["rust/crates/*", "rust/apps/*", "rust/tools/*"]

[workspace.package]
edition = "2024"
rust-version = "1.84"
license = "..."

[workspace.dependencies]
# versiones centralizadas — los crates las consumen con { workspace = true }
```

Cada crate hereda con `edition.workspace = true`, deps con `serde = { workspace = true }`.

---

## 7. C++ — CMake + Presets

`CMakePresets.json` declara presets por target:

```jsonc
{
  "version": 6,
  "configurePresets": [
    { "name": "desktop-debug", "binaryDir": "${sourceDir}/build/desktop-debug", ... },
    { "name": "desktop-release", ... }
  ]
}
```

Cada lib/app en `cpp/` tiene su propio `CMakeLists.txt`. Un `CMakeLists.txt` raíz opcional los agrega con `add_subdirectory`.

vcpkg en modo manifest (`vcpkg.json`) si se usa — no se commitean binarios.

---

## 8. PlatformIO

`platformio.ini` raíz con un env por firmware. `lib_extra_dirs` apunta a `embedded/libs`. No hay `platformio.ini` por firmware — todo se declara en el archivo raíz.

---

## 9. Python — uv como default

`pyproject.toml` raíz:

```toml
[tool.uv.workspace]
members = ["python/packages/*", "python/apps/*", "python/tools/*"]
```

Cada package/app tiene su `pyproject.toml` local. `uv sync` desde la raíz resuelve todo. Lockfile único en `uv.lock`.

---

## 10. Orquestación cross-language

El root `package.json` contiene scripts `orchestrate:*` que delegan al toolchain correcto:

```jsonc
{
  "scripts": {
    "build:ts": "pnpm -r --filter='./ts/**' build",
    "build:dotnet": "dotnet build v-mono.sln",
    "build:rust": "cargo build --workspace",
    "build:cpp": "cmake --build --preset desktop-release",
    "build:embedded": "pio run",
    "build:python": "uv sync && uv run hatch build",
    "build:all": "pnpm run build:ts && pnpm run build:dotnet && pnpm run build:rust && pnpm run build:cpp && pnpm run build:python",
    "codegen": "pnpm -F @v/tooling-codegen run all"
  }
}
```

Para flujos complejos (matrices de build por cambios), se usa `nx` o `turbo` **sólo para el lado TS**. La orquestación cross-language se mantiene en scripts explícitos en CI para no acoplar .NET/Rust/C++ a herramientas del ecosistema JS.

---

## 11. CI (.github/workflows/)

Un workflow por toolchain, con `paths:` filters para que cambios en `ts/` no disparen builds de Rust y viceversa:

```
.github/workflows/
├── ci-ts.yml        paths: ts/**, pnpm-*.yaml, tsconfig*.json
├── ci-angular.yml   paths: ts/angular/**, angular.json
├── ci-dotnet.yml    paths: dotnet/src/**, dotnet/apps/**, v-mono.sln, Directory.*.props
├── ci-netfx.yml     paths: dotnet/netfx/**                     (runs-on: windows)
├── ci-rust.yml      paths: rust/**, Cargo.toml, rust-toolchain.toml
├── ci-cpp.yml       paths: cpp/**, CMake*
├── ci-embedded.yml  paths: embedded/**, platformio.ini
├── ci-python.yml    paths: python/**, pyproject.toml, uv.lock
├── ci-contracts.yml paths: contracts/**  (regenera y verifica que generated/ está al día)
└── ci-full.yml      manual dispatch — builds everything
```

---

## 12. Problemas conocidos y soluciones

| Problema                                          | Solución                                              |
|---------------------------------------------------|-------------------------------------------------------|
| `node_modules` gigante en la raíz                 | `pnpm` con `symlinked-node-modules-hoisting=false`    |
| .NET analyzers corriendo sobre `generated/`       | `<Compile Remove="**/generated/**" />` en props globales a nivel de proyecto, o marcar como auto-generated |
| Cargo compila todo el workspace siempre           | Usar `-p <crate>` en CI selectivo o `cargo-hakari`    |
| Angular CLI no respeta `tsconfig.base`            | Cada lib Angular extiende explícitamente              |
| PlatformIO escribe en `.pio/` dentro de cada env  | Gitignored globalmente                                |
| `dotnet restore` baja paquetes TS por error       | `<EnableDefaultItems>` controlado; nada de globs laxos |
