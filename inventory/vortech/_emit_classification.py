import json
from pathlib import Path

ROOT = Path(r"E:/v-repos/repos/vortech")
entries: list[tuple[str, str, str]] = []
for p in sorted(ROOT.rglob("package.json")):
    rel = p.parent.relative_to(ROOT)
    r = "." if str(rel) == "." else str(rel).replace("\\", "/")
    if r == ".":
        continue
    d = json.loads(p.read_text(encoding="utf-8"))
    entries.append((r, d.get("name", "?"), "package.json"))
for sub in ("rust-workspace/alloy", "rust-workspace/core", "rust-workspace/desktop"):
    t = (ROOT / sub / "Cargo.toml").read_text(encoding="utf-8", errors="replace")
    name = next(
        line.split("=", 1)[1].strip().strip('"')
        for line in t.splitlines()
        if line.strip().startswith("name = ")
    )
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

seen: set[str] = set()
out: list[tuple[str, str, str]] = []
for t in sorted(entries, key=lambda x: x[0]):
    if t[0] in seen:
        continue
    seen.add(t[0])
    out.append(t)


def typ(path: str, m: str) -> str:
    if m == "angular.json":
        return "app-angular (solo angular.json)"
    if m.endswith("csproj"):
        return "proyecto-dotnet"
    if m == "Cargo.toml":
        return "crate-rust"
    if "sokectio" in path:
        return "lib-ts-socketio-tree"
    if "examples/" in path:
        return "ejemplo"
    if any(x in path for x in ("devtools/", "vscode", "mcp", "ts-server")):
        return "herramienta"
    if path.startswith("host/"):
        return "hosting"
    if path.startswith("platform/"):
        return "plataforma"
    if path.startswith("packages/"):
        return "paquete-nucleo"
    if path.startswith("system-agent/"):
        return "system-agent"
    if path.startswith("metaquest/"):
        return "metaquest"
    if path.startswith("connections/"):
        return "conexión"
    if path.startswith("apis/"):
        return "api-cliente"
    return "otro"


def lang(m: str, p: str) -> str:
    if m == "Cargo.toml":
        return "rust"
    if m.endswith("csproj"):
        return "csharp"
    if m == "angular.json":
        return "angular"
    if "sokectio" in p:
        return "ts"
    return "ts"


for path, name, m in out:
    print(
        f"| `{path}` | {name} | {lang(m, path)} | {typ(path, m)} | `{m}` |"
    )
print("TOTAL", len(out))
