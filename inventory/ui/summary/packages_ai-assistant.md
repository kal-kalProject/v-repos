---
kind: package-summary
repo: ui
package_name: "ai-assistant"
package_path: packages/ai-assistant
language: python
manifest: requirements.txt
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

- **Nombre publicado:** `ai-assistant` (paquete Python)
- **Descripción declarada:** "Chat con documentos propios. Sin Docker, sin servidores externos. Usa ChromaDB (SQLite embebido) para búsqueda semántica local."
- **Ruta en el repo:** `packages/ai-assistant`
- **Manifiesto:** `requirements.txt`
- **Lenguaje principal:** Python

## 2. Propósito

Asistente de IA local para chat con documentos propios — implementa un sistema RAG (Retrieval-Augmented Generation) completamente local: sin Docker, sin APIs externas. Usa ChromaDB con SQLite embebido para búsqueda semántica, permite ingestar documentos de texto y código, y ofrece un servidor de chat y herramientas de agente.

## 3. Superficie pública

- `server.py` — servidor HTTP/API para el chat con documentos.
- `chat.py` — lógica de chat con el modelo de lenguaje y recuperación de contexto.
- `ingest.py` — ingestión de documentos de texto a ChromaDB.
- `ingest_code.py` — ingestión especializada de código fuente.
- `agent_tools.py` — herramientas del agente de IA (funciones que el LLM puede llamar).
- `finetune.py` — fine-tuning del modelo con datos propios.
- `export_dataset.py` — exportación del dataset de fine-tuning.
- `app/` — módulo de aplicación (posiblemente lógica de negocio o UI).

## 4. Dependencias

- **ChromaDB** — base de datos vectorial local (usa SQLite embebido internamente).
- Un modelo de embeddings local (posiblemente `sentence-transformers` o similar).
- Un LLM local o API (Ollama, OpenAI, Anthropic — la descripción "sin servidores externos" sugiere Ollama u otro modelo local).
- Las dependencias específicas deben extraerse del `requirements.txt` del paquete.
- *Nota:* las dependencias listadas en la instrucción (`lark-parser`, `pydantic`, `pytest`, `click`, `dataclasses-json`, `colorama`) corresponden a `vc-language-py/requirements.txt`, no a este paquete; el `requirements.txt` propio de `ai-assistant` debe verificarse.

## 5. Consumidores internos

- `projects/ui/ai-chat` — la app Angular de chat puede consumir `server.py` como backend API.
- `projects/mcp-servers/vortech-docs` — el MCP server de documentación puede delegar la búsqueda semántica en este asistente.
- Desarrolladores del equipo Vortech para queries sobre el codebase.

## 6. Estructura interna

```
packages/ai-assistant/
├── requirements.txt
├── server.py
├── chat.py
├── ingest.py
├── ingest_code.py
├── agent_tools.py
├── finetune.py
├── export_dataset.py
└── app/
```

## 7. Estado

- **Madurez:** experimental
- Stack completamente local: ChromaDB + SQLite + LLM local; sin dependencias de servicios en la nube.
- La presencia de `finetune.py` y `export_dataset.py` indica que hay trabajo de adaptación del modelo al dominio Vortech.

## 8. Dominios que toca

- **IA / RAG** — Retrieval-Augmented Generation con documentos propios.
- **Búsqueda Semántica** — ChromaDB + embeddings para búsqueda vectorial.
- **Python / Backend** — servidor de chat y pipeline de ingestión.
- **Fine-tuning** — adaptación de modelos al dominio Vortech.

## 9. Observaciones

- El enfoque "sin Docker, sin servidores externos" es un principio de diseño explícito que prioriza la privacidad y la simplicidad de despliegue.
- La separación entre `ingest.py` (documentos) e `ingest_code.py` (código) sugiere estrategias de chunking y embedding diferentes para texto y código.
- `agent_tools.py` indica que el asistente puede ejecutar acciones además de responder preguntas (agente tool-use).
- La aclaración sobre las dependencias en el bloque de instrucción — que corresponden a `vc-language-py`, no a este paquete — es importante para un inventario correcto.

## 10. Hipótesis

- El backend de LLM es probablemente Ollama (LLM local) dado el principio "sin servidores externos", con modelos como Llama 3, Mistral o similar.
- `export_dataset.py` genera datasets en formato JSONL o similar para fine-tuning con herramientas como `axolotl`, `unsloth` o el CLI de Ollama.

## 11. Preguntas abiertas

1. ¿Qué modelo de lenguaje local usa por defecto (Ollama + Llama 3, etc.)?
2. ¿Qué modelo de embeddings usa para ChromaDB (`sentence-transformers`, `nomic-embed-text`, etc.)?
3. ¿`agent_tools.py` tiene herramientas de acceso al filesystem o al codebase?
4. ¿El `requirements.txt` propio de `ai-assistant` es diferente al de `vc-language-py`?
