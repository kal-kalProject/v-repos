#!/usr/bin/env bash
# Validador de inventario Fase 1 para v-repos.
# Uso: scripts/validate-inventory.sh <repo>
# Exit code: 0 si todo cumple, !=0 si hay fallos.
# Requiere: bash 4+, python (no python3), ejecutarse desde la raíz de v-repos.

set -u

if [[ $# -ne 1 ]]; then
  echo "Uso: $0 <repo>" >&2
  exit 2
fi

REPO="$1"
INV_DIR="inventory/$REPO"
SRC_FILE="$INV_DIR/_meta/source.md"

if [[ ! -d "$INV_DIR" ]]; then
  echo "FATAL: no existe $INV_DIR" >&2
  exit 2
fi

if [[ ! -f "$SRC_FILE" ]]; then
  echo "FATAL: no existe $SRC_FILE (requisito de anclaje)" >&2
  exit 2
fi

# --- Extraer identidad de source.md (acepta repo_name o source_repo) --------
SRC_REPO=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
m=re.search(r'^(?:source_repo|repo_name):\s*(\S+)', t, re.M)
print(m.group(1) if m else '')
" "$SRC_FILE")

SRC_COMMIT=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
m=re.search(r'^source_commit:\s*(\S+)', t, re.M)
print(m.group(1) if m else '')
" "$SRC_FILE")

if [[ -z "$SRC_REPO" || -z "$SRC_COMMIT" ]]; then
  echo "FATAL: $SRC_FILE no contiene source_repo / source_commit en frontmatter" >&2
  exit 2
fi

if [[ "$SRC_REPO" != "$REPO" ]]; then
  echo "WARN: source_repo ($SRC_REPO) != nombre solicitado ($REPO)"
fi

echo "== Validando inventory/$REPO  (commit: $SRC_COMMIT) =="
echo

FAILS=0
pass() { echo "  PASS  $1"; }
fail() { echo "  FAIL  $1"; FAILS=$((FAILS+1)); }
section() { echo; echo "-- $1"; }

# ---------------------------------------------------------------------------
section "1. Frontmatter presente y coherente en todo .md (excepto source.md)"
# ---------------------------------------------------------------------------
while IFS= read -r -d '' f; do
  # Omitir source.md
  [[ "$f" == "$SRC_FILE" ]] && continue

  first=$(head -n1 "$f")
  if [[ "$first" != "---" ]]; then
    fail "sin frontmatter: $f"
    continue
  fi

  fm_repo=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
parts=t.split('---',2)
if len(parts)<3: print(''); sys.exit()
m=re.search(r'^source_repo:\s*(\S+)', parts[1], re.M)
print(m.group(1) if m else '')
" "$f")

  fm_commit=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
parts=t.split('---',2)
if len(parts)<3: print(''); sys.exit()
m=re.search(r'^source_commit:\s*(\S+)', parts[1], re.M)
print(m.group(1) if m else '')
" "$f")

  if [[ -z "$fm_repo" ]]; then
    fail "frontmatter sin source_repo: $f"
  elif [[ "$fm_repo" != "$SRC_REPO" ]]; then
    fail "source_repo divergente ($fm_repo vs $SRC_REPO): $f"
  fi

  if [[ -z "$fm_commit" ]]; then
    fail "frontmatter sin source_commit: $f"
  elif [[ "$fm_commit" != "$SRC_COMMIT" ]]; then
    fail "source_commit divergente ($fm_commit vs $SRC_COMMIT): $f"
  fi
done < <(find "$INV_DIR" -type f -name "*.md" -print0)

[[ $FAILS -eq 0 ]] && pass "frontmatter coherente en todos los artefactos"

# ---------------------------------------------------------------------------
section "2. _meta obligatorios"
# ---------------------------------------------------------------------------
REQUIRED_META=(tree.md classification.md completion-report.md)
for m in "${REQUIRED_META[@]}"; do
  if [[ -f "$INV_DIR/_meta/$m" ]]; then
    pass "_meta/$m presente"
  else
    fail "falta _meta/$m"
  fi
done

# ---------------------------------------------------------------------------
section "3. Summaries: uno por entrada de classification.md"
# ---------------------------------------------------------------------------
CLASS_FILE="$INV_DIR/_meta/classification.md"
if [[ -f "$CLASS_FILE" ]]; then
  # Contar entries: heurística = líneas que empiezan con `- ` o `| ` y tienen un path con backtick.
  # Más robusto: contar apariciones de backtick-path entre backticks en el cuerpo.
  ENTRIES=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
# strip frontmatter
parts=t.split('---',2)
body=parts[2] if len(parts)>=3 else t
# paths entre backticks tipo \`foo/bar\` — contamos únicos
paths=set(re.findall(r'\`([^\`\n]+/[^\`\n]+)\`', body))
# filtrar los que parecen manifests (package.json, *.csproj, etc.) — nos quedamos con directorios-de-proyecto
paths={p for p in paths if not p.endswith(('.json','.toml','.csproj','.sln','.slnx','.yaml','.yml','.ini','.cfg','.mod'))}
for p in sorted(paths): print(p)
" "$CLASS_FILE")
  N_ENTRIES=$(echo "$ENTRIES" | grep -c . || true)

  N_SUMMARIES=0
  if [[ -d "$INV_DIR/summary" ]]; then
    N_SUMMARIES=$(find "$INV_DIR/summary" -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')
  fi

  if [[ "$N_SUMMARIES" -ge "$N_ENTRIES" && "$N_ENTRIES" -gt 0 ]]; then
    pass "summaries ($N_SUMMARIES) >= entries detectadas en classification ($N_ENTRIES)"
  elif [[ "$N_ENTRIES" -eq 0 ]]; then
    fail "no se detectaron entries en classification.md (revisa formato de backticks)"
  else
    fail "summaries insuficientes: $N_SUMMARIES archivos vs $N_ENTRIES entries detectadas"
    echo "         entries detectadas:"
    echo "$ENTRIES" | sed 's/^/           /'
  fi
else
  fail "no se pudo contar summaries: falta classification.md"
fi

# ---------------------------------------------------------------------------
section "4. Slugs de summary en lowercase"
# ---------------------------------------------------------------------------
if [[ -d "$INV_DIR/summary" ]]; then
  BAD_SLUGS=$(find "$INV_DIR/summary" -maxdepth 1 -name "*.md" -printf "%f\n" 2>/dev/null | grep '[A-Z]' || true)
  if [[ -z "$BAD_SLUGS" ]]; then
    pass "todos los slugs de summary/ están en lowercase"
  else
    fail "slugs con mayúsculas en summary/:"
    echo "$BAD_SLUGS" | sed 's/^/           /'
  fi
else
  echo "  SKIP  summary/ no existe"
fi

# ---------------------------------------------------------------------------
section "5. domains/: un solo frontmatter por archivo"
# ---------------------------------------------------------------------------
if [[ -d "$INV_DIR/domains" ]]; then
  DOM_COUNT=0
  DOM_BAD=0
  while IFS= read -r -d '' f; do
    DOM_COUNT=$((DOM_COUNT+1))
    n=$(grep -c '^---$' "$f" || true)
    if [[ "$n" -ne 2 ]]; then
      fail "domains: $f tiene $n delimitadores '---' (esperado 2 = un solo frontmatter)"
      DOM_BAD=$((DOM_BAD+1))
    fi
  done < <(find "$INV_DIR/domains" -maxdepth 1 -type f -name "*.md" -print0)

  if [[ "$DOM_COUNT" -eq 0 ]]; then
    fail "domains/ vacío — debe haber al menos un dominio"
  elif [[ "$DOM_BAD" -eq 0 ]]; then
    pass "$DOM_COUNT archivo(s) de dominio con un solo frontmatter cada uno"
  fi
else
  fail "falta directorio domains/"
fi

# ---------------------------------------------------------------------------
section "6. status/: 5 secciones obligatorias"
# ---------------------------------------------------------------------------
REQUIRED_SECTIONS=("## Bugs" "## Duplicaciones internas" "## Incompletitud" "## Deuda" "## Tests")
if [[ -d "$INV_DIR/status" ]]; then
  STATUS_COUNT=0
  while IFS= read -r -d '' f; do
    STATUS_COUNT=$((STATUS_COUNT+1))
    for sec in "${REQUIRED_SECTIONS[@]}"; do
      if ! grep -qF "$sec" "$f"; then
        fail "status: $f sin sección '$sec'"
      fi
    done
  done < <(find "$INV_DIR/status" -maxdepth 1 -type f -name "*.md" -print0)

  if [[ "$STATUS_COUNT" -eq 0 ]]; then
    fail "status/ vacío — debe haber al menos un archivo"
  fi
else
  fail "falta directorio status/"
fi

# ---------------------------------------------------------------------------
section "7. completion-report.md: complete flag"
# ---------------------------------------------------------------------------
CR="$INV_DIR/_meta/completion-report.md"
if [[ -f "$CR" ]]; then
  COMPLETE=$(python -c "
import re,sys
t=open(sys.argv[1],encoding='utf-8').read()
parts=t.split('---',2)
if len(parts)<3: print('missing'); sys.exit()
m=re.search(r'^complete:\s*(\S+)', parts[1], re.M)
print(m.group(1) if m else 'missing')
" "$CR")
  case "$COMPLETE" in
    true)  pass "completion-report.md: complete: true" ;;
    false) echo "  INFO  completion-report.md: complete: false (inventario marcado como parcial)" ;;
    *)     fail "completion-report.md sin flag complete: en frontmatter" ;;
  esac
fi

# ---------------------------------------------------------------------------
section "8. Paths en classification.md: backticks balanceados"
# ---------------------------------------------------------------------------
if [[ -f "$CLASS_FILE" ]]; then
  UNBAL=$(python -c "
import sys
t=open(sys.argv[1],encoding='utf-8').read()
# contar backticks totales por linea; si es impar hay desbalance
bad=[]
for i,l in enumerate(t.splitlines(),1):
    if l.count('\`')%2!=0:
        bad.append(f'  L{i}: {l.strip()}')
print('\n'.join(bad))
" "$CLASS_FILE")
  if [[ -z "$UNBAL" ]]; then
    pass "backticks balanceados en classification.md"
  else
    fail "líneas con backticks desbalanceados en classification.md:"
    echo "$UNBAL" | sed 's/^/         /'
  fi
fi

# ---------------------------------------------------------------------------
echo
if [[ $FAILS -eq 0 ]]; then
  echo "== RESULTADO: OK ($REPO pasa todos los checks) =="
  exit 0
else
  echo "== RESULTADO: $FAILS FALLO(S) en $REPO =="
  exit 1
fi
