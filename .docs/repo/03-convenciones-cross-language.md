# 03 — Convenciones cross-language

**Objetivo:** reglas de consistencia que se aplican en **todos** los lenguajes del monorepo para que un desarrollador pueda saltar entre toolchains sin reaprender convenciones.

---

## 1. Naming de dominios

Un **dominio** es la unidad semántica de la plataforma (identity, wire, transport, layout, theming, runtime, etc.). Cada dominio tiene un nombre canónico definido en `contracts/<domain>/`.

**Reglas duras:**
- El nombre del dominio es una sola palabra (o compuesta con guión: `plugin-host`, no `pluginHost`).
- El mismo dominio usa el mismo nombre en todos los lenguajes.
- Prohibido usar sinónimos: `identity` no se convierte en `auth` en ningún lado.

### 1.1 Proyección a nombres de package

| Lenguaje    | Patrón                              | Ejemplo                                |
|-------------|-------------------------------------|----------------------------------------|
| TypeScript  | `@v/<domain>-<role>`                | `@v/identity-client`                   |
| Angular lib | `@v/ng-<domain>[-<role>]`           | `@v/ng-layout`, `@v/ng-identity-ui`    |
| .NET        | `V.<Domain>.<Role>` (PascalCase)    | `V.Identity.Client`                    |
| Rust        | `v-<domain>-<role>`                 | `v-identity-client`                    |
| C++         | target `v_<domain>_<role>`, namespace `v::<domain>::<role>` | `v::identity::client` |
| Python      | `v_<domain>_<role>`                 | `v_identity_client`                    |

`<role>` es uno de: `contract`, `client`, `server`, `core`, `codegen`, `cli`, `ui`, `testing`.

---

## 2. Tipado y contratos

### 2.1 Fuente de verdad

Los tipos públicos de un dominio **no se definen en cada lenguaje**. Se definen una vez en `contracts/<domain>/<domain>.schema.json` (o `.proto` cuando aplica) y se generan por lenguaje.

### 2.2 Reglas de codegen

- Los archivos generados viven en `contracts/<domain>/generated/<lang>/`.
- Los consumidores importan desde ahí, **no** desde otras implementaciones.
- Los archivos generados llevan header estándar: `// AUTO-GENERATED — DO NOT EDIT`.
- CI falla si `generated/` está desincronizado con el `.schema.json`.

### 2.3 Tipos que viven fuera de `contracts/`

- Tipos internos de implementación (detalles privados).
- Tipos de test.
- Tipos específicos de UI que no cruzan proceso.

---

## 3. Versionado

- **SemVer estricto** en todos los lenguajes.
- Versión sincronizada por dominio: `identity-client` TS, C# y Rust deben tener la **misma** major/minor si implementan el mismo contrato.
- Breaking changes en `contracts/<domain>/` bump la major de **todos** los generated y de los consumidores directos.
- Se usa **Changesets** (TS) + hook que propaga a `Directory.Packages.props`, `Cargo.toml workspace deps`, y `pyproject.toml` para mantener la sincronía.

---

## 4. Estilo de código

| Aspecto              | TS / JS         | .NET                | Rust          | C++               | Python        |
|----------------------|-----------------|---------------------|---------------|-------------------|---------------|
| Indent               | 2 espacios      | 4 espacios          | 4 espacios    | 4 espacios        | 4 espacios    |
| Line ending          | LF              | LF                  | LF            | LF                | LF            |
| Max line             | 120             | 140                 | 100           | 120               | 100           |
| Naming types         | PascalCase      | PascalCase          | PascalCase    | PascalCase        | PascalCase    |
| Naming funcs         | camelCase       | PascalCase          | snake_case    | camelCase / snake | snake_case    |
| Naming constants     | `UPPER_SNAKE`   | `PascalCase`        | `UPPER_SNAKE` | `UPPER_SNAKE`     | `UPPER_SNAKE` |
| Linter               | ESLint          | .NET analyzers + EditorConfig | clippy (deny warnings) | clang-tidy    | ruff + mypy   |
| Formatter            | Prettier        | `dotnet format`     | rustfmt       | clang-format      | ruff format   |

**Los formatters se corren en pre-commit y en CI**. PRs con diffs de formatter se rechazan.

---

## 5. Testing

- Framework por lenguaje:
  - TS: Vitest.
  - .NET: xUnit.
  - Rust: `cargo test` + `insta` para snapshots.
  - C++: Catch2 o GoogleTest (elegir uno y mantenerlo).
  - Python: pytest.
- Tests viven junto al código (`*.test.ts`, `*_test.rs`, `*Tests.cs`, `test_*.py`) — **no** en carpetas separadas `tests/` salvo integración cross-package.
- Smoke tests en este workspace están prohibidos — la validación de cambios debe ser por tests unitarios o uso real en IDE según el objetivo.
- Cobertura: gate en CI del 70% mínimo por package, subir con el tiempo.

---

## 6. Estructura interna de un package

Aplicable a cualquier lenguaje (adaptando extensiones):

```
<package-root>/
├── README.md              ← propósito, uso, status
├── <manifest>             ← package.json / *.csproj / Cargo.toml / pyproject.toml / CMakeLists.txt
├── src/
│   ├── index.*            ← entry point con re-exports públicos
│   └── <subdomain>/
│       ├── index.*
│       └── <files>
├── tests/                 ← solo integración
└── CHANGELOG.md           ← generado por changesets
```

**Reglas estructurales duras:**
- Prohibidos los archivos monolíticos.
- Cada directorio tiene `index.*` con re-exports.
- Un archivo no contiene más de un tipo público exportado principal.
- No se salta la capa `src/` — todo código va ahí.

---

## 7. Imports y dependencias

### 7.1 Reglas de dependencia entre lenguajes

- **Ningún lenguaje depende del artefacto de otro en tiempo de build.** Todo puente es por contrato (gRPC, REST, mensajes sobre Wire, archivos generados desde `contracts/`).
- Las únicas dependencias cross-language permitidas son:
  - Generación de código desde `contracts/` al subirse el schema.
  - Consumo runtime vía protocolos de red declarados.

### 7.2 Reglas de dependencia dentro del mismo lenguaje

- Sin referencias a archivos de paquetes legacy o "fuera del workspace actual".
- Los packages declaran dependencias en su manifest, nunca por paths relativos a otro package.
- `dependency-cruiser` (TS), analyzers .NET, `cargo deny` (Rust) enforced en CI.

---

## 8. Documentación

- Cada package tiene `README.md` con:
  1. Propósito en una línea.
  2. Contrato que implementa (link a `contracts/<domain>/`).
  3. Snippet de uso mínimo.
  4. Estado (alpha / beta / stable / deprecated).
- La documentación de arquitectura vive en `v-mono/.docs/` (este directorio y extensiones futuras).
- Los `CHANGELOG.md` se generan automáticamente.

---

## 9. Qué está prohibido transversalmente

- Duplicar lógica de dominio entre packages del mismo lenguaje.
- Reimplementar un contrato a mano en vez de consumir el generated.
- Añadir dependencias de runtime que no estén en el lockfile del lenguaje correspondiente.
- Hacer commits con archivos generados modificados a mano.
- Usar nombres distintos para el mismo concepto entre lenguajes.
- Saltarse la separación `contracts/` ↔ implementación "porque es más rápido".

---

## 10. Checklist para un nuevo package

Antes de crear un package en cualquier lenguaje:

1. [ ] ¿El dominio ya existe en `contracts/`? Si no, crearlo primero.
2. [ ] ¿El nombre sigue el patrón del §1.1?
3. [ ] ¿Va al directorio del lenguaje correcto (`ts/packages`, `dotnet/src`, etc.)?
4. [ ] ¿Está registrado en el workspace manifest correspondiente?
5. [ ] ¿Tiene `README.md` con los 4 puntos del §8?
6. [ ] ¿Consume contratos desde `contracts/<domain>/generated/<lang>` en lugar de reimplementarlos?
7. [ ] ¿Los tests corren en CI del lenguaje?
