# Bridge en .NET

> **Rol.** TransportDriver especializado en **traducir** entre Wire y un runtime ajeno. Convierte un sistema legacy/nativo en ciudadano de primera clase de la plataforma.
>
> **Primitiva diferenciadora.** La mayoría de frameworks no tiene esto — asumen que todo corre en su runtime. Vortech no lo asume.

---

## 1. Qué es en concreto

Un Bridge en .NET es una **clase C# que implementa `ITransportDriver`** (o un Driver especializado que delega a un Bridge) y:

1. Habla **Wire por un lado** (ver [`14-wire.md`](14-wire.md)).
2. Habla **el protocolo nativo del runtime ajeno por el otro** — COM, P/Invoke, named pipes propietarias, protocolo serie, protocolo de PLC, API de un ActiveX, un DLL de C legacy, un binario antiguo.
3. **Traduce bidireccionalmente** mensajes Wire a llamadas/mensajes nativos y viceversa.
4. Se expone al Host como un driver de transporte más.

Un mensaje Wire que llega al Bridge no se "adapta": se **re-expresa** como operación nativa; la respuesta nativa se **re-expresa** como mensaje Wire.

---

## 2. Forma del contrato

```csharp
[VortechBridge(
    Name = "mach4",
    TargetRuntime = "C++ / COM (Mach4 Controller)",
    Direction = BridgeDirection.Bidirectional)]
public sealed class Mach4Bridge : IBridge
{
    public async Task<WireResponse<TOut>> DispatchAsync<TIn, TOut>(
        WireRequest<TIn> request,
        BridgeContext ctx,
        CancellationToken ct)
    {
        // 1. Mapea operación Wire → llamada COM/C++/P-Invoke
        // 2. Ejecuta sobre el runtime ajeno
        // 3. Envuelve resultado / error nativo como WireResponse o WireError
    }

    public IAsyncEnumerable<WireFrame<TEvent>> SubscribeAsync<TEvent>(
        WireRequest<TIn> request,
        BridgeContext ctx,
        CancellationToken ct);
}
```

Convenciones fijadas:

- **Un Bridge por runtime ajeno.** No un Bridge por operación.
- **Tabla de mapeo operación Wire ↔ invocación nativa** — código o generado por atributos.
- **Traducción de errores nativos a `DomainError`** — `HRESULT`, códigos C, códigos propietarios → dominio.
- **Gestión de recursos nativos.** Handles, apartamentos COM, sesiones — el Bridge los posee y los libera.

---

## 3. Casos donde .NET es el stack natural

Los Bridges que casi siempre se implementan en C# son los que cruzan hacia el ecosistema Microsoft/Windows:

- **COM / OLE / ActiveX.** P/Invoke y `System.Runtime.InteropServices` son excelentes; ningún stack moderno los iguala en madurez.
- **MSAccess / Office / Outlook / Excel.** Interop COM de primera clase.
- **WMI / PowerShell / Win32 nativo.** `System.Management`, hosting de PowerShell, P/Invoke.
- **.NET Framework legacy.** Se puede llamar cross-runtime.
- **Controladores industriales Windows** (OPC, Mach, PLC SDKs .NET).

Para runtimes donde otro lenguaje es mejor (firmware bare-metal, chips embebidos), el Bridge puede estar en ese lenguaje — sigue siendo Bridge, pero vive fuera de .NET, expone Wire al Host .NET.

---

## 4. Relación con Driver

Un Driver y un Bridge **no son mutuamente excluyentes**: un Driver del Provider de datos contra MSAccess es **un Driver que internamente usa el Bridge COM-MSAccess**. El Driver implementa la interfaz del Provider; el Bridge sirve al Driver con el interop COM.

Patrón típico:

```
InventoryProvider
    └─ MsAccessInventoryDriver          ← implementa IInventoryDriver
         └─ depende de MsAccessComBridge ← Bridge COM genérico
```

El Bridge es reutilizable entre Drivers distintos; el Driver es específico al Provider.

---

## 5. Runtime

- El Host registra Bridges igual que cualquier otro transporte/driver.
- Gestiona ciclo de vida según el runtime ajeno: single-threaded apartment para COM, afinidad de thread si el runtime ajeno lo exige, pool de handles, reconexión.
- Aplica políticas de resiliencia: timeout duro, kill del proceso ajeno si se cuelga, circuit breaker.
- Exposición observable: cada llamada cruza barrera Wire, por tanto genera telemetría uniforme.

---

## 6. Proyección vía codegen

- `v-gen` puede generar **tablas de mapeo Wire↔nativo** desde atributos sobre la interfaz del Driver, reduciendo boilerplate.
- Para sistemas nativos con IDL propio (p.ej. TLB de COM, IDL de gRPC existente, WSDL), `v-gen` puede emitir el scaffolding del Bridge tomando el IDL como entrada secundaria.

---

## 7. Reglas invariantes

1. **Wire es la frontera externa**, siempre. El Host consume Wire, no el protocolo nativo.
2. **Errores nativos se traducen.** Nunca se propaga un `HRESULT` ni un `errno` crudo al Provider.
3. **Recursos nativos se liberan** bajo cualquier camino (éxito, error, cancelación).
4. **Cardinalidad 1:N.** Un Bridge sirve a N Drivers si tiene sentido.
5. **El Bridge no conoce el dominio.** Sabe traducir mensajes; no sabe qué significa un Sku.

---

## 8. Qué no es

- **No es un adaptador de API HTTP externa.** Una API REST externa se consume con un Driver HTTP ordinario, no con un Bridge. Bridge se reserva para cuando hay **traducción cross-runtime real**.
- **No es un parche.** No "añades un Bridge" para evitar rediseñar; Bridge es solución arquitectónica a problema arquitectónico (runtime ajeno legítimo).
- **No es opcional en los dominios legacy.** Donde hay runtime ajeno serio, Bridge es obligatorio; atajos con servicios sueltos generan deuda.

---

## 9. Por qué es diferenciador

Los frameworks habituales tratan los runtimes ajenos como problema del usuario. Vortech los eleva a **primitiva nombrada, versionada, contratada y observable**. Esto convierte los escenarios reales de la industria (fábricas, legacy, firmware, bancos con mainframes) en terreno natural de la plataforma, no en excepciones incómodas.
