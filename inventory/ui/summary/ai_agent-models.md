---
kind: package-summary
repo: ui
package_name: "@vortech/agent-models"
package_path: ai/agent-models
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre de paquete:** `@vortech/agent-models`
- **Ruta:** `ai/agent-models/`
- **Manifest:** `ai/agent-models/package.json`
- **Tipo:** librería TypeScript

## 2. Propósito

Gestión de modelos LLM para el agente IA de Vortech. Proporciona un registro centralizado de modelos, resolución dinámica del modelo activo según configuración o contexto, y adaptadores que normalizan la interfaz de distintos providers (OpenAI, Anthropic, Ollama, etc.) a un contrato común.

## 3. Superficie pública

Exporta desde `src/index.ts`. La surface exacta se infiere de la estructura de directorios:

- **Registry:** funciones/clases para registrar y listar modelos disponibles
- **Resolver:** lógica para seleccionar el modelo adecuado según `AgentModelProvider` (definido en `@vortech/agent-protocol`)
- **Adapters:** adaptadores por provider (cada adaptador en `src/adapters/`)
- **Types:** tipos compartidos del sub-módulo (`src/types/`)

## 4. Dependencias

- `@vortech/agent-protocol` — usa `AgentModelProvider` y tipos de configuración del agente
- Potenciales dependencias externas: SDKs de OpenAI, Anthropic u otros providers LLM

## 5. Consumidores internos

- `@vortech/agent-core` — solicita el modelo resuelto para invocar inferencia durante el ciclo del agente
- `@vortech/agent-runtime` — puede consultar el registro para seleccionar modelos por política

## 6. Estructura interna

```
ai/agent-models/
├── package.json
└── src/
    ├── adapters/      # adaptadores por provider LLM
    ├── registry/      # registro de modelos disponibles
    ├── resolver/      # resolución dinámica de modelo activo
    ├── types/         # tipos internos del módulo
    └── index.ts       # barrel exports
```

## 7. Estado

Experimental. La presencia de `adapters/`, `registry/` y `resolver/` como directorios separados indica una arquitectura extensible en diseño, pero la falta de madurez declarada sugiere que los adaptadores concretos pueden estar incompletos o en prueba.

## 8. Dominios que toca

- Integración con providers LLM externos (OpenAI, Anthropic, Ollama, etc.)
- Abstracción de modelos de lenguaje
- Configuración y resolución de modelos en tiempo de ejecución

## 9. Observaciones

- El patrón `adapters/` + `registry/` + `resolver/` es coherente con un diseño de plugin registry: nuevos providers se añaden implementando la interfaz del adaptador y registrándolo.
- La presencia de `types/` separado de `adapters/` sugiere que los tipos de modelo son agnósticos al provider concreto.

## 10. Hipótesis

- Cada adaptador en `src/adapters/` implementa una interfaz común `ModelAdapter` o similar, con métodos como `complete()`, `stream()`, `tokenCount()`.
- El resolver puede usar la configuración del workspace o variables de entorno para determinar el provider activo.
- Puede existir un adaptador `mock` o `local` para testing sin conexión a APIs externas.

## 11. Preguntas abiertas

- ¿Qué providers LLM están implementados actualmente (adaptadores concretos)?
- ¿El registro es estático (compile-time) o dinámico (runtime con plugins)?
- ¿Hay soporte para streaming de tokens o solo completions síncronas?
- ¿Cómo se gestiona la autenticación/API keys para cada provider?
