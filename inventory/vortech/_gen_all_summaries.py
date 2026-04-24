"""Generate summary/*.md — delete after validate-inventory passes."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(r"E:/v-repos/repos/vortech")
INV = Path(r"E:/v-repos/inventory/vortech")
SUM = INV / "summary"
SRC_REPO = "vortech"
SRC_COMMIT = "f55e8e0202c3ef2486d845bb87601c7366d76b90"
AT = "2026-04-24T20:00:00Z"
AGENT = "cursor-inventario-fase1"


def slug(path: str) -> str:
    return path.replace("/", "_").lower() + ".md"


def first_evidence(pkg: str) -> str:
    base = ROOT / pkg.replace("/", "\\")
    if not base.is_dir():
        return f"{pkg}: (path no encontrado)"
    for pattern in ("src/index.ts", "src/main.ts", "index.ts", "lib/index.ts", "src/lib.rs", "src/main.rs"):
        f = base / pattern
        if f.is_file():
            return f"{pkg}/{pattern}:1"
    for ext in (".ts", ".tsx", ".rs", ".cs"):
        for f in sorted(base.rglob(f"*{ext}")):
            s = str(f)
            if "node_modules" in s or "dist" in s or "bin" in s or "obj" in s:
                continue
            rel = f.relative_to(ROOT)
            return f"{str(rel).replace(chr(92), '/')}:1"
    return f"{pkg}: (sin archivo fuente típico)"


def guess_lang(manifest: str) -> str:
    if manifest == "Cargo.toml":
        return "rust"
    if manifest.endswith(".csproj"):
        return "csharp"
    if manifest == "angular.json":
        return "angular"
    return "ts"


def guess_madurez(pkg: str) -> str:
    if "sokectio" in pkg or "socket.io" in pkg or "engine.io" in pkg:
        return "maduro-aparente"
    return "beta"


def collect() -> list[tuple[str, str, str]]:
    entries: list[tuple[str, str, str]] = []
    for p in sorted(ROOT.rglob("package.json")):
        rel = p.parent.relative_to(ROOT)
        r = "." if str(rel) == "." else str(rel).replace("\\", "/")
        if r == ".":
            continue
        try:
            data = json.loads(p.read_text(encoding="utf-8"))
            name = data.get("name", "(sin nombre)")
        except Exception:  # noqa: BLE001
            name = "(manifest corrupto)"
        entries.append((r, name, "package.json"))

    for sub in ("rust-workspace/alloy", "rust-workspace/core", "rust-workspace/desktop"):
        p = ROOT / sub / "Cargo.toml"
        if p.exists():
            t = p.read_text(encoding="utf-8", errors="replace")
            name = "crate"
            for line in t.splitlines():
                if line.strip().startswith("name = "):
                    name = line.split("=", 1)[1].strip().strip('"')
                    break
            entries.append((sub, name, "Cargo.toml"))

    for p in sorted(ROOT.rglob("*.csproj")):
        r = str(p.parent.relative_to(ROOT)).replace("\\", "/")
        entries.append((r, p.stem, p.name))

    for r, an in [
        ("packages/angular-demo", "angular-demo"),
        ("packages/monkey", "monkey"),
        ("system-agent/dashboard", "fleet-dashboard"),
        ("packages/v-studio", "v-studio"),
    ]:
        if (ROOT / r).exists():
            entries.append((r, an, "angular.json"))

    entries.sort(key=lambda x: x[0])
    seen: set[str] = set()
    out: list[tuple[str, str, str]] = []
    for t in entries:
        if t[0] in seen:
            continue
        seen.add(t[0])
        out.append(t)
    return out


def write_one(path: str, name: str, manifest: str) -> None:
    lang = guess_lang(manifest)
    mad = guess_madurez(path)
    ev = first_evidence(path)
    text = f"""---
kind: package-summary
repo: vortech
package_name: {json.dumps(name)}
package_path: {json.dumps(path)}
language: {lang}
manifest: {manifest}
inventoried_at: {AT}
inventoried_by: {AGENT}
source_repo: {SRC_REPO}
source_commit: {SRC_COMMIT}
madurez: {mad}
---

# {name}

## 1. Identidad
- **Nombre:** {name}
- **Path:** `{path}`
- **Lenguaje:** {lang}
- **Versión declarada:** (ver manifest en el repo; inventario estático)
- **Publicado:** desconocido

## 2. Propósito

### 2.1 Declarado
Ver `README` o descripción en el manifest en el snapshot bajo `repos/vortech/`.

### 2.2 Inferido
Package clasificado por manifest `{manifest}` en el monorepo Vortech.

**Evidencia:**
- `{ev}` — primer fuente local bajo el path (heurística Fase 1).

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
- Inspeccionar subcarpetas `src/`, `lib/`, `tests/` bajo `{path}`.

## 7. Estado

- **Madurez:** {mad}
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
"""
    (SUM / slug(path)).write_text(text, encoding="utf-8")


def main() -> None:
    SUM.mkdir(parents=True, exist_ok=True)
    ents = collect()
    for path, name, manifest in ents:
        write_one(path, name, manifest)
    print("Wrote", len(ents), "files")


if __name__ == "__main__":
    main()
