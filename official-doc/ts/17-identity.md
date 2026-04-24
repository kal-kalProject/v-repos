# Identity en TypeScript / frontend

> **Rol.** El frontend **consume** Identity. No la implementa.
>
> **Espejo del backend:** [`../dotnet/17-identity.md`](../dotnet/17-identity.md).

---

## 1. Cómo aparece en el frontend

El frontend ve Identity a través de:

### 1.1 Provider local: `IPrincipalProvider`

Expone el Principal activo como atom:

```ts
@Provider({ domain: 'shell.identity' })
export interface IPrincipalProvider {
  readonly current: Atom<Principal | null>;
  readonly isAuthenticated: Atom<boolean>;
  readonly claims: Atom<readonly Claim[]>;
  readonly tenant: Atom<TenantId | null>;
}
```

- Estado **derivado** de la sesión Wire activa.
- Cualquier vista puede subscribirse a `current()` y reaccionar (mostrar nombre, avatar, deshabilitar acciones).

### 1.2 Provider remoto: `IAuthenticationProvider`

- Generado desde C# ([`../dotnet/17-identity.md §1`](../dotnet/17-identity.md)).
- Expone operaciones canónicas: `authenticate`, `refresh`, `revoke`.
- Login/logout son llamadas Wire normales, ejecutadas desde la vista de login del shell.

### 1.3 Provider local: `ITokenStoreProvider` con Drivers

Almacena tokens (access + refresh) localmente:

| Driver | Uso |
|---|---|
| `MemoryTokenDriver` | Sesión actual sin persistencia |
| `IndexedDbEncryptedTokenDriver` | Persistente entre sesiones, cifrado vía WebCrypto |
| `OsKeychainDriver` | En Electron/Tauri, vía Bridge al keychain del SO |

Capabilities reflejan: `Persistent`, `Encrypted`, `OsBacked`, `BiometricUnlock`.

---

## 2. Flujo

```
Vista login (componente)
    │
    │ user submit
    ▼
inject(IAuthenticationProvider).authenticate(req)
    │
    │ Wire request
    ▼
Host Identity (.NET)
    │
    │ Wire response con tokens
    ▼
Cliente Wire detecta tokens en respuesta
    │
    ├─▶ ITokenStoreProvider.set(...)
    └─▶ IPrincipalProvider.current.set(principal)

Subscripciones reactivas:
    Header del shell rerinde con nombre del usuario
    Permisos derivados se recalculan
    ScopeContext se ancla al tenant del Principal
```

---

## 3. Token y refresh transparente

- `IWireClient` ([`14-wire.md`](14-wire.md)) lee el token del `ITokenStoreProvider` y lo inyecta en cada request.
- Detecta `401` con código `token-expired` y dispara `refresh()` transparente.
- Reintenta la operación una sola vez tras refresh.
- Si el refresh también falla → emite evento `unauthorized` y desinicia el `IPrincipalProvider`. El shell reacciona mostrando login.

---

## 4. Autorización en frontend

- **Cero permisos hardcodeados.** Toda decisión "puede X hacer Y" se delega.
- **Mecanismo recomendado:** Provider remoto `IAuthorizationProvider.can(operation, scope)` invocado por el componente cuando necesita decidir UI.
- **Cache local opcional** vía `ICacheProvider` con invalidación por evento de cambio de Principal o Scope.
- **Nunca decidir permisos en cliente solo.** El backend siempre revalida; el cliente decide UX (mostrar/ocultar/deshabilitar).

```ts
class InventoryActions {
  private readonly authz = inject(IAuthorizationProvider);
  private readonly scope = inject(ScopeContext);

  readonly canEdit = derivedAsync(() =>
    this.authz.can('inventory.write', this.scope.current()));
}
```

---

## 5. Federación / login externo

Para flujos OIDC/SAML, la vista de login simplemente redirige al endpoint del Host Identity, que orquesta. El callback del proveedor externo retorna a una ruta del shell (`/auth/callback`) donde un componente del Workbench llama `IAuthenticationProvider.completeFederated(...)` con el `code`.

El frontend **no implementa flujos OIDC**. Solo navega y completa.

---

## 6. Reglas invariantes

1. **Cero `localStorage.setItem('token', ...)` directo.** Todo va por `ITokenStoreProvider`.
2. **Cero parsing de JWT** en componentes. Si se necesita un claim, se lee del `IPrincipalProvider`.
3. **Cero refresh manual.** El `IWireClient` lo gestiona.
4. **Cero permisos por bandera local.** Siempre delegado.
5. **Sesión expirada → desconexión limpia.** El shell vuelve a login sin estado residual.

---

## 7. Qué no es

- **No es un IdP cliente.** No emite tokens; solo los recibe y los presenta.
- **No es OAuth client library.** No se importa `oidc-client` ni equivalentes — el flujo lo orquesta el backend; el frontend solo navega.
- **No es authorization library.** Las decisiones de permiso vienen del backend.

---

## 8. Inspiración

- **MSAL** — patrones de cache de tokens, refresh transparente.
- **Auth0 SPA SDK** — patrones de Principal context y refresh silencioso.

Leídos como fuente; no adoptados.
