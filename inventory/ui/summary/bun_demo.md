---
kind: package-summary
repo: ui
package_name: "demo"
package_path: bun/demo
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `demo` (en el scope del directorio `bun/`)
- **Ruta en el repo:** `bun/demo`
- **Manifiesto:** `package.json`
- **Lenguaje principal:** TypeScript (runtime: Bun)

## 2. Propósito

Demo de runtime Bun para Vortech — prueba de compatibilidad y rendimiento de los paquetes Vortech ejecutándose sobre el runtime alternativo Bun. Evalúa si Bun puede reemplazar o complementar Node.js como runtime para el backend y tooling del ecosistema Vortech.

## 3. Superficie pública

- No tiene API pública exportada; es una demo ejecutable.
- Ejemplo de ejecución de código Vortech sobre el runtime Bun.
- Posiblemente benchmarks de rendimiento comparativos con Node.js.

## 4. Dependencias

- Bun runtime (no compatible con npm estándar en todos los casos).
- Paquetes del workspace Vortech que se prueba bajo Bun.
- TypeScript (Bun soporta TypeScript nativavemente sin transpilación previa).

## 5. Consumidores internos

- No es consumida por otros paquetes; es un artefacto de investigación y validación.
- Informa la decisión de adoptar Bun como runtime alternativo para el ecosistema.

## 6. Estructura interna

```
bun/demo/
├── package.json
└── src/
    └── (código de demostración ejecutado con Bun)
```

## 7. Estado

- **Madurez:** experimental
- La compatibilidad con Bun depende de que los paquetes Vortech no usen APIs exclusivas de Node.js.
- La adopción de Bun en el workspace está en evaluación (evidenciado por la existencia de esta demo aislada en `bun/`).

## 8. Dominios que toca

- **Runtime Alternativo** — evaluación de Bun vs Node.js.
- **Tooling / Build** — Bun como herramienta de build y runtime.
- **Rendimiento** — evaluación de mejoras de velocidad de Bun.

## 9. Observaciones

- El directorio `bun/` al nivel raíz del repo (paralelo a `demos/`, `projects/`, `packages/`) indica que la evaluación de Bun tiene suficiente relevancia para tener su propio directorio.
- Bun tiene compatibilidad casi total con Node.js pero hay diferencias en módulos nativos (`node:crypto`, workers, etc.) que esta demo probablemente ejercita.
- La coexistencia de `demos/node-app` y `bun/demo` sugiere una comparativa deliberada entre ambos runtimes.

## 10. Hipótesis

- La demo probablemente ejecuta los mismos casos de uso que `demos/node-app` pero sobre Bun, para facilitar la comparación.
- Si Bun tiene integración nativa con SQLite (`Bun:sqlite`), esta demo puede solaparse con `demos/sqlite-demo`.

## 11. Preguntas abiertas

1. ¿Qué funcionalidades específicas se prueban bajo Bun que no se prueban en `demos/node-app`?
2. ¿Hay benchmarks de rendimiento Node.js vs Bun en esta demo?
3. ¿El workspace usa `bun` como package manager además de `pnpm`?
4. ¿Hay plan de migrar el tooling del workspace a Bun si las pruebas son satisfactorias?
