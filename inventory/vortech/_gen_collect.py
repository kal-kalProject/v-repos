# Temporary helper: collect package entries (run once; can delete after inventory)
import json
from pathlib import Path

root = Path(r"E:/v-repos/repos/vortech")
items: list[tuple[str, str, str]] = []

for p in sorted(root.rglob("package.json")):
    rel = p.parent.relative_to(root)
    r = "." if str(rel) == "." else str(rel).replace("\\", "/")
    try:
        data = json.loads(p.read_text(encoding="utf-8"))
        name = data.get("name", "(sin nombre)")
    except Exception as e:  # noqa: BLE001
        name = f"(error: {e})"
    items.append((r, name, "package.json"))

for sub, cargo_name in [
    ("rust-workspace/alloy", "v-alloy"),
    ("rust-workspace/core", "v-core"),
    ("rust-workspace/desktop", "v-desk"),
]:
    p = root / sub / "Cargo.toml"
    if p.exists():
        t = p.read_text(encoding="utf-8", errors="replace")
        name = cargo_name
        for line in t.splitlines():
            if line.strip().startswith("name = "):
                name = line.split("=", 1)[1].strip().strip('"')
                break
        items.append((sub, name, "Cargo.toml"))

for p in sorted(root.rglob("*.csproj")):
    r = str(p.parent.relative_to(root)).replace("\\", "/")
    items.append((r, p.stem, p.name))

for r, an in [
    ("packages/angular-demo", "angular-demo"),
    ("packages/monkey", "monkey"),
    ("system-agent/dashboard", "fleet-dashboard"),
    ("packages/v-studio", "v-studio"),
]:
    if (root / r).exists():
        items.append((r, an, "angular.json"))

# de-dup by path
seen = set()
out = []
for t in sorted(items, key=lambda x: x[0]):
    if t[0] in seen:
        continue
    seen.add(t[0])
    out.append(t)

for r, n, m in out:
    print(f"{r}\t{n}\t{m}")
print("TOTAL", len(out))
