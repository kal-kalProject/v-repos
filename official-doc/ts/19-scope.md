# Scope en TypeScript / frontend

> **Rol.** Árbol jerárquico de namespaces con contexto, materializado en frontend como un atom activo (`ScopeContext`) que viaja en cada llamada Wire y al que se subscriben las vistas.
>
> **Espejo del backend:** [`../dotnet/19-scope.md`](../dotnet/19-scope.md).

---

## 1. Forma del contrato

```ts
export class Scope {
  readonly path: string;
  readonly kind: 'namespace' | 'context-ref';
  readonly context?: ScopeContextRef;
  readonly parent: Scope | null;
  readonly children: readonly Scope[];

  child(name: string): Scope;
  withContext(ref: ScopeContextRef): Scope;
}

export const ScopeContext = createToken<Atom<Scope>>('ScopeContext');
```

Convenciones idénticas al backend:

- **Inmutable.** Operaciones devuelven nuevos nodos.
- **Path canónico** dot-notation, serializable.
- **Contexto por referencia**, no por valor.

---

## 2. ScopeContext — el atom activo del shell

El shell registra un **atom global** con el Scope activo:

```ts
const shellScope = atom<Scope>(Scope.root);
```

Cambia con:

- **Login** → se ancla a `tenants.byId(tenantId).accounts.byId(principalId)`.
- **Selección de tenant** → cambia subgrafo.
- **Navegación** → la vista activa puede derivar un sub-Scope (`inventory.skus.byCode("SKU-001")`).
- **Selección de elemento** dentro de una vista → sub-Scope más específico.

El `ScopeContext` se inyecta vía DI y se lee en:

- `@vortech/wire` para embeber Scope en cada request.
- Componentes que necesitan reactividad por scope (sidebars, breadcrumbs, headers).
- `IAuthorizationProvider` para evaluar permisos contextuales.

---

## 3. Navegación tipada

```ts
const s = scope.root
              .child('identity')
              .child('accounts')
              .withContext({ type: 'account', key: accountId })
              .child('sessions')
              .child('active');

// path = "identity.accounts.byAccount(...).sessions.active"
```

Los **navegadores tipados por dominio** son generados por `v-gen` desde el grafo canónico:

```ts
// Generado
import { scopes } from '@vortech/sdk';

const s = scopes.identity.accounts.byEmail('alice@example.com').sessions.active;
```

Autocompletado completo en el IDE.

---

## 4. Patrones reactivos

```ts
class TenantHeader {
  private readonly scope = inject(ScopeContext);
  readonly tenant = derived(() => this.scope().findContext('tenant'));
  readonly tenantName = derivedAsync(() =>
    this.tenant() ? inject(ITenantProvider).get(this.tenant()!.key) : null);
}
```

Cuando el usuario cambia de tenant:

1. `shellScope.set(newScope)`.
2. Todos los `derived` que leen `scope` recalculan.
3. Las vistas se rerinden; las subscripciones Wire se reanudan con el nuevo Scope.

---

## 5. Sub-scopes por vista

Una vista del Workbench puede crear su propio sub-Scope:

```ts
class SkuDetailView {
  readonly scopeOverride = computed(() =>
    inject(ScopeContext)().child('skus').withContext({
      type: 'sku', key: this.skuId() }));

  // Provider de hijos hereda este scope
  readonly children = providersFor(this.scopeOverride);
}
```

Esto permite anidamiento natural: cada vista de detalle ancla el Scope adecuado para sus llamadas Wire.

---

## 6. Reglas invariantes

1. **Inmutabilidad.** Scope nunca muta.
2. **Atom global único** del shell. Sub-scopes derivan vía atoms locales, pero la fuente raíz del shell es uno.
3. **Embebido automático en Wire.** Cero pasaje manual.
4. **Path canónico serializable** — un Scope se puede embeber en URL para deep-link.
5. **Cero `Scope.Current`** ambient. Siempre vía DI.

---

## 7. Qué no es

- **No es URL state.** El router del shell ([`20-router.md`](20-router.md)) puede sincronizarse con el Scope, pero son cosas distintas — el router maneja vistas, el Scope maneja contexto de dominio.
- **No es un store.** Solo localiza; no almacena entidades.
- **No es global ambient.** Si un componente necesita Scope, lo inyecta.

---

## 8. Sincronización con URL

Patrón opcional: el shell puede serializar el Scope activo en la URL para deep-link.

- Al navegar a `https://app/inventory/skus/SKU-001`, se reconstruye el Scope `inventory.skus.byCode("SKU-001")`.
- Al cambiar el Scope desde código, la URL se actualiza si está bindeada.
- La sincronización vive en el `IShellRouter` ([`20-router.md`](20-router.md)), no en el Scope mismo.

---

## 9. Inspiración

- **VSCode `IContextKeyService`** — modelo de claves contextuales para `when` clauses; conceptualmente similar a sub-scopes.
- **React Context** — patrón de contexto inyectable (idea, no se adopta el modelo).
