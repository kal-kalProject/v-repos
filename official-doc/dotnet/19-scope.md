# Scope en .NET

> **Rol.** Árbol jerárquico de namespaces con contexto. Direccionamiento universal sobre el grafo de Providers y entidades.
>
> **Par operativo:** [`20-router.md`](20-router.md).

---

## 1. Qué es en concreto

Un Scope es una **referencia navegable** sobre el grafo de la plataforma:

- Cada **nodo** del árbol es o bien un **namespace puro** (contenedor) o un **namespace con contexto** (tiene valor asociado — un tenant, una cuenta, una sesión, un producto, un documento).
- El **contexto no vive en Scope**: Scope lo **referencia** — separación intencional.
- Una ruta de Scope se expresa como **cadena jerárquica** o **expresión tipada** en C#.

Ejemplos:

```
identity
identity.accounts
identity.accounts.byEmail("alice@example.com")
identity.accounts.byEmail("alice@example.com").sessions
identity.accounts.byEmail("alice@example.com").sessions.active
inventory.skus
inventory.skus.byCode("SKU-001")
cluster.nodes.byId("node-7").jobs.running
```

Scope resuelve **todo** en la plataforma con la misma sintaxis: endpoints, recursos, entidades, estados, jobs, dispositivos.

---

## 2. Forma del contrato

```csharp
public sealed class Scope
{
    public string Path { get; }
    public ScopeKind Kind { get; }          // Namespace | ContextRef
    public ScopeContextRef? Context { get; }
    public Scope Parent { get; }
    public IReadOnlyList<Scope> Children { get; }
}

public readonly record struct ScopeContextRef(string Type, string Key);

// Builder tipado
var s = Scope.Root
             .Child("identity")
             .Child("accounts")
             .Context("account", accountId)
             .Child("sessions")
             .Child("active");
```

Convenciones fijadas:

- **Scope es inmutable.** Operaciones producen nuevos nodos.
- **Path canónico** en dot-notation; serializable en Wire.
- **Context es referencia**, no valor — el valor vive en su Provider; Scope solo lo localiza.
- **Pattern matching** para descomposición en tiempo de ejecución.

---

## 3. Runtime

- El Host construye el **Scope raíz** desde el request Wire (ver [`14-wire.md`](14-wire.md): cada sobre Wire transporta su Scope).
- El Pipeline del Host deriva sub-Scopes por etapa — autorización ancla el principal al Scope, el Provider puede derivar más.
- `ProviderRuntime` usa el Scope para elegir Driver (por tenant, región) y para logging/trace coherentes.
- El Scope viaja **transversalmente** por todo el request — no se re-construye en cada capa.

---

## 4. Relación con Identity

- Un principal está **asociado a un Scope raíz** (típicamente `tenants.byId(...)` o análogo).
- Los permisos (`[17-identity.md §1]`) se evalúan sobre (principal, operación, scope-target).
- **No hay permisos globales sin Scope.** La pregunta siempre es "¿puede X hacer Y sobre Scope Z?"

---

## 5. Proyección vía codegen

- El modelo de Scope es **canónico**: los clientes TS/Rust reciben la misma API de navegación tipada, proyectada por v-gen.
- Se pueden generar **navegadores tipados por dominio** — `identity.accounts.byEmail(x).sessions.active` con autocompletado y type-check en C# y en TS.
- La documentación auto-generada incluye un mapa navegable del árbol de Scope canónico del deploy.

---

## 6. Reglas invariantes

1. **Inmutabilidad.** Scope nunca muta.
2. **Path canónico serializable.** Cualquier Scope se puede expresar como cadena y reconstruir sin pérdida.
3. **Context por referencia, nunca por valor.** Scope no embebe datos — solo llaves.
4. **El Scope viaja completo** en Wire; no hay "scope implícito" en el lado servidor.
5. **Navegación tipada** preferida sobre string libre cuando el dominio es conocido en tiempo de compilación.

---

## 7. Qué no es

- **No es un directorio de objetos.** No almacena entidades; solo las localiza.
- **No es un router.** Router opera sobre Scope; Scope es la estructura, Router es la operación.
- **No es un contexto global.** No existe `Scope.Current` como ambient singleton — siempre es explícito en el request.
- **No es un path de URL.** Un path HTTP puede derivarse de un Scope para el driver HTTP de Wire, pero Scope existe por encima del transporte.

---

## 8. Para qué sirve en la práctica

- **Direccionar cualquier cosa.** `scope` + operación = todo lo resoluble.
- **Autorización uniforme.** El permiso siempre es sobre un Scope.
- **Multitenancy natural.** El scope de tenant es raíz del subgrafo del tenant.
- **Observabilidad.** Trazas, logs y métricas ancladas al Scope permiten slicing instantáneo por tenant/región/cuenta.
- **Auditoría.** Cada evento de plataforma registra el Scope activo.
