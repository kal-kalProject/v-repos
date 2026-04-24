# Host en .NET

> **Rol.** Contenedor runtime con pipeline de ejecución. Orquesta Providers, Drivers, Agents, Extensions. Soporta topología master/slave.
>
> **Base técnica.** ASP.NET Core extendido. Código de extensión 100% propio; solo se apoya en lo nativo de ASP.NET Core y BCL ([cierre §1](01-cierre-decisiones-dotnet.md)).

---

## 1. Qué es en concreto

El Host es un **proceso .NET** que:

1. Arranca con una configuración declarativa (`HostOptions` + manifest de módulos).
2. Resuelve **qué Providers, Drivers, Agents, Extensions** se cargan.
3. Construye el **DI container** (el de ASP.NET Core, sin reemplazarlo).
4. Monta el **pipeline de ejecución** — secuencia ordenada de etapas por las que pasa cada request/operación.
5. Expone los transportes Wire configurados (HTTP, WS, etc.).
6. Participa en la **topología del cluster** si hay master/slave.
7. Gestiona **observabilidad** (logs, métricas, trazas) por construcción.

Es ASP.NET Core visto desde fuera; es el runtime canónico de Vortech visto desde dentro.

---

## 2. Forma del contrato

```csharp
public sealed class VortechHost
{
    public static VortechHostBuilder CreateBuilder(string[] args);
}

var builder = VortechHost.CreateBuilder(args);

builder.UseIdentity();                    // si el Host es Identity
builder.UseProviders(asm: typeof(InventoryProvider).Assembly);
builder.UseDrivers(asm: typeof(SqlServerInventoryDriver).Assembly);
builder.UseAgents(asm: typeof(PricingOptimizerAgent).Assembly);
builder.UseExtensions(folder: "./extensions");

builder.UseWire()
       .WithHttp()
       .WithWebSocket()
       .WithInProcess();

builder.UseCluster()
       .AsMaster()           // o AsReplica()
       .WithDiscovery(...);

var host = builder.Build();
await host.RunAsync();
```

Convenciones fijadas:

- **Un proceso Host = una unidad de despliegue.** Puede hostear múltiples dominios.
- **Arranque declarativo.** Código, no XML; pero el contenido es configuración, no lógica.
- **Composición por assembly o folder.** Providers/Drivers/Agents se descubren por atributos.
- **Fallo en arranque si algo está mal** — nunca silenciado.

---

## 3. Pipeline

El pipeline del Host es una secuencia de **etapas** atravesadas por cada operación. Extensible por Extensions. Etapas canónicas:

1. **Ingress** — decodificación Wire del sobre entrante.
2. **Identity** — resolución de principal y validación de tokens.
3. **Scope** — construcción del Scope activo (tenant, región, contexto).
4. **Routing** — resolución de la operación a Provider concreto.
5. **Authorization** — validación de permisos sobre Provider/operación.
6. **Idempotency** — deduplicación si la operación lo declara.
7. **Invocation** — ejecución del Provider.
8. **Egress** — codificación Wire de la respuesta.
9. **Telemetry** — eventos, métricas, trazas.

Cada etapa es código propio sobre middleware de ASP.NET Core. Extensions pueden insertar etapas adicionales declarativamente.

---

## 4. Topología

El Host soporta tres roles:

- **Standalone** — proceso único, útil para desarrollo y despliegues pequeños.
- **Master** — coordina cluster, mantiene registro de réplicas, rutea si aplica.
- **Replica** — sirve tráfico, consulta al master para metadatos/elecciones.

La elección es **configuración**, no código. El mismo binario del Host puede arrancar en cualquier rol.

Mecánicas soportadas:

- Discovery (estática, DNS, API externa).
- Health checks cross-nodo.
- Promoción de réplica si el master cae.
- Estado compartido crítico vía almacén externo (el Host no inventa un consenso propio).

---

## 5. Relación con ASP.NET Core

El Host **usa** ASP.NET Core, no lo oculta:

- `IHostBuilder`, `IServiceCollection`, `IServiceProvider` del runtime de .NET son la base del DI.
- Kestrel es el servidor HTTP subyacente cuando el driver HTTP de Wire está activo.
- `IOptions<T>`, `IConfiguration`, `ILogger<T>` se usan tal cual.
- Endpoints, auth, data protection, hosted services — se aprovechan sin envolverlos.

El código "propio" de la plataforma añade: descubrimiento por atributos Vortech, pipeline de operaciones de dominio, `ProviderRuntime`, `AgentRuntime`, resolución de Capabilities, carga de Extensions, proyección Wire — cosas que no están en ASP.NET.

---

## 6. Arranque y ciclo de vida

```
[arranque]
   └─ lee configuración + manifests
   └─ escanea assemblies/folders → descubre Providers/Drivers/Agents/Extensions
   └─ valida grafo (capabilities, scopes, dependencias)
   └─ construye DI
   └─ monta pipeline
   └─ inicia transportes Wire
   └─ une al cluster si aplica
   └─ anuncia ready

[en ejecución]
   └─ responde a operaciones vía Wire
   └─ ejecuta BackgroundServices (Agents .NET in-proc, watchdogs)
   └─ mantiene health/telemetry

[apagado]
   └─ drena conexiones Wire
   └─ detiene BackgroundServices en orden inverso
   └─ libera Drivers (incluidos Bridges con recursos nativos)
   └─ abandona cluster limpiamente
```

---

## 7. Reglas invariantes

1. **Un Host, un proceso.** No hay "sub-Hosts" virtuales.
2. **Arranque determinista.** Misma config + mismo binario = mismo grafo de servicios.
3. **El pipeline es inspeccionable** — se puede exportar la lista de etapas activas.
4. **Las Extensions no pueden romper el pipeline canónico**; solo insertar etapas adicionales.
5. **Fallback de observabilidad.** Si la telemetría configurada cae, el Host no cae con ella.

---

## 8. Qué no es

- **No es un monolito.** Un Host puede servir solo uno o dos dominios — lo común es modular.
- **No es un microservicio.** Un microservicio es un caso particular de Host pequeño; la primitiva es la misma.
- **No es un framework aparte de ASP.NET Core.** Es una extensión estructurada sobre ASP.NET Core.

---

## 9. Casos típicos de Host

- **Identity Host** — dedicado a autenticación/autorización ([`17-identity.md`](17-identity.md)).
- **Product Host** — hostea los dominios de negocio de un producto.
- **Edge Host** — corre en sitio del cliente (fábrica, oficina), comunica con un Host central.
- **Agent Host** — hostea Agents .NET in-proc en procesos dedicados para aislamiento.
