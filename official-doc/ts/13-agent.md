# Agent en TypeScript / frontend

> **Rol.** Desde el frontend, los Agents se **invocan**, no se alojan. Se ven como proxies tipados sobre Wire.
>
> **Espejo del backend:** [`../dotnet/13-agent.md`](../dotnet/13-agent.md).

---

## 1. Forma del consumo

```ts
// Generado por v-gen desde el contrato C# del Agent
export interface IPricingOptimizerAgent
  extends IAgent<PricingJob, PricingPlan> {}

export const IPricingOptimizerAgent =
  createToken<IPricingOptimizerAgent>('IPricingOptimizerAgent');

// Uso en un componente
class PricingPanel {
  private readonly opt = inject(IPricingOptimizerAgent);
  private readonly job = atom<PricingJob | null>(null);

  readonly plan = derivedAsync(() =>
    this.job() ? this.opt.run(this.job()!) : null);
}
```

Convenciones fijadas:

- **Cliente Agent es un proxy** generado, no un cliente HTTP/WS escrito a mano.
- **Misma forma `IAgent<TIn,TOut>` / `IStreamingAgent<TIn,TOut>` / `ISubscribingAgent<TIn,TEvent>`** que en backend.
- **Invocación tipada** con autocompletado y type-check.
- **Cancelación** vía `AbortSignal` o token de `derivedAsync`.

---

## 2. Streaming Agents

Casos típicos: Agents IA/ML que entregan tokens, Agents de procesamiento que entregan progreso, Agents de scraping con resultados parciales.

```ts
class ChatPanel {
  private readonly assistant = inject(IAssistantAgent);
  readonly tokens = atomCollection<string>();

  async ask(prompt: string) {
    this.tokens.clear();
    for await (const tok of this.assistant.stream({ prompt })) {
      this.tokens.append(tok);
    }
  }
}
```

- El stream es `AsyncIterable<TOut>`.
- El proxy gestiona reconexión Wire si el transporte la soporta.
- La UI reacciona token a token sin código extra: `tokens` es un atom y el template se rerinde.

---

## 3. Runtime

- El proxy del Agent **sólo conoce el Wire del Host**. No habla directo con el Agent — siempre va Browser → Host → Agent.
- El Host enruta vía su `AgentRuntime` ([`../dotnet/13-agent.md §3`](../dotnet/13-agent.md)).
- Telemetría: el Wire emite eventos; observables desde devtools del shell.

---

## 4. Reglas invariantes

1. **Cero alojamiento de Agents en el frontend.** Si una "tarea" vive solo en el cliente, es lógica de Provider local, no Agent.
2. **Cero invocación libre.** No `fetch('/agent/run')`; siempre proxy generado.
3. **Cancelación obligatoria** en streams largos.
4. **Errores tipados.** Mismo modelo `DomainError` que el resto de Wire.

---

## 5. Qué no es

- **No es un Web Worker.** Web Workers son detalle interno del frontend para offload de cómputo (lo encapsula un Provider local con su Driver Worker). Agent es ejecución autónoma del lado server o adyacente.
- **No es un servicio HTTP.** El consumidor no ve URLs ni endpoints.

---

## 6. Inspiración

- **MCP tool clients** — patrón de invocación tipada de tareas remotas.
- **OpenAI / Anthropic SDKs** — patrón de streaming de tokens.

Leídos como fuente; no adoptados.
